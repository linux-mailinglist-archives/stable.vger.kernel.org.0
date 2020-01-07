Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8128133496
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgAGU6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgAGU6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7813D2087F;
        Tue,  7 Jan 2020 20:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430695;
        bh=3SJTPSct5jTRZGqgyUTqVJSEmLApLRx6RYj4LX4qBrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bz+4yF6ffb+UAhVm05Wl0fiW212ekH5xZj50Kweid1tAwA56pojrzjCD/Cpw1eNiM
         5h2cYjYmcAnLp9UhjHWYB9aBoKPcEu0JHe3B9GodYeJoLwzIFTpWVsk7w/kMndf7GP
         wvqvhnzJaGNry3kkuLM/f3Dul1BAI2RFgIkAg+Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/191] tcp: fix data-race in tcp_recvmsg()
Date:   Tue,  7 Jan 2020 21:52:59 +0100
Message-Id: <20200107205336.154367392@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a5a7daa52edb5197a3b696afee13ef174dc2e993 ]

Reading tp->recvmsg_inq after socket lock is released
raises a KCSAN warning [1]

Replace has_tss & has_cmsg by cmsg_flags and make
sure to not read tp->recvmsg_inq a second time.

[1]
BUG: KCSAN: data-race in tcp_chrono_stop / tcp_recvmsg

write to 0xffff888126adef24 of 2 bytes by interrupt on cpu 0:
 tcp_chrono_set net/ipv4/tcp_output.c:2309 [inline]
 tcp_chrono_stop+0x14c/0x280 net/ipv4/tcp_output.c:2338
 tcp_clean_rtx_queue net/ipv4/tcp_input.c:3165 [inline]
 tcp_ack+0x274f/0x3170 net/ipv4/tcp_input.c:3688
 tcp_rcv_established+0x37e/0xf50 net/ipv4/tcp_input.c:5696
 tcp_v4_do_rcv+0x381/0x4e0 net/ipv4/tcp_ipv4.c:1561
 tcp_v4_rcv+0x19dc/0x1bb0 net/ipv4/tcp_ipv4.c:1942
 ip_protocol_deliver_rcu+0x4d/0x420 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x110/0x140 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_local_deliver+0x133/0x210 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x121/0x160 net/ipv4/ip_input.c:413
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_rcv+0x18f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5010
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5124
 netif_receive_skb_internal+0x59/0x190 net/core/dev.c:5214
 napi_skb_finish net/core/dev.c:5677 [inline]
 napi_gro_receive+0x28f/0x330 net/core/dev.c:5710

read to 0xffff888126adef25 of 1 bytes by task 7275 on cpu 1:
 tcp_recvmsg+0x77b/0x1a30 net/ipv4/tcp.c:2187
 inet_recvmsg+0xbb/0x250 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec net/socket.c:871 [inline]
 sock_recvmsg net/socket.c:889 [inline]
 sock_recvmsg+0x92/0xb0 net/socket.c:885
 sock_read_iter+0x15f/0x1e0 net/socket.c:967
 call_read_iter include/linux/fs.h:1889 [inline]
 new_sync_read+0x389/0x4f0 fs/read_write.c:414
 __vfs_read+0xb1/0xc0 fs/read_write.c:427
 vfs_read fs/read_write.c:461 [inline]
 vfs_read+0x143/0x2c0 fs/read_write.c:446
 ksys_read+0xd5/0x1b0 fs/read_write.c:587
 __do_sys_read fs/read_write.c:597 [inline]
 __se_sys_read fs/read_write.c:595 [inline]
 __x64_sys_read+0x4c/0x60 fs/read_write.c:595
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7275 Comm: sshd Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: b75eba76d3d7 ("tcp: send in-queue bytes in cmsg upon read")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d8876f0e9672..e537a4b6531b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1958,8 +1958,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	struct sk_buff *skb, *last;
 	u32 urg_hole = 0;
 	struct scm_timestamping_internal tss;
-	bool has_tss = false;
-	bool has_cmsg;
+	int cmsg_flags;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
@@ -1974,7 +1973,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	if (sk->sk_state == TCP_LISTEN)
 		goto out;
 
-	has_cmsg = tp->recvmsg_inq;
+	cmsg_flags = tp->recvmsg_inq ? 1 : 0;
 	timeo = sock_rcvtimeo(sk, nonblock);
 
 	/* Urgent data needs to be handled specially. */
@@ -2157,8 +2156,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
 			tcp_update_recv_tstamps(skb, &tss);
-			has_tss = true;
-			has_cmsg = true;
+			cmsg_flags |= 2;
 		}
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 			goto found_fin_ok;
@@ -2183,10 +2181,10 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 	release_sock(sk);
 
-	if (has_cmsg) {
-		if (has_tss)
+	if (cmsg_flags) {
+		if (cmsg_flags & 2)
 			tcp_recv_timestamp(msg, sk, &tss);
-		if (tp->recvmsg_inq) {
+		if (cmsg_flags & 1) {
 			inq = tcp_inq_hint(sk);
 			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
 		}
-- 
2.20.1



