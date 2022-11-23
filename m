Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415F7635E7F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbiKWMxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiKWMwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:52:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4668C088;
        Wed, 23 Nov 2022 04:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 556C8B81F5D;
        Wed, 23 Nov 2022 12:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60333C433C1;
        Wed, 23 Nov 2022 12:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207491;
        bh=CXq8M54/XjkD0bssnk/2sXsBayYRu1MRXe8SxuzsGwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLUNKa2o4oqOocqkXBRl3Sy46VBvQsO8avtJtFTISkkOD/IF+bGASWyf1MYQwQR+x
         A1Q6Hqs0y3AvmEH6dx87Hn+jdMkR92Wvc9G7RSomT9Ko/kUglXd427wRk9zAMI5jHC
         /4/+peXLZrDFgyo1GwIJqFkbvzLNzTVnJqUGRtVUWa81yxpyXwDTMWWmbqHUlDtXiT
         /pEj8KOW1eRH0eVvswvWE6Auo9E9Bl+3nJnloGEEPonOQO2oX/CID0smOab5pz8aGG
         +T9+oplh8sCNFOZp9C0qgf4c+/+YvAF1RTFoGGkurWuS/st420WqCXw92os++J5lXh
         mB6ljCpKrqpCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/15] block: make blk_set_default_limits() private
Date:   Wed, 23 Nov 2022 07:44:21 -0500
Message-Id: <20221123124427.266286-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124427.266286-1-sashal@kernel.org>
References: <20221123124427.266286-1-sashal@kernel.org>
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
index 13be635300a8..eb4a6c01ec22 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -60,7 +60,6 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->misaligned = 0;
 	lim->zoned = BLK_ZONED_NONE;
 }
-EXPORT_SYMBOL(blk_set_default_limits);
 
 /**
  * blk_set_stacking_limits - set default limits for stacking devices
diff --git a/block/blk.h b/block/blk.h
index ee3d5664d962..07a6a7c734b5 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -241,6 +241,7 @@ void blk_rq_set_mixed_merge(struct request *rq);
 bool blk_rq_merge_ok(struct request *rq, struct bio *bio);
 enum elv_merge blk_try_merge(struct request *rq, struct bio *bio);
 
+void blk_set_default_limits(struct queue_limits *lim);
 int blk_dev_init(void);
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 308c2d8cdca1..d0ce2489488c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1098,7 +1098,6 @@ extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_queue_depth(struct request_queue *q, unsigned int depth);
-extern void blk_set_default_limits(struct queue_limits *lim);
 extern void blk_set_stacking_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
-- 
2.35.1

