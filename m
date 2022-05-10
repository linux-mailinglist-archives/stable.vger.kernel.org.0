Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907F952184E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243082AbiEJNeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243435AbiEJNa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7272C2C7A77;
        Tue, 10 May 2022 06:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7987061663;
        Tue, 10 May 2022 13:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B24C385C9;
        Tue, 10 May 2022 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188894;
        bh=WCI11bdAGF3EREfpmGf7G6RtuJWIfLFDZarkLZWOsS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCmgZE6zY3YDNDoQpnFT6j0atRnWn4K1geToFA5kBjN1B1On/l1iEZbTmvheL6j/p
         QhDGG+zY3RJan1DOSDIhcyBe/OP+Z9xux+8r+eaCiQaqiyzKzdsYelFIWy2NIybuF0
         XQEKv0h1hni2hHlDyi8fzmF5ZztNP06H2hSOeBHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 83/88] tcp: make sure treq->af_specific is initialized
Date:   Tue, 10 May 2022 15:08:08 +0200
Message-Id: <20220510130736.143634816@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit ba5a4fdd63ae0c575707030db0b634b160baddd7 upstream.

syzbot complained about a recent change in TCP stack,
hitting a NULL pointer [1]

tcp request sockets have an af_specific pointer, which
was used before the blamed change only for SYNACK generation
in non SYNCOOKIE mode.

tcp requests sockets momentarily created when third packet
coming from client in SYNCOOKIE mode were not using
treq->af_specific.

Make sure this field is populated, in the same way normal
TCP requests sockets do in tcp_conn_request().

[1]
TCP: request_sock_TCPv6: Possible SYN flooding on port 20002. Sending cookies.  Check SNMP counters.
general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 3695 Comm: syz-executor864 Not tainted 5.18.0-rc3-syzkaller-00224-g5fd1fe4807f9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcp_create_openreq_child+0xe16/0x16b0 net/ipv4/tcp_minisocks.c:534
Code: 48 c1 ea 03 80 3c 02 00 0f 85 e5 07 00 00 4c 8b b3 28 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7e 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c9 07 00 00 48 8b 3c 24 48 89 de 41 ff 56 08 48
RSP: 0018:ffffc90000de0588 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888076490330 RCX: 0000000000000100
RDX: 0000000000000001 RSI: ffffffff87d67ff0 RDI: 0000000000000008
RBP: ffff88806ee1c7f8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87d67f00 R11: 0000000000000000 R12: ffff88806ee1bfc0
R13: ffff88801b0e0368 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f517fe58700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcead76960 CR3: 000000006f97b000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 tcp_v6_syn_recv_sock+0x199/0x23b0 net/ipv6/tcp_ipv6.c:1267
 tcp_get_cookie_sock+0xc9/0x850 net/ipv4/syncookies.c:207
 cookie_v6_check+0x15c3/0x2340 net/ipv6/syncookies.c:258
 tcp_v6_cookie_check net/ipv6/tcp_ipv6.c:1131 [inline]
 tcp_v6_do_rcv+0x1148/0x13b0 net/ipv6/tcp_ipv6.c:1486
 tcp_v6_rcv+0x3305/0x3840 net/ipv6/tcp_ipv6.c:1725
 ip6_protocol_deliver_rcu+0x2e9/0x1900 net/ipv6/ip6_input.c:422
 ip6_input_finish+0x14c/0x2c0 net/ipv6/ip6_input.c:464
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:473
 dst_input include/net/dst.h:461 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x27f/0x3b0 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5405
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5519
 process_backlog+0x3a0/0x7c0 net/core/dev.c:5847
 __napi_poll+0xb3/0x6e0 net/core/dev.c:6413
 napi_poll net/core/dev.c:6480 [inline]
 net_rx_action+0x8ec/0xc60 net/core/dev.c:6567
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097

Fixes: 5b0b9e4c2c89 ("tcp: md5: incorrect tcp_header_len for incoming connections")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[fruggeri: Account for backport conflicts from 35b2c3211609 and 6fc8c827dd4f]
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h     |    5 +++++
 net/ipv4/syncookies.c |    1 +
 net/ipv4/tcp_ipv4.c   |    2 +-
 net/ipv6/syncookies.c |    1 +
 net/ipv6/tcp_ipv6.c   |    2 +-
 5 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1939,6 +1939,11 @@ struct tcp_request_sock_ops {
 			   enum tcp_synack_type synack_type);
 };
 
+extern const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops;
+#if IS_ENABLED(CONFIG_IPV6)
+extern const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops;
+#endif
+
 #ifdef CONFIG_SYN_COOKIES
 static inline __u32 cookie_init_sequence(const struct tcp_request_sock_ops *ops,
 					 const struct sock *sk, struct sk_buff *skb,
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -337,6 +337,7 @@ struct sock *cookie_v4_check(struct sock
 
 	ireq = inet_rsk(req);
 	treq = tcp_rsk(req);
+	treq->af_specific	= &tcp_request_sock_ipv4_ops;
 	treq->rcv_isn		= ntohl(th->seq) - 1;
 	treq->snt_isn		= cookie;
 	treq->ts_off		= 0;
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1372,7 +1372,7 @@ struct request_sock_ops tcp_request_sock
 	.syn_ack_timeout =	tcp_syn_ack_timeout,
 };
 
-static const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
+const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 	.mss_clamp	=	TCP_MSS_DEFAULT,
 #ifdef CONFIG_TCP_MD5SIG
 	.req_md5_lookup	=	tcp_v4_md5_lookup,
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -181,6 +181,7 @@ struct sock *cookie_v6_check(struct sock
 
 	ireq = inet_rsk(req);
 	treq = tcp_rsk(req);
+	treq->af_specific = &tcp_request_sock_ipv6_ops;
 	treq->tfo_listener = false;
 
 	if (security_inet_conn_request(sk, skb, req))
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -789,7 +789,7 @@ struct request_sock_ops tcp6_request_soc
 	.syn_ack_timeout =	tcp_syn_ack_timeout,
 };
 
-static const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
+const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 	.mss_clamp	=	IPV6_MIN_MTU - sizeof(struct tcphdr) -
 				sizeof(struct ipv6hdr),
 #ifdef CONFIG_TCP_MD5SIG


