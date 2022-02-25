Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D654C48F1
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbiBYP36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242102AbiBYP34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:29:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA33C2177F0
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:29:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99AEFB83252
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BECC340F0;
        Fri, 25 Feb 2022 15:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645802961;
        bh=QyF/RksBrKrCfba0teqpMYCtjRxlXnKpOg/gRdTwj1c=;
        h=Subject:To:Cc:From:Date:From;
        b=qv8Nc9Q1xj8NGVEbjRGv7RZCFgVU1SyAZWqeagluWNKSOD3BRFwEtARsuwnaCI4/M
         jVMjizWjcDtfsMUJ49Sp80Mccmcnr4aQlNlcZ0FUpu0urcooSVCbmOVG3t4BXsAujK
         44yOaRKIXmfaArAJfjjpRcTXBHH54fpJEUYft5zw=
Subject: FAILED: patch "[PATCH] net-timestamp: convert sk->sk_tskey to atomic_t" failed to apply to 5.10-stable tree
To:     edumazet@google.com, davem@davemloft.net,
        syzkaller@googlegroups.com, willemb@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:29:09 +0100
Message-ID: <164580294989127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a1cdec57e03a1352e92fbbe7974039dda4efcec0 Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 17 Feb 2022 09:05:02 -0800
Subject: [PATCH] net-timestamp: convert sk->sk_tskey to atomic_t

UDP sendmsg() can be lockless, this is causing all kinds
of data races.

This patch converts sk->sk_tskey to remove one of these races.

BUG: KCSAN: data-race in __ip_append_data / __ip_append_data

read to 0xffff8881035d4b6c of 4 bytes by task 8877 on cpu 1:
 __ip_append_data+0x1c1/0x1de0 net/ipv4/ip_output.c:994
 ip_make_skb+0x13f/0x2d0 net/ipv4/ip_output.c:1636
 udp_sendmsg+0x12bd/0x14c0 net/ipv4/udp.c:1249
 inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff8881035d4b6c of 4 bytes by task 8880 on cpu 0:
 __ip_append_data+0x1d8/0x1de0 net/ipv4/ip_output.c:994
 ip_make_skb+0x13f/0x2d0 net/ipv4/ip_output.c:1636
 udp_sendmsg+0x12bd/0x14c0 net/ipv4/udp.c:1249
 inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000054d -> 0x0000054e

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 8880 Comm: syz-executor.5 Not tainted 5.17.0-rc2-syzkaller-00167-gdcb85f85fa6f-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/sock.h b/include/net/sock.h
index ff9b508d9c5f..50aecd28b355 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -507,7 +507,7 @@ struct sock {
 #endif
 	u16			sk_tsflags;
 	u8			sk_shutdown;
-	u32			sk_tskey;
+	atomic_t		sk_tskey;
 	atomic_t		sk_zckey;
 
 	u8			sk_clockid;
@@ -2667,7 +2667,7 @@ static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
 		__sock_tx_timestamp(tsflags, tx_flags);
 		if (tsflags & SOF_TIMESTAMPING_OPT_ID && tskey &&
 		    tsflags & SOF_TIMESTAMPING_TX_RECORD_MASK)
-			*tskey = sk->sk_tskey++;
+			*tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 	}
 	if (unlikely(sock_flag(sk, SOCK_WIFI_STATUS)))
 		*tx_flags |= SKBTX_WIFI_STATUS;
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index a271688780a2..307ee1174a6e 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2006,7 +2006,7 @@ struct j1939_session *j1939_tp_send(struct j1939_priv *priv,
 		/* set the end-packet for broadcast */
 		session->pkt.last = session->pkt.total;
 
-	skcb->tskey = session->sk->sk_tskey++;
+	skcb->tskey = atomic_inc_return(&session->sk->sk_tskey) - 1;
 	session->tskey = skcb->tskey;
 
 	return session;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9d0388bed0c1..6a15ce3eb1d3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4730,7 +4730,7 @@ static void __skb_complete_tx_timestamp(struct sk_buff *skb,
 	if (sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID) {
 		serr->ee.ee_data = skb_shinfo(skb)->tskey;
 		if (sk_is_tcp(sk))
-			serr->ee.ee_data -= sk->sk_tskey;
+			serr->ee.ee_data -= atomic_read(&sk->sk_tskey);
 	}
 
 	err = sock_queue_err_skb(sk, skb);
diff --git a/net/core/sock.c b/net/core/sock.c
index 4ff806d71921..6eb174805bf0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -879,9 +879,9 @@ int sock_set_timestamping(struct sock *sk, int optname,
 			if ((1 << sk->sk_state) &
 			    (TCPF_CLOSE | TCPF_LISTEN))
 				return -EINVAL;
-			sk->sk_tskey = tcp_sk(sk)->snd_una;
+			atomic_set(&sk->sk_tskey, tcp_sk(sk)->snd_una);
 		} else {
-			sk->sk_tskey = 0;
+			atomic_set(&sk->sk_tskey, 0);
 		}
 	}
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 139cec29ed06..7911916a480b 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -991,7 +991,7 @@ static int __ip_append_data(struct sock *sk,
 
 	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
-		tskey = sk->sk_tskey++;
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2995f8d89e7e..304a295de84f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1465,7 +1465,7 @@ static int __ip6_append_data(struct sock *sk,
 
 	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
-		tskey = sk->sk_tskey++;
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 

