Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04E94ED776
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 12:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbiCaKDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 06:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbiCaKDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 06:03:11 -0400
Received: from iris.vrvis.at (iris.vrvis.at [92.60.8.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2867964BF5;
        Thu, 31 Mar 2022 03:01:22 -0700 (PDT)
Received: from [10.43.0.42]
        by iris.vrvis.at with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <valentin@vrvis.at>)
        id 1nZrcG-0006PH-P5; Thu, 31 Mar 2022 12:01:21 +0200
Message-ID: <774968b2-5d34-0f36-5ec6-284aaabb4585@vrvis.at>
Date:   Thu, 31 Mar 2022 12:01:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>, linux-block@vger.kernel.org
Content-Language: en-US
From:   Valentin Kleibel <valentin@vrvis.at>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <c274db07-9c7d-d857-33ad-4a762819bcdd@vrvis.at>
 <YinpIKY0HVlJ+TLR@kroah.com> <50ddedf1-5ac3-91c3-0b50-645ceb541071@vrvis.at>
 <YinufgnQtSeTA18w@kroah.com> <9dd4a25a-7deb-fcdf-0c05-d37d4c894d86@vrvis.at>
 <Yi8jO3Q+xbPx0JwF@kroah.com> <b19953f8-2097-6962-eceb-5d41f4639ce4@vrvis.at>
In-Reply-To: <b19953f8-2097-6962-eceb-5d41f4639ce4@vrvis.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
Subject: [PATCH v2 2/2] aoe: use blk_mq_alloc_disk and blk_cleanup_disk
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use blk_mq_alloc_disk and blk_cleanup_disk to simplify the gendisk and
request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Link: https://lore.kernel.org/r/20210602065345.355274-17-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 6560ec961a080944f8d5e1fef17b771bfaf189cb)
Fixes: 3582dd291788 (aoe: convert aoeblk to blk-mq)
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215647
Signed-off-by: Valentin Kleibel <valentin@vrvis.at>
---
  drivers/block/aoe/aoedev.c | 3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index e2ea2356da06..c5753c6bfe80 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -277,9 +277,8 @@ freedev(struct aoedev *d)
         if (d->gd) {
                 aoedisk_rm_debugfs(d);
                 del_gendisk(d->gd);
-               put_disk(d->gd);
+               blk_cleanup_disk(d->gd);
                 blk_mq_free_tag_set(&d->tag_set);
-               blk_cleanup_queue(d->blkq);
         }
         t = d->targets;
         e = t + d->ntargets;
