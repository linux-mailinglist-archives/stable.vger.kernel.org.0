Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58B86998A1
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 16:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjBPPT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 10:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjBPPT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 10:19:26 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615B648E1A
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:19:25 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id z14so562454iob.10
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjez0L/LxXn3HnvptBOuF6EryK2CIHbWYpMFu4wG7eM=;
        b=N5uYZFPyPxmNEk32kZ/oC5b31XMpTEOipncdIs4QhjqlmHXWGnZVMiQ4HCxY8tPwdX
         ax2rexF/04te8O5vaGAdNXflw3oUSYJAy0QkFgQpxim1JwAba6rbmDkr8mM+SfsQRL5I
         xGpiEsbxG/eZOEu8hxUQPdLXcbMb6ujkYKS72vVO9gwiFCAwHkHFFVDKnKspE9irqhVE
         pKex2uBDJgwf6fUKoRvSpcKG1XzWXEoryXDqk3LjVlXp5ESMAm7wU9lDuNFWVm3hoJ2z
         PJOdFIXcUOr0AsYOoHbfrJj+Ws3OEu/ZOG34Fh6tr9CxvqbnjkxAQbga8OOU5m9c02mU
         1kiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yjez0L/LxXn3HnvptBOuF6EryK2CIHbWYpMFu4wG7eM=;
        b=H7JwnlSEU+20YkMjf90UF+inUZHC50PoWjCJTJJFZRE0/tYfJnu9JiPmJRNS7nBR5g
         2bbH5+plnVH2gO/aghjQo/aYAqusIgzfbRO74ammRYVeT6wDFvh2UqPU2FtByypI3RGv
         EJuH6JBKANWmbU2KieEcM3JgZTTrQaPoMNblvVIxrdYW+BnDzUVq2O0pbLpjjQRkVOkK
         43YJ7av9C7bh1HGUWctXLGdauYg95ouwUC9+e4t+9qHU3WPmUpLCXqfhj2F4opxQifq1
         ClHDWXT6NaEemlSV4N4ccdUT8aN5pXvXDxLFmhvIKiZw5JkfaoDhrZvNUJWw4CUqfthm
         nuTQ==
X-Gm-Message-State: AO0yUKXvqBSOMsKc1aZofoWd7GQ9YV37evWqMg/Zzb0lloAmJ8TpwlAZ
        AHADnt8QY/v/yz2mVucYJ4C0CA==
X-Google-Smtp-Source: AK7set8ogXJq2FZihrnyVHUVJVLr/QSbrgdSCf+Lvbix/Imrf3Q8zkt/0s4ShIsSgyj1F1GULrCWqQ==
X-Received: by 2002:a6b:b2d1:0:b0:744:5aff:2ea9 with SMTP id b200-20020a6bb2d1000000b007445aff2ea9mr1461325iof.2.1676560764606;
        Thu, 16 Feb 2023 07:19:24 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p10-20020a0566022b0a00b006e2f2369d3csm561600iov.50.2023.02.16.07.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 07:19:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     hch@infradead.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] brd: check for REQ_NOWAIT and set correct page allocation mask
Date:   Thu, 16 Feb 2023 08:19:16 -0700
Message-Id: <20230216151918.319585-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216151918.319585-1-axboe@kernel.dk>
References: <20230216151918.319585-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If REQ_NOWAIT is set, then do a non-blocking allocation if the operation
is a write and we need to insert a new page. Currently REQ_NOWAIT cannot
be set as the queue isn't marked as supporting nowait, this change is in
preparation for allowing that.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/brd.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 15a148d5aad9..1ddada0cdaca 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -80,26 +80,20 @@ static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 /*
  * Insert a new page for a given sector, if one does not already exist.
  */
-static int brd_insert_page(struct brd_device *brd, sector_t sector)
+static int brd_insert_page(struct brd_device *brd, sector_t sector, gfp_t gfp)
 {
 	pgoff_t idx;
 	struct page *page;
-	gfp_t gfp_flags;
 
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
+	if (radix_tree_preload(gfp)) {
 		__free_page(page);
 		return -ENOMEM;
 	}
@@ -167,19 +161,20 @@ static void brd_free_pages(struct brd_device *brd)
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
@@ -254,20 +249,26 @@ static void copy_from_brd(void *dst, struct brd_device *brd,
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
@@ -296,8 +297,12 @@ static void brd_submit_bio(struct bio *bio)
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
-- 
2.39.1

