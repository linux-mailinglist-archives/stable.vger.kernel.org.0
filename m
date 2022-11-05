Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4DE61A5F5
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 00:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiKDXkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 19:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiKDXkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 19:40:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA4D14D2F;
        Fri,  4 Nov 2022 16:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC655B83012;
        Fri,  4 Nov 2022 23:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC74C433D6;
        Fri,  4 Nov 2022 23:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667605196;
        bh=6RjxLMlyr4vJchPn5ZXKAbpz8mxVm4+zK7KGs7HQVQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeC1JRVadEt4TR1R3uVP0idFs/2CF+GZCD0Iv2jgWU/Afog9oyZbzCHkPAtTxStCl
         Gh4e5trr0ZMhcqkxCtR2Rd7MlNpJJynGElSqAE9qJ7yaI7Eo5E70544X2UCSuqetuU
         LFXKBXl5RGLXxrKKz6JdxEzwxazd3xRyhDTJSNSypW0pZaZbNwC47gXGPRXXynkQzP
         8imPn18MAS+DEOayLS0u+Se5B7cSdZOGKZcHK49wDtvWbKO6W0M5gpTYV+HAeFXoTy
         TKll0ZM5h0e91FHzry502la+91KtcoCQwAycfzx2PP8loabmAlDIAXF9O1su62t0H8
         EpAWFsksErdoA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 5.10 1/3] fscrypt: simplify master key locking
Date:   Fri,  4 Nov 2022 16:37:58 -0700
Message-Id: <20221104233800.421135-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104233800.421135-1-ebiggers@kernel.org>
References: <20221104233800.421135-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 4a4b8721f1a5e4b01e45b3153c68d5a1014b25de upstream.

The stated reasons for separating fscrypt_master_key::mk_secret_sem from
the standard semaphore contained in every 'struct key' no longer apply.

First, due to commit a992b20cd4ee ("fscrypt: add
fscrypt_prepare_new_inode() and fscrypt_set_context()"),
fscrypt_get_encryption_info() is no longer called from within a
filesystem transaction.

Second, due to commit d3ec10aa9581 ("KEYS: Don't write out to userspace
while holding key semaphore"), the semaphore for the "keyring" key type
no longer ranks above page faults.

That leaves performance as the only possible reason to keep the separate
mk_secret_sem.  Specifically, having mk_secret_sem reduces the
contention between setup_file_encryption_key() and
FS_IOC_{ADD,REMOVE}_ENCRYPTION_KEY.  However, these ioctls aren't
executed often, so this doesn't seem to be worth the extra complexity.

Therefore, simplify the locking design by just using key->sem instead of
mk_secret_sem.

Link: https://lore.kernel.org/r/20201117032626.320275-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 19 ++++++-------------
 fs/crypto/hooks.c           |  8 +++++---
 fs/crypto/keyring.c         |  8 +-------
 fs/crypto/keysetup.c        | 20 +++++++++-----------
 4 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 052ad40ecdb28..8a0141f7195bf 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -439,16 +439,9 @@ struct fscrypt_master_key {
 	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
 	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
 	 *
-	 * Locking: protected by key->sem (outer) and mk_secret_sem (inner).
-	 * The reason for two locks is that key->sem also protects modifying
-	 * mk_users, which ranks it above the semaphore for the keyring key
-	 * type, which is in turn above page faults (via keyring_read).  But
-	 * sometimes filesystems call fscrypt_get_encryption_info() from within
-	 * a transaction, which ranks it below page faults.  So we need a
-	 * separate lock which protects mk_secret but not also mk_users.
+	 * Locking: protected by this master key's key->sem.
 	 */
 	struct fscrypt_master_key_secret	mk_secret;
-	struct rw_semaphore			mk_secret_sem;
 
 	/*
 	 * For v1 policy keys: an arbitrary key descriptor which was assigned by
@@ -467,8 +460,8 @@ struct fscrypt_master_key {
 	 *
 	 * This is NULL for v1 policy keys; those can only be added by root.
 	 *
-	 * Locking: in addition to this keyrings own semaphore, this is
-	 * protected by the master key's key->sem, so we can do atomic
+	 * Locking: in addition to this keyring's own semaphore, this is
+	 * protected by this master key's key->sem, so we can do atomic
 	 * search+insert.  It can also be searched without taking any locks, but
 	 * in that case the returned key may have already been removed.
 	 */
@@ -510,9 +503,9 @@ is_master_key_secret_present(const struct fscrypt_master_key_secret *secret)
 	/*
 	 * The READ_ONCE() is only necessary for fscrypt_drop_inode() and
 	 * fscrypt_key_describe().  These run in atomic context, so they can't
-	 * take ->mk_secret_sem and thus 'secret' can change concurrently which
-	 * would be a data race.  But they only need to know whether the secret
-	 * *was* present at the time of check, so READ_ONCE() suffices.
+	 * take the key semaphore and thus 'secret' can change concurrently
+	 * which would be a data race.  But they only need to know whether the
+	 * secret *was* present at the time of check, so READ_ONCE() suffices.
 	 */
 	return READ_ONCE(secret->size) != 0;
 }
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 4180371bf8642..0c6fa5c2d6f3a 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -139,6 +139,7 @@ int fscrypt_prepare_setflags(struct inode *inode,
 			     unsigned int oldflags, unsigned int flags)
 {
 	struct fscrypt_info *ci;
+	struct key *key;
 	struct fscrypt_master_key *mk;
 	int err;
 
@@ -154,13 +155,14 @@ int fscrypt_prepare_setflags(struct inode *inode,
 		ci = inode->i_crypt_info;
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
 			return -EINVAL;
-		mk = ci->ci_master_key->payload.data[0];
-		down_read(&mk->mk_secret_sem);
+		key = ci->ci_master_key;
+		mk = key->payload.data[0];
+		down_read(&key->sem);
 		if (is_master_key_secret_present(&mk->mk_secret))
 			err = fscrypt_derive_dirhash_key(ci, mk);
 		else
 			err = -ENOKEY;
-		up_read(&mk->mk_secret_sem);
+		up_read(&key->sem);
 		return err;
 	}
 	return 0;
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index d7ec52cb3d9af..0b3ffbb4faf4a 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -347,7 +347,6 @@ static int add_new_master_key(struct fscrypt_master_key_secret *secret,
 	mk->mk_spec = *mk_spec;
 
 	move_master_key_secret(&mk->mk_secret, secret);
-	init_rwsem(&mk->mk_secret_sem);
 
 	refcount_set(&mk->mk_refcount, 1); /* secret is present */
 	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
@@ -427,11 +426,8 @@ static int add_existing_master_key(struct fscrypt_master_key *mk,
 	}
 
 	/* Re-add the secret if needed. */
-	if (rekey) {
-		down_write(&mk->mk_secret_sem);
+	if (rekey)
 		move_master_key_secret(&mk->mk_secret, secret);
-		up_write(&mk->mk_secret_sem);
-	}
 	return 0;
 }
 
@@ -975,10 +971,8 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 	/* No user claims remaining.  Go ahead and wipe the secret. */
 	dead = false;
 	if (is_master_key_secret_present(&mk->mk_secret)) {
-		down_write(&mk->mk_secret_sem);
 		wipe_master_key_secret(&mk->mk_secret);
 		dead = refcount_dec_and_test(&mk->mk_refcount);
-		up_write(&mk->mk_secret_sem);
 	}
 	up_write(&key->sem);
 	if (dead) {
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 73d96e35d9ae4..72aec33e0ea5d 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -405,11 +405,11 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
  * Find the master key, then set up the inode's actual encryption key.
  *
  * If the master key is found in the filesystem-level keyring, then the
- * corresponding 'struct key' is returned in *master_key_ret with
- * ->mk_secret_sem read-locked.  This is needed to ensure that only one task
- * links the fscrypt_info into ->mk_decrypted_inodes (as multiple tasks may race
- * to create an fscrypt_info for the same inode), and to synchronize the master
- * key being removed with a new inode starting to use it.
+ * corresponding 'struct key' is returned in *master_key_ret with its semaphore
+ * read-locked.  This is needed to ensure that only one task links the
+ * fscrypt_info into ->mk_decrypted_inodes (as multiple tasks may race to create
+ * an fscrypt_info for the same inode), and to synchronize the master key being
+ * removed with a new inode starting to use it.
  */
 static int setup_file_encryption_key(struct fscrypt_info *ci,
 				     bool need_dirhash_key,
@@ -458,7 +458,7 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	}
 
 	mk = key->payload.data[0];
-	down_read(&mk->mk_secret_sem);
+	down_read(&key->sem);
 
 	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
 	if (!is_master_key_secret_present(&mk->mk_secret)) {
@@ -490,7 +490,7 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	return 0;
 
 out_release_key:
-	up_read(&mk->mk_secret_sem);
+	up_read(&key->sem);
 	key_put(key);
 	return err;
 }
@@ -593,9 +593,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	res = 0;
 out:
 	if (master_key) {
-		struct fscrypt_master_key *mk = master_key->payload.data[0];
-
-		up_read(&mk->mk_secret_sem);
+		up_read(&master_key->sem);
 		key_put(master_key);
 	}
 	put_crypt_info(crypt_info);
@@ -769,7 +767,7 @@ int fscrypt_drop_inode(struct inode *inode)
 		return 0;
 
 	/*
-	 * Note: since we aren't holding ->mk_secret_sem, the result here can
+	 * Note: since we aren't holding the key semaphore, the result here can
 	 * immediately become outdated.  But there's no correctness problem with
 	 * unnecessarily evicting.  Nor is there a correctness problem with not
 	 * evicting while iput() is racing with the key being removed, since
-- 
2.38.1

