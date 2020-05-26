Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9755C1AC859
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438444AbgDPPHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408753AbgDPNvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:51:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92AD72063A;
        Thu, 16 Apr 2020 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045107;
        bh=S5yUT3XahH+vWAmWzWwpw2gx7g3yxN4oFFd7Z/MPZBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxdmb+lj/pVtlw8SeOHdHdvP2+VMylQKbJZRbJxFg4oob3z8KhrZqq6rSrZF1EeUy
         SCCKLQDogBcAgHA4s0JqmEv5XCLnRi5BGwtaHs/maIHqgs01sZhlqZi2uWchpW9oS7
         b2SG3B7W2pbWqJK0ZS8qIlC/qLvCqc5WBFAsMT9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 219/232] dm clone: replace spin_lock_irqsave with spin_lock_irq
Date:   Thu, 16 Apr 2020 15:25:13 +0200
Message-Id: <20200416131342.886025798@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6ca43ed8376a51afec790dd484a51804ade4352a ]

If we are in a place where it is known that interrupts are enabled,
functions spin_lock_irq/spin_unlock_irq should be used instead of
spin_lock_irqsave/spin_unlock_irqrestore.

spin_lock_irq and spin_unlock_irq are faster because they don't need to
push and pop the flags register.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-clone-metadata.c | 29 ++++++++++++-----------------
 drivers/md/dm-clone-metadata.h |  4 +++-
 drivers/md/dm-clone-target.c   | 28 ++++++++++++----------------
 3 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-clone-metadata.c b/drivers/md/dm-clone-metadata.c
index 2460cc6e0ef1d..581d11250333a 100644
--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -748,7 +748,7 @@ static int __metadata_commit(struct dm_clone_metadata *cmd)
 static int __flush_dmap(struct dm_clone_metadata *cmd, struct dirty_map *dmap)
 {
 	int r;
-	unsigned long word, flags;
+	unsigned long word;
 
 	word = 0;
 	do {
@@ -772,9 +772,9 @@ static int __flush_dmap(struct dm_clone_metadata *cmd, struct dirty_map *dmap)
 		return r;
 
 	/* Update the changed flag */
-	spin_lock_irqsave(&cmd->bitmap_lock, flags);
+	spin_lock_irq(&cmd->bitmap_lock);
 	dmap->changed = 0;
-	spin_unlock_irqrestore(&cmd->bitmap_lock, flags);
+	spin_unlock_irq(&cmd->bitmap_lock);
 
 	return 0;
 }
@@ -782,7 +782,6 @@ static int __flush_dmap(struct dm_clone_metadata *cmd, struct dirty_map *dmap)
 int dm_clone_metadata_pre_commit(struct dm_clone_metadata *cmd)
 {
 	int r = 0;
-	unsigned long flags;
 	struct dirty_map *dmap, *next_dmap;
 
 	down_write(&cmd->lock);
@@ -808,9 +807,9 @@ int dm_clone_metadata_pre_commit(struct dm_clone_metadata *cmd)
 	}
 
 	/* Swap dirty bitmaps */
-	spin_lock_irqsave(&cmd->bitmap_lock, flags);
+	spin_lock_irq(&cmd->bitmap_lock);
 	cmd->current_dmap = next_dmap;
-	spin_unlock_irqrestore(&cmd->bitmap_lock, flags);
+	spin_unlock_irq(&cmd->bitmap_lock);
 
 	/* Set old dirty bitmap as currently committing */
 	cmd->committing_dmap = dmap;
@@ -878,9 +877,9 @@ int dm_clone_cond_set_range(struct dm_clone_metadata *cmd, unsigned long start,
 {
 	int r = 0;
 	struct dirty_map *dmap;
-	unsigned long word, region_nr, flags;
+	unsigned long word, region_nr;
 
-	spin_lock_irqsave(&cmd->bitmap_lock, flags);
+	spin_lock_irq(&cmd->bitmap_lock);
 
 	if (cmd->read_only) {
 		r = -EPERM;
@@ -898,7 +897,7 @@ int dm_clone_cond_set_range(struct dm_clone_metadata *cmd, unsigned long start,
 		}
 	}
 out:
-	spin_unlock_irqrestore(&cmd->bitmap_lock, flags);
+	spin_unlock_irq(&cmd->bitmap_lock);
 
 	return r;
 }
@@ -965,13 +964,11 @@ int dm_clone_metadata_abort(struct dm_clone_metadata *cmd)
 
 void dm_clone_metadata_set_read_only(struct dm_clone_metadata *cmd)
 {
-	unsigned long flags;
-
 	down_write(&cmd->lock);
 
-	spin_lock_irqsave(&cmd->bitmap_lock, flags);
+	spin_lock_irq(&cmd->bitmap_lock);
 	cmd->read_only = 1;
-	spin_unlock_irqrestore(&cmd->bitmap_lock, flags);
+	spin_unlock_irq(&cmd->bitmap_lock);
 
 	if (!cmd->fail_io)
 		dm_bm_set_read_only(cmd->bm);
@@ -981,13 +978,11 @@ void dm_clone_metadata_set_read_only(struct dm_clone_metadata *cmd)
 
 void dm_clone_metadata_set_read_write(struct dm_clone_metadata *cmd)
 {
-	unsigned long flags;
-
 	down_write(&cmd->lock);
 
-	spin_lock_irqsave(&cmd->bitmap_lock, flags);
+	spin_lock_irq(&cmd->bitmap_lock);
 	cmd->read_only = 0;
-	spin_unlock_irqrestore(&cmd->bitmap_lock, flags);
+	spin_unlock_irq(&cmd->bitmap_lock);
 
 	if (!cmd->fail_io)
 		dm_bm_set_read_write(cmd->bm);
diff --git a/drivers/md/dm-clone-metadata.h b/drivers/md/dm-clone-metadata.h
index 6a217f5ea98c0..d848b8799c07d 100644
--- a/drivers/md/dm-clone-metadata.h
+++ b/drivers/md/dm-clone-metadata.h
@@ -44,7 +44,9 @@ int dm_clone_set_region_hydrated(struct dm_clone_metadata *cmd, unsigned long re
  * @start: Starting region number
  * @nr_regions: Number of regions in the range
  *
- * This function doesn't block, so it's safe to call it from interrupt context.
+ * This function doesn't block, but since it uses spin_lock_irq()/spin_unlock_irq()
+ * it's NOT safe to call it from any context where interrupts are disabled, e.g.,
+ * from interrupt context.
  */
 int dm_clone_cond_set_range(struct dm_clone_metadata *cmd, unsigned long start,
 			    unsigned long nr_regions);
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 2addf611ef3d8..ad5dca5d20707 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -338,8 +338,6 @@ static void submit_bios(struct bio_list *bios)
  */
 static void issue_bio(struct clone *clone, struct bio *bio)
 {
-	unsigned long flags;
-
 	if (!bio_triggers_commit(clone, bio)) {
 		generic_make_request(bio);
 		return;
@@ -358,9 +356,9 @@ static void issue_bio(struct clone *clone, struct bio *bio)
 	 * Batch together any bios that trigger commits and then issue a single
 	 * commit for them in process_deferred_flush_bios().
 	 */
-	spin_lock_irqsave(&clone->lock, flags);
+	spin_lock_irq(&clone->lock);
 	bio_list_add(&clone->deferred_flush_bios, bio);
-	spin_unlock_irqrestore(&clone->lock, flags);
+	spin_unlock_irq(&clone->lock);
 
 	wake_worker(clone);
 }
@@ -475,7 +473,7 @@ static void complete_discard_bio(struct clone *clone, struct bio *bio, bool succ
 
 static void process_discard_bio(struct clone *clone, struct bio *bio)
 {
-	unsigned long rs, re, flags;
+	unsigned long rs, re;
 
 	bio_region_range(clone, bio, &rs, &re);
 	BUG_ON(re > clone->nr_regions);
@@ -507,9 +505,9 @@ static void process_discard_bio(struct clone *clone, struct bio *bio)
 	/*
 	 * Defer discard processing.
 	 */
-	spin_lock_irqsave(&clone->lock, flags);
+	spin_lock_irq(&clone->lock);
 	bio_list_add(&clone->deferred_discard_bios, bio);
-	spin_unlock_irqrestore(&clone->lock, flags);
+	spin_unlock_irq(&clone->lock);
 
 	wake_worker(clone);
 }
@@ -1167,13 +1165,13 @@ static void process_deferred_discards(struct clone *clone)
 	int r = -EPERM;
 	struct bio *bio;
 	struct blk_plug plug;
-	unsigned long rs, re, flags;
+	unsigned long rs, re;
 	struct bio_list discards = BIO_EMPTY_LIST;
 
-	spin_lock_irqsave(&clone->lock, flags);
+	spin_lock_irq(&clone->lock);
 	bio_list_merge(&discards, &clone->deferred_discard_bios);
 	bio_list_init(&clone->deferred_discard_bios);
-	spin_unlock_irqrestore(&clone->lock, flags);
+	spin_unlock_irq(&clone->lock);
 
 	if (bio_list_empty(&discards))
 		return;
@@ -1203,13 +1201,12 @@ static void process_deferred_discards(struct clone *clone)
 
 static void process_deferred_bios(struct clone *clone)
 {
-	unsigned long flags;
 	struct bio_list bios = BIO_EMPTY_LIST;
 
-	spin_lock_irqsave(&clone->lock, flags);
+	spin_lock_irq(&clone->lock);
 	bio_list_merge(&bios, &clone->deferred_bios);
 	bio_list_init(&clone->deferred_bios);
-	spin_unlock_irqrestore(&clone->lock, flags);
+	spin_unlock_irq(&clone->lock);
 
 	if (bio_list_empty(&bios))
 		return;
@@ -1220,7 +1217,6 @@ static void process_deferred_bios(struct clone *clone)
 static void process_deferred_flush_bios(struct clone *clone)
 {
 	struct bio *bio;
-	unsigned long flags;
 	bool dest_dev_flushed;
 	struct bio_list bios = BIO_EMPTY_LIST;
 	struct bio_list bio_completions = BIO_EMPTY_LIST;
@@ -1229,13 +1225,13 @@ static void process_deferred_flush_bios(struct clone *clone)
 	 * If there are any deferred flush bios, we must commit the metadata
 	 * before issuing them or signaling their completion.
 	 */
-	spin_lock_irqsave(&clone->lock, flags);
+	spin_lock_irq(&clone->lock);
 	bio_list_merge(&bios, &clone->deferred_flush_bios);
 	bio_list_init(&clone->deferred_flush_bios);
 
 	bio_list_merge(&bio_completions, &clone->deferred_flush_completions);
 	bio_list_init(&clone->deferred_flush_completions);
-	spin_unlock_irqrestore(&clone->lock, flags);
+	spin_unlock_irq(&clone->lock);
 
 	if (bio_list_empty(&bios) && bio_list_empty(&bio_completions) &&
 	    !(dm_clone_changed_this_transaction(clone->cmd) && need_commit_due_to_time(clone)))
-- 
2.20.1



