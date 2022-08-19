Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6BC5997B8
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 10:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345812AbiHSIky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 04:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347339AbiHSIkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 04:40:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A2B54C92;
        Fri, 19 Aug 2022 01:40:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6E4165CADE;
        Fri, 19 Aug 2022 08:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660898410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yogtGeU6T4HwxQaQOjei0BPw0BmkB0QRhftalud8vGU=;
        b=aVgRC4gGwK9KhUUr3xNDIHDHC+pdaH6aHdlW7AVrvWiliHTub96M1EPOe+pIvx5jFvjSzT
        vTNu7QRHlzNxWO+CyG1Y30Oovx0PRuton/8lB850uTT73O4H9KFIQwGQBBRZH8zkM0lILa
        jodoSTBZcoR9EXOjj2LjiFBaD+4GHe4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 36C4A13AE9;
        Fri, 19 Aug 2022 08:40:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uKaTOmhM/2LDagAAMHmgww
        (envelope-from <wqu@suse.com>); Fri, 19 Aug 2022 08:40:08 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.15 1/2] btrfs: only write the sectors in the vertical stripe which has data stripes
Date:   Fri, 19 Aug 2022 16:39:49 +0800
Message-Id: <e1694a5724fa6b950b10566599a492ce4537f772.1660898037.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660898037.git.wqu@suse.com>
References: <cover.1660898037.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 fs/btrfs/raid56.c | 55 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 893d93e3c516..13a7bab7ff4e 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -324,6 +324,9 @@ static void merge_rbio(struct btrfs_raid_bio *dest,
 {
 	bio_list_merge(&dest->bio_list, &victim->bio_list);
 	dest->bio_list_bytes += victim->bio_list_bytes;
+	/* Also inherit the bitmaps from @victim. */
+	bitmap_or(dest->dbitmap, victim->dbitmap, dest->dbitmap,
+		  dest->stripe_npages);
 	dest->generic_bio_cnt += victim->generic_bio_cnt;
 	bio_list_init(&victim->bio_list);
 }
@@ -865,6 +868,12 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
 
 	if (rbio->generic_bio_cnt)
 		btrfs_bio_counter_sub(rbio->fs_info, rbio->generic_bio_cnt);
+	/*
+	 * Clear the data bitmap, as the rbio may be cached for later usage.
+	 * do this before before unlock_stripe() so there will be no new bio
+	 * for this bio.
+	 */
+	bitmap_clear(rbio->dbitmap, 0, rbio->stripe_npages);
 
 	/*
 	 * At this moment, rbio->bio_list is empty, however since rbio does not
@@ -1197,6 +1206,9 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	else
 		BUG();
 
+	/* We should have at least one data sector. */
+	ASSERT(bitmap_weight(rbio->dbitmap, rbio->stripe_npages));
+
 	/* at this point we either have a full stripe,
 	 * or we've read the full stripe from the drive.
 	 * recalculate the parity and write the new results.
@@ -1268,6 +1280,11 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
 		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
 			struct page *page;
+
+			/* This vertical stripe has no data, skip it. */
+			if (!test_bit(pagenr, rbio->dbitmap))
+				continue;
+
 			if (stripe < rbio->nr_data) {
 				page = page_in_rbio(rbio, stripe, pagenr, 1);
 				if (!page)
@@ -1292,6 +1309,11 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 
 		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
 			struct page *page;
+
+			/* This vertical stripe has no data, skip it. */
+			if (!test_bit(pagenr, rbio->dbitmap))
+				continue;
+
 			if (stripe < rbio->nr_data) {
 				page = page_in_rbio(rbio, stripe, pagenr, 1);
 				if (!page)
@@ -1715,6 +1737,33 @@ static void btrfs_raid_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	run_plug(plug);
 }
 
+/* Add the original bio into rbio->bio_list, and update rbio::dbitmap. */
+static void rbio_add_bio(struct btrfs_raid_bio *rbio, struct bio *orig_bio)
+{
+	const struct btrfs_fs_info *fs_info = rbio->fs_info;
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
+			   fs_info->sectorsize_bits) % rbio->stripe_npages;
+
+		set_bit(bit, rbio->dbitmap);
+	}
+}
+
 /*
  * our main entry point for writes from the rest of the FS.
  */
@@ -1731,9 +1780,8 @@ int raid56_parity_write(struct btrfs_fs_info *fs_info, struct bio *bio,
 		btrfs_put_bioc(bioc);
 		return PTR_ERR(rbio);
 	}
-	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 	rbio->operation = BTRFS_RBIO_WRITE;
+	rbio_add_bio(rbio, bio);
 
 	btrfs_bio_counter_inc_noblocked(fs_info);
 	rbio->generic_bio_cnt = 1;
@@ -2135,8 +2183,7 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
 	}
 
 	rbio->operation = BTRFS_RBIO_READ_REBUILD;
-	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_iter.bi_size;
+	rbio_add_bio(rbio, bio);
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
-- 
2.37.1

