Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015772266D0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733061AbgGTQG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733059AbgGTQG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:06:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA42A2064B;
        Mon, 20 Jul 2020 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261187;
        bh=qoOvrOeyt3ESlHFHYWj3QOkoysAm1lPOWTCXiLF8O3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESZfWsXvQ1Re/GNfUpalQ7D3Ol4VosPeOyaTFnaYAVR+25zuS2IrjL3tO5+lZe0QS
         qHOy0d6/Pa5ocNzF3dlFm6JBWglbfm5B5TbFtt26FMzllefwahhkoHEDGI2B4UbzIU
         SCSjQijFhafFJGdaTX75An/38hecFLxMOwcQXN8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 025/244] ip: Fix SO_MARK in RST, ACK and ICMP packets
Date:   Mon, 20 Jul 2020 17:34:56 +0200
Message-Id: <20200720152827.056191093@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 0da7536fb47f51df89ccfcb1fa09f249d9accec5 ]

When no full socket is available, skbs are sent over a per-netns
control socket. Its sk_mark is temporarily adjusted to match that
of the real (request or timewait) socket or to reflect an incoming
skb, so that the outgoing skb inherits this in __ip_make_skb.

Introduction of the socket cookie mark field broke this. Now the
skb is set through the cookie and cork:

<caller>		# init sockc.mark from sk_mark or cmsg
ip_append_data
  ip_setup_cork		# convert sockc.mark to cork mark
ip_push_pending_frames
  ip_finish_skb
    __ip_make_skb	# set skb->mark to cork mark

But I missed these special control sockets. Update all callers of
__ip(6)_make_skb that were originally missed.

For IPv6, the same two icmp(v6) paths are affected. The third
case is not, as commit 92e55f412cff ("tcp: don't annotate
mark on control socket from tcp_v6_send_response()") replaced
the ctl_sk->sk_mark with passing the mark field directly as a
function argument. That commit predates the commit that
introduced the bug.

Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reported-by: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/icmp.c      |    4 ++--
 net/ipv4/ip_output.c |    2 +-
 net/ipv6/icmp.c      |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -427,7 +427,7 @@ static void icmp_reply(struct icmp_bxm *
 
 	ipcm_init(&ipc);
 	inet->tos = ip_hdr(skb)->tos;
-	sk->sk_mark = mark;
+	ipc.sockc.mark = mark;
 	daddr = ipc.addr = ip_hdr(skb)->saddr;
 	saddr = fib_compute_spec_dst(skb);
 
@@ -710,10 +710,10 @@ void __icmp_send(struct sk_buff *skb_in,
 	icmp_param.skb	  = skb_in;
 	icmp_param.offset = skb_network_offset(skb_in);
 	inet_sk(sk)->tos = tos;
-	sk->sk_mark = mark;
 	ipcm_init(&ipc);
 	ipc.addr = iph->saddr;
 	ipc.opt = &icmp_param.replyopts.opt;
+	ipc.sockc.mark = mark;
 
 	rt = icmp_route_lookup(net, &fl4, skb_in, iph, saddr, tos, mark,
 			       type, code, &icmp_param);
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1702,7 +1702,7 @@ void ip_send_unicast_reply(struct sock *
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
 	sk->sk_sndbuf = sysctl_wmem_default;
-	sk->sk_mark = fl4.flowi4_mark;
+	ipc.sockc.mark = fl4.flowi4_mark;
 	err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
 			     len, 0, &ipc, &rt, MSG_DONTWAIT);
 	if (unlikely(err)) {
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -566,7 +566,6 @@ static void icmp6_send(struct sk_buff *s
 	fl6.mp_hash = rt6_multipath_hash(net, &fl6, skb, NULL);
 	security_skb_classify_flow(skb, flowi6_to_flowi(&fl6));
 
-	sk->sk_mark = mark;
 	np = inet6_sk(sk);
 
 	if (!icmpv6_xrlim_allow(sk, type, &fl6))
@@ -583,6 +582,7 @@ static void icmp6_send(struct sk_buff *s
 		fl6.flowi6_oif = np->ucast_oif;
 
 	ipcm6_init_sk(&ipc6, np);
+	ipc6.sockc.mark = mark;
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
 	dst = icmpv6_route_lookup(net, skb, sk, &fl6);
@@ -751,7 +751,6 @@ static void icmpv6_echo_reply(struct sk_
 	sk = icmpv6_xmit_lock(net);
 	if (!sk)
 		goto out_bh_enable;
-	sk->sk_mark = mark;
 	np = inet6_sk(sk);
 
 	if (!fl6.flowi6_oif && ipv6_addr_is_multicast(&fl6.daddr))
@@ -779,6 +778,7 @@ static void icmpv6_echo_reply(struct sk_
 	ipcm6_init_sk(&ipc6, np);
 	ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 	ipc6.tclass = ipv6_get_dsfield(ipv6_hdr(skb));
+	ipc6.sockc.mark = mark;
 
 	if (ip6_append_data(sk, icmpv6_getfrag, &msg,
 			    skb->len + sizeof(struct icmp6hdr),


