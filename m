Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F09608838
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiJVILs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiJVIKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:10:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ECF360B8;
        Sat, 22 Oct 2022 00:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 311E260B83;
        Sat, 22 Oct 2022 07:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244A7C433C1;
        Sat, 22 Oct 2022 07:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425252;
        bh=YcStJxjHg0fqIvmWcwiT7jzTU68fC8sbWFU0pppjLsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYUcQ4DKKYexnB1Cbt0VJmia5xka5gBhoEiJ8pRsFKQYHYuQ87XCztb/QI6x8Epm2
         9+1C3IXw8UH7Xa2hRtCWELdR0iJIB3mPgHJWzorU7W1Sjvfi3SgMFiTqQvlR6KXYfS
         LtYfibP5t2OWIWfLLBZLiWByOQwPDFhzIBVDgako=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sloan <david.sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        Guoqing Jiang <Guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 441/717] md/raid5: Remove unnecessary bio_put() in raid5_read_one_chunk()
Date:   Sat, 22 Oct 2022 09:25:20 +0200
Message-Id: <20221022072517.827549241@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sloan <david.sloan@eideticom.com>

[ Upstream commit c66a6f41e09ad386fd2cce22b9cded837bbbc704 ]

When running chunk-sized reads on disks with badblocks duplicate bio
free/puts are observed:

   =============================================================================
   BUG bio-200 (Not tainted): Object already free
   -----------------------------------------------------------------------------
   Allocated in mempool_alloc_slab+0x17/0x20 age=3 cpu=2 pid=7504
    __slab_alloc.constprop.0+0x5a/0xb0
    kmem_cache_alloc+0x31e/0x330
    mempool_alloc_slab+0x17/0x20
    mempool_alloc+0x100/0x2b0
    bio_alloc_bioset+0x181/0x460
    do_mpage_readpage+0x776/0xd00
    mpage_readahead+0x166/0x320
    blkdev_readahead+0x15/0x20
    read_pages+0x13f/0x5f0
    page_cache_ra_unbounded+0x18d/0x220
    force_page_cache_ra+0x181/0x1c0
    page_cache_sync_ra+0x65/0xb0
    filemap_get_pages+0x1df/0xaf0
    filemap_read+0x1e1/0x700
    blkdev_read_iter+0x1e5/0x330
    vfs_read+0x42a/0x570
   Freed in mempool_free_slab+0x17/0x20 age=3 cpu=2 pid=7504
    kmem_cache_free+0x46d/0x490
    mempool_free_slab+0x17/0x20
    mempool_free+0x66/0x190
    bio_free+0x78/0x90
    bio_put+0x100/0x1a0
    raid5_make_request+0x2259/0x2450
    md_handle_request+0x402/0x600
    md_submit_bio+0xd9/0x120
    __submit_bio+0x11f/0x1b0
    submit_bio_noacct_nocheck+0x204/0x480
    submit_bio_noacct+0x32e/0xc70
    submit_bio+0x98/0x1a0
    mpage_readahead+0x250/0x320
    blkdev_readahead+0x15/0x20
    read_pages+0x13f/0x5f0
    page_cache_ra_unbounded+0x18d/0x220
   Slab 0xffffea000481b600 objects=21 used=0 fp=0xffff8881206d8940 flags=0x17ffffc0010201(locked|slab|head|node=0|zone=2|lastcpupid=0x1fffff)
   CPU: 0 PID: 34525 Comm: kworker/u24:2 Not tainted 6.0.0-rc2-localyes-265166-gf11c5343fa3f #143
   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
   Workqueue: raid5wq raid5_do_work
   Call Trace:
    <TASK>
    dump_stack_lvl+0x5a/0x78
    dump_stack+0x10/0x16
    print_trailer+0x158/0x165
    object_err+0x35/0x50
    free_debug_processing.cold+0xb7/0xbe
    __slab_free+0x1ae/0x330
    kmem_cache_free+0x46d/0x490
    mempool_free_slab+0x17/0x20
    mempool_free+0x66/0x190
    bio_free+0x78/0x90
    bio_put+0x100/0x1a0
    mpage_end_io+0x36/0x150
    bio_endio+0x2fd/0x360
    md_end_io_acct+0x7e/0x90
    bio_endio+0x2fd/0x360
    handle_failed_stripe+0x960/0xb80
    handle_stripe+0x1348/0x3760
    handle_active_stripes.constprop.0+0x72a/0xaf0
    raid5_do_work+0x177/0x330
    process_one_work+0x616/0xb20
    worker_thread+0x2bd/0x6f0
    kthread+0x179/0x1b0
    ret_from_fork+0x22/0x30
    </TASK>

The double free is caused by an unnecessary bio_put() in the
if(is_badblock(...)) error path in raid5_read_one_chunk().

The error path was moved ahead of bio_alloc_clone() in c82aa1b76787c
("md/raid5: move checking badblock before clone bio in
raid5_read_one_chunk"). The previous code checked and freed align_bio
which required a bio_put. After the move that is no longer needed as
raid_bio is returned to the control of the common io path which
performs its own endio resulting in a double free on bad device blocks.

Fixes: c82aa1b76787c ("md/raid5: move checking badblock before clone bio in raid5_read_one_chunk")
Signed-off-by: David Sloan <david.sloan@eideticom.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Guoqing Jiang <Guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d6cad962669a..f498bd4af8c2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5446,7 +5446,6 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 
 	if (is_badblock(rdev, sector, bio_sectors(raid_bio), &first_bad,
 			&bad_sectors)) {
-		bio_put(raid_bio);
 		rdev_dec_pending(rdev, mddev);
 		return 0;
 	}
-- 
2.35.1



