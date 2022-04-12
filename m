Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F874FE145
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 14:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354984AbiDLM7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 08:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354717AbiDLM4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 08:56:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09AF4BFC1;
        Tue, 12 Apr 2022 05:30:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8E1161F858;
        Tue, 12 Apr 2022 12:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649766638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NM2GpfCd8nFNsgG+e/0yorBSU2ROiUfUMusRblx8+Es=;
        b=gJ+OzLio+fKNXoJLJPIu6n7TAPsi5Ms3I3x3Vv88KyzfmEAs06g/0TSGp4tYM0sNwAFrJh
        UltoVrCheEmmTROA1QptRPrZL8yNObopxXp6GCJtJ7m55IKlBEEsUhAs1GTT/gcoUD9Z+a
        INvdejAHnNuIZ1L/2DHdkfk47JGUDJY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 86FCD13A99;
        Tue, 12 Apr 2022 12:30:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yDUSMexwVWKBewAAMHmgww
        (envelope-from <wqu@suse.com>); Tue, 12 Apr 2022 12:30:36 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: avoid double clean up when submit_one_bio() failed
Date:   Tue, 12 Apr 2022 20:30:13 +0800
Message-Id: <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649766550.git.wqu@suse.com>
References: <cover.1649766550.git.wqu@suse.com>
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

[BUG]
When running generic/475 with 64K page size and 4K sector size, it has a
very high chance (almost 100%) to hang, with mostly data page locked but
no one is going to unlock it.

[CAUSE]
With commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
reads"), if we failed to lookup checksum due to metadata IO error, we
will return error for btrfs_submit_data_bio().

This will cause the page to be unlocked twice in btrfs_do_readpage():

 btrfs_do_readpage()
 |- submit_extent_page()
 |  |- submit_one_bio()
 |     |- btrfs_submit_data_bio()
 |        |- if (ret) {
 |        |-     bio->bi_status = ret;
 |        |-     bio_endio(bio); }
 |               In the endio function, we will call end_page_read()
 |               and unlock_extent() to cleanup the subpage range.
 |
 |- if (ret) {
 |-        unlock_extent(); end_page_read() }
           Here we unlock the extent and cleanup the subpage range
           again.

For unlock_extent(), it's mostly double unlock safe.

But for end_page_read(), it's not, especially for subpage case,
as for subpage case we will call btrfs_subpage_end_reader() to reduce
the reader number, and use that to number to determine if we need to
unlock the full page.

If double accounted, it can underflow the number and leave the page
locked without anyone to unlock it.

[FIX]
The commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
reads") itself is completely fine, it's our existing code not properly
handling the error from bio submission hook properly.

This patch will make submit_one_bio() to return void so that the callers
will never be able to do cleanup when bio submission hook fails.

CC: stable@vger.kernel.org # 5.18+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 114 ++++++++++++++-----------------------------
 fs/btrfs/extent_io.h |   3 +-
 fs/btrfs/inode.c     |  13 +++--
 3 files changed, 44 insertions(+), 86 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 15a429e28174..163aa6dee987 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -166,24 +166,27 @@ static int add_extent_changeset(struct extent_state *state, u32 bits,
 	return ret;
 }
 
-int __must_check submit_one_bio(struct bio *bio, int mirror_num,
-				unsigned long bio_flags)
+void submit_one_bio(struct bio *bio, int mirror_num, unsigned long bio_flags)
 {
-	blk_status_t ret = 0;
 	struct extent_io_tree *tree = bio->bi_private;
 
 	bio->bi_private = NULL;
 
 	/* Caller should ensure the bio has at least some range added */
 	ASSERT(bio->bi_iter.bi_size);
+
 	if (is_data_inode(tree->private_data))
-		ret = btrfs_submit_data_bio(tree->private_data, bio, mirror_num,
+		btrfs_submit_data_bio(tree->private_data, bio, mirror_num,
 					    bio_flags);
 	else
-		ret = btrfs_submit_metadata_bio(tree->private_data, bio,
+		btrfs_submit_metadata_bio(tree->private_data, bio,
 						mirror_num, bio_flags);
-
-	return blk_status_to_errno(ret);
+	/*
+	 * Above submission hooks will handle the error by ending the bio,
+	 * which will do the cleanup properly.
+	 * So here we should not return any error, or the caller of
+	 * submit_extent_page() will do cleanup again, causing problems.
+	 */
 }
 
 /* Cleanup unsubmitted bios */
@@ -204,13 +207,12 @@ static void end_write_bio(struct extent_page_data *epd, int ret)
  * Return 0 if everything is OK.
  * Return <0 for error.
  */
-static int __must_check flush_write_bio(struct extent_page_data *epd)
+static void flush_write_bio(struct extent_page_data *epd)
 {
-	int ret = 0;
 	struct bio *bio = epd->bio_ctrl.bio;
 
 	if (bio) {
-		ret = submit_one_bio(bio, 0, 0);
+		submit_one_bio(bio, 0, 0);
 		/*
 		 * Clean up of epd->bio is handled by its endio function.
 		 * And endio is either triggered by successful bio execution
@@ -220,7 +222,6 @@ static int __must_check flush_write_bio(struct extent_page_data *epd)
 		 */
 		epd->bio_ctrl.bio = NULL;
 	}
-	return ret;
 }
 
 int __init extent_state_cache_init(void)
@@ -3441,10 +3442,8 @@ static int submit_extent_page(unsigned int opf,
 	ASSERT(pg_offset < PAGE_SIZE && size <= PAGE_SIZE &&
 	       pg_offset + size <= PAGE_SIZE);
 	if (force_bio_submit && bio_ctrl->bio) {
-		ret = submit_one_bio(bio_ctrl->bio, mirror_num, bio_ctrl->bio_flags);
+		submit_one_bio(bio_ctrl->bio, mirror_num, bio_ctrl->bio_flags);
 		bio_ctrl->bio = NULL;
-		if (ret < 0)
-			return ret;
 	}
 
 	while (cur < pg_offset + size) {
@@ -3485,11 +3484,9 @@ static int submit_extent_page(unsigned int opf,
 		if (added < size - offset) {
 			/* The bio should contain some page(s) */
 			ASSERT(bio_ctrl->bio->bi_iter.bi_size);
-			ret = submit_one_bio(bio_ctrl->bio, mirror_num,
+			submit_one_bio(bio_ctrl->bio, mirror_num,
 					bio_ctrl->bio_flags);
 			bio_ctrl->bio = NULL;
-			if (ret < 0)
-				return ret;
 		}
 		cur += added;
 	}
@@ -4237,14 +4234,12 @@ static noinline_for_stack int lock_extent_buffer_for_io(struct extent_buffer *eb
 			  struct extent_page_data *epd)
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
-	int i, num_pages, failed_page_nr;
+	int i, num_pages;
 	int flush = 0;
 	int ret = 0;
 
 	if (!btrfs_try_tree_write_lock(eb)) {
-		ret = flush_write_bio(epd);
-		if (ret < 0)
-			return ret;
+		flush_write_bio(epd);
 		flush = 1;
 		btrfs_tree_lock(eb);
 	}
@@ -4254,9 +4249,7 @@ static noinline_for_stack int lock_extent_buffer_for_io(struct extent_buffer *eb
 		if (!epd->sync_io)
 			return 0;
 		if (!flush) {
-			ret = flush_write_bio(epd);
-			if (ret < 0)
-				return ret;
+			flush_write_bio(epd);
 			flush = 1;
 		}
 		while (1) {
@@ -4303,39 +4296,13 @@ static noinline_for_stack int lock_extent_buffer_for_io(struct extent_buffer *eb
 
 		if (!trylock_page(p)) {
 			if (!flush) {
-				int err;
-
-				err = flush_write_bio(epd);
-				if (err < 0) {
-					ret = err;
-					failed_page_nr = i;
-					goto err_unlock;
-				}
+				flush_write_bio(epd);
 				flush = 1;
 			}
 			lock_page(p);
 		}
 	}
 
-	return ret;
-err_unlock:
-	/* Unlock already locked pages */
-	for (i = 0; i < failed_page_nr; i++)
-		unlock_page(eb->pages[i]);
-	/*
-	 * Clear EXTENT_BUFFER_WRITEBACK and wake up anyone waiting on it.
-	 * Also set back EXTENT_BUFFER_DIRTY so future attempts to this eb can
-	 * be made and undo everything done before.
-	 */
-	btrfs_tree_lock(eb);
-	spin_lock(&eb->refs_lock);
-	set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
-	end_extent_buffer_writeback(eb);
-	spin_unlock(&eb->refs_lock);
-	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, eb->len,
-				 fs_info->dirty_metadata_batch);
-	btrfs_clear_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
-	btrfs_tree_unlock(eb);
 	return ret;
 }
 
@@ -4957,13 +4924,19 @@ int btree_write_cache_pages(struct address_space *mapping,
 	 *   if the fs already has error.
 	 */
 	if (!BTRFS_FS_ERROR(fs_info)) {
-		ret = flush_write_bio(&epd);
+		flush_write_bio(&epd);
 	} else {
 		ret = -EROFS;
 		end_write_bio(&epd, ret);
 	}
 out:
 	btrfs_zoned_meta_io_unlock(fs_info);
+	/*
+	 * We can get ret > 0 from submit_extent_page() indicating how many ebs
+	 * were submitted. Reset it to 0 to avoid false alerts for the caller.
+	 */
+	if (ret > 0)
+		ret = 0;
 	return ret;
 }
 
@@ -5065,8 +5038,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			 * tmpfs file mapping
 			 */
 			if (!trylock_page(page)) {
-				ret = flush_write_bio(epd);
-				BUG_ON(ret < 0);
+				flush_write_bio(epd);
 				lock_page(page);
 			}
 
@@ -5076,10 +5048,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			}
 
 			if (wbc->sync_mode != WB_SYNC_NONE) {
-				if (PageWriteback(page)) {
-					ret = flush_write_bio(epd);
-					BUG_ON(ret < 0);
-				}
+				if (PageWriteback(page))
+					flush_write_bio(epd);
 				wait_on_page_writeback(page);
 			}
 
@@ -5119,9 +5089,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
 		 * page in our current bio, and thus deadlock, so flush the
 		 * write bio here.
 		 */
-		ret = flush_write_bio(epd);
-		if (!ret)
-			goto retry;
+		flush_write_bio(epd);
+		goto retry;
 	}
 
 	if (wbc->range_cyclic || (wbc->nr_to_write > 0 && range_whole))
@@ -5147,8 +5116,7 @@ int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 		return ret;
 	}
 
-	ret = flush_write_bio(&epd);
-	ASSERT(ret <= 0);
+	flush_write_bio(&epd);
 	return ret;
 }
 
@@ -5210,7 +5178,7 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end)
 	}
 
 	if (!found_error)
-		ret = flush_write_bio(&epd);
+		flush_write_bio(&epd);
 	else
 		end_write_bio(&epd, ret);
 
@@ -5243,7 +5211,7 @@ int extent_writepages(struct address_space *mapping,
 		end_write_bio(&epd, ret);
 		return ret;
 	}
-	ret = flush_write_bio(&epd);
+	flush_write_bio(&epd);
 	return ret;
 }
 
@@ -5266,10 +5234,8 @@ void extent_readahead(struct readahead_control *rac)
 	if (em_cached)
 		free_extent_map(em_cached);
 
-	if (bio_ctrl.bio) {
-		if (submit_one_bio(bio_ctrl.bio, 0, bio_ctrl.bio_flags))
-			return;
-	}
+	if (bio_ctrl.bio)
+		submit_one_bio(bio_ctrl.bio, 0, bio_ctrl.bio_flags);
 }
 
 /*
@@ -6649,12 +6615,8 @@ static int read_extent_buffer_subpage(struct extent_buffer *eb, int wait,
 		atomic_dec(&eb->io_pages);
 	}
 	if (bio_ctrl.bio) {
-		int tmp;
-
-		tmp = submit_one_bio(bio_ctrl.bio, mirror_num, 0);
+		submit_one_bio(bio_ctrl.bio, mirror_num, 0);
 		bio_ctrl.bio = NULL;
-		if (tmp < 0)
-			return tmp;
 	}
 	if (ret || wait != WAIT_COMPLETE)
 		return ret;
@@ -6767,10 +6729,8 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int wait, int mirror_num)
 	}
 
 	if (bio_ctrl.bio) {
-		err = submit_one_bio(bio_ctrl.bio, mirror_num, bio_ctrl.bio_flags);
+		submit_one_bio(bio_ctrl.bio, mirror_num, bio_ctrl.bio_flags);
 		bio_ctrl.bio = NULL;
-		if (err)
-			return err;
 	}
 
 	if (ret || wait != WAIT_COMPLETE)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 05253612ce7b..9a283b2358b8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -178,8 +178,7 @@ typedef struct extent_map *(get_extent_t)(struct btrfs_inode *inode,
 int try_release_extent_mapping(struct page *page, gfp_t mask);
 int try_release_extent_buffer(struct page *page);
 
-int __must_check submit_one_bio(struct bio *bio, int mirror_num,
-				unsigned long bio_flags);
+void submit_one_bio(struct bio *bio, int mirror_num, unsigned long bio_flags);
 int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 		      struct btrfs_bio_ctrl *bio_ctrl,
 		      unsigned int read_flags, u64 *prev_em_start);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 03fa33db1640..62fdcb7576ba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8158,13 +8158,12 @@ int btrfs_readpage(struct file *file, struct page *page)
 	btrfs_lock_and_flush_ordered_range(inode, start, end, NULL);
 
 	ret = btrfs_do_readpage(page, NULL, &bio_ctrl, 0, NULL);
-	if (bio_ctrl.bio) {
-		int ret2;
-
-		ret2 = submit_one_bio(bio_ctrl.bio, 0, bio_ctrl.bio_flags);
-		if (ret == 0)
-			ret = ret2;
-	}
+	/*
+	 * If btrfs_do_readpage() failed we will want to submit the assembled
+	 * bio to do the cleanup.
+	 */
+	if (bio_ctrl.bio)
+		submit_one_bio(bio_ctrl.bio, 0, bio_ctrl.bio_flags);
 	return ret;
 }
 
-- 
2.35.1

