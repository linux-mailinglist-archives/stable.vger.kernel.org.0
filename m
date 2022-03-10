Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87984D46FA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiCJMa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235393AbiCJMa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:30:58 -0500
Received: from iris.vrvis.at (iris.vrvis.at [92.60.8.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7990E818A5;
        Thu, 10 Mar 2022 04:29:57 -0800 (PST)
Received: from [10.43.0.34]
        by iris.vrvis.at with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <valentin@vrvis.at>)
        id 1nSHLq-0005Vw-31; Thu, 10 Mar 2022 12:53:02 +0100
Message-ID: <c274db07-9c7d-d857-33ad-4a762819bcdd@vrvis.at>
Date:   Thu, 10 Mar 2022 12:53:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Valentin Kleibel <valentin@vrvis.at>
Cc:     Jens Axboe <axboe@kernel.dk>, Justin Sanders <justin@coraid.com>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
Subject: [PATCH] block: aoe: fix page fault in freedev()
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a bug in the aoe driver module where every forcible removal of 
an aoe device (eg. "rmmod aoe" with aoe devices available or "aoe-flush 
ex.x") leads to a page fault.
The code in freedev() calls blk_mq_free_tag_set() before running 
blk_cleanup_queue() which leads to this issue 
(drivers/block/aoe/aoedev.c L281ff).
This issue was fixed upstream in commit 6560ec9 (aoe: use 
blk_mq_alloc_disk and blk_cleanup_disk) with the introduction and use of 
the function blk_cleanup_disk().

This patch applies to kernels 5.4 and 5.10.

The function calls are reordered to match the behavior of 
blk_cleanup_disk() to mitigate this issue.

Fixes: 3582dd2 (aoe: convert aoeblk to blk-mq)
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215647
Signed-off-by: Valentin Kleibel <valentin@vrvis.at>
---
  drivers/block/aoe/aoedev.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index e2ea2356da06..08c98ea724ea 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -277,9 +277,9 @@ freedev(struct aoedev *d)
         if (d->gd) {
                 aoedisk_rm_debugfs(d);
                 del_gendisk(d->gd);
+               blk_cleanup_queue(d->blkq);
                 put_disk(d->gd);
                 blk_mq_free_tag_set(&d->tag_set);
-               blk_cleanup_queue(d->blkq);
         }
         t = d->targets;
         e = t + d->ntargets;
