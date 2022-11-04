Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D65A61A5F7
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 00:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiKDXkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 19:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiKDXkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 19:40:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79A1275F4;
        Fri,  4 Nov 2022 16:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85B38B83026;
        Fri,  4 Nov 2022 23:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FDDC433B5;
        Fri,  4 Nov 2022 23:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667605197;
        bh=TR1uhEwmy4l0+pFm6fiduXwKw4Bl5l917+3ptEBbPLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9HW9QLwocjJSIplXalHb85FHRtsGBMS8DuiaRsgXj1AXd3XaPO1PHB0et44+L61/
         NPchu/zExGeKvIc+amMCn63JAJeOMzog6AdYtFSLOY1aXQFJxLFBQePf7IXg14MDiG
         PngEwVkMmuoziJyv/EC46WqB+yRy8eNCxc2xGo75kljBv1S9RpBY2VnJ9h6shTT41H
         K7mFr8UEBPkCFQzj8jwqJBkryT9fbWvzXcQoFDEEW7Wccd3eYNHssWl81ITkjO482p
         bUdbE9csmXTTpUFLPa8s4yeWmcZywZ4Gv7jiob9br1tCF3orwvorX8U/KMsRQKeTqG
         Esyhc9G3q1jAA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        syzbot+104c2a89561289cec13e@syzkaller.appspotmail.com,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.10 3/3] fscrypt: fix keyring memory leak on mount failure
Date:   Fri,  4 Nov 2022 16:38:00 -0700
Message-Id: <20221104233800.421135-4-ebiggers@kernel.org>
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
index 175b071beaf81..02f8bf8bd54da 100644
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
index beee3e1b4c296..7629f9dd031cc 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -293,6 +293,7 @@ static void __put_super(struct super_block *s)
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(!list_empty(&s->s_mounts));
 		security_sb_free(s);
+		fscrypt_destroy_keyring(s);
 		put_user_ns(s->s_user_ns);
 		kfree(s->s_subtype);
 		call_rcu(&s->rcu, destroy_super_rcu);
@@ -453,7 +454,7 @@ void generic_shutdown_super(struct super_block *sb)
 		evict_inodes(sb);
 		/* only nonzero refcount inodes can have marks */
 		fsnotify_sb_delete(sb);
-		fscrypt_sb_delete(sb);
+		fscrypt_destroy_keyring(sb);
 
 		if (sb->s_dio_done_wq) {
 			destroy_workqueue(sb->s_dio_done_wq);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 23d3ea47f7649..d0bc66fae7e01 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -193,7 +193,7 @@ fscrypt_free_dummy_policy(struct fscrypt_dummy_policy *dummy_policy)
 }
 
 /* keyring.c */
-void fscrypt_sb_delete(struct super_block *sb);
+void fscrypt_destroy_keyring(struct super_block *sb);
 int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
 int fscrypt_ioctl_remove_key(struct file *filp, void __user *arg);
 int fscrypt_ioctl_remove_key_all_users(struct file *filp, void __user *arg);
@@ -380,7 +380,7 @@ fscrypt_free_dummy_policy(struct fscrypt_dummy_policy *dummy_policy)
 }
 
 /* keyring.c */
-static inline void fscrypt_sb_delete(struct super_block *sb)
+static inline void fscrypt_destroy_keyring(struct super_block *sb)
 {
 }
 
-- 
2.38.1

