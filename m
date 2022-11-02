Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B571615B14
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiKBDrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiKBDrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:47:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A11C275C1
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F8F7B81AF4
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB46C433D6;
        Wed,  2 Nov 2022 03:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360839;
        bh=NRKlOyS0DgI0nHBvdC+14pqf6hbuEVjTvaoLoVuA8Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pI/T0jtPUKSkIJKxuovWHH6dopYJQM8m5OToSPghFeChLJQb1P9NvXfmYM7l4QVcP
         AGQrDGudcbE1p904r1Vwkc0UDyMiaXOnwa40ZN62nsSbi7WcswkHicJ/rUpg8omngb
         849xHnDcqVLrNF7bDU3LNPQcPvytDWaB5jq87TOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 29/44] kcm: annotate data-races around kcm->rx_psock
Date:   Wed,  2 Nov 2022 03:35:15 +0100
Message-Id: <20221102022050.100813396@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
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

[ Upstream commit 15e4dabda11b0fa31d510a915d1a580f47dfc92e ]

kcm->rx_psock can be read locklessly in kcm_rfree().
Annotate the read and writes accordingly.

We do the same for kcm->rx_wait in the following patch.

syzbot reported:
BUG: KCSAN: data-race in kcm_rfree / unreserve_rx_kcm

write to 0xffff888123d827b8 of 8 bytes by task 2758 on cpu 1:
unreserve_rx_kcm+0x72/0x1f0 net/kcm/kcmsock.c:313
kcm_rcv_strparser+0x2b5/0x3a0 net/kcm/kcmsock.c:373
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

read to 0xffff888123d827b8 of 8 bytes by task 5859 on cpu 0:
kcm_rfree+0x14c/0x220 net/kcm/kcmsock.c:181
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

value changed: 0xffff88812971ce00 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 5859 Comm: syz-executor.3 Not tainted 6.0.0-syzkaller-12189-g19d17ab7c68b-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 2f3cd09ee0df..9ba4ac8053b2 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -178,7 +178,7 @@ static void kcm_rfree(struct sk_buff *skb)
 	/* For reading rx_wait and rx_psock without holding lock */
 	smp_mb__after_atomic();
 
-	if (!kcm->rx_wait && !kcm->rx_psock &&
+	if (!kcm->rx_wait && !READ_ONCE(kcm->rx_psock) &&
 	    sk_rmem_alloc_get(sk) < sk->sk_rcvlowat) {
 		spin_lock_bh(&mux->rx_lock);
 		kcm_rcv_ready(kcm);
@@ -283,7 +283,8 @@ static struct kcm_sock *reserve_rx_kcm(struct kcm_psock *psock,
 	kcm->rx_wait = false;
 
 	psock->rx_kcm = kcm;
-	kcm->rx_psock = psock;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, psock);
 
 	spin_unlock_bh(&mux->rx_lock);
 
@@ -310,7 +311,8 @@ static void unreserve_rx_kcm(struct kcm_psock *psock,
 	spin_lock_bh(&mux->rx_lock);
 
 	psock->rx_kcm = NULL;
-	kcm->rx_psock = NULL;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, NULL);
 
 	/* Commit kcm->rx_psock before sk_rmem_alloc_get to sync with
 	 * kcm_rfree
-- 
2.35.1



