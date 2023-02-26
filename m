Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3286A3407
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 21:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBZUnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 15:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjBZUnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 15:43:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3543E5274;
        Sun, 26 Feb 2023 12:42:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A51CBB80DC1;
        Sun, 26 Feb 2023 20:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AEDC4339E;
        Sun, 26 Feb 2023 20:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677444070;
        bh=nBR8xdL87GKQEZbV+va26SNh+fk7l5AhlCFHpzuELZU=;
        h=From:To:Cc:Subject:Date:From;
        b=GmaEFgy3cUvREDO/7h7TLs9jUJmfdSkfsYz4NmZoe2mL9jiIiC6bD3MHBbeZCBB+L
         euS7K5bVGBsStMcM2Da+ixeaGEyJXc491velDWSU1nxFe41eAhQc2SpNTdiouITlhn
         sDKoManaHVMUQU2+NliDVg190n2OoaIhq3K7Hhk2PgvcCttwp2asvUOSJfuJA2EeOA
         Zjn4bhi42eeuRbclZjTiML7+2tswz+vHRRE8vskoz9jiS+rv8IyN/Ews/mE71brKwZ
         6nZbeW+hSZravAH5blJ+0uAKO5a0CmzpeE3Dc8VkBbyOcy2l7jxJ+Mg9F/+kOVA0/B
         lFvFgv2Jei5YA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] blk-crypto: make blk_crypto_evict_key() always try to evict
Date:   Sun, 26 Feb 2023 12:38:16 -0800
Message-Id: <20230226203816.207449-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
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

Once all I/O using a blk_crypto_key has completed, filesystems can call
blk_crypto_evict_key().  However, the block layer doesn't call
blk_crypto_put_keyslot() until the request is being cleaned up, which
happens after upper layers have been told (via bio_endio()) the I/O has
completed.  This causes a race condition where blk_crypto_evict_key()
can see 'slot_refs > 0' without there being an actual bug.

This makes __blk_crypto_evict_key() hit the
'WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)' and return without
doing anything, eventually causing a use-after-free in
blk_crypto_reprogram_all_keys().  (This is a very rare bug and has only
been seen when per-file keys are being used with fscrypt.)

There are two options to fix this: either release the keyslot in
blk_update_request() just before bio_endio() is called on the request's
last bio, or just make __blk_crypto_evict_key() ignore slot_refs.  Let's
go with the latter solution for now, since it avoids adding overhead to
the loop in blk_update_request().  (It does have the disadvantage that
hypothetical bugs where a key is evicted while still in-use become
harder to detect.  But so far there haven't been any such bugs anyway.)

A related issue with __blk_crypto_evict_key() is that ->keyslot_evict
failing would cause the same use-after-free as well.  Fix this by always
removing the key from the keyslot management structures.

Update the function documentation to properly document the semantics.

Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-profile.c | 52 +++++++++++++++-----------------------
 block/blk-crypto.c         | 24 +++++++++++-------
 2 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 0307fb0d95d3..29b4148cc50d 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -354,22 +354,11 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
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
+ * It is used only for blk_crypto_evict_key().  For details on what this does,
+ * see the documentation for blk_crypto_evict_key().
  */
 int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
 			   const struct blk_crypto_key *key)
@@ -389,22 +378,23 @@ int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
 
 	blk_crypto_hw_enter(profile);
 	slot = blk_crypto_find_keyslot(profile, key);
-	if (!slot)
-		goto out_unlock;
-
-	if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)) {
-		err = -EBUSY;
-		goto out_unlock;
+	if (slot) {
+		/*
+		 * Note: it is a bug if the key is still in use by I/O here.
+		 * But 'slot_refs > 0' can't be used to detect such bugs here,
+		 * since the keyslot isn't released until after upper layers
+		 * have already been told the I/O is complete.
+		 */
+		err = profile->ll_ops.keyslot_evict(
+				profile, key, blk_crypto_keyslot_index(slot));
+		/*
+		 * Even on ->keyslot_evict failure, we must remove the
+		 * blk_crypto_key from the keyslot management structures, since
+		 * the caller is allowed to free it regardless.
+		 */
+		hlist_del(&slot->hash_node);
+		slot->key = NULL;
 	}
-	err = profile->ll_ops.keyslot_evict(profile, key,
-					    blk_crypto_keyslot_index(slot));
-	if (err)
-		goto out_unlock;
-
-	hlist_del(&slot->hash_node);
-	slot->key = NULL;
-	err = 0;
-out_unlock:
 	blk_crypto_hw_exit(profile);
 	return err;
 }
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 45378586151f..3dcbe578beb2 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -399,17 +399,23 @@ int blk_crypto_start_using_key(struct block_device *bdev,
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
+ * or fallback keyslot(s) it may have been programmed into.
  *
- * Return: 0 on success or if the key wasn't in any keyslot; -errno on error.
+ * Upper layers must call this before freeing the blk_crypto_key.  It must be
+ * called for every block_device the key may have been used on.  The key must no
+ * longer be in use by any I/O when this function is called.
+ *
+ * Context: May sleep.
+ * Return: 0 on success or if the key wasn't in any keyslot; -errno if the key
+ *	   failed to be evicted from a hardware keyslot.  Even in the -errno
+ *	   case, the key is removed from the keyslot management structures and
+ *	   the caller is allowed (and expected) to free the blk_crypto_key.
  */
 int blk_crypto_evict_key(struct block_device *bdev,
 			 const struct blk_crypto_key *key)

base-commit: 489fa31ea873282b41046d412ec741f93946fc2d
-- 
2.39.2

