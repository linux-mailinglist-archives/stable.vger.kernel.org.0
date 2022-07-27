Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E02E582CAE
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbiG0Qtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240643AbiG0QtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:49:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2C761735;
        Wed, 27 Jul 2022 09:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A3DAB8200D;
        Wed, 27 Jul 2022 16:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72314C433D6;
        Wed, 27 Jul 2022 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939558;
        bh=cz+hdvCS81/1ofgS66D9vhSA5DTELGq6dMXwQkqw964=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYVd2EyksE928bZo/Vh2b+ldR0GCH2eDSItd6WhweQ/Hy0g39sARLv8V2Ij1foBou
         U5NnRcjvVmVYh5OF3yL1d/ul19Z6JhD+DrpOfkVAqkXhcIp3GxOdJyuyg+xQbrzCCW
         GNYoCYmh5L5kcGHa/lUHiHVRiDRPyBCz2pO7+vXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10 008/105] block: fix bounce_clone_bio for passthrough bios
Date:   Wed, 27 Jul 2022 18:09:54 +0200
Message-Id: <20220727161012.411398366@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit b90994c6ab623baf9268df9710692f14920ce9d2 upstream.

Now that bio_alloc_bioset does not fall back to kmalloc for a NULL
bio_set, handle that case explicitly and simplify the calling
conventions.

Based on an earlier patch from Chaitanya Kulkarni.

Fixes: 3175199ab0ac ("block: split bio_kmalloc from bio_alloc_bioset")
Reported-by: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bounce.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/block/bounce.c
+++ b/block/bounce.c
@@ -214,8 +214,7 @@ static void bounce_end_io_read_isa(struc
 	__bounce_end_io_read(bio, &isa_page_pool);
 }
 
-static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
-		struct bio_set *bs)
+static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask)
 {
 	struct bvec_iter iter;
 	struct bio_vec bv;
@@ -242,8 +241,11 @@ static struct bio *bounce_clone_bio(stru
 	 *    asking for trouble and would force extra work on
 	 *    __bio_clone_fast() anyways.
 	 */
-
-	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
+	if (bio_is_passthrough(bio_src))
+		bio = bio_kmalloc(gfp_mask, bio_segments(bio_src));
+	else
+		bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src),
+				       &bounce_bio_set);
 	if (!bio)
 		return NULL;
 	bio->bi_disk		= bio_src->bi_disk;
@@ -294,7 +296,6 @@ static void __blk_queue_bounce(struct re
 	unsigned i = 0;
 	bool bounce = false;
 	int sectors = 0;
-	bool passthrough = bio_is_passthrough(*bio_orig);
 
 	bio_for_each_segment(from, *bio_orig, iter) {
 		if (i++ < BIO_MAX_PAGES)
@@ -305,14 +306,14 @@ static void __blk_queue_bounce(struct re
 	if (!bounce)
 		return;
 
-	if (!passthrough && sectors < bio_sectors(*bio_orig)) {
+	if (!bio_is_passthrough(*bio_orig) &&
+	    sectors < bio_sectors(*bio_orig)) {
 		bio = bio_split(*bio_orig, sectors, GFP_NOIO, &bounce_bio_split);
 		bio_chain(bio, *bio_orig);
 		submit_bio_noacct(*bio_orig);
 		*bio_orig = bio;
 	}
-	bio = bounce_clone_bio(*bio_orig, GFP_NOIO, passthrough ? NULL :
-			&bounce_bio_set);
+	bio = bounce_clone_bio(*bio_orig, GFP_NOIO);
 
 	/*
 	 * Bvec table can't be updated by bio_for_each_segment_all(),


