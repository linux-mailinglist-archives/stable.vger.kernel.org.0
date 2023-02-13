Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EAF6948CA
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjBMOx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjBMOxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:53:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FFE1CAE9
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3518361134
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C835C433D2;
        Mon, 13 Feb 2023 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676299986;
        bh=bomrllBPbjUk+T/6tWsLpiXreyR8+eczJ8i+U/3iC8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ku0LfWNvHvoeRJJBsa9F39n+rbaW3Z7TV873t3qCSxfbM+K5GvpfWvXcjtxVYrciN
         rzeEeFFE+VTMndJF+UkpYC/enfy4f+AnbxFRcP8s1VfvVupoWo0oW2Njkwq87/Js6i
         8R4TF+NSmfHmJ1yYgvVnCtDf1o33dcaOfaRORgDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/114] xfrm: annotate data-race around use_time
Date:   Mon, 13 Feb 2023 15:47:35 +0100
Message-Id: <20230213144743.196894495@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0a9e5794b21e2d1303759ff8fe5f9215db7757ba ]

KCSAN reported multiple cpus can update use_time
at the same time.

Adds READ_ONCE()/WRITE_ONCE() annotations.

Note that 32bit arches are not fully protected,
but they will probably no longer be supported/used in 2106.

BUG: KCSAN: data-race in __xfrm_policy_check / __xfrm_policy_check

write to 0xffff88813e7ec108 of 8 bytes by interrupt on cpu 0:
__xfrm_policy_check+0x6ae/0x17f0 net/xfrm/xfrm_policy.c:3664
__xfrm_policy_check2 include/net/xfrm.h:1174 [inline]
xfrm_policy_check include/net/xfrm.h:1179 [inline]
xfrm6_policy_check+0x2e9/0x320 include/net/xfrm.h:1189
udpv6_queue_rcv_one_skb+0x48/0xa30 net/ipv6/udp.c:703
udpv6_queue_rcv_skb+0x2d6/0x310 net/ipv6/udp.c:792
udp6_unicast_rcv_skb+0x16b/0x190 net/ipv6/udp.c:935
__udp6_lib_rcv+0x84b/0x9b0 net/ipv6/udp.c:1020
udpv6_rcv+0x4b/0x50 net/ipv6/udp.c:1133
ip6_protocol_deliver_rcu+0x99e/0x1020 net/ipv6/ip6_input.c:439
ip6_input_finish net/ipv6/ip6_input.c:484 [inline]
NF_HOOK include/linux/netfilter.h:302 [inline]
ip6_input+0xca/0x180 net/ipv6/ip6_input.c:493
dst_input include/net/dst.h:454 [inline]
ip6_rcv_finish+0x1e9/0x2d0 net/ipv6/ip6_input.c:79
NF_HOOK include/linux/netfilter.h:302 [inline]
ipv6_rcv+0x85/0x140 net/ipv6/ip6_input.c:309
__netif_receive_skb_one_core net/core/dev.c:5482 [inline]
__netif_receive_skb+0x8b/0x1b0 net/core/dev.c:5596
process_backlog+0x23f/0x3b0 net/core/dev.c:5924
__napi_poll+0x65/0x390 net/core/dev.c:6485
napi_poll net/core/dev.c:6552 [inline]
net_rx_action+0x37e/0x730 net/core/dev.c:6663
__do_softirq+0xf2/0x2c7 kernel/softirq.c:571
do_softirq+0xb1/0xf0 kernel/softirq.c:472
__local_bh_enable_ip+0x6f/0x80 kernel/softirq.c:396
__raw_read_unlock_bh include/linux/rwlock_api_smp.h:257 [inline]
_raw_read_unlock_bh+0x17/0x20 kernel/locking/spinlock.c:284
wg_socket_send_skb_to_peer+0x107/0x120 drivers/net/wireguard/socket.c:184
wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
wg_packet_tx_worker+0x142/0x360 drivers/net/wireguard/send.c:276
process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
worker_thread+0x618/0xa70 kernel/workqueue.c:2436
kthread+0x1a9/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

write to 0xffff88813e7ec108 of 8 bytes by interrupt on cpu 1:
__xfrm_policy_check+0x6ae/0x17f0 net/xfrm/xfrm_policy.c:3664
__xfrm_policy_check2 include/net/xfrm.h:1174 [inline]
xfrm_policy_check include/net/xfrm.h:1179 [inline]
xfrm6_policy_check+0x2e9/0x320 include/net/xfrm.h:1189
udpv6_queue_rcv_one_skb+0x48/0xa30 net/ipv6/udp.c:703
udpv6_queue_rcv_skb+0x2d6/0x310 net/ipv6/udp.c:792
udp6_unicast_rcv_skb+0x16b/0x190 net/ipv6/udp.c:935
__udp6_lib_rcv+0x84b/0x9b0 net/ipv6/udp.c:1020
udpv6_rcv+0x4b/0x50 net/ipv6/udp.c:1133
ip6_protocol_deliver_rcu+0x99e/0x1020 net/ipv6/ip6_input.c:439
ip6_input_finish net/ipv6/ip6_input.c:484 [inline]
NF_HOOK include/linux/netfilter.h:302 [inline]
ip6_input+0xca/0x180 net/ipv6/ip6_input.c:493
dst_input include/net/dst.h:454 [inline]
ip6_rcv_finish+0x1e9/0x2d0 net/ipv6/ip6_input.c:79
NF_HOOK include/linux/netfilter.h:302 [inline]
ipv6_rcv+0x85/0x140 net/ipv6/ip6_input.c:309
__netif_receive_skb_one_core net/core/dev.c:5482 [inline]
__netif_receive_skb+0x8b/0x1b0 net/core/dev.c:5596
process_backlog+0x23f/0x3b0 net/core/dev.c:5924
__napi_poll+0x65/0x390 net/core/dev.c:6485
napi_poll net/core/dev.c:6552 [inline]
net_rx_action+0x37e/0x730 net/core/dev.c:6663
__do_softirq+0xf2/0x2c7 kernel/softirq.c:571
do_softirq+0xb1/0xf0 kernel/softirq.c:472
__local_bh_enable_ip+0x6f/0x80 kernel/softirq.c:396
__raw_read_unlock_bh include/linux/rwlock_api_smp.h:257 [inline]
_raw_read_unlock_bh+0x17/0x20 kernel/locking/spinlock.c:284
wg_socket_send_skb_to_peer+0x107/0x120 drivers/net/wireguard/socket.c:184
wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
wg_packet_tx_worker+0x142/0x360 drivers/net/wireguard/send.c:276
process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
worker_thread+0x618/0xa70 kernel/workqueue.c:2436
kthread+0x1a9/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

value changed: 0x0000000063c62d6f -> 0x0000000063c62d70

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 4185 Comm: kworker/1:2 Tainted: G W 6.2.0-rc4-syzkaller-00009-gd532dd102151-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: wg-crypt-wg0 wg_packet_tx_worker

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 11 +++++++----
 net/xfrm/xfrm_state.c  | 10 +++++-----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index e392d8d05e0ca..52538d5360673 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -336,7 +336,7 @@ static void xfrm_policy_timer(struct timer_list *t)
 	}
 	if (xp->lft.hard_use_expires_seconds) {
 		time64_t tmo = xp->lft.hard_use_expires_seconds +
-			(xp->curlft.use_time ? : xp->curlft.add_time) - now;
+			(READ_ONCE(xp->curlft.use_time) ? : xp->curlft.add_time) - now;
 		if (tmo <= 0)
 			goto expired;
 		if (tmo < next)
@@ -354,7 +354,7 @@ static void xfrm_policy_timer(struct timer_list *t)
 	}
 	if (xp->lft.soft_use_expires_seconds) {
 		time64_t tmo = xp->lft.soft_use_expires_seconds +
-			(xp->curlft.use_time ? : xp->curlft.add_time) - now;
+			(READ_ONCE(xp->curlft.use_time) ? : xp->curlft.add_time) - now;
 		if (tmo <= 0) {
 			warn = 1;
 			tmo = XFRM_KM_TIMEOUT;
@@ -3586,7 +3586,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		return 1;
 	}
 
-	pol->curlft.use_time = ktime_get_real_seconds();
+	/* This lockless write can happen from different cpus. */
+	WRITE_ONCE(pol->curlft.use_time, ktime_get_real_seconds());
 
 	pols[0] = pol;
 	npols++;
@@ -3601,7 +3602,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 				xfrm_pol_put(pols[0]);
 				return 0;
 			}
-			pols[1]->curlft.use_time = ktime_get_real_seconds();
+			/* This write can happen from different cpus. */
+			WRITE_ONCE(pols[1]->curlft.use_time,
+				   ktime_get_real_seconds());
 			npols++;
 		}
 	}
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 3d2fe7712ac5b..0f88cb6fc3c22 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -572,7 +572,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	}
 	if (x->lft.hard_use_expires_seconds) {
 		long tmo = x->lft.hard_use_expires_seconds +
-			(x->curlft.use_time ? : now) - now;
+			(READ_ONCE(x->curlft.use_time) ? : now) - now;
 		if (tmo <= 0)
 			goto expired;
 		if (tmo < next)
@@ -594,7 +594,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	}
 	if (x->lft.soft_use_expires_seconds) {
 		long tmo = x->lft.soft_use_expires_seconds +
-			(x->curlft.use_time ? : now) - now;
+			(READ_ONCE(x->curlft.use_time) ? : now) - now;
 		if (tmo <= 0)
 			warn = 1;
 		else if (tmo < next)
@@ -1754,7 +1754,7 @@ int xfrm_state_update(struct xfrm_state *x)
 
 		hrtimer_start(&x1->mtimer, ktime_set(1, 0),
 			      HRTIMER_MODE_REL_SOFT);
-		if (x1->curlft.use_time)
+		if (READ_ONCE(x1->curlft.use_time))
 			xfrm_state_check_expire(x1);
 
 		if (x->props.smark.m || x->props.smark.v || x->if_id) {
@@ -1786,8 +1786,8 @@ EXPORT_SYMBOL(xfrm_state_update);
 
 int xfrm_state_check_expire(struct xfrm_state *x)
 {
-	if (!x->curlft.use_time)
-		x->curlft.use_time = ktime_get_real_seconds();
+	if (!READ_ONCE(x->curlft.use_time))
+		WRITE_ONCE(x->curlft.use_time, ktime_get_real_seconds());
 
 	if (x->curlft.bytes >= x->lft.hard_byte_limit ||
 	    x->curlft.packets >= x->lft.hard_packet_limit) {
-- 
2.39.0



