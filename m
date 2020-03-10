Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0A017FD55
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgCJMxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729094AbgCJMxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:53:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C3E24692;
        Tue, 10 Mar 2020 12:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844778;
        bh=zIkW5w5iHGe1BG22rwFNnqCuldDOaOwm7rAIwYEbfRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bgMR968t8JMrt0v/w2bS5Os0zfA40AakKCggt4Te5UKbaxqknrJqZBcXmCuNnT5o
         L0GuzM7uc59LNt+RK6u75mVT4TA2MrUXcUC6euuqIFLpG4f48DBCWyD1uokPrzcry8
         OtITkouUHaUboNQERnrrlzFBkqQEuN3kXSjtrM0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corey Marthaler <cmarthal@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 108/168] dm: report suspended device during destroy
Date:   Tue, 10 Mar 2020 13:39:14 +0100
Message-Id: <20200310123646.318562515@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit adc0daad366b62ca1bce3e2958a40b0b71a8b8b3 upstream.

The function dm_suspended returns true if the target is suspended.
However, when the target is being suspended during unload, it returns
false.

An example where this is a problem: the test "!dm_suspended(wc->ti)" in
writecache_writeback is not sufficient, because dm_suspended returns
zero while writecache_suspend is in progress.  As is, without an
enhanced dm_suspended, simply switching from flush_workqueue to
drain_workqueue still emits warnings:
workqueue writecache-writeback: drain_workqueue() isn't complete after 10 tries
workqueue writecache-writeback: drain_workqueue() isn't complete after 100 tries
workqueue writecache-writeback: drain_workqueue() isn't complete after 200 tries
workqueue writecache-writeback: drain_workqueue() isn't complete after 300 tries
workqueue writecache-writeback: drain_workqueue() isn't complete after 400 tries

writecache_suspend calls flush_workqueue(wc->writeback_wq) - this function
flushes the current work. However, the workqueue may re-queue itself and
flush_workqueue doesn't wait for re-queued works to finish. Because of
this - the function writecache_writeback continues execution after the
device was suspended and then concurrently with writecache_dtr, causing
a crash in writecache_writeback.

We must use drain_workqueue - that waits until the work and all re-queued
works finish.

As a prereq for switching to drain_workqueue, this commit fixes
dm_suspended to return true after the presuspend hook and before the
postsuspend hook - just like during a normal suspend. It allows
simplifying the dm-integrity and dm-writecache targets so that they
don't have to maintain suspended flags on their own.

With this change use of drain_workqueue() can be used effectively.  This
change was tested with the lvm2 testsuite and cryptsetup testsuite and
the are no regressions.

Fixes: 48debafe4f2f ("dm: add writecache target")
Cc: stable@vger.kernel.org # 4.18+
Reported-by: Corey Marthaler <cmarthal@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c  |   12 +++++-------
 drivers/md/dm-writecache.c |    2 +-
 drivers/md/dm.c            |    1 +
 3 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -199,12 +199,13 @@ struct dm_integrity_c {
 	__u8 log2_blocks_per_bitmap_bit;
 
 	unsigned char mode;
-	int suspending;
 
 	int failed;
 
 	struct crypto_shash *internal_hash;
 
+	struct dm_target *ti;
+
 	/* these variables are locked with endio_wait.lock */
 	struct rb_root in_progress;
 	struct list_head wait_list;
@@ -2311,7 +2312,7 @@ static void integrity_writer(struct work
 	unsigned prev_free_sectors;
 
 	/* the following test is not needed, but it tests the replay code */
-	if (READ_ONCE(ic->suspending) && !ic->meta_dev)
+	if (unlikely(dm_suspended(ic->ti)) && !ic->meta_dev)
 		return;
 
 	spin_lock_irq(&ic->endio_wait.lock);
@@ -2372,7 +2373,7 @@ static void integrity_recalc(struct work
 
 next_chunk:
 
-	if (unlikely(READ_ONCE(ic->suspending)))
+	if (unlikely(dm_suspended(ic->ti)))
 		goto unlock_ret;
 
 	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
@@ -2800,8 +2801,6 @@ static void dm_integrity_postsuspend(str
 
 	del_timer_sync(&ic->autocommit_timer);
 
-	WRITE_ONCE(ic->suspending, 1);
-
 	if (ic->recalc_wq)
 		drain_workqueue(ic->recalc_wq);
 
@@ -2830,8 +2829,6 @@ static void dm_integrity_postsuspend(str
 #endif
 	}
 
-	WRITE_ONCE(ic->suspending, 0);
-
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 
 	ic->journal_uptodate = true;
@@ -3615,6 +3612,7 @@ static int dm_integrity_ctr(struct dm_ta
 	}
 	ti->private = ic;
 	ti->per_io_data_size = sizeof(struct dm_integrity_io);
+	ic->ti = ti;
 
 	ic->in_progress = RB_ROOT;
 	INIT_LIST_HEAD(&ic->wait_list);
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -838,7 +838,7 @@ static void writecache_suspend(struct dm
 	}
 	wc_unlock(wc);
 
-	flush_workqueue(wc->writeback_wq);
+	drain_workqueue(wc->writeback_wq);
 
 	wc_lock(wc);
 	if (flush_on_suspend)
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2389,6 +2389,7 @@ static void __dm_destroy(struct mapped_d
 	map = dm_get_live_table(md, &srcu_idx);
 	if (!dm_suspended_md(md)) {
 		dm_table_presuspend_targets(map);
+		set_bit(DMF_SUSPENDED, &md->flags);
 		dm_table_postsuspend_targets(map);
 	}
 	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */


