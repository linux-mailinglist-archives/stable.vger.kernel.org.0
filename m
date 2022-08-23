Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13CA59E054
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358942AbiHWMDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359549AbiHWMBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871D997D6E;
        Tue, 23 Aug 2022 02:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DC4860F50;
        Tue, 23 Aug 2022 09:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBE0C433D6;
        Tue, 23 Aug 2022 09:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247322;
        bh=d3/bFyS6crCYfRMDCsNDfPmdhYyvVo9Ex+1NXh96UTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bb+2yx59CtHwFu2/w8tJTo+8f5jG8BD+xMfa+LV3R/U3TDo33fkANO0T/PRepsCfr
         Mhg+yBPoG5MqB5+1eTsCvuZv3jAmPEeA1yCysZE6ObhsizkXnE6Y7l9spileeEB1NT
         7IVAITUGy1mblufWEiPYdajvtFCavps8IhbfuAJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Qu Wenruo <wqu@suse.com>
Subject: [PATCH 5.4 388/389] btrfs: only write the sectors in the vertical stripe which has data stripes
Date:   Tue, 23 Aug 2022 10:27:46 +0200
Message-Id: <20220823080131.793099140@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/raid56.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)

--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -334,6 +334,9 @@ static void merge_rbio(struct btrfs_raid
 {
 	bio_list_merge(&dest->bio_list, &victim->bio_list);
 	dest->bio_list_bytes += victim->bio_list_bytes;
+	/* Also inherit the bitmaps from @victim. */
+	bitmap_or(dest->dbitmap, victim->dbitmap, dest->dbitmap,
+		  dest->stripe_npages);
 	dest->generic_bio_cnt += victim->generic_bio_cnt;
 	bio_list_init(&victim->bio_list);
 }
@@ -878,6 +881,12 @@ static void rbio_orig_end_io(struct btrf
 
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
@@ -1212,6 +1221,9 @@ static noinline void finish_rmw(struct b
 	else
 		BUG();
 
+	/* We should have at least one data sector. */
+	ASSERT(bitmap_weight(rbio->dbitmap, rbio->stripe_npages));
+
 	/* at this point we either have a full stripe,
 	 * or we've read the full stripe from the drive.
 	 * recalculate the parity and write the new results.
@@ -1285,6 +1297,11 @@ static noinline void finish_rmw(struct b
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
@@ -1309,6 +1326,11 @@ static noinline void finish_rmw(struct b
 
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
@@ -1748,6 +1770,33 @@ static void btrfs_raid_unplug(struct blk
 	run_plug(plug);
 }
 
+/* Add the original bio into rbio->bio_list, and update rbio::dbitmap. */
+static void rbio_add_bio(struct btrfs_raid_bio *rbio, struct bio *orig_bio)
+{
+	const struct btrfs_fs_info *fs_info = rbio->fs_info;
+	const u64 orig_logical = orig_bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	const u64 full_stripe_start = rbio->bbio->raid_map[0];
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
+			   PAGE_SHIFT) % rbio->stripe_npages;
+
+		set_bit(bit, rbio->dbitmap);
+	}
+}
+
 /*
  * our main entry point for writes from the rest of the FS.
  */
@@ -1764,9 +1813,8 @@ int raid56_parity_write(struct btrfs_fs_
 		btrfs_put_bbio(bbio);
 		return PTR_ERR(rbio);
 	}
-	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 	rbio->operation = BTRFS_RBIO_WRITE;
+	rbio_add_bio(rbio, bio);
 
 	btrfs_bio_counter_inc_noblocked(fs_info);
 	rbio->generic_bio_cnt = 1;
@@ -2170,8 +2218,7 @@ int raid56_parity_recover(struct btrfs_f
 	}
 
 	rbio->operation = BTRFS_RBIO_READ_REBUILD;
-	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_iter.bi_size;
+	rbio_add_bio(rbio, bio);
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {


