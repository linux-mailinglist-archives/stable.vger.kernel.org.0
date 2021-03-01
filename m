Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6943284D5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbhCAQnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:43:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233052AbhCAQhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:37:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD84A64EC6;
        Mon,  1 Mar 2021 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616017;
        bh=iHTbiCX0olySGzrnfKh0VyEkFZFdhb9HRmNAYClbZFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjU9viz0dvVUHg0WuJWrETrYCI9zCoww063q1CtX9/RcoMa8zwbh5prPeXOP8XyMk
         Zi45PQIKo2PIxVYlm7BZ7J2JGpd7u3/5zFexwOov+IZhGme92POngqNu7ENUULOz9V
         +qhZmkt+eQzUxN7QhvWejEeTb2AJ5+a2eohpuvIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SinYu <liuxyon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 133/134] net: icmp: pass zeroed opts from icmp{,v6}_ndo_send before sending
Date:   Mon,  1 Mar 2021 17:13:54 +0100
Message-Id: <20210301161020.145987815@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit ee576c47db60432c37e54b1e2b43a8ca6d3a8dca upstream.

The icmp{,v6}_send functions make all sorts of use of skb->cb, casting
it with IPCB or IP6CB, assuming the skb to have come directly from the
inet layer. But when the packet comes from the ndo layer, especially
when forwarded, there's no telling what might be in skb->cb at that
point. As a result, the icmp sending code risks reading bogus memory
contents, which can result in nasty stack overflows such as this one
reported by a user:

    panic+0x108/0x2ea
    __stack_chk_fail+0x14/0x20
    __icmp_send+0x5bd/0x5c0
    icmp_ndo_send+0x148/0x160

In icmp_send, skb->cb is cast with IPCB and an ip_options struct is read
from it. The optlen parameter there is of particular note, as it can
induce writes beyond bounds. There are quite a few ways that can happen
in __ip_options_echo. For example:

    // sptr/skb are attacker-controlled skb bytes
    sptr = skb_network_header(skb);
    // dptr/dopt points to stack memory allocated by __icmp_send
    dptr = dopt->__data;
    // sopt is the corrupt skb->cb in question
    if (sopt->rr) {
        optlen  = sptr[sopt->rr+1]; // corrupt skb->cb + skb->data
        soffset = sptr[sopt->rr+2]; // corrupt skb->cb + skb->data
	// this now writes potentially attacker-controlled data, over
	// flowing the stack:
        memcpy(dptr, sptr+sopt->rr, optlen);
    }

In the icmpv6_send case, the story is similar, but not as dire, as only
IP6CB(skb)->iif and IP6CB(skb)->dsthao are used. The dsthao case is
worse than the iif case, but it is passed to ipv6_find_tlv, which does
a bit of bounds checking on the value.

This is easy to simulate by doing a `memset(skb->cb, 0x41,
sizeof(skb->cb));` before calling icmp{,v6}_ndo_send, and it's only by
good fortune and the rarity of icmp sending from that context that we've
avoided reports like this until now. For example, in KASAN:

    BUG: KASAN: stack-out-of-bounds in __ip_options_echo+0xa0e/0x12b0
    Write of size 38 at addr ffff888006f1f80e by task ping/89
    CPU: 2 PID: 89 Comm: ping Not tainted 5.10.0-rc7-debug+ #5
    Call Trace:
     dump_stack+0x9a/0xcc
     print_address_description.constprop.0+0x1a/0x160
     __kasan_report.cold+0x20/0x38
     kasan_report+0x32/0x40
     check_memory_region+0x145/0x1a0
     memcpy+0x39/0x60
     __ip_options_echo+0xa0e/0x12b0
     __icmp_send+0x744/0x1700

Actually, out of the 4 drivers that do this, only gtp zeroed the cb for
the v4 case, while the rest did not. So this commit actually removes the
gtp-specific zeroing, while putting the code where it belongs in the
shared infrastructure of icmp{,v6}_ndo_send.

This commit fixes the issue by passing an empty IPCB or IP6CB along to
the functions that actually do the work. For the icmp_send, this was
already trivial, thanks to __icmp_send providing the plumbing function.
For icmpv6_send, this required a tiny bit of refactoring to make it
behave like the v4 case, after which it was straight forward.

Fixes: a2b78e9b2cac ("sunvnet: generate ICMP PTMUD messages for smaller port MTUs")
Reported-by: SinYu <liuxyon@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/netdev/CAF=yD-LOF116aHub6RMe8vB8ZpnrrnoTdqhobEx+bvoA8AsP0w@mail.gmail.com/T/
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20210223131858.72082-1-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c      |    1 -
 include/linux/icmpv6.h |   26 ++++++++++++++++++++------
 include/linux/ipv6.h   |    2 +-
 include/net/icmp.h     |    6 +++++-
 net/ipv4/icmp.c        |    5 +++--
 net/ipv6/icmp.c        |   16 ++++++++--------
 net/ipv6/ip6_icmp.c    |   12 +++++++-----
 7 files changed, 44 insertions(+), 24 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -559,7 +559,6 @@ static int gtp_build_skb_ip4(struct sk_b
 	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
 	    mtu < ntohs(iph->tot_len)) {
 		netdev_dbg(dev, "packet too big, fragmentation needed\n");
-		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			      htonl(mtu));
 		goto err_rt;
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -2,6 +2,7 @@
 #define _LINUX_ICMPV6_H
 
 #include <linux/skbuff.h>
+#include <linux/ipv6.h>
 #include <uapi/linux/icmpv6.h>
 
 static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
@@ -14,13 +15,16 @@ static inline struct icmp6hdr *icmp6_hdr
 #if IS_ENABLED(CONFIG_IPV6)
 
 typedef void ip6_icmp_send_t(struct sk_buff *skb, u8 type, u8 code, __u32 info,
-			     const struct in6_addr *force_saddr);
+			     const struct in6_addr *force_saddr,
+			     const struct inet6_skb_parm *parm);
 void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
-		const struct in6_addr *force_saddr);
+		const struct in6_addr *force_saddr,
+		const struct inet6_skb_parm *parm);
 #if IS_BUILTIN(CONFIG_IPV6)
-static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
+static inline void __icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+				 const struct inet6_skb_parm *parm)
 {
-	icmp6_send(skb, type, code, info, NULL);
+	icmp6_send(skb, type, code, info, NULL, parm);
 }
 static inline int inet6_register_icmp_sender(ip6_icmp_send_t *fn)
 {
@@ -33,11 +37,17 @@ static inline int inet6_unregister_icmp_
 	return 0;
 }
 #else
-extern void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info);
+extern void __icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+			  const struct inet6_skb_parm *parm);
 extern int inet6_register_icmp_sender(ip6_icmp_send_t *fn);
 extern int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn);
 #endif
 
+static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
+{
+	__icmpv6_send(skb, type, code, info, IP6CB(skb));
+}
+
 int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 			       unsigned int data_len);
 
@@ -53,7 +63,11 @@ static inline void icmpv6_send(struct sk
 #if IS_ENABLED(CONFIG_NF_NAT)
 void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);
 #else
-#define icmpv6_ndo_send icmpv6_send
+static inline void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
+{
+	struct inet6_skb_parm parm = { 0 };
+	__icmpv6_send(skb_in, type, code, info, &parm);
+}
 #endif
 
 extern int				icmpv6_init(void);
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -2,6 +2,7 @@
 #define _IPV6_H
 
 #include <uapi/linux/ipv6.h>
+#include <uapi/linux/icmpv6.h>
 
 #define ipv6_optlen(p)  (((p)->hdrlen+1) << 3)
 #define ipv6_authlen(p) (((p)->hdrlen+2) << 2)
@@ -73,7 +74,6 @@ struct ipv6_params {
 	__s32 autoconf;
 };
 extern struct ipv6_params ipv6_defaults;
-#include <linux/icmpv6.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
 
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -50,7 +50,11 @@ static inline void icmp_send(struct sk_b
 #if IS_ENABLED(CONFIG_NF_NAT)
 void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
 #else
-#define icmp_ndo_send icmp_send
+static inline void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
+{
+	struct ip_options opts = { 0 };
+	__icmp_send(skb_in, type, code, info, &opts);
+}
 #endif
 
 int icmp_rcv(struct sk_buff *skb);
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -743,13 +743,14 @@ EXPORT_SYMBOL(__icmp_send);
 void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 {
 	struct sk_buff *cloned_skb = NULL;
+	struct ip_options opts = { 0 };
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 	__be32 orig_ip;
 
 	ct = nf_ct_get(skb_in, &ctinfo);
 	if (!ct || !(ct->status & IPS_SRC_NAT)) {
-		icmp_send(skb_in, type, code, info);
+		__icmp_send(skb_in, type, code, info, &opts);
 		return;
 	}
 
@@ -764,7 +765,7 @@ void icmp_ndo_send(struct sk_buff *skb_i
 
 	orig_ip = ip_hdr(skb_in)->saddr;
 	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
-	icmp_send(skb_in, type, code, info);
+	__icmp_send(skb_in, type, code, info, &opts);
 	ip_hdr(skb_in)->saddr = orig_ip;
 out:
 	consume_skb(cloned_skb);
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -298,10 +298,9 @@ static int icmpv6_getfrag(void *from, ch
 }
 
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
-static void mip6_addr_swap(struct sk_buff *skb)
+static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt)
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
-	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct ipv6_destopt_hao *hao;
 	struct in6_addr tmp;
 	int off;
@@ -318,7 +317,7 @@ static void mip6_addr_swap(struct sk_buf
 	}
 }
 #else
-static inline void mip6_addr_swap(struct sk_buff *skb) {}
+static inline void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt) {}
 #endif
 
 static struct dst_entry *icmpv6_route_lookup(struct net *net,
@@ -389,7 +388,8 @@ relookup_failed:
  *	Send an ICMP message in response to a packet in error
  */
 void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
-		const struct in6_addr *force_saddr)
+		const struct in6_addr *force_saddr,
+		const struct inet6_skb_parm *parm)
 {
 	struct net *net = dev_net(skb->dev);
 	struct inet6_dev *idev = NULL;
@@ -473,7 +473,7 @@ void icmp6_send(struct sk_buff *skb, u8
 		return;
 	}
 
-	mip6_addr_swap(skb);
+	mip6_addr_swap(skb, parm);
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_proto = IPPROTO_ICMPV6;
@@ -556,7 +556,7 @@ out:
  */
 void icmpv6_param_prob(struct sk_buff *skb, u8 code, int pos)
 {
-	icmp6_send(skb, ICMPV6_PARAMPROB, code, pos, NULL);
+	icmp6_send(skb, ICMPV6_PARAMPROB, code, pos, NULL, IP6CB(skb));
 	kfree_skb(skb);
 }
 EXPORT_SYMBOL(icmp6_send);
@@ -613,10 +613,10 @@ int ip6_err_gen_icmpv6_unreach(struct sk
 	}
 	if (type == ICMP_TIME_EXCEEDED)
 		icmp6_send(skb2, ICMPV6_TIME_EXCEED, ICMPV6_EXC_HOPLIMIT,
-			   info, &temp_saddr);
+			   info, &temp_saddr, IP6CB(skb2));
 	else
 		icmp6_send(skb2, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH,
-			   info, &temp_saddr);
+			   info, &temp_saddr, IP6CB(skb2));
 	if (rt)
 		ip6_rt_put(rt);
 
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -32,23 +32,25 @@ int inet6_unregister_icmp_sender(ip6_icm
 }
 EXPORT_SYMBOL(inet6_unregister_icmp_sender);
 
-void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
+void __icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+		   const struct inet6_skb_parm *parm)
 {
 	ip6_icmp_send_t *send;
 
 	rcu_read_lock();
 	send = rcu_dereference(ip6_icmp_send);
 	if (send)
-		send(skb, type, code, info, NULL);
+		send(skb, type, code, info, NULL, parm);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(icmpv6_send);
+EXPORT_SYMBOL(__icmpv6_send);
 #endif
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 #include <net/netfilter/nf_conntrack.h>
 void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 {
+	struct inet6_skb_parm parm = { 0 };
 	struct sk_buff *cloned_skb = NULL;
 	enum ip_conntrack_info ctinfo;
 	struct in6_addr orig_ip;
@@ -56,7 +58,7 @@ void icmpv6_ndo_send(struct sk_buff *skb
 
 	ct = nf_ct_get(skb_in, &ctinfo);
 	if (!ct || !(ct->status & IPS_SRC_NAT)) {
-		icmpv6_send(skb_in, type, code, info);
+		__icmpv6_send(skb_in, type, code, info, &parm);
 		return;
 	}
 
@@ -71,7 +73,7 @@ void icmpv6_ndo_send(struct sk_buff *skb
 
 	orig_ip = ipv6_hdr(skb_in)->saddr;
 	ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
-	icmpv6_send(skb_in, type, code, info);
+	__icmpv6_send(skb_in, type, code, info, &parm);
 	ipv6_hdr(skb_in)->saddr = orig_ip;
 out:
 	consume_skb(cloned_skb);


