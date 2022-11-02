Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C1D615897
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiKBCyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiKBCyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:54:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2071A234
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68162617CF
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD42C433D6;
        Wed,  2 Nov 2022 02:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357677;
        bh=SrhuQARTAHlxCuZo7TJG7X23jRoay8VLKA9mtxJo5V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAHjfujIZZ0Rehslr5L1Aj53IEuVBgaTQUHQm8/dcLyeNHjd5VFZCgDQwy4shorZI
         sV+uyj3O/e7DvwCZQiTG4G1KoGKsQ6V9JqN/SM9QFCQcG2WMcp4KfPmrfyZmTUj+Ws
         onfSSma/dv2VV9txFWf73kT2Q37GCh7ulSrcY4vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 184/240] kcm: annotate data-races around kcm->rx_wait
Date:   Wed,  2 Nov 2022 03:32:39 +0100
Message-Id: <20221102022115.550224351@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0c745b5141a45a076f1cb9772a399f7ebcb0948a ]

kcm->rx_psock can be read locklessly in kcm_rfree().
Annotate the read and writes accordingly.

syzbot reported:

BUG: KCSAN: data-race in kcm_rcv_strparser / kcm_rfree

write to 0xffff88810784e3d0 of 1 bytes by task 1823 on cpu 1:
reserve_rx_kcm net/kcm/kcmsock.c:283 [inline]
kcm_rcv_strparser+0x250/0x3a0 net/kcm/kcmsock.c:363
__strp_recv+0x64c/0xd20 net/strparser/strparser.c:301
strp_recv+0x6d/0x80 net/strparser/strparser.c:335
tcp_read_sock+0x13e/0x5a0 net/ipv4/tcp.c:1703
strp_read_sock net/strparser/strparser.c:358 [inline]
do_strp_work net/strparser/strparser.c:406 [inline]
strp_work+0xe8/0x180 net/strparser/strparser.c:415
process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
worker_thread+0x618/0xa70 kernel/workqueue.c:2436
kthread+0x1a9/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

read to 0xffff88810784e3d0 of 1 bytes by task 17869 on cpu 0:
kcm_rfree+0x121/0x220 net/kcm/kcmsock.c:181
skb_release_head_state+0x8e/0x160 net/core/skbuff.c:841
skb_release_all net/core/skbuff.c:852 [inline]
__kfree_skb net/core/skbuff.c:868 [inline]
kfree_skb_reason+0x5c/0x260 net/core/skbuff.c:891
kfree_skb include/linux/skbuff.h:1216 [inline]
kcm_recvmsg+0x226/0x2b0 net/kcm/kcmsock.c:1161
____sys_recvmsg+0x16c/0x2e0
___sys_recvmsg net/socket.c:2743 [inline]
do_recvmmsg+0x2f1/0x710 net/socket.c:2837
__sys_recvmmsg net/socket.c:2916 [inline]
__do_sys_recvmmsg net/socket.c:2939 [inline]
__se_sys_recvmmsg net/socket.c:2932 [inline]
__x64_sys_recvmmsg+0xde/0x160 net/socket.c:2932
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x01 -> 0x00

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 17869 Comm: syz-executor.2 Not tainted 6.1.0-rc1-syzkaller-00010-gbb1a1146467a-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 656d07a92029..90e0aeae9ff2 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -162,7 +162,8 @@ static void kcm_rcv_ready(struct kcm_sock *kcm)
 	/* Buffer limit is okay now, add to ready list */
 	list_add_tail(&kcm->wait_rx_list,
 		      &kcm->mux->kcm_rx_waiters);
-	kcm->rx_wait = true;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, true);
 }
 
 static void kcm_rfree(struct sk_buff *skb)
@@ -178,7 +179,7 @@ static void kcm_rfree(struct sk_buff *skb)
 	/* For reading rx_wait and rx_psock without holding lock */
 	smp_mb__after_atomic();
 
-	if (!kcm->rx_wait && !READ_ONCE(kcm->rx_psock) &&
+	if (!READ_ONCE(kcm->rx_wait) && !READ_ONCE(kcm->rx_psock) &&
 	    sk_rmem_alloc_get(sk) < sk->sk_rcvlowat) {
 		spin_lock_bh(&mux->rx_lock);
 		kcm_rcv_ready(kcm);
@@ -237,7 +238,8 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 		if (kcm_queue_rcv_skb(&kcm->sk, skb)) {
 			/* Should mean socket buffer full */
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 
 			/* Commit rx_wait to read in kcm_free */
 			smp_wmb();
@@ -280,7 +282,8 @@ static struct kcm_sock *reserve_rx_kcm(struct kcm_psock *psock,
 	kcm = list_first_entry(&mux->kcm_rx_waiters,
 			       struct kcm_sock, wait_rx_list);
 	list_del(&kcm->wait_rx_list);
-	kcm->rx_wait = false;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, false);
 
 	psock->rx_kcm = kcm;
 	/* paired with lockless reads in kcm_rfree() */
@@ -1242,7 +1245,8 @@ static void kcm_recv_disable(struct kcm_sock *kcm)
 	if (!kcm->rx_psock) {
 		if (kcm->rx_wait) {
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 		}
 
 		requeue_rx_msgs(mux, &kcm->sk.sk_receive_queue);
@@ -1795,7 +1799,8 @@ static void kcm_done(struct kcm_sock *kcm)
 
 	if (kcm->rx_wait) {
 		list_del(&kcm->wait_rx_list);
-		kcm->rx_wait = false;
+		/* paired with lockless reads in kcm_rfree() */
+		WRITE_ONCE(kcm->rx_wait, false);
 	}
 	/* Move any pending receive messages to other kcm sockets */
 	requeue_rx_msgs(mux, &sk->sk_receive_queue);
-- 
2.35.1



