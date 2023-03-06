Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066EB6ACB5E
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 18:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCFRxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 12:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjCFRxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 12:53:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24D740FA
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 09:52:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2D276102A
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 17:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97E0C433EF;
        Mon,  6 Mar 2023 17:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678125173;
        bh=5lL2+FwTNvkMIXMQ9kV2IC0Scz/kBj/A+nL8xUdnvRo=;
        h=Subject:To:Cc:From:Date:From;
        b=r6eCtgcgD1bSwtCxiDe78GxyCus/FSK2nnMZgz6tT/IiEE29BfWk4Rd3pFl+JsOai
         q/sdPFYVe/0CnMEG4LxMszU0wnyjJxWL66jJ+6ZF7kFX1sw52J/AVEae3W9m4EKOXk
         eswWWobk0S6ZdXyW2n7R7dYhQGYBQBG2gng99+aQ=
Subject: FAILED: patch "[PATCH] brd: check for REQ_NOWAIT and set correct page allocation" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk, hch@lst.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 18:50:32 +0100
Message-ID: <167812503219822@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 6ded703c56c21bfb259725d4f1831a5feb563e9b
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167812503219822@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

6ded703c56c2 ("brd: check for REQ_NOWAIT and set correct page allocation mask")
db0ccc44a20b ("brd: return 0/-error from brd_insert_page()")
ba91fd01aad2 ("block/brd: Use the enum req_op type")
3e08773c3841 ("block: switch polling to be bio based")
6ce913fe3eee ("block: rename REQ_HIPRI to REQ_POLLED")
d729cf9acb93 ("io_uring: don't sleep when polling for I/O")
ef99b2d37666 ("block: replace the spin argument to blk_iopoll with a flags argument")
28a1ae6b9dab ("blk-mq: remove blk_qc_t_valid")
efbabbe121f9 ("blk-mq: remove blk_qc_t_to_tag and blk_qc_t_is_internal")
c6699d6fe0ff ("blk-mq: factor out a "classic" poll helper")
f70299f0d58e ("blk-mq: factor out a blk_qc_to_hctx helper")
71fc3f5e2c00 ("block: don't try to poll multi-bio I/Os in __blkdev_direct_IO")
0f38d7664615 ("blk-mq: cleanup blk_mq_submit_bio")
47c122e35d7e ("block: pre-allocate requests if plug is started and is a batch")
24b83deb29b7 ("block: move struct request to blk-mq.h")
badf7f643787 ("block: move a few merge helpers out of <linux/blkdev.h>")
2e9bc3465ac5 ("block: move elevator.h to block/")
9778ac77c202 ("block: remove the struct blk_queue_ctx forward declaration")
90138237a562 ("block: remove the unused blk_queue_state enum")
cc9c884dd7f4 ("block: call submit_bio_checks under q_usage_counter")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6ded703c56c21bfb259725d4f1831a5feb563e9b Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 16 Feb 2023 08:01:08 -0700
Subject: [PATCH] brd: check for REQ_NOWAIT and set correct page allocation
 mask

If REQ_NOWAIT is set, then do a non-blocking allocation if the operation
is a write and we need to insert a new page. Currently REQ_NOWAIT cannot
be set as the queue isn't marked as supporting nowait, this change is in
preparation for allowing that.

radix_tree_preload() warns on attempting to call it with an allocation
mask that doesn't allow blocking. While that warning could arguably
be removed, we need to handle radix insertion failures anyway as they
are more likely if we cannot block to get memory.

Remove legacy BUG_ON()'s and turn them into proper errors instead, one
for the allocation failure and one for finding a page that doesn't
match the correct index.

Cc: stable@vger.kernel.org # 5.10+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 15a148d5aad9..00f3c5b51a01 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -80,26 +80,21 @@ static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 /*
  * Insert a new page for a given sector, if one does not already exist.
  */
-static int brd_insert_page(struct brd_device *brd, sector_t sector)
+static int brd_insert_page(struct brd_device *brd, sector_t sector, gfp_t gfp)
 {
 	pgoff_t idx;
 	struct page *page;
-	gfp_t gfp_flags;
+	int ret = 0;
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
 		return 0;
 
-	/*
-	 * Must use NOIO because we don't want to recurse back into the
-	 * block or filesystem layers from page reclaim.
-	 */
-	gfp_flags = GFP_NOIO | __GFP_ZERO | __GFP_HIGHMEM;
-	page = alloc_page(gfp_flags);
+	page = alloc_page(gfp | __GFP_ZERO | __GFP_HIGHMEM);
 	if (!page)
 		return -ENOMEM;
 
-	if (radix_tree_preload(GFP_NOIO)) {
+	if (gfpflags_allow_blocking(gfp) && radix_tree_preload(gfp)) {
 		__free_page(page);
 		return -ENOMEM;
 	}
@@ -110,15 +105,17 @@ static int brd_insert_page(struct brd_device *brd, sector_t sector)
 	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
 		__free_page(page);
 		page = radix_tree_lookup(&brd->brd_pages, idx);
-		BUG_ON(!page);
-		BUG_ON(page->index != idx);
+		if (!page)
+			ret = -ENOMEM;
+		else if (page->index != idx)
+			ret = -EIO;
 	} else {
 		brd->brd_nr_pages++;
 	}
 	spin_unlock(&brd->brd_lock);
 
 	radix_tree_preload_end();
-	return 0;
+	return ret;
 }
 
 /*
@@ -167,19 +164,20 @@ static void brd_free_pages(struct brd_device *brd)
 /*
  * copy_to_brd_setup must be called before copy_to_brd. It may sleep.
  */
-static int copy_to_brd_setup(struct brd_device *brd, sector_t sector, size_t n)
+static int copy_to_brd_setup(struct brd_device *brd, sector_t sector, size_t n,
+			     gfp_t gfp)
 {
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 	int ret;
 
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
-	ret = brd_insert_page(brd, sector);
+	ret = brd_insert_page(brd, sector, gfp);
 	if (ret)
 		return ret;
 	if (copy < n) {
 		sector += copy >> SECTOR_SHIFT;
-		ret = brd_insert_page(brd, sector);
+		ret = brd_insert_page(brd, sector, gfp);
 	}
 	return ret;
 }
@@ -254,20 +252,26 @@ static void copy_from_brd(void *dst, struct brd_device *brd,
  * Process a single bvec of a bio.
  */
 static int brd_do_bvec(struct brd_device *brd, struct page *page,
-			unsigned int len, unsigned int off, enum req_op op,
+			unsigned int len, unsigned int off, blk_opf_t opf,
 			sector_t sector)
 {
 	void *mem;
 	int err = 0;
 
-	if (op_is_write(op)) {
-		err = copy_to_brd_setup(brd, sector, len);
+	if (op_is_write(opf)) {
+		/*
+		 * Must use NOIO because we don't want to recurse back into the
+		 * block or filesystem layers from page reclaim.
+		 */
+		gfp_t gfp = opf & REQ_NOWAIT ? GFP_NOWAIT : GFP_NOIO;
+
+		err = copy_to_brd_setup(brd, sector, len, gfp);
 		if (err)
 			goto out;
 	}
 
 	mem = kmap_atomic(page);
-	if (!op_is_write(op)) {
+	if (!op_is_write(opf)) {
 		copy_from_brd(mem + off, brd, sector, len);
 		flush_dcache_page(page);
 	} else {
@@ -296,8 +300,12 @@ static void brd_submit_bio(struct bio *bio)
 				(len & (SECTOR_SIZE - 1)));
 
 		err = brd_do_bvec(brd, bvec.bv_page, len, bvec.bv_offset,
-				  bio_op(bio), sector);
+				  bio->bi_opf, sector);
 		if (err) {
+			if (err == -ENOMEM && bio->bi_opf & REQ_NOWAIT) {
+				bio_wouldblock_error(bio);
+				return;
+			}
 			bio_io_error(bio);
 			return;
 		}

