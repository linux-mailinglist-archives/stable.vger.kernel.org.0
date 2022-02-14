Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E0A4B46D2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241244AbiBNJhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245413AbiBNJgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:36:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BF56DA9F;
        Mon, 14 Feb 2022 01:34:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE825B80DCC;
        Mon, 14 Feb 2022 09:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EDCC340E9;
        Mon, 14 Feb 2022 09:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831277;
        bh=o0pEpcsUFfgRzpuHWku1OvbvDzy+twvKJnNPSEj3M4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pie8z0pGOGuz2BzkDD6olacStzreB1fFWyijsOvqSXTM+4ifnDk5VIbvzR3Zihvb
         1s3+ZsRUh05mYLY/DJ3l52NXiKLholMvPOSpbl1G2LpHMHDWthC8ik7t96lhRZVOvA
         tMFeo1a/P9hFbGb0W1T0KmywLL6ojtBfHmxlUC7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/49] veth: fix races around rq->rx_notify_masked
Date:   Mon, 14 Feb 2022 10:25:57 +0100
Message-Id: <20220214092449.324113105@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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
index 5e988f7ec1743..76e834ca54e79 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -152,9 +152,10 @@ static void __veth_xdp_flush(struct veth_rq *rq)
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
 
@@ -623,8 +624,10 @@ static int veth_poll(struct napi_struct *napi, int budget)
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



