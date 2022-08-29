Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210175A4943
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiH2LWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiH2LU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:20:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C0975495;
        Mon, 29 Aug 2022 04:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD8DE61211;
        Mon, 29 Aug 2022 11:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE63C433D6;
        Mon, 29 Aug 2022 11:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771631;
        bh=thEZZoC+rG7e+f2dd8Ys+Qa+9APUgQYy76CqHlo4o10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJyA+6ZBZQpayNUvM+1ZX1jdXYOh+RBFqk73/r1+E6S4r9fuz27ooy4P6+eBh+udi
         qv7bwGH5ZfRHqfIrC5xlXcmWs8q7m6S8wtZNjIu2ni9SSJPH1nwAVI/dXdjPtDpxdn
         k9Xb10nBplhFl/qJhkq19jFt0eYPfqCrn4TGf+jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 129/136] blk-mq: fix io hung due to missing commit_rqs
Date:   Mon, 29 Aug 2022 12:59:56 +0200
Message-Id: <20220829105809.989544642@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

commit 65fac0d54f374625b43a9d6ad1f2c212bd41f518 upstream.

Currently, in virtio_scsi, if 'bd->last' is not set to true while
dispatching request, such io will stay in driver's queue, and driver
will wait for block layer to dispatch more rqs. However, if block
layer failed to dispatch more rq, it should trigger commit_rqs to
inform driver.

There is a problem in blk_mq_try_issue_list_directly() that commit_rqs
won't be called:

// assume that queue_depth is set to 1, list contains two rq
blk_mq_try_issue_list_directly
 blk_mq_request_issue_directly
 // dispatch first rq
 // last is false
  __blk_mq_try_issue_directly
   blk_mq_get_dispatch_budget
   // succeed to get first budget
   __blk_mq_issue_directly
    scsi_queue_rq
     cmd->flags |= SCMD_LAST
      virtscsi_queuecommand
       kick = (sc->flags & SCMD_LAST) != 0
       // kick is false, first rq won't issue to disk
 queued++

 blk_mq_request_issue_directly
 // dispatch second rq
  __blk_mq_try_issue_directly
   blk_mq_get_dispatch_budget
   // failed to get second budget
 ret == BLK_STS_RESOURCE
  blk_mq_request_bypass_insert
 // errors is still 0

 if (!list_empty(list) || errors && ...)
  // won't pass, commit_rqs won't be called

In this situation, first rq relied on second rq to dispatch, while
second rq relied on first rq to complete, thus they will both hung.

Fix the problem by also treat 'BLK_STS_*RESOURCE' as 'errors' since
it means that request is not queued successfully.

Same problem exists in blk_mq_dispatch_rq_list(), 'BLK_STS_*RESOURCE'
can't be treated as 'errors' here, fix the problem by calling
commit_rqs if queue_rq return 'BLK_STS_*RESOURCE'.

Fixes: d666ba98f849 ("blk-mq: add mq_ops->commit_rqs()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220726122224.1790882-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1400,7 +1400,8 @@ out:
 	/* If we didn't flush the entire list, we could have told the driver
 	 * there was more coming, but that turned out to be a lie.
 	 */
-	if ((!list_empty(list) || errors) && q->mq_ops->commit_rqs && queued)
+	if ((!list_empty(list) || errors || needs_resource ||
+	     ret == BLK_STS_DEV_RESOURCE) && q->mq_ops->commit_rqs && queued)
 		q->mq_ops->commit_rqs(hctx);
 	/*
 	 * Any items that need requeuing? Stuff them into hctx->dispatch,
@@ -2111,6 +2112,7 @@ void blk_mq_try_issue_list_directly(stru
 		list_del_init(&rq->queuelist);
 		ret = blk_mq_request_issue_directly(rq, list_empty(list));
 		if (ret != BLK_STS_OK) {
+			errors++;
 			if (ret == BLK_STS_RESOURCE ||
 					ret == BLK_STS_DEV_RESOURCE) {
 				blk_mq_request_bypass_insert(rq, false,
@@ -2118,7 +2120,6 @@ void blk_mq_try_issue_list_directly(stru
 				break;
 			}
 			blk_mq_end_request(rq, ret);
-			errors++;
 		} else
 			queued++;
 	}


