Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C647C6B1227
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 20:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCHTjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 14:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjCHTjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 14:39:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B161C7C3C7;
        Wed,  8 Mar 2023 11:39:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D8CA61938;
        Wed,  8 Mar 2023 19:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D60C433D2;
        Wed,  8 Mar 2023 19:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678304376;
        bh=bbb+45XrVULPTKf/JqPwmrPjLg03mNEHizYqoAVoe1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEc4Lbjtd0ge0AydvT2tB0mTOToL+HIr1wjag7UXlEzHxFjBDwEK4yFzn9T9uD9Xz
         ASSdEnK5QRT4Jf1ngG102uNYYxpQGcYanKxYuUxWn3i5qrI5gwL7rW4/eI6sIPBr38
         ijwfqKMfEhTyv7557LiY+cOe4cbxXUeH9RHjtj8gKZVaGvETgnAA8zU4PJK5dL5dpP
         /a588v2OAURbEyRRB5DdrWRmzncO7k2zlCpUtU77pZME2Eplt5tCNVDu9+QJkJ/lc7
         uJR/M2RGpmdFXGy7TnPbgAMT9qXbmbg3NY/vcjr1lx3lHMiol7RudAoY3LoQ3KR0qx
         7cSiwtLBbjFeg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/4] blk-crypto: make blk_crypto_evict_key() more robust
Date:   Wed,  8 Mar 2023 11:36:43 -0800
Message-Id: <20230308193645.114069-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308193645.114069-1-ebiggers@kernel.org>
References: <20230308193645.114069-1-ebiggers@kernel.org>
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
bug) or that ->keyslot_evict failed, it currently just returns an error
while leaving the key linked into the keyslot management structures.

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

Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
Cc: stable@vger.kernel.org
Reviewed-by: Nathan Huckleberry <nhuck@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-profile.c | 50 +++++++++++++++-----------------------
 block/blk-crypto.c         | 23 +++++++++++-------
 2 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 0307fb0d95d3..1b20ead59f39 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -354,22 +354,10 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
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
@@ -389,22 +377,22 @@ int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
 
 	blk_crypto_hw_enter(profile);
 	slot = blk_crypto_find_keyslot(profile, key);
-	if (!slot)
-		goto out_unlock;
-
-	if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)) {
-		err = -EBUSY;
-		goto out_unlock;
+	if (slot) {
+		if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)) {
+			/* BUG: key is still in use by I/O */
+			err = -EBUSY;
+		} else {
+			err = profile->ll_ops.keyslot_evict(
+					profile, key,
+					blk_crypto_keyslot_index(slot));
+		}
+		/*
+		 * Callers may free the key even on error, so unlink the key
+		 * from the hash table and clear slot->key even on error.
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
index d0c7feb447e9..4e26fac64199 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -399,17 +399,22 @@ int blk_crypto_start_using_key(struct block_device *bdev,
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
  *
- * Return: 0 on success or if the key wasn't in any keyslot; -errno on error.
+ * Upper layers must call this before freeing the blk_crypto_key.  It must be
+ * called for every block_device the key may have been used on.  The key must no
+ * longer be in use by any I/O when this function is called.
+ *
+ * Context: May sleep.
+ * Return: 0 on success or if the key wasn't in any keyslot; -errno if the key
+ *	   failed to be evicted from a keyslot or is still in-use.  Even on
+ *	   "failure", the key is removed from the keyslot management structures.
  */
 int blk_crypto_evict_key(struct block_device *bdev,
 			 const struct blk_crypto_key *key)
-- 
2.39.2

