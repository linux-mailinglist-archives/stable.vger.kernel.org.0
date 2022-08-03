Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B349858852B
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 02:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiHCAvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 20:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiHCAvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 20:51:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CD94C611;
        Tue,  2 Aug 2022 17:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14DAEB810B0;
        Wed,  3 Aug 2022 00:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8822C433D6;
        Wed,  3 Aug 2022 00:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659487859;
        bh=JhyWxsrgMyUj/JRIdNq3gJekYY7lNP4xubl40rJsemY=;
        h=Date:To:From:Subject:From;
        b=Heh4l/NB4JSSrKyuLbDYe4PPsa6bOZU7AYpZ9xVCy4r+nTC+SwUJBm+57ZHPuQspI
         DvhumlKuvz84NisnW0IPyDg0jn2MCupU0DgQNRuzujy6I+XcOT+z5H/KhvWvg5ViHX
         ao8tqWroj9qtlxtaP6LCqnb0XGxTrxrpcTiodJX0=
Date:   Tue, 02 Aug 2022 17:50:59 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stapelberg+linux@google.com, stable@vger.kernel.org,
        khazhy@google.com, jack@suse.cz, fengguang.wu@intel.com,
        khazhy@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-avoid-use-after-free-after-removing-device.patch added to mm-hotfixes-unstable branch
Message-Id: <20220803005059.B8822C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: writeback: avoid use-after-free after removing device
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     writeback-avoid-use-after-free-after-removing-device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-avoid-use-after-free-after-removing-device.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Khazhismel Kumykov <khazhy@chromium.org>
Subject: writeback: avoid use-after-free after removing device
Date: Mon, 1 Aug 2022 08:50:34 -0700

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
Cc: Jan Kara <jack@suse.cz>
Cc: Michael Stapelberg <stapelberg+linux@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c   |   12 ++++++------
 mm/backing-dev.c    |   10 +++++-----
 mm/page-writeback.c |    6 +++++-
 3 files changed, 16 insertions(+), 12 deletions(-)

--- a/fs/fs-writeback.c~writeback-avoid-use-after-free-after-removing-device
+++ a/fs/fs-writeback.c
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
 
--- a/mm/backing-dev.c~writeback-avoid-use-after-free-after-removing-device
+++ a/mm/backing-dev.c
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
--- a/mm/page-writeback.c~writeback-avoid-use-after-free-after-removing-device
+++ a/mm/page-writeback.c
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
_

Patches currently in -mm which might be from khazhy@chromium.org are

writeback-avoid-use-after-free-after-removing-device.patch

