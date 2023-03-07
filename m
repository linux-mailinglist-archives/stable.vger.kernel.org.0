Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE816AEC7E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCGRzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjCGRzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:55:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1C5A2198
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:50:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D16161507
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22918C433EF;
        Tue,  7 Mar 2023 17:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211401;
        bh=4kE2uW3RXaMUo4vk3LtW5hwFku4qjjG9WOutV27XEJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWeDK/hTTtaRSlXgBMzDo5AO94uaixoOX1j5HjwwN4cxtT4WNgtDWVk/Wo/jR5qoL
         KPuOZrWmSPTq03IueKVXGp96eedh7gwJcXS6f1vIwwwjR0mej9rcf/fSeA7eNMl1Bc
         OwlDfpZp7u9qumBwrv7eHg+Q3UPQVlwO5LcZlEKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0850/1001] brd: check for REQ_NOWAIT and set correct page allocation mask
Date:   Tue,  7 Mar 2023 18:00:22 +0100
Message-Id: <20230307170058.703770401@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 6ded703c56c21bfb259725d4f1831a5feb563e9b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/brd.c |   48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -80,26 +80,21 @@ static struct page *brd_lookup_page(stru
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
@@ -110,15 +105,17 @@ static int brd_insert_page(struct brd_de
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
@@ -167,19 +164,20 @@ static void brd_free_pages(struct brd_de
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
@@ -254,20 +252,26 @@ static void copy_from_brd(void *dst, str
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
@@ -296,8 +300,12 @@ static void brd_submit_bio(struct bio *b
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


