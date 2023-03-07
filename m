Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B76D6AEE12
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjCGSJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbjCGSJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8202195E27
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA3B3B8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F20C4339B;
        Tue,  7 Mar 2023 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212200;
        bh=CnQo34brO7Gk1qTweuoQ/wz2ZvMjCScRvsLtOp2fd9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMSqS90qgTVKKMb3GpPkqJgEJLqIUxnfQUh4zjp9ZqpkfCQQ35yeDzbh9bjNbg+lo
         uad+S4VbIRhTP06kKNOLW2cYsTQQbGsNZP+ftzQVb5ZFXnjgHslizGUfxau3X9n5zn
         svsAQENwCbh1OgijEYccwm1+vkSO5inn+0j1zAHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jinke Han <hanjinke.666@bytedance.com>,
        Ming Lei <ming.lei@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/885] block: Fix io statistics for cgroup in throttle path
Date:   Tue,  7 Mar 2023 17:50:42 +0100
Message-Id: <20230307170006.570679696@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Jinke Han <hanjinke.666@bytedance.com>

[ Upstream commit 0f7c8f0f7934c389b0f9fa1f151e753d8de6348f ]

In the current code, io statistics are missing for cgroup when bio
was throttled by blk-throttle. Fix it by moving the unreaching code
to submit_bio_noacct_nocheck.

Fixes: 3f98c753717c ("block: don't check bio in blk_throtl_dispatch_work_fn")
Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230216032250.74230-1-hanjinke.666@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5487912befe89..553afcdd638a6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -672,6 +672,18 @@ static void __submit_bio_noacct_mq(struct bio *bio)
 
 void submit_bio_noacct_nocheck(struct bio *bio)
 {
+	blk_cgroup_bio_start(bio);
+	blkcg_bio_issue_init(bio);
+
+	if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {
+		trace_block_bio_queue(bio);
+		/*
+		 * Now that enqueuing has been traced, we need to trace
+		 * completion as well.
+		 */
+		bio_set_flag(bio, BIO_TRACE_COMPLETION);
+	}
+
 	/*
 	 * We only want one ->submit_bio to be active at a time, else stack
 	 * usage with stacked devices could be a problem.  Use current->bio_list
@@ -776,17 +788,6 @@ void submit_bio_noacct(struct bio *bio)
 
 	if (blk_throtl_bio(bio))
 		return;
-
-	blk_cgroup_bio_start(bio);
-	blkcg_bio_issue_init(bio);
-
-	if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-		trace_block_bio_queue(bio);
-		/* Now that enqueuing has been traced, we need to trace
-		 * completion as well.
-		 */
-		bio_set_flag(bio, BIO_TRACE_COMPLETION);
-	}
 	submit_bio_noacct_nocheck(bio);
 	return;
 
-- 
2.39.2



