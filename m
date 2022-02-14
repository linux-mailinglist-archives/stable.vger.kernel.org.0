Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7053D4B47F0
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245596AbiBNJw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343814AbiBNJvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:51:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C9066F94;
        Mon, 14 Feb 2022 01:42:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB32BB80D83;
        Mon, 14 Feb 2022 09:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE08C340E9;
        Mon, 14 Feb 2022 09:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831730;
        bh=err9IuKH0aI3SPXb3bFE8Nkt5cImY9/9EJ9NwkyQ70s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPJFfhnCn6qbqx3pMqavSFbTgFM/+0eqZ0Ilr9zJI8uaQ5J6mTQAmLvhpoN+p9vf7
         KEC+mF8HH1E0OeU+d54X4umjX+HvSF7yrjajZzVyHsUsR8VwmEY5itEtHJWZF04YM1
         mGBUtQ04yegESL6PFPOcW4r6sDtQ7IBLpqPrTfzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/116] veth: fix races around rq->rx_notify_masked
Date:   Mon, 14 Feb 2022 10:26:17 +0100
Message-Id: <20220214092501.460006995@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 68468d8c4cd4222a4ca1f185ab5a1c14480d078c ]

veth being NETIF_F_LLTX enabled, we need to be more careful
whenever we read/write rq->rx_notify_masked.

BUG: KCSAN: data-race in veth_xmit / veth_xmit

write to 0xffff888133d9a9f8 of 1 bytes by task 23552 on cpu 0:
 __veth_xdp_flush drivers/net/veth.c:269 [inline]
 veth_xmit+0x307/0x470 drivers/net/veth.c:350
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3473
 dev_hard_start_xmit net/core/dev.c:3489 [inline]
 __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
 br_dev_queue_push_xmit+0x3ce/0x430 net/bridge/br_forward.c:53
 NF_HOOK include/linux/netfilter.h:307 [inline]
 br_forward_finish net/bridge/br_forward.c:66 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 __br_forward+0x2e4/0x400 net/bridge/br_forward.c:115
 br_flood+0x521/0x5c0 net/bridge/br_forward.c:242
 br_dev_xmit+0x8b6/0x960
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3473
 dev_hard_start_xmit net/core/dev.c:3489 [inline]
 __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
 neigh_hh_output include/net/neighbour.h:525 [inline]
 neigh_output include/net/neighbour.h:539 [inline]
 ip_finish_output2+0x6f8/0xb70 net/ipv4/ip_output.c:228
 ip_finish_output+0xfb/0x240 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:451 [inline]
 ip_local_out net/ipv4/ip_output.c:126 [inline]
 ip_send_skb+0x6e/0xe0 net/ipv4/ip_output.c:1570
 udp_send_skb+0x641/0x880 net/ipv4/udp.c:967
 udp_sendmsg+0x12ea/0x14c0 net/ipv4/udp.c:1254
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

read to 0xffff888133d9a9f8 of 1 bytes by task 23563 on cpu 1:
 __veth_xdp_flush drivers/net/veth.c:268 [inline]
 veth_xmit+0x2d6/0x470 drivers/net/veth.c:350
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3473
 dev_hard_start_xmit net/core/dev.c:3489 [inline]
 __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
 br_dev_queue_push_xmit+0x3ce/0x430 net/bridge/br_forward.c:53
 NF_HOOK include/linux/netfilter.h:307 [inline]
 br_forward_finish net/bridge/br_forward.c:66 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 __br_forward+0x2e4/0x400 net/bridge/br_forward.c:115
 br_flood+0x521/0x5c0 net/bridge/br_forward.c:242
 br_dev_xmit+0x8b6/0x960
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3473
 dev_hard_start_xmit net/core/dev.c:3489 [inline]
 __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
 neigh_hh_output include/net/neighbour.h:525 [inline]
 neigh_output include/net/neighbour.h:539 [inline]
 ip_finish_output2+0x6f8/0xb70 net/ipv4/ip_output.c:228
 ip_finish_output+0xfb/0x240 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:451 [inline]
 ip_local_out net/ipv4/ip_output.c:126 [inline]
 ip_send_skb+0x6e/0xe0 net/ipv4/ip_output.c:1570
 udp_send_skb+0x641/0x880 net/ipv4/udp.c:967
 udp_sendmsg+0x12ea/0x14c0 net/ipv4/udp.c:1254
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

value changed: 0x00 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 23563 Comm: syz-executor.5 Not tainted 5.17.0-rc2-syzkaller-00064-gc36c04c2e132 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 948d4f214fde ("veth: Add driver XDP")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index aef66f8eecee1..f7e3eb309a26e 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -256,9 +256,10 @@ static void __veth_xdp_flush(struct veth_rq *rq)
 {
 	/* Write ptr_ring before reading rx_notify_masked */
 	smp_mb();
-	if (!rq->rx_notify_masked) {
-		rq->rx_notify_masked = true;
-		napi_schedule(&rq->xdp_napi);
+	if (!READ_ONCE(rq->rx_notify_masked) &&
+	    napi_schedule_prep(&rq->xdp_napi)) {
+		WRITE_ONCE(rq->rx_notify_masked, true);
+		__napi_schedule(&rq->xdp_napi);
 	}
 }
 
@@ -852,8 +853,10 @@ static int veth_poll(struct napi_struct *napi, int budget)
 		/* Write rx_notify_masked before reading ptr_ring */
 		smp_store_mb(rq->rx_notify_masked, false);
 		if (unlikely(!__ptr_ring_empty(&rq->xdp_ring))) {
-			rq->rx_notify_masked = true;
-			napi_schedule(&rq->xdp_napi);
+			if (napi_schedule_prep(&rq->xdp_napi)) {
+				WRITE_ONCE(rq->rx_notify_masked, true);
+				__napi_schedule(&rq->xdp_napi);
+			}
 		}
 	}
 
-- 
2.34.1



