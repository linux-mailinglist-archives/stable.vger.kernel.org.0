Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E866BBC80
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjCOSm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjCOSm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:42:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1481E2AB;
        Wed, 15 Mar 2023 11:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CCBAB81F10;
        Wed, 15 Mar 2023 18:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF979C4339E;
        Wed, 15 Mar 2023 18:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678905632;
        bh=xqR7r+TSfrM+1ggDX5VsWh7dG6I0faiObGb5WTWlPls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hs2ReypwUOQ+yPSoxnkjgv0+w8IYrrypnVrZ9R3ua/EqCvfqsfk0tnyTgN2Q4Yux4
         JSJPaGrXYIm9Ie0leV9RJju2nBh5TGLSdTakwRIuFiiDU/RyaKbKcf7uWTw/YlslOB
         1w/Cl24OoFfBfF7/M3bZwI5Bv1u/1afFgGV+XOTU1KtLDzIoYlslvObRGF76Wh0HeD
         zqZNVaPdF/7ZdUjcCh7qXh7G5pa6I8JvXzHzmyt01lGxi3zIDTTWOVAoTlhpIFgnbR
         jr503VLvXXLXrHkzvuQUDL0MVLswT2OW/KvvVJekbJ2dDGdlRmm3mbx8L3ZN2HShno
         nq2LrMqww2ZAw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, stable@vger.kernel.org
Subject: [PATCH v3 3/6] blk-crypto: make blk_crypto_evict_key() more robust
Date:   Wed, 15 Mar 2023 11:39:04 -0700
Message-Id: <20230315183907.53675-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315183907.53675-1-ebiggers@kernel.org>
References: <20230315183907.53675-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If blk_crypto_evict_key() sees that the key is still in-use (due to a
bug) or that ->keyslot_evict failed, it currently just returns while
leaving the key linked into the keyslot management structures.

However, blk_crypto_evict_key() is only called in contexts such as inode
eviction where failure is not an option.  So actually the caller
proceeds with freeing the blk_crypto_key regardless of the return value
of blk_crypto_evict_key().

These two assumptions don't match, and the result is that there can be a
use-after-free in blk_crypto_reprogram_all_keys() after one of these
errors occurs.  (Note, these errors *shouldn't* happen; we're just
talking about what happens if they do anyway.)

Fix this by making blk_crypto_evict_key() unlink the key from the
keyslot management structures even on failure.

Also improve some comments.

Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-profile.c | 46 +++++++++++++++++---------------------
 block/blk-crypto.c         | 28 ++++++++++++++++-------
 2 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 0307fb0d95d34..3290c03c9918d 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -354,28 +354,16 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 	return true;
 }
 
-/**
- * __blk_crypto_evict_key() - Evict a key from a device.
- * @profile: the crypto profile of the device
- * @key: the key to evict.  It must not still be used in any I/O.
- *
- * If the device has keyslots, this finds the keyslot (if any) that contains the
- * specified key and calls the driver's keyslot_evict function to evict it.
- *
- * Otherwise, this just calls the driver's keyslot_evict function if it is
- * implemented, passing just the key (without any particular keyslot).  This
- * allows layered devices to evict the key from their underlying devices.
- *
- * Context: Process context. Takes and releases profile->lock.
- * Return: 0 on success or if there's no keyslot with the specified key, -EBUSY
- *	   if the keyslot is still in use, or another -errno value on other
- *	   error.
+/*
+ * This is an internal function that evicts a key from an inline encryption
+ * device that can be either a real device or the blk-crypto-fallback "device".
+ * It is used only by blk_crypto_evict_key(); see that function for details.
  */
 int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
 			   const struct blk_crypto_key *key)
 {
 	struct blk_crypto_keyslot *slot;
-	int err = 0;
+	int err;
 
 	if (profile->num_slots == 0) {
 		if (profile->ll_ops.keyslot_evict) {
@@ -389,22 +377,30 @@ int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
 
 	blk_crypto_hw_enter(profile);
 	slot = blk_crypto_find_keyslot(profile, key);
-	if (!slot)
-		goto out_unlock;
+	if (!slot) {
+		/*
+		 * Not an error, since a key not in use by I/O is not guaranteed
+		 * to be in a keyslot.  There can be more keys than keyslots.
+		 */
+		err = 0;
+		goto out;
+	}
 
 	if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)) {
+		/* BUG: key is still in use by I/O */
 		err = -EBUSY;
-		goto out_unlock;
+		goto out_remove;
 	}
 	err = profile->ll_ops.keyslot_evict(profile, key,
 					    blk_crypto_keyslot_index(slot));
-	if (err)
-		goto out_unlock;
-
+out_remove:
+	/*
+	 * Callers free the key even on error, so unlink the key from the hash
+	 * table and clear slot->key even on error.
+	 */
 	hlist_del(&slot->hash_node);
 	slot->key = NULL;
-	err = 0;
-out_unlock:
+out:
 	blk_crypto_hw_exit(profile);
 	return err;
 }
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index e800f305e9eda..4d760b092deb9 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -400,15 +400,19 @@ int blk_crypto_start_using_key(struct block_device *bdev,
 }
 
 /**
- * blk_crypto_evict_key() - Evict a key from any inline encryption hardware
- *			    it may have been programmed into
- * @bdev: The block_device who's associated inline encryption hardware this key
- *     might have been programmed into
- * @key: The key to evict
+ * blk_crypto_evict_key() - Evict a blk_crypto_key from a block_device
+ * @bdev: a block_device on which I/O using the key may have been done
+ * @key: the key to evict
  *
- * Upper layers (filesystems) must call this function to ensure that a key is
- * evicted from any hardware that it might have been programmed into.  The key
- * must not be in use by any in-flight IO when this function is called.
+ * For a given block_device, this function removes the given blk_crypto_key from
+ * the keyslot management structures and evicts it from any underlying hardware
+ * keyslot(s) or blk-crypto-fallback keyslot it may have been programmed into.
+ *
+ * Upper layers must call this before freeing the blk_crypto_key.  It must be
+ * called for every block_device the key may have been used on.  The key must no
+ * longer be in use by any I/O when this function is called.
+ *
+ * Context: May sleep.
  */
 void blk_crypto_evict_key(struct block_device *bdev,
 			  const struct blk_crypto_key *key)
@@ -420,6 +424,14 @@ void blk_crypto_evict_key(struct block_device *bdev,
 		err = __blk_crypto_evict_key(q->crypto_profile, key);
 	else
 		err = blk_crypto_fallback_evict_key(key);
+	/*
+	 * An error can only occur here if the key failed to be evicted from a
+	 * keyslot (due to a hardware or driver issue) or is allegedly still in
+	 * use by I/O (due to a kernel bug).  Even in these cases, the key is
+	 * still unlinked from the keyslot management structures, and the caller
+	 * is allowed and expected to free it right away.  There's nothing
+	 * callers can do to handle errors, so just log them and return void.
+	 */
 	if (err)
 		pr_warn_ratelimited("%pg: error %d evicting key\n", bdev, err);
 }
-- 
2.39.2

