Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD1A635D6D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbiKWMpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbiKWMoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:44:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A760A6F356;
        Wed, 23 Nov 2022 04:42:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14FC8B81F59;
        Wed, 23 Nov 2022 12:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C84C43470;
        Wed, 23 Nov 2022 12:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207340;
        bh=HtuvYn1EQ5IHM4x16ZQTiO4cKQFCLzaTQZaxEJr+Qzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHV3TNq0v+DXCGI4adrN1iILRTbr+SH3RxzQj1xOBBs9nKXKpBhA+DaiMLSU97fqm
         r4XNsVhltqfzPj9JeUZIx9hVjsqzxgDPDPRrYR89CBJHszYdbu62i2kI04KXlMQkdM
         hIZvnT7z3qooU4kPxtNacsng7hnqzUpYl0MGOpLju6k2VQurrvyoduM/V8U1tjDsKA
         JCMGzwkAPismewpZN5FTrbEQLgosO4qbRN29MtCmO2hgvVJykEpyPdYre3nDic4zq8
         LfsHlFl0Tm+SIZFCWjDNXA//FE34erZFGME3CRW4cnkPAIyr7jNrBRGrJbFj+Dgjm0
         52Q0z/0/5yLnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 36/44] block: make blk_set_default_limits() private
Date:   Wed, 23 Nov 2022 07:40:45 -0500
Message-Id: <20221123124057.264822-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b3228254bb6e91e57f920227f72a1a7d81925d81 ]

There are no external users of this function.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221110184501.2451620-4-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c   | 1 -
 block/blk.h            | 1 +
 include/linux/blkdev.h | 1 -
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 4949ed3ce7c9..8ac1038d0c79 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -59,7 +59,6 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
 }
-EXPORT_SYMBOL(blk_set_default_limits);
 
 /**
  * blk_set_stacking_limits - set default limits for stacking devices
diff --git a/block/blk.h b/block/blk.h
index 52432eab621e..ff0bec16f0fa 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -324,6 +324,7 @@ void blk_rq_set_mixed_merge(struct request *rq);
 bool blk_rq_merge_ok(struct request *rq, struct bio *bio);
 enum elv_merge blk_try_merge(struct request *rq, struct bio *bio);
 
+void blk_set_default_limits(struct queue_limits *lim);
 int blk_dev_init(void);
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 79624711fda7..e6bf06dc0770 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -946,7 +946,6 @@ extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_queue_depth(struct request_queue *q, unsigned int depth);
-extern void blk_set_default_limits(struct queue_limits *lim);
 extern void blk_set_stacking_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
-- 
2.35.1

