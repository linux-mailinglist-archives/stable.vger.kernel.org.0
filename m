Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BE2658352
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiL1Qqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiL1Qp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:45:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB241DA56
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:41:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2845461572
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBB5C433D2;
        Wed, 28 Dec 2022 16:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245673;
        bh=H850jVq67tVt0GSLkzOla16JWgCEzjxQpwzXPtGvzEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yR443fSL0bMTPcqDiZu7l931MqzH2XhIY6soKvdsFiFOEvjb+yJYcxCeNKxl55H6I
         clnsZDlcG8w/wH1n1Pn+hjhfo4+pWyIWCvd8fJ0lnzpuYRTFYdG/6GpnFeQB9hQTJZ
         E163Teh++EBQ2pQfPs+CbWFIOw4M+V4j1IfLuKks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Eric Biggers <ebiggers@google.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0903/1146] blk-crypto: pass a gendisk to blk_crypto_sysfs_{,un}register
Date:   Wed, 28 Dec 2022 15:40:42 +0100
Message-Id: <20221228144354.740102648@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 450deb93df7d457cdd93594a1987f9650c749b96 ]

Prepare for changes to the block layer sysfs handling by passing the
readily available gendisk to blk_crypto_sysfs_{,un}register.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221114042637.1009333-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d36a9ea5e776 ("block: fix use-after-free of q->q_usage_counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-crypto-internal.h | 10 ++++++----
 block/blk-crypto-sysfs.c    |  7 ++++---
 block/blk-sysfs.c           |  4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index e6818ffaddbf..b8a00847171f 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -21,9 +21,9 @@ extern const struct blk_crypto_mode blk_crypto_modes[];
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 
-int blk_crypto_sysfs_register(struct request_queue *q);
+int blk_crypto_sysfs_register(struct gendisk *disk);
 
-void blk_crypto_sysfs_unregister(struct request_queue *q);
+void blk_crypto_sysfs_unregister(struct gendisk *disk);
 
 void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
 			     unsigned int inc);
@@ -67,12 +67,14 @@ static inline bool blk_crypto_rq_is_encrypted(struct request *rq)
 
 #else /* CONFIG_BLK_INLINE_ENCRYPTION */
 
-static inline int blk_crypto_sysfs_register(struct request_queue *q)
+static inline int blk_crypto_sysfs_register(struct gendisk *disk)
 {
 	return 0;
 }
 
-static inline void blk_crypto_sysfs_unregister(struct request_queue *q) { }
+static inline void blk_crypto_sysfs_unregister(struct gendisk *disk)
+{
+}
 
 static inline bool bio_crypt_rq_ctx_compatible(struct request *rq,
 					       struct bio *bio)
diff --git a/block/blk-crypto-sysfs.c b/block/blk-crypto-sysfs.c
index fd93bd2f33b7..e05f145cd797 100644
--- a/block/blk-crypto-sysfs.c
+++ b/block/blk-crypto-sysfs.c
@@ -126,8 +126,9 @@ static struct kobj_type blk_crypto_ktype = {
  * If the request_queue has a blk_crypto_profile, create the "crypto"
  * subdirectory in sysfs (/sys/block/$disk/queue/crypto/).
  */
-int blk_crypto_sysfs_register(struct request_queue *q)
+int blk_crypto_sysfs_register(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
 	struct blk_crypto_kobj *obj;
 	int err;
 
@@ -149,9 +150,9 @@ int blk_crypto_sysfs_register(struct request_queue *q)
 	return 0;
 }
 
-void blk_crypto_sysfs_unregister(struct request_queue *q)
+void blk_crypto_sysfs_unregister(struct gendisk *disk)
 {
-	kobject_put(q->crypto_kobject);
+	kobject_put(disk->queue->crypto_kobject);
 }
 
 static int __init blk_crypto_sysfs_init(void)
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e7871665825a..2b1cf0b2a5c7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -833,7 +833,7 @@ int blk_register_queue(struct gendisk *disk)
 			goto put_dev;
 	}
 
-	ret = blk_crypto_sysfs_register(q);
+	ret = blk_crypto_sysfs_register(disk);
 	if (ret)
 		goto put_dev;
 
@@ -910,7 +910,7 @@ void blk_unregister_queue(struct gendisk *disk)
 	 */
 	if (queue_is_mq(q))
 		blk_mq_sysfs_unregister(disk);
-	blk_crypto_sysfs_unregister(q);
+	blk_crypto_sysfs_unregister(disk);
 
 	mutex_lock(&q->sysfs_lock);
 	elv_unregister_queue(q);
-- 
2.35.1



