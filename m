Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF6B65B0E7
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjABL3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbjABL2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:28:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAD66400
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:27:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A293EB80D1D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F0CC433EF;
        Mon,  2 Jan 2023 11:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658870;
        bh=YJy36GgUFuwVa9epmvWsRdS/BP4DZC3VsA6nXtMkFkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xafK1pjjr/P1n4rOj0/Ef9GfNo7SfwmMWSmeFZn91Zlhp8paAEHC1j1qTJaBv0rpX
         X5o8BAGmJPHfu2DCQhdaoJEQAliHVMY6KakMSfN23E41GRwe5YMjh3r7c7hhW01wNN
         DLSiFGY5CmNxXLypPzs1VpJhv7FRqsNAxuJL/JGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Andreas Herrmann <aherrmann@suse.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 03/74] blk-cgroup: remove blk_queue_root_blkg
Date:   Mon,  2 Jan 2023 12:21:36 +0100
Message-Id: <20230102110552.208383783@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 928f6f00a91ecbef6cb1fe59474831ceaf205290 ]

Just open code it in the only caller and drop the unused !BLK_CGROUP
stub.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220921180501.1539876-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 813e693023ba ("blk-iolatency: Fix memory leak on add_disk() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c |  3 +--
 block/blk-cgroup.h | 13 -------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bcd3873ac5ff..11f256214928 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -915,8 +915,7 @@ static void blkcg_fill_root_iostats(void)
 	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
 	while ((dev = class_dev_iter_next(&iter))) {
 		struct block_device *bdev = dev_to_bdev(dev);
-		struct blkcg_gq *blkg =
-			blk_queue_root_blkg(bdev_get_queue(bdev));
+		struct blkcg_gq *blkg = bdev->bd_disk->queue->root_blkg;
 		struct blkg_iostat tmp;
 		int cpu;
 		unsigned long flags;
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index d2724d1dd7c9..c1fb00a1dfc0 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -268,17 +268,6 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 	return __blkg_lookup(blkcg, q, false);
 }
 
-/**
- * blk_queue_root_blkg - return blkg for the (blkcg_root, @q) pair
- * @q: request_queue of interest
- *
- * Lookup blkg for @q at the root level. See also blkg_lookup().
- */
-static inline struct blkcg_gq *blk_queue_root_blkg(struct request_queue *q)
-{
-	return q->root_blkg;
-}
-
 /**
  * blkg_to_pdata - get policy private data
  * @blkg: blkg of interest
@@ -507,8 +496,6 @@ struct blkcg {
 };
 
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
-static inline struct blkcg_gq *blk_queue_root_blkg(struct request_queue *q)
-{ return NULL; }
 static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
 static inline void blkcg_exit_queue(struct request_queue *q) { }
 static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
-- 
2.35.1



