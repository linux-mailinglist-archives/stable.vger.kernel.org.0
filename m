Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B211A9BB8
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408840AbgDOLFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:05:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37293 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408839AbgDOLDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:03:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 2C5D35C0158;
        Wed, 15 Apr 2020 07:03:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:03:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+fP91k
        9OuB57yPC/GWRLn3DMTh2rEUfu2seQZU88F5k=; b=D2Wu3MQlZWgkPeIJzJjL28
        sOYVXxJUArS0iNLGVhKmYpC0tCbouOLf+4V560Yg8UYdxJO6Pvx4qVq/NezK+2Ut
        bhwZAd3qXyefD05RTM9ItuN+UhgudDbqcOWcl9wJS9/MKMo/dtkZ7Hjze0nDC39e
        wRuy7b3011/cuyPAHjOXDr6hhL7yxi8+5ZFR+kyTVE+LK+CCepfN2e/TovOgWYdc
        P4LJ1hX6VD+0pPysyuOG4dP4Mh0wgfSzgn8TsflhZwBsAA0afk/0ryFhlD8IDCVU
        0b2pa+giAjan9mazqDHJTOTzkoNWk8U5LzQVflO4T9PWmf+MNBX+pOrpEyO1cGkw
        ==
X-ME-Sender: <xms:7umWXhPJtkXJKkA1qX4Eo5hzwxQxlpTWz_F1XeSNKjNR0NqeDi5EJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7umWXt-FKTy0toOSimD2iTeR-QmqNpqtzrcLt8yf4VoZmAB2hkAVcA>
    <xmx:7umWXpZyeR6fCklDaf0P1jsBftqt-kuAr4jukbywMDgV-6wFQlGslg>
    <xmx:7umWXlN6A8nS3QwNJe3--_S0qOadaqRV0BvRynf_83Yq1n-oeDAYQA>
    <xmx:7-mWXhRosk866S_EeSmeG52f5RYNHCD4T8kh5xraeB6HG5_E9Ehogw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6845A3060060;
        Wed, 15 Apr 2020 07:03:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm clone: Fix handling of partial region discards" failed to apply to 5.4-stable tree
To:     ntsironis@arrikto.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:03:09 +0200
Message-ID: <1586948589138112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4b5142905d4ff58a4b93f7c8eaa7ba829c0a53c9 Mon Sep 17 00:00:00 2001
From: Nikos Tsironis <ntsironis@arrikto.com>
Date: Fri, 27 Mar 2020 16:01:08 +0200
Subject: [PATCH] dm clone: Fix handling of partial region discards

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

diff --git a/drivers/md/dm-clone-metadata.c b/drivers/md/dm-clone-metadata.c
index c05b12110456..199e7af00858 100644
--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -850,6 +850,12 @@ int dm_clone_set_region_hydrated(struct dm_clone_metadata *cmd, unsigned long re
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
@@ -879,6 +885,13 @@ int dm_clone_cond_set_range(struct dm_clone_metadata *cmd, unsigned long start,
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
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index d1e1b5b56b1b..022dddcad647 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -293,10 +293,17 @@ static inline unsigned long bio_to_region(struct clone *clone, struct bio *bio)
 
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
@@ -454,7 +461,7 @@ static void trim_bio(struct bio *bio, sector_t sector, unsigned int len)
 
 static void complete_discard_bio(struct clone *clone, struct bio *bio, bool success)
 {
-	unsigned long rs, re;
+	unsigned long rs, nr_regions;
 
 	/*
 	 * If the destination device supports discards, remap and trim the
@@ -463,9 +470,9 @@ static void complete_discard_bio(struct clone *clone, struct bio *bio, bool succ
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
@@ -473,12 +480,21 @@ static void complete_discard_bio(struct clone *clone, struct bio *bio, bool succ
 
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
@@ -487,7 +503,7 @@ static void process_discard_bio(struct clone *clone, struct bio *bio)
 	 * The covered regions are already hydrated so we just need to pass
 	 * down the discard.
 	 */
-	if (dm_clone_is_range_hydrated(clone->cmd, rs, re - rs)) {
+	if (dm_clone_is_range_hydrated(clone->cmd, rs, nr_regions)) {
 		complete_discard_bio(clone, bio, true);
 		return;
 	}
@@ -1169,7 +1185,7 @@ static void process_deferred_discards(struct clone *clone)
 	int r = -EPERM;
 	struct bio *bio;
 	struct blk_plug plug;
-	unsigned long rs, re;
+	unsigned long rs, nr_regions;
 	struct bio_list discards = BIO_EMPTY_LIST;
 
 	spin_lock_irq(&clone->lock);
@@ -1185,14 +1201,13 @@ static void process_deferred_discards(struct clone *clone)
 
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

