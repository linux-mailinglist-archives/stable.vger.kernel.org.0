Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4175995B2
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 09:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346941AbiHSHCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 03:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346852AbiHSHCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 03:02:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3251FBA16C;
        Fri, 19 Aug 2022 00:02:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DDC995CAB3;
        Fri, 19 Aug 2022 07:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660892522; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SF6FXy0Ltjnt4GMl936S6rRrZATz9maIhVd3mPfxGQ4=;
        b=dyy1X8Om79H7oIAFJ1Bk7dIPcpjbJMO05JCHBv/rzt4Gcx71WQhddzjL8PORqsGGS+iq2q
        tJgbU0AiI9IhEs546SeF3HsSZJSDlWs54y5jGzu5KIcRWH5ItlPUYQMfVFzaa0UEwO7kOH
        nO/IIGoe6Zk6CzBcFcE9rRovhd9wm2g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5C12A13AC1;
        Fri, 19 Aug 2022 07:02:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qHmcD2g1/2JJRAAAMHmgww
        (envelope-from <wqu@suse.com>); Fri, 19 Aug 2022 07:02:00 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.19 1/2] btrfs: only write the sectors in the vertical stripe which has data stripes
Date:   Fri, 19 Aug 2022 15:01:38 +0800
Message-Id: <21fd4ed644aede2078f639c00291f3247bd03fcf.1660891713.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660891713.git.wqu@suse.com>
References: <cover.1660891713.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit bd8f7e627703ca5707833d623efcd43f104c7b3f upstream.

If we have only 8K partial write at the beginning of a full RAID56
stripe, we will write the following contents:

                    0  8K           32K             64K
Disk 1	(data):     |XX|            |               |
Disk 2  (data):     |               |               |
Disk 3  (parity):   |XXXXXXXXXXXXXXX|XXXXXXXXXXXXXXX|

|X| means the sector will be written back to disk.

Note that, although we won't write any sectors from disk 2, but we will
write the full 64KiB of parity to disk.

This behavior is fine for now, but not for the future (especially for
RAID56J, as we waste quite some space to journal the unused parity
stripes).

So here we will also utilize the btrfs_raid_bio::dbitmap, anytime we
queue a higher level bio into an rbio, we will update rbio::dbitmap to
indicate which vertical stripes we need to writeback.

And at finish_rmw(), we also check dbitmap to see if we need to write
any sector in the vertical stripe.

So after the patch, above example will only lead to the following
writeback pattern:

                    0  8K           32K             64K
Disk 1	(data):     |XX|            |               |
Disk 2  (data):     |               |               |
Disk 3  (parity):   |XX|            |               |

Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c | 53 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 13e0bb0479e6..ddf9f7a7418e 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -403,6 +403,9 @@ static void merge_rbio(struct btrfs_raid_bio *dest,
 {
 	bio_list_merge(&dest->bio_list, &victim->bio_list);
 	dest->bio_list_bytes += victim->bio_list_bytes;
+	/* Also inherit the bitmaps from @victim. */
+	bitmap_or(dest->dbitmap, victim->dbitmap, dest->dbitmap,
+		  dest->stripe_nsectors);
 	dest->generic_bio_cnt += victim->generic_bio_cnt;
 	bio_list_init(&victim->bio_list);
 }
@@ -944,6 +947,12 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
 
 	if (rbio->generic_bio_cnt)
 		btrfs_bio_counter_sub(rbio->bioc->fs_info, rbio->generic_bio_cnt);
+	/*
+	 * Clear the data bitmap, as the rbio may be cached for later usage.
+	 * do this before before unlock_stripe() so there will be no new bio
+	 * for this bio.
+	 */
+	bitmap_clear(rbio->dbitmap, 0, rbio->stripe_nsectors);
 
 	/*
 	 * At this moment, rbio->bio_list is empty, however since rbio does not
@@ -1294,6 +1303,9 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	else
 		BUG();
 
+	/* We should have at least one data sector. */
+	ASSERT(bitmap_weight(rbio->dbitmap, rbio->stripe_nsectors));
+
 	/* at this point we either have a full stripe,
 	 * or we've read the full stripe from the drive.
 	 * recalculate the parity and write the new results.
@@ -1368,6 +1380,10 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 		for (sectornr = 0; sectornr < rbio->stripe_nsectors; sectornr++) {
 			struct sector_ptr *sector;
 
+			/* This vertical stripe has no data, skip it. */
+			if (!test_bit(sectornr, rbio->dbitmap))
+				continue;
+
 			if (stripe < rbio->nr_data) {
 				sector = sector_in_rbio(rbio, stripe, sectornr, 1);
 				if (!sector)
@@ -1394,6 +1410,10 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 		for (sectornr = 0; sectornr < rbio->stripe_nsectors; sectornr++) {
 			struct sector_ptr *sector;
 
+			/* This vertical stripe has no data, skip it. */
+			if (!test_bit(sectornr, rbio->dbitmap))
+				continue;
+
 			if (stripe < rbio->nr_data) {
 				sector = sector_in_rbio(rbio, stripe, sectornr, 1);
 				if (!sector)
@@ -1845,6 +1865,33 @@ static void btrfs_raid_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	run_plug(plug);
 }
 
+/* Add the original bio into rbio->bio_list, and update rbio::dbitmap. */
+static void rbio_add_bio(struct btrfs_raid_bio *rbio, struct bio *orig_bio)
+{
+	const struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
+	const u64 orig_logical = orig_bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	const u64 full_stripe_start = rbio->bioc->raid_map[0];
+	const u32 orig_len = orig_bio->bi_iter.bi_size;
+	const u32 sectorsize = fs_info->sectorsize;
+	u64 cur_logical;
+
+	ASSERT(orig_logical >= full_stripe_start &&
+	       orig_logical + orig_len <= full_stripe_start +
+	       rbio->nr_data * rbio->stripe_len);
+
+	bio_list_add(&rbio->bio_list, orig_bio);
+	rbio->bio_list_bytes += orig_bio->bi_iter.bi_size;
+
+	/* Update the dbitmap. */
+	for (cur_logical = orig_logical; cur_logical < orig_logical + orig_len;
+	     cur_logical += sectorsize) {
+		int bit = ((u32)(cur_logical - full_stripe_start) >>
+			   fs_info->sectorsize_bits) % rbio->stripe_nsectors;
+
+		set_bit(bit, rbio->dbitmap);
+	}
+}
+
 /*
  * our main entry point for writes from the rest of the FS.
  */
@@ -1861,9 +1908,8 @@ int raid56_parity_write(struct bio *bio, struct btrfs_io_context *bioc, u32 stri
 		btrfs_put_bioc(bioc);
 		return PTR_ERR(rbio);
 	}
-	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 	rbio->operation = BTRFS_RBIO_WRITE;
+	rbio_add_bio(rbio, bio);
 
 	btrfs_bio_counter_inc_noblocked(fs_info);
 	rbio->generic_bio_cnt = 1;
@@ -2268,8 +2314,7 @@ int raid56_parity_recover(struct bio *bio, struct btrfs_io_context *bioc,
 	}
 
 	rbio->operation = BTRFS_RBIO_READ_REBUILD;
-	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_iter.bi_size;
+	rbio_add_bio(rbio, bio);
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
-- 
2.37.1

