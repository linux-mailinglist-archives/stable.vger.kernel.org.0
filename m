Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0AE62142D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbiKHN6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234849AbiKHN6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:58:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1661C623A7;
        Tue,  8 Nov 2022 05:58:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A06615A3;
        Tue,  8 Nov 2022 13:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A479EC433D7;
        Tue,  8 Nov 2022 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915884;
        bh=wA5jijDbpEQbs5m8nu46fYFGnecBZUjnCkqKr4Gubf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adZdOQI9ornWsuJfwF6n/zabxGvJ9CDM3Vw21QOfJJFdVamCYdTFToySR2+GQ5QPX
         KpV7gHi1rRs1ANJLJVwiDaMSJtV9ajyJkdFl4Mn+fDxZUuND5yoJk/vB3aSGpkEBxp
         Dw2ppeBOz4y7n50xXiFyzMLuCMQ7yN6enpjhJNFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.10 080/118] fscrypt: simplify master key locking
Date:   Tue,  8 Nov 2022 14:39:18 +0100
Message-Id: <20221108133344.190915106@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/crypto/fscrypt_private.h |   19 ++++++-------------
 fs/crypto/hooks.c           |    8 +++++---
 fs/crypto/keyring.c         |    8 +-------
 fs/crypto/keysetup.c        |   20 +++++++++-----------
 4 files changed, 21 insertions(+), 34 deletions(-)

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
@@ -510,9 +503,9 @@ is_master_key_secret_present(const struc
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
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -139,6 +139,7 @@ int fscrypt_prepare_setflags(struct inod
 			     unsigned int oldflags, unsigned int flags)
 {
 	struct fscrypt_info *ci;
+	struct key *key;
 	struct fscrypt_master_key *mk;
 	int err;
 
@@ -154,13 +155,14 @@ int fscrypt_prepare_setflags(struct inod
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
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -347,7 +347,6 @@ static int add_new_master_key(struct fsc
 	mk->mk_spec = *mk_spec;
 
 	move_master_key_secret(&mk->mk_secret, secret);
-	init_rwsem(&mk->mk_secret_sem);
 
 	refcount_set(&mk->mk_refcount, 1); /* secret is present */
 	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
@@ -427,11 +426,8 @@ static int add_existing_master_key(struc
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
 
@@ -975,10 +971,8 @@ static int do_remove_key(struct file *fi
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
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -405,11 +405,11 @@ static bool fscrypt_valid_master_key_siz
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
@@ -458,7 +458,7 @@ static int setup_file_encryption_key(str
 	}
 
 	mk = key->payload.data[0];
-	down_read(&mk->mk_secret_sem);
+	down_read(&key->sem);
 
 	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
 	if (!is_master_key_secret_present(&mk->mk_secret)) {
@@ -490,7 +490,7 @@ static int setup_file_encryption_key(str
 	return 0;
 
 out_release_key:
-	up_read(&mk->mk_secret_sem);
+	up_read(&key->sem);
 	key_put(key);
 	return err;
 }
@@ -593,9 +593,7 @@ fscrypt_setup_encryption_info(struct ino
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
@@ -769,7 +767,7 @@ int fscrypt_drop_inode(struct inode *ino
 		return 0;
 
 	/*
-	 * Note: since we aren't holding ->mk_secret_sem, the result here can
+	 * Note: since we aren't holding the key semaphore, the result here can
 	 * immediately become outdated.  But there's no correctness problem with
 	 * unnecessarily evicting.  Nor is there a correctness problem with not
 	 * evicting while iput() is racing with the key being removed, since


