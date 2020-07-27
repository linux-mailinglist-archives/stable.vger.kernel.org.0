Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E669422F0AD
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732074AbgG0O0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732650AbgG0O0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:26:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5880321744;
        Mon, 27 Jul 2020 14:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595860000;
        bh=ryFPf0gi8ONfmeI9fC5hycejzOITrJfCPPB3Lb9o6v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngdTw5U241tbq5i3mSq/Vv/IjOXgrhbj9vbPrxMghh4qh+xiPhUYQrVRlVwS9gtJT
         KfuQBXSFZcD1HHarjAUSMXrNXkmygw6omYzLfi/w6/q4FDM+q9hiQT2QdrwXmzhhVA
         sDVy6+LR8Ly2XA4AM7MGDx1WtT1YxbCYEl+Sqh9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.7 177/179] dm integrity: fix integrity recalculation that is improperly skipped
Date:   Mon, 27 Jul 2020 16:05:52 +0200
Message-Id: <20200727134941.277738499@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5df96f2b9f58a5d2dc1f30fe7de75e197f2c25f2 upstream.

Commit adc0daad366b62ca1bce3e2958a40b0b71a8b8b3 ("dm: report suspended
device during destroy") broke integrity recalculation.

The problem is dm_suspended() returns true not only during suspend,
but also during resume. So this race condition could occur:
1. dm_integrity_resume calls queue_work(ic->recalc_wq, &ic->recalc_work)
2. integrity_recalc (&ic->recalc_work) preempts the current thread
3. integrity_recalc calls if (unlikely(dm_suspended(ic->ti))) goto unlock_ret;
4. integrity_recalc exits and no recalculating is done.

To fix this race condition, add a function dm_post_suspending that is
only true during the postsuspend phase and use it instead of
dm_suspended().

Signed-off-by: Mikulas Patocka <mpatocka redhat com>
Fixes: adc0daad366b ("dm: report suspended device during destroy")
Cc: stable vger kernel org # v4.18+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c     |    4 ++--
 drivers/md/dm.c               |   17 +++++++++++++++++
 include/linux/device-mapper.h |    1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2424,7 +2424,7 @@ static void integrity_writer(struct work
 	unsigned prev_free_sectors;
 
 	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_suspended(ic->ti)) && !ic->meta_dev)
+	if (unlikely(dm_post_suspending(ic->ti)) && !ic->meta_dev)
 		return;
 
 	spin_lock_irq(&ic->endio_wait.lock);
@@ -2485,7 +2485,7 @@ static void integrity_recalc(struct work
 
 next_chunk:
 
-	if (unlikely(dm_suspended(ic->ti)))
+	if (unlikely(dm_post_suspending(ic->ti)))
 		goto unlock_ret;
 
 	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -142,6 +142,7 @@ EXPORT_SYMBOL_GPL(dm_bio_get_target_bio_
 #define DMF_NOFLUSH_SUSPENDING 5
 #define DMF_DEFERRED_REMOVE 6
 #define DMF_SUSPENDED_INTERNALLY 7
+#define DMF_POST_SUSPENDING 8
 
 #define DM_NUMA_NODE NUMA_NO_NODE
 static int dm_numa_node = DM_NUMA_NODE;
@@ -2385,6 +2386,7 @@ static void __dm_destroy(struct mapped_d
 	if (!dm_suspended_md(md)) {
 		dm_table_presuspend_targets(map);
 		set_bit(DMF_SUSPENDED, &md->flags);
+		set_bit(DMF_POST_SUSPENDING, &md->flags);
 		dm_table_postsuspend_targets(map);
 	}
 	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */
@@ -2743,7 +2745,9 @@ retry:
 	if (r)
 		goto out_unlock;
 
+	set_bit(DMF_POST_SUSPENDING, &md->flags);
 	dm_table_postsuspend_targets(map);
+	clear_bit(DMF_POST_SUSPENDING, &md->flags);
 
 out_unlock:
 	mutex_unlock(&md->suspend_lock);
@@ -2840,7 +2844,9 @@ static void __dm_internal_suspend(struct
 	(void) __dm_suspend(md, map, suspend_flags, TASK_UNINTERRUPTIBLE,
 			    DMF_SUSPENDED_INTERNALLY);
 
+	set_bit(DMF_POST_SUSPENDING, &md->flags);
 	dm_table_postsuspend_targets(map);
+	clear_bit(DMF_POST_SUSPENDING, &md->flags);
 }
 
 static void __dm_internal_resume(struct mapped_device *md)
@@ -3001,6 +3007,11 @@ int dm_suspended_md(struct mapped_device
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+static int dm_post_suspending_md(struct mapped_device *md)
+{
+	return test_bit(DMF_POST_SUSPENDING, &md->flags);
+}
+
 int dm_suspended_internally_md(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
@@ -3017,6 +3028,12 @@ int dm_suspended(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_suspended);
 
+int dm_post_suspending(struct dm_target *ti)
+{
+	return dm_post_suspending_md(dm_table_get_md(ti->table));
+}
+EXPORT_SYMBOL_GPL(dm_post_suspending);
+
 int dm_noflush_suspending(struct dm_target *ti)
 {
 	return __noflush_suspending(dm_table_get_md(ti->table));
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -426,6 +426,7 @@ const char *dm_device_name(struct mapped
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct dm_target *ti);
+int dm_post_suspending(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
 union map_info *dm_get_rq_mapinfo(struct request *rq);


