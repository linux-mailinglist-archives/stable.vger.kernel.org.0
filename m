Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC32E6BBC9F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjCOSqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCOSqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:46:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB1B18143;
        Wed, 15 Mar 2023 11:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0B25B81F0D;
        Wed, 15 Mar 2023 18:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742DAC4339B;
        Wed, 15 Mar 2023 18:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678905632;
        bh=odC1xQHL7ynUb87om8IH745XnPEFBc3hWniPvn6Q4SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JH6Fi9nbWsu4CkNpo3goCQSk1bUZToc/3murEXAd3cQQl/IPnIgsHzT6DGHyUkvsp
         0FBySOVaEWlriYXRXuO6jEKL5U/yccz6R2IC7X8HAJbUvxDB5GehhI0FJlMWntCe+n
         qtoHrXRwWqwBgFArz3Sn0o8haxz+o+rIewjQHBE2lFkyZjNV68ZPTlBi2jReTC6Vl9
         dZNjGA33gU9pIvzFrvqyMeVgkME3FiD87buqlfRpgs/JzOfAXf6AqRzdCRH0BPC6Jw
         ie90JCCsDuCv46BHpbMxC2TXL6XAYn//KhMULc6XgeXihEVhDWOUPkolkyOlvZ6b10
         KebNaz/JcMDiQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, stable@vger.kernel.org
Subject: [PATCH v3 2/6] blk-crypto: make blk_crypto_evict_key() return void
Date:   Wed, 15 Mar 2023 11:39:03 -0700
Message-Id: <20230315183907.53675-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315183907.53675-1-ebiggers@kernel.org>
References: <20230315183907.53675-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

blk_crypto_evict_key() is only called in contexts such as inode eviction
where failure is not an option.  So there is nothing the caller can do
with errors except log them.  (dm-table.c does "use" the error code, but
only to pass on to upper layers, so it doesn't really count.)

Just make blk_crypto_evict_key() return void and log errors itself.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto.c         | 20 +++++++++-----------
 drivers/md/dm-table.c      | 19 +++++--------------
 include/linux/blk-crypto.h |  4 ++--
 3 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index d0c7feb447e96..e800f305e9eda 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/blk-crypto-profile.h>
 #include <linux/module.h>
+#include <linux/ratelimit.h>
 #include <linux/slab.h>
 
 #include "blk-crypto-internal.h"
@@ -408,21 +409,18 @@ int blk_crypto_start_using_key(struct block_device *bdev,
  * Upper layers (filesystems) must call this function to ensure that a key is
  * evicted from any hardware that it might have been programmed into.  The key
  * must not be in use by any in-flight IO when this function is called.
- *
- * Return: 0 on success or if the key wasn't in any keyslot; -errno on error.
  */
-int blk_crypto_evict_key(struct block_device *bdev,
-			 const struct blk_crypto_key *key)
+void blk_crypto_evict_key(struct block_device *bdev,
+			  const struct blk_crypto_key *key)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
+	int err;
 
 	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
-		return __blk_crypto_evict_key(q->crypto_profile, key);
-
-	/*
-	 * If the block_device didn't support the key, then blk-crypto-fallback
-	 * may have been used, so try to evict the key from blk-crypto-fallback.
-	 */
-	return blk_crypto_fallback_evict_key(key);
+		err = __blk_crypto_evict_key(q->crypto_profile, key);
+	else
+		err = blk_crypto_fallback_evict_key(key);
+	if (err)
+		pr_warn_ratelimited("%pg: error %d evicting key\n", bdev, err);
 }
 EXPORT_SYMBOL_GPL(blk_crypto_evict_key);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2055a758541de..7899f5fb4c133 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1202,21 +1202,12 @@ struct dm_crypto_profile {
 	struct mapped_device *md;
 };
 
-struct dm_keyslot_evict_args {
-	const struct blk_crypto_key *key;
-	int err;
-};
-
 static int dm_keyslot_evict_callback(struct dm_target *ti, struct dm_dev *dev,
 				     sector_t start, sector_t len, void *data)
 {
-	struct dm_keyslot_evict_args *args = data;
-	int err;
+	const struct blk_crypto_key *key = data;
 
-	err = blk_crypto_evict_key(dev->bdev, args->key);
-	if (!args->err)
-		args->err = err;
-	/* Always try to evict the key from all devices. */
+	blk_crypto_evict_key(dev->bdev, key);
 	return 0;
 }
 
@@ -1229,7 +1220,6 @@ static int dm_keyslot_evict(struct blk_crypto_profile *profile,
 {
 	struct mapped_device *md =
 		container_of(profile, struct dm_crypto_profile, profile)->md;
-	struct dm_keyslot_evict_args args = { key };
 	struct dm_table *t;
 	int srcu_idx;
 
@@ -1242,11 +1232,12 @@ static int dm_keyslot_evict(struct blk_crypto_profile *profile,
 
 		if (!ti->type->iterate_devices)
 			continue;
-		ti->type->iterate_devices(ti, dm_keyslot_evict_callback, &args);
+		ti->type->iterate_devices(ti, dm_keyslot_evict_callback,
+					  (void *)key);
 	}
 
 	dm_put_live_table(md, srcu_idx);
-	return args.err;
+	return 0;
 }
 
 static int
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 1e3e5d0adf120..5e5822c18ee41 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -95,8 +95,8 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key);
 
-int blk_crypto_evict_key(struct block_device *bdev,
-			 const struct blk_crypto_key *key);
+void blk_crypto_evict_key(struct block_device *bdev,
+			  const struct blk_crypto_key *key);
 
 bool blk_crypto_config_supported_natively(struct block_device *bdev,
 					  const struct blk_crypto_config *cfg);
-- 
2.39.2

