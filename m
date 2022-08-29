Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787B55A49DB
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbiH2LaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiH2L3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BDA7B1FE;
        Mon, 29 Aug 2022 04:17:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC14361265;
        Mon, 29 Aug 2022 11:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C08C433D6;
        Mon, 29 Aug 2022 11:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771833;
        bh=4vyBfHJMqDH0kiRRLnL90LgZzWk1Zt/AhZzOVdGozek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dkmZ5tOno9PlQspIXEFT8byOP2Ty5pZX0t7NhQX0MjMgS977GQgPJaFWXK+nZZJH
         cM/csUcsfVmbvmINulRHS5UIHoMOQ6tL6UCLKyMYDbnF64CP7+fedli5UWnhIMjFg9
         laoIWaCoVdnHYFiB3iR8DINc7d90P42j+BSZ2sYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>,
        Jan Kara <jack@suse.cz>,
        Michael Stapelberg <stapelberg+linux@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 111/158] writeback: avoid use-after-free after removing device
Date:   Mon, 29 Aug 2022 12:59:21 +0200
Message-Id: <20220829105813.761083165@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Khazhismel Kumykov <khazhy@chromium.org>

commit f87904c075515f3e1d8f4a7115869d3b914674fd upstream.

When a disk is removed, bdi_unregister gets called to stop further
writeback and wait for associated delayed work to complete.  However,
wb_inode_writeback_end() may schedule bandwidth estimation dwork after
this has completed, which can result in the timer attempting to access the
just freed bdi_writeback.

Fix this by checking if the bdi_writeback is alive, similar to when
scheduling writeback work.

Since this requires wb->work_lock, and wb_inode_writeback_end() may get
called from interrupt, switch wb->work_lock to an irqsafe lock.

Link: https://lkml.kernel.org/r/20220801155034.3772543-1-khazhy@google.com
Fixes: 45a2966fd641 ("writeback: fix bandwidth estimate for spiky workload")
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Michael Stapelberg <stapelberg+linux@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c   |   12 ++++++------
 mm/backing-dev.c    |   10 +++++-----
 mm/page-writeback.c |    6 +++++-
 3 files changed, 16 insertions(+), 12 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -134,10 +134,10 @@ static bool inode_io_list_move_locked(st
 
 static void wb_wakeup(struct bdi_writeback *wb)
 {
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 	if (test_bit(WB_registered, &wb->state))
 		mod_delayed_work(bdi_wq, &wb->dwork, 0);
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 }
 
 static void finish_writeback_work(struct bdi_writeback *wb,
@@ -164,7 +164,7 @@ static void wb_queue_work(struct bdi_wri
 	if (work->done)
 		atomic_inc(&work->done->cnt);
 
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 
 	if (test_bit(WB_registered, &wb->state)) {
 		list_add_tail(&work->list, &wb->work_list);
@@ -172,7 +172,7 @@ static void wb_queue_work(struct bdi_wri
 	} else
 		finish_writeback_work(wb, work);
 
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 }
 
 /**
@@ -2082,13 +2082,13 @@ static struct wb_writeback_work *get_nex
 {
 	struct wb_writeback_work *work = NULL;
 
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 	if (!list_empty(&wb->work_list)) {
 		work = list_entry(wb->work_list.next,
 				  struct wb_writeback_work, list);
 		list_del_init(&work->list);
 	}
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 	return work;
 }
 
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -260,10 +260,10 @@ void wb_wakeup_delayed(struct bdi_writeb
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 	if (test_bit(WB_registered, &wb->state))
 		queue_delayed_work(bdi_wq, &wb->dwork, timeout);
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 }
 
 static void wb_update_bandwidth_workfn(struct work_struct *work)
@@ -334,12 +334,12 @@ static void cgwb_remove_from_bdi_list(st
 static void wb_shutdown(struct bdi_writeback *wb)
 {
 	/* Make sure nobody queues further work */
-	spin_lock_bh(&wb->work_lock);
+	spin_lock_irq(&wb->work_lock);
 	if (!test_and_clear_bit(WB_registered, &wb->state)) {
-		spin_unlock_bh(&wb->work_lock);
+		spin_unlock_irq(&wb->work_lock);
 		return;
 	}
-	spin_unlock_bh(&wb->work_lock);
+	spin_unlock_irq(&wb->work_lock);
 
 	cgwb_remove_from_bdi_list(wb);
 	/*
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2867,6 +2867,7 @@ static void wb_inode_writeback_start(str
 
 static void wb_inode_writeback_end(struct bdi_writeback *wb)
 {
+	unsigned long flags;
 	atomic_dec(&wb->writeback_inodes);
 	/*
 	 * Make sure estimate of writeback throughput gets updated after
@@ -2875,7 +2876,10 @@ static void wb_inode_writeback_end(struc
 	 * that if multiple inodes end writeback at a similar time, they get
 	 * batched into one bandwidth update.
 	 */
-	queue_delayed_work(bdi_wq, &wb->bw_dwork, BANDWIDTH_INTERVAL);
+	spin_lock_irqsave(&wb->work_lock, flags);
+	if (test_bit(WB_registered, &wb->state))
+		queue_delayed_work(bdi_wq, &wb->bw_dwork, BANDWIDTH_INTERVAL);
+	spin_unlock_irqrestore(&wb->work_lock, flags);
 }
 
 bool __folio_end_writeback(struct folio *folio)


