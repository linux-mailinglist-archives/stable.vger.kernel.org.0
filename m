Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3194766CD43
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbjAPRfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbjAPReh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:34:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498C73BDA7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:10:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEB93B810A0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C34C433D2;
        Mon, 16 Jan 2023 17:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889045;
        bh=dIFI76H+3HKySnfrj/8RrdvNXumTys7GmJPQEr6L9T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udrTcwCGmLugnI9suz7O1CUcSWmuZHFKu8GJKquArLM3ivEq2wHRdTYnha0JKQs/H
         Avg8j73f7uICIxE+v5wCcHl4oMaz7HzeXD9qmOmNYz1j8Drt/poxNolU0MSU0bA199
         MfMYZEsWR7ZocD30v5FN7G0+P7Xa77vJ/fLrkbd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+6fd64001c20aa99e34a4@syzkaller.appspotmail.com,
        Schspa Shi <schspa@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 237/338] mrp: introduce active flags to prevent UAF when applicant uninit
Date:   Mon, 16 Jan 2023 16:51:50 +0100
Message-Id: <20230116154831.381822103@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Schspa Shi <schspa@gmail.com>

[ Upstream commit ab0377803dafc58f1e22296708c1c28e309414d6 ]

The caller of del_timer_sync must prevent restarting of the timer, If
we have no this synchronization, there is a small probability that the
cancellation will not be successful.

And syzbot report the fellowing crash:
==================================================================
BUG: KASAN: use-after-free in hlist_add_head include/linux/list.h:929 [inline]
BUG: KASAN: use-after-free in enqueue_timer+0x18/0xa4 kernel/time/timer.c:605
Write at addr f9ff000024df6058 by task syz-fuzzer/2256
Pointer tag: [f9], memory tag: [fe]

CPU: 1 PID: 2256 Comm: syz-fuzzer Not tainted 6.1.0-rc5-syzkaller-00008-
ge01d50cbd6ee #0
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace.part.0+0xe0/0xf0 arch/arm64/kernel/stacktrace.c:156
 dump_backtrace arch/arm64/kernel/stacktrace.c:162 [inline]
 show_stack+0x18/0x40 arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x68/0x84 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x1a8/0x4a0 mm/kasan/report.c:395
 kasan_report+0x94/0xb4 mm/kasan/report.c:495
 __do_kernel_fault+0x164/0x1e0 arch/arm64/mm/fault.c:320
 do_bad_area arch/arm64/mm/fault.c:473 [inline]
 do_tag_check_fault+0x78/0x8c arch/arm64/mm/fault.c:749
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
 hlist_add_head include/linux/list.h:929 [inline]
 enqueue_timer+0x18/0xa4 kernel/time/timer.c:605
 mod_timer+0x14/0x20 kernel/time/timer.c:1161
 mrp_periodic_timer_arm net/802/mrp.c:614 [inline]
 mrp_periodic_timer+0xa0/0xc0 net/802/mrp.c:627
 call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
 expire_timers+0x98/0xc4 kernel/time/timer.c:1519

To fix it, we can introduce a new active flags to make sure the timer will
not restart.

Reported-by: syzbot+6fd64001c20aa99e34a4@syzkaller.appspotmail.com

Signed-off-by: Schspa Shi <schspa@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mrp.h |  1 +
 net/802/mrp.c     | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/net/mrp.h b/include/net/mrp.h
index ef58b4a07190..c6c53370e390 100644
--- a/include/net/mrp.h
+++ b/include/net/mrp.h
@@ -120,6 +120,7 @@ struct mrp_applicant {
 	struct sk_buff		*pdu;
 	struct rb_root		mad;
 	struct rcu_head		rcu;
+	bool			active;
 };
 
 struct mrp_port {
diff --git a/net/802/mrp.c b/net/802/mrp.c
index 7a893a03e795..fb4d1e9c0bb2 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -609,7 +609,10 @@ static void mrp_join_timer(unsigned long data)
 	spin_unlock(&app->lock);
 
 	mrp_queue_xmit(app);
-	mrp_join_timer_arm(app);
+	spin_lock(&app->lock);
+	if (likely(app->active))
+		mrp_join_timer_arm(app);
+	spin_unlock(&app->lock);
 }
 
 static void mrp_periodic_timer_arm(struct mrp_applicant *app)
@@ -623,11 +626,12 @@ static void mrp_periodic_timer(unsigned long data)
 	struct mrp_applicant *app = (struct mrp_applicant *)data;
 
 	spin_lock(&app->lock);
-	mrp_mad_event(app, MRP_EVENT_PERIODIC);
-	mrp_pdu_queue(app);
+	if (likely(app->active)) {
+		mrp_mad_event(app, MRP_EVENT_PERIODIC);
+		mrp_pdu_queue(app);
+		mrp_periodic_timer_arm(app);
+	}
 	spin_unlock(&app->lock);
-
-	mrp_periodic_timer_arm(app);
 }
 
 static int mrp_pdu_parse_end_mark(struct sk_buff *skb, int *offset)
@@ -875,6 +879,7 @@ int mrp_init_applicant(struct net_device *dev, struct mrp_application *appl)
 	app->dev = dev;
 	app->app = appl;
 	app->mad = RB_ROOT;
+	app->active = true;
 	spin_lock_init(&app->lock);
 	skb_queue_head_init(&app->queue);
 	rcu_assign_pointer(dev->mrp_port->applicants[appl->type], app);
@@ -904,6 +909,9 @@ void mrp_uninit_applicant(struct net_device *dev, struct mrp_application *appl)
 
 	RCU_INIT_POINTER(port->applicants[appl->type], NULL);
 
+	spin_lock_bh(&app->lock);
+	app->active = false;
+	spin_unlock_bh(&app->lock);
 	/* Delete timer and generate a final TX event to flush out
 	 * all pending messages before the applicant is gone.
 	 */
-- 
2.35.1



