Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3805C0243
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiIUPuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiIUPuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:50:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23BF9AFA1;
        Wed, 21 Sep 2022 08:48:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61A06B82714;
        Wed, 21 Sep 2022 15:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F89C433D7;
        Wed, 21 Sep 2022 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775297;
        bh=rUgipJmpjZh5pth/kIAQWW4Q0vsv4QZFp+a/XZ7EPeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhCj0dYD63JjkoqB05rLcPqpTKG+NGLMSQchwfclYTK3Jvh9BfzSllD848LCGCByl
         Uv0BzHPWQ8cAd56ZhFe2VTWdJ1jHt3Uuiqd65auDksK57cqBHY9utMo8IMuMLiu5v8
         Cau3xy2htGC8J082KUupxHX0nPDGjYmb8hXoyvwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 25/38] blk-lib: fix blkdev_issue_secure_erase
Date:   Wed, 21 Sep 2022 17:46:09 +0200
Message-Id: <20220921153647.052501707@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit c4fa368466cc1b60bb92f867741488930ddd6034 upstream.

There's a bug in blkdev_issue_secure_erase. The statement
"unsigned int len = min_t(sector_t, nr_sects, max_sectors);"
sets the variable "len" to the length in sectors, but the statement
"bio->bi_iter.bi_size = len" treats it as if it were in bytes.
The statements "sector += len << SECTOR_SHIFT" and "nr_sects -= len <<
SECTOR_SHIFT" are thinko.

This patch fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v5.19
Fixes: 44abff2c0b97 ("block: decouple REQ_OP_SECURE_ERASE from REQ_OP_DISCARD")
Link: https://lore.kernel.org/r/alpine.LRH.2.02.2209141549480.28100@file01.intranet.prod.int.rdu2.redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-lib.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -311,6 +311,11 @@ int blkdev_issue_secure_erase(struct blo
 	struct blk_plug plug;
 	int ret = 0;
 
+	/* make sure that "len << SECTOR_SHIFT" doesn't overflow */
+	if (max_sectors > UINT_MAX >> SECTOR_SHIFT)
+		max_sectors = UINT_MAX >> SECTOR_SHIFT;
+	max_sectors &= ~bs_mask;
+
 	if (max_sectors == 0)
 		return -EOPNOTSUPP;
 	if ((sector | nr_sects) & bs_mask)
@@ -324,10 +329,10 @@ int blkdev_issue_secure_erase(struct blo
 
 		bio = blk_next_bio(bio, bdev, 0, REQ_OP_SECURE_ERASE, gfp);
 		bio->bi_iter.bi_sector = sector;
-		bio->bi_iter.bi_size = len;
+		bio->bi_iter.bi_size = len << SECTOR_SHIFT;
 
-		sector += len << SECTOR_SHIFT;
-		nr_sects -= len << SECTOR_SHIFT;
+		sector += len;
+		nr_sects -= len;
 		if (!nr_sects) {
 			ret = submit_bio_wait(bio);
 			bio_put(bio);


