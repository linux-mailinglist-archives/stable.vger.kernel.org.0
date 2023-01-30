Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8DC68114C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbjA3OLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbjA3OLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:11:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BE43BD87
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF47F6108A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1339C433D2;
        Mon, 30 Jan 2023 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087906;
        bh=eFYx3TNNvA7y0yV7IxrgEJaeHyogYEQgkFiuevykvPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPZf8Er3SQFIFAHf/5zw4sG47btI1t7H2Y5QQWVXIwEzwbGM7DH/8Sjf9yeISdh0u
         REjK1aUkcHSeRV2VUkYH0a991CMCM45ruC4+qoQA32MHAkkt419XRRIQUReBI3VxsE
         kIVVa5Cbqk+nsGlhppl1rAOGV4q29DLphkBV4SR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/204] net/sched: sch_taprio: fix possible use-after-free
Date:   Mon, 30 Jan 2023 14:50:15 +0100
Message-Id: <20230130134318.522583807@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3a415d59c1dbec9d772dbfab2d2520d98360caae ]

syzbot reported a nasty crash [1] in net_tx_action() which
made little sense until we got a repro.

This repro installs a taprio qdisc, but providing an
invalid TCA_RATE attribute.

qdisc_create() has to destroy the just initialized
taprio qdisc, and taprio_destroy() is called.

However, the hrtimer used by taprio had already fired,
therefore advance_sched() called __netif_schedule().

Then net_tx_action was trying to use a destroyed qdisc.

We can not undo the __netif_schedule(), so we must wait
until one cpu serviced the qdisc before we can proceed.

Many thanks to Alexander Potapenko for his help.

[1]
BUG: KMSAN: uninit-value in queued_spin_trylock include/asm-generic/qspinlock.h:94 [inline]
BUG: KMSAN: uninit-value in do_raw_spin_trylock include/linux/spinlock.h:191 [inline]
BUG: KMSAN: uninit-value in __raw_spin_trylock include/linux/spinlock_api_smp.h:89 [inline]
BUG: KMSAN: uninit-value in _raw_spin_trylock+0x92/0xa0 kernel/locking/spinlock.c:138
 queued_spin_trylock include/asm-generic/qspinlock.h:94 [inline]
 do_raw_spin_trylock include/linux/spinlock.h:191 [inline]
 __raw_spin_trylock include/linux/spinlock_api_smp.h:89 [inline]
 _raw_spin_trylock+0x92/0xa0 kernel/locking/spinlock.c:138
 spin_trylock include/linux/spinlock.h:359 [inline]
 qdisc_run_begin include/net/sch_generic.h:187 [inline]
 qdisc_run+0xee/0x540 include/net/pkt_sched.h:125
 net_tx_action+0x77c/0x9a0 net/core/dev.c:5086
 __do_softirq+0x1cc/0x7fb kernel/softirq.c:571
 run_ksoftirqd+0x2c/0x50 kernel/softirq.c:934
 smpboot_thread_fn+0x554/0x9f0 kernel/smpboot.c:164
 kthread+0x31b/0x430 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3258 [inline]
 __kmalloc_node_track_caller+0x814/0x1250 mm/slub.c:4970
 kmalloc_reserve net/core/skbuff.c:358 [inline]
 __alloc_skb+0x346/0xcf0 net/core/skbuff.c:430
 alloc_skb include/linux/skbuff.h:1257 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 netlink_ack+0x5f3/0x12b0 net/netlink/af_netlink.c:2436
 netlink_rcv_skb+0x55d/0x6c0 net/netlink/af_netlink.c:2507
 rtnetlink_rcv+0x30/0x40 net/core/rtnetlink.c:6108
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xabc/0xe90 net/socket.c:2482
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2536
 __sys_sendmsg net/socket.c:2565 [inline]
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2572
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 6.0.0-rc2-syzkaller-47461-gac3859c02d7f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 7 +++++++
 net/sched/sch_taprio.c    | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 891b44d80c98..6906da5c733e 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1335,4 +1335,11 @@ void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
 
 int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
 
+/* Make sure qdisc is no longer in SCHED state. */
+static inline void qdisc_synchronize(const struct Qdisc *q)
+{
+	while (test_bit(__QDISC_STATE_SCHED, &q->state))
+		msleep(1);
+}
+
 #endif
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index bd10a8eeb82d..a76a2afe9585 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1632,6 +1632,8 @@ static void taprio_reset(struct Qdisc *sch)
 	int i;
 
 	hrtimer_cancel(&q->advance_timer);
+	qdisc_synchronize(sch);
+
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues; i++)
 			if (q->qdiscs[i])
@@ -1653,6 +1655,7 @@ static void taprio_destroy(struct Qdisc *sch)
 	 * happens in qdisc_create(), after taprio_init() has been called.
 	 */
 	hrtimer_cancel(&q->advance_timer);
+	qdisc_synchronize(sch);
 
 	taprio_disable_offload(dev, q, NULL);
 
-- 
2.39.0



