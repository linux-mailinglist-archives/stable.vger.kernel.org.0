Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6936A91A9
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 08:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCCHXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 02:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjCCHXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 02:23:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3076D14495;
        Thu,  2 Mar 2023 23:23:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AE8261771;
        Fri,  3 Mar 2023 07:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE9FC4339E;
        Fri,  3 Mar 2023 07:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677828209;
        bh=sa61M2+pFizpLQ61APorBId7JMTf9Cn6cm1le+eyI7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9Tq4WzY25FFuUee2wup+AW8On32w89kSRu4Us7HKJxhGAmGgpPuciTD8i2tcW86G
         j7/VDzk8WKY6SWchE5EAf9QnMZK4uloutSnr7ZD2qUh0w3wv/wVX0OIWga51+kixTo
         fx9vw1s6EL093cKPDZFvBgWz2NCdixyuuIRcJ+ase2TAXI18kPb9g+PaNC6bbUY6gs
         hjdhDmKfakqCPlMqowi5rpRycLXD3Ai0ZeBR6UgUs10YT4Ueah/KZrVnyTJeGCR/Q4
         dLBUzK2y26oAmUz7ef25+H4QWZOhQCZwU4qt7Hns7ZpiIlMjq3Dqdy2Wu3XoCVM9pi
         J+g6vGef0shCw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>, stable@vger.kernel.org
Subject: [PATCH 2/3] blk-crypto: make blk_crypto_evict_key() more robust
Date:   Thu,  2 Mar 2023 23:19:58 -0800
Message-Id: <20230303071959.144604-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303071959.144604-1-ebiggers@kernel.org>
References: <20230303071959.144604-1-ebiggers@kernel.org>
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
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-profile.c | 50 +++++++++++++++-----------------------
 block/blk-crypto.c         | 23 +++++++++++-------
 2 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 0307fb0d95d34..1b20ead59f39b 100644
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
index 8e5612364c48c..caa86a210cb6c 100644
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

