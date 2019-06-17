Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5389F48B6D
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfFQSJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfFQSJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 14:09:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB1BC208C4;
        Mon, 17 Jun 2019 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560794967;
        bh=yxs4/xteIEhngtjPp+wvZtIFDhwEjZn838d+P1TwVWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dxBw2K+lm4fcPyGViWDjhx8Osp1Y93T5iVVp80YQ+/GDYfjnDT1TbDhJO9IahOppI
         f8XZaukcojaYYKyBBAVfTXlSDQ4fGRhWcVU80+wUYcfbxqdbrVJnJUQhk9FaZoy4ga
         zEzCcr5Cc//A0VA/c7jiFXW/iYmgII0d5Y+RVsK4=
Date:   Mon, 17 Jun 2019 20:09:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 4.19.52
Message-ID: <20190617180924.GB16902@kroah.com>
References: <20190617180919.GA16902@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617180919.GA16902@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 2c31208528d5..7eb9366422f5 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -250,6 +250,14 @@ tcp_base_mss - INTEGER
 	Path MTU discovery (MTU probing).  If MTU probing is enabled,
 	this is the initial MSS used by the connection.
 
+tcp_min_snd_mss - INTEGER
+	TCP SYN and SYNACK messages usually advertise an ADVMSS option,
+	as described in RFC 1122 and RFC 6691.
+	If this ADVMSS option is smaller than tcp_min_snd_mss,
+	it is silently capped to tcp_min_snd_mss.
+
+	Default : 48 (at least 8 bytes of payload per segment)
+
 tcp_congestion_control - STRING
 	Set the congestion control algorithm to be used for new
 	connections. The algorithm "reno" is always available, but
diff --git a/Makefile b/Makefile
index dd4be2f32b88..c82ee02ad9be 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 51
+SUBLEVEL = 52
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index d2c8f280e48f..4374196b98ea 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -485,4 +485,8 @@ static inline u16 tcp_mss_clamp(const struct tcp_sock *tp, u16 mss)
 
 	return (user_mss && user_mss < mss) ? user_mss : mss;
 }
+
+int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
+		  int shiftlen);
+
 #endif	/* _LINUX_TCP_H */
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 622db6bc2f02..366e2a60010e 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -114,6 +114,7 @@ struct netns_ipv4 {
 #endif
 	int sysctl_tcp_mtu_probing;
 	int sysctl_tcp_base_mss;
+	int sysctl_tcp_min_snd_mss;
 	int sysctl_tcp_probe_threshold;
 	u32 sysctl_tcp_probe_interval;
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 770917d0caa7..e75661f92daa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -55,6 +55,8 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 
 #define MAX_TCP_HEADER	(128 + MAX_HEADER)
 #define MAX_TCP_OPTION_SPACE 40
+#define TCP_MIN_SND_MSS		48
+#define TCP_MIN_GSO_SIZE	(TCP_MIN_SND_MSS - MAX_TCP_OPTION_SPACE)
 
 /*
  * Never offer a window over 32767 without using window scaling. Some
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index f80135e5feaa..abae27c3001c 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -282,6 +282,7 @@ enum
 	LINUX_MIB_TCPACKCOMPRESSED,		/* TCPAckCompressed */
 	LINUX_MIB_TCPZEROWINDOWDROP,		/* TCPZeroWindowDrop */
 	LINUX_MIB_TCPRCVQDROP,			/* TCPRcvQDrop */
+	LINUX_MIB_TCPWQUEUETOOBIG,		/* TCPWqueueTooBig */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 70289682a670..eab5c02da8ae 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -290,6 +290,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPAckCompressed", LINUX_MIB_TCPACKCOMPRESSED),
 	SNMP_MIB_ITEM("TCPZeroWindowDrop", LINUX_MIB_TCPZEROWINDOWDROP),
 	SNMP_MIB_ITEM("TCPRcvQDrop", LINUX_MIB_TCPRCVQDROP),
+	SNMP_MIB_ITEM("TCPWqueueTooBig", LINUX_MIB_TCPWQUEUETOOBIG),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index ce64453d337d..ad132b6e8cfa 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -39,6 +39,8 @@ static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
 static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
+static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
+static int tcp_min_snd_mss_max = 65535;
 static int ip_privileged_port_min;
 static int ip_privileged_port_max = 65535;
 static int ip_ttl_min = 1;
@@ -737,6 +739,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "tcp_min_snd_mss",
+		.data		= &init_net.ipv4.sysctl_tcp_min_snd_mss,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &tcp_min_snd_mss_min,
+		.extra2		= &tcp_min_snd_mss_max,
+	},
 	{
 		.procname	= "tcp_probe_threshold",
 		.data		= &init_net.ipv4.sysctl_tcp_probe_threshold,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 30c6e94b06c4..364e6fdaa38f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3829,6 +3829,7 @@ void __init tcp_init(void)
 	unsigned long limit;
 	unsigned int i;
 
+	BUILD_BUG_ON(TCP_MIN_SND_MSS <= MAX_TCP_OPTION_SPACE);
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) >
 		     FIELD_SIZEOF(struct sk_buff, cb));
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cfdd70e32755..4a8869d39662 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1315,7 +1315,7 @@ static bool tcp_shifted_skb(struct sock *sk, struct sk_buff *prev,
 	TCP_SKB_CB(skb)->seq += shifted;
 
 	tcp_skb_pcount_add(prev, pcount);
-	BUG_ON(tcp_skb_pcount(skb) < pcount);
+	WARN_ON_ONCE(tcp_skb_pcount(skb) < pcount);
 	tcp_skb_pcount_add(skb, -pcount);
 
 	/* When we're adding to gso_segs == 1, gso_size will be zero,
@@ -1381,6 +1381,21 @@ static int skb_can_shift(const struct sk_buff *skb)
 	return !skb_headlen(skb) && skb_is_nonlinear(skb);
 }
 
+int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from,
+		  int pcount, int shiftlen)
+{
+	/* TCP min gso_size is 8 bytes (TCP_MIN_GSO_SIZE)
+	 * Since TCP_SKB_CB(skb)->tcp_gso_segs is 16 bits, we need
+	 * to make sure not storing more than 65535 * 8 bytes per skb,
+	 * even if current MSS is bigger.
+	 */
+	if (unlikely(to->len + shiftlen >= 65535 * TCP_MIN_GSO_SIZE))
+		return 0;
+	if (unlikely(tcp_skb_pcount(to) + pcount > 65535))
+		return 0;
+	return skb_shift(to, from, shiftlen);
+}
+
 /* Try collapsing SACK blocks spanning across multiple skbs to a single
  * skb.
  */
@@ -1486,7 +1501,7 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
 	if (!after(TCP_SKB_CB(skb)->seq + len, tp->snd_una))
 		goto fallback;
 
-	if (!skb_shift(prev, skb, len))
+	if (!tcp_skb_shift(prev, skb, pcount, len))
 		goto fallback;
 	if (!tcp_shifted_skb(sk, prev, skb, state, pcount, len, mss, dup_sack))
 		goto out;
@@ -1504,11 +1519,10 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
 		goto out;
 
 	len = skb->len;
-	if (skb_shift(prev, skb, len)) {
-		pcount += tcp_skb_pcount(skb);
-		tcp_shifted_skb(sk, prev, skb, state, tcp_skb_pcount(skb),
+	pcount = tcp_skb_pcount(skb);
+	if (tcp_skb_shift(prev, skb, pcount, len))
+		tcp_shifted_skb(sk, prev, skb, state, pcount,
 				len, mss, 0);
-	}
 
 out:
 	return prev;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 11101cf8693b..b76cf96d5cfe 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2527,6 +2527,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_ecn_fallback = 1;
 
 	net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
+	net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
 	net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
 	net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bd134e3a0473..147ed82b73d3 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1299,6 +1299,11 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	if (nsize < 0)
 		nsize = 0;
 
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
+		return -ENOMEM;
+	}
+
 	if (skb_unclone(skb, gfp))
 		return -ENOMEM;
 
@@ -1457,8 +1462,7 @@ static inline int __tcp_mtu_to_mss(struct sock *sk, int pmtu)
 	mss_now -= icsk->icsk_ext_hdr_len;
 
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
-	if (mss_now < 48)
-		mss_now = 48;
+	mss_now = max(mss_now, sock_net(sk)->ipv4.sysctl_tcp_min_snd_mss);
 	return mss_now;
 }
 
@@ -2727,7 +2731,7 @@ static bool tcp_collapse_retrans(struct sock *sk, struct sk_buff *skb)
 		if (next_skb_size <= skb_availroom(skb))
 			skb_copy_bits(next_skb, 0, skb_put(skb, next_skb_size),
 				      next_skb_size);
-		else if (!skb_shift(skb, next_skb, next_skb_size))
+		else if (!tcp_skb_shift(skb, next_skb, 1, next_skb_size))
 			return false;
 	}
 	tcp_highest_sack_replace(sk, next_skb, skb);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index b1b5a648def6..17335a370e64 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -166,6 +166,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 		mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
 		mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
 		mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
+		mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
 		icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
 	}
 	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
