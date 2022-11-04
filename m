Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C5C61A4F0
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 23:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiKDWzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 18:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKDWzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 18:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12434A1A4;
        Fri,  4 Nov 2022 15:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A04D56237B;
        Fri,  4 Nov 2022 22:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D8CC433D7;
        Fri,  4 Nov 2022 22:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667602551;
        bh=7cy0/F4ACE2an4g49DpJ2dgvdlRM44LxjqIixFhvUq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9I0DWZpdLSlxnbPda2m5kjkNLFAwJHBvwgvRRC1hfO2ZgaERcgDAjWPkXiFJyUVu
         LhO72i1dBfHawRLfP+6BoJO9fqsA8j4KggODSaNMIqN12BiE4a8Cab/fCSEOgvWt3l
         RZnNaQcd7Jk0Q07yLWtMqxAF7Tw68wNGLp0WDwzuKBxtVGdFFYZMjceUKZY4DoFVoE
         CuE3a19jwJd4wY41fDnv6fAJ3TSrFp/0ZCCcIFrA3uB/Pf7GtMZzSrzC4VakY2Cgql
         ejEaQCItAQWawe3v1fd4zmpvRlqgAMZ6UtTLkijH2kFGPtZc0mRWzoR787cdWcSs20
         zkEJQAH/iBTDg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        syzbot+104c2a89561289cec13e@syzkaller.appspotmail.com,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 6.0 2/2] fscrypt: fix keyring memory leak on mount failure
Date:   Fri,  4 Nov 2022 15:54:39 -0700
Message-Id: <20221104225439.338239-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104225439.338239-1-ebiggers@kernel.org>
References: <20221104225439.338239-1-ebiggers@kernel.org>
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

commit ccd30a476f8e864732de220bd50e6f372f5ebcab upstream.

Commit d7e7b9af104c ("fscrypt: stop using keyrings subsystem for
fscrypt_master_key") moved the keyring destruction from __put_super() to
generic_shutdown_super() so that the filesystem's block device(s) are
still available.  Unfortunately, this causes a memory leak in the case
where a mount is attempted with the test_dummy_encryption mount option,
but the mount fails after the option has already been processed.

To fix this, attempt the keyring destruction in both places.

Reported-by: syzbot+104c2a89561289cec13e@syzkaller.appspotmail.com
Fixes: d7e7b9af104c ("fscrypt: stop using keyrings subsystem for fscrypt_master_key")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Link: https://lore.kernel.org/r/20221011213838.209879-1-ebiggers@kernel.org
---
 fs/crypto/keyring.c     | 17 +++++++++++------
 fs/super.c              |  3 ++-
 include/linux/fscrypt.h |  4 ++--
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 9b98d6a576e6a..f10ace12c05f8 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -202,14 +202,19 @@ static int allocate_filesystem_keyring(struct super_block *sb)
 }
 
 /*
- * This is called at unmount time to release all encryption keys that have been
- * added to the filesystem, along with the keyring that contains them.
+ * Release all encryption keys that have been added to the filesystem, along
+ * with the keyring that contains them.
  *
- * Note that besides clearing and freeing memory, this might need to evict keys
- * from the keyslots of an inline crypto engine.  Therefore, this must be called
- * while the filesystem's underlying block device(s) are still available.
+ * This is called at unmount time.  The filesystem's underlying block device(s)
+ * are still available at this time; this is important because after user file
+ * accesses have been allowed, this function may need to evict keys from the
+ * keyslots of an inline crypto engine, which requires the block device(s).
+ *
+ * This is also called when the super_block is being freed.  This is needed to
+ * avoid a memory leak if mounting fails after the "test_dummy_encryption"
+ * option was processed, as in that case the unmount-time call isn't made.
  */
-void fscrypt_sb_delete(struct super_block *sb)
+void fscrypt_destroy_keyring(struct super_block *sb)
 {
 	struct fscrypt_keyring *keyring = sb->s_master_keys;
 	size_t i;
diff --git a/fs/super.c b/fs/super.c
index 6a82660e1adba..8d39e4f11cfa3 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -291,6 +291,7 @@ static void __put_super(struct super_block *s)
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(!list_empty(&s->s_mounts));
 		security_sb_free(s);
+		fscrypt_destroy_keyring(s);
 		put_user_ns(s->s_user_ns);
 		kfree(s->s_subtype);
 		call_rcu(&s->rcu, destroy_super_rcu);
@@ -479,7 +480,7 @@ void generic_shutdown_super(struct super_block *sb)
 		evict_inodes(sb);
 		/* only nonzero refcount inodes can have marks */
 		fsnotify_sb_delete(sb);
-		fscrypt_sb_delete(sb);
+		fscrypt_destroy_keyring(sb);
 		security_sb_delete(sb);
 
 		if (sb->s_dio_done_wq) {
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index d86f43bd95502..d0e40a20ff810 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -312,7 +312,7 @@ fscrypt_free_dummy_policy(struct fscrypt_dummy_policy *dummy_policy)
 }
 
 /* keyring.c */
-void fscrypt_sb_delete(struct super_block *sb);
+void fscrypt_destroy_keyring(struct super_block *sb);
 int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
 int fscrypt_add_test_dummy_key(struct super_block *sb,
 			       const struct fscrypt_dummy_policy *dummy_policy);
@@ -526,7 +526,7 @@ fscrypt_free_dummy_policy(struct fscrypt_dummy_policy *dummy_policy)
 }
 
 /* keyring.c */
-static inline void fscrypt_sb_delete(struct super_block *sb)
+static inline void fscrypt_destroy_keyring(struct super_block *sb)
 {
 }
 
-- 
2.38.1

