Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166691ACAA6
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408249AbgDPPhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897913AbgDPNjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:39:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CEED20732;
        Thu, 16 Apr 2020 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044355;
        bh=16MRUCU6snLRWWVpqH8LfJr+huMqXQc8E9e/L4ZEB34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eF94o2dzxQ+BzdAqYCUV0h5tZw0p2IyNEoi99f1t39mF/3726ZOawATa8I8Kki5vp
         7sB9YPBsLGrrgBcCGiW1COAdAL+vS7+1MwJ+dZQeBiq1ool80ByFwPK5MpJRyYOVnJ
         T8JPee7xKQlFVNpuRZMZocAeqaygCK+/CQf26PhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.5 184/257] dm clone: Fix handling of partial region discards
Date:   Thu, 16 Apr 2020 15:23:55 +0200
Message-Id: <20200416131349.329846347@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 4b5142905d4ff58a4b93f7c8eaa7ba829c0a53c9 upstream.

There is a bug in the way dm-clone handles discards, which can lead to
discarding the wrong blocks or trying to discard blocks beyond the end
of the device.

This could lead to data corruption, if the destination device indeed
discards the underlying blocks, i.e., if the discard operation results
in the original contents of a block to be lost.

The root of the problem is the code that calculates the range of regions
covered by a discard request and decides which regions to discard.

Since dm-clone handles the device in units of regions, we don't discard
parts of a region, only whole regions.

The range is calculated as:

    rs = dm_sector_div_up(bio->bi_iter.bi_sector, clone->region_size);
    re = bio_end_sector(bio) >> clone->region_shift;

, where 'rs' is the first region to discard and (re - rs) is the number
of regions to discard.

The bug manifests when we try to discard part of a single region, i.e.,
when we try to discard a block with size < region_size, and the discard
request both starts at an offset with respect to the beginning of that
region and ends before the end of the region.

The root cause is the following comparison:

  if (rs == re)
    // skip discard and complete original bio immediately

, which doesn't take into account that 'rs' might be greater than 're'.

Thus, we then issue a discard request for the wrong blocks, instead of
skipping the discard all together.

Fix the check to also take into account the above case, so we don't end
up discarding the wrong blocks.

Also, add some range checks to dm_clone_set_region_hydrated() and
dm_clone_cond_set_range(), which update dm-clone's region bitmap.

Note that the aforementioned bug doesn't cause invalid memory accesses,
because dm_clone_is_range_hydrated() returns True for this case, so the
checks are just precautionary.

Fixes: 7431b7835f55 ("dm: add clone target")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-clone-metadata.c |   13 ++++++++++++
 drivers/md/dm-clone-target.c   |   43 +++++++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 14 deletions(-)

--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -850,6 +850,12 @@ int dm_clone_set_region_hydrated(struct
 	struct dirty_map *dmap;
 	unsigned long word, flags;
 
+	if (unlikely(region_nr >= cmd->nr_regions)) {
+		DMERR("Region %lu out of range (total number of regions %lu)",
+		      region_nr, cmd->nr_regions);
+		return -ERANGE;
+	}
+
 	word = region_nr / BITS_PER_LONG;
 
 	spin_lock_irqsave(&cmd->bitmap_lock, flags);
@@ -879,6 +885,13 @@ int dm_clone_cond_set_range(struct dm_cl
 	struct dirty_map *dmap;
 	unsigned long word, region_nr;
 
+	if (unlikely(start >= cmd->nr_regions || (start + nr_regions) < start ||
+		     (start + nr_regions) > cmd->nr_regions)) {
+		DMERR("Invalid region range: start %lu, nr_regions %lu (total number of regions %lu)",
+		      start, nr_regions, cmd->nr_regions);
+		return -ERANGE;
+	}
+
 	spin_lock_irq(&cmd->bitmap_lock);
 
 	if (cmd->read_only) {
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -293,10 +293,17 @@ static inline unsigned long bio_to_regio
 
 /* Get the region range covered by the bio */
 static void bio_region_range(struct clone *clone, struct bio *bio,
-			     unsigned long *rs, unsigned long *re)
+			     unsigned long *rs, unsigned long *nr_regions)
 {
+	unsigned long end;
+
 	*rs = dm_sector_div_up(bio->bi_iter.bi_sector, clone->region_size);
-	*re = bio_end_sector(bio) >> clone->region_shift;
+	end = bio_end_sector(bio) >> clone->region_shift;
+
+	if (*rs >= end)
+		*nr_regions = 0;
+	else
+		*nr_regions = end - *rs;
 }
 
 /* Check whether a bio overwrites a region */
@@ -454,7 +461,7 @@ static void trim_bio(struct bio *bio, se
 
 static void complete_discard_bio(struct clone *clone, struct bio *bio, bool success)
 {
-	unsigned long rs, re;
+	unsigned long rs, nr_regions;
 
 	/*
 	 * If the destination device supports discards, remap and trim the
@@ -463,9 +470,9 @@ static void complete_discard_bio(struct
 	 */
 	if (test_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags) && success) {
 		remap_to_dest(clone, bio);
-		bio_region_range(clone, bio, &rs, &re);
+		bio_region_range(clone, bio, &rs, &nr_regions);
 		trim_bio(bio, rs << clone->region_shift,
-			 (re - rs) << clone->region_shift);
+			 nr_regions << clone->region_shift);
 		generic_make_request(bio);
 	} else
 		bio_endio(bio);
@@ -473,12 +480,21 @@ static void complete_discard_bio(struct
 
 static void process_discard_bio(struct clone *clone, struct bio *bio)
 {
-	unsigned long rs, re;
+	unsigned long rs, nr_regions;
 
-	bio_region_range(clone, bio, &rs, &re);
-	BUG_ON(re > clone->nr_regions);
+	bio_region_range(clone, bio, &rs, &nr_regions);
+	if (!nr_regions) {
+		bio_endio(bio);
+		return;
+	}
 
-	if (unlikely(rs == re)) {
+	if (WARN_ON(rs >= clone->nr_regions || (rs + nr_regions) < rs ||
+		    (rs + nr_regions) > clone->nr_regions)) {
+		DMERR("%s: Invalid range (%lu + %lu, total regions %lu) for discard (%llu + %u)",
+		      clone_device_name(clone), rs, nr_regions,
+		      clone->nr_regions,
+		      (unsigned long long)bio->bi_iter.bi_sector,
+		      bio_sectors(bio));
 		bio_endio(bio);
 		return;
 	}
@@ -487,7 +503,7 @@ static void process_discard_bio(struct c
 	 * The covered regions are already hydrated so we just need to pass
 	 * down the discard.
 	 */
-	if (dm_clone_is_range_hydrated(clone->cmd, rs, re - rs)) {
+	if (dm_clone_is_range_hydrated(clone->cmd, rs, nr_regions)) {
 		complete_discard_bio(clone, bio, true);
 		return;
 	}
@@ -1169,7 +1185,7 @@ static void process_deferred_discards(st
 	int r = -EPERM;
 	struct bio *bio;
 	struct blk_plug plug;
-	unsigned long rs, re;
+	unsigned long rs, nr_regions;
 	struct bio_list discards = BIO_EMPTY_LIST;
 
 	spin_lock_irq(&clone->lock);
@@ -1185,14 +1201,13 @@ static void process_deferred_discards(st
 
 	/* Update the metadata */
 	bio_list_for_each(bio, &discards) {
-		bio_region_range(clone, bio, &rs, &re);
+		bio_region_range(clone, bio, &rs, &nr_regions);
 		/*
 		 * A discard request might cover regions that have been already
 		 * hydrated. There is no need to update the metadata for these
 		 * regions.
 		 */
-		r = dm_clone_cond_set_range(clone->cmd, rs, re - rs);
-
+		r = dm_clone_cond_set_range(clone->cmd, rs, nr_regions);
 		if (unlikely(r))
 			break;
 	}


