Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429C54F3342
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245174AbiDEIyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241086AbiDEIcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B4313F58;
        Tue,  5 Apr 2022 01:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E985460FFC;
        Tue,  5 Apr 2022 08:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D00C385A4;
        Tue,  5 Apr 2022 08:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147226;
        bh=g+BIlF8aVqHMQOFVwronpp1v3eo4iKq0jRClRPv6cIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9tJugj28bIz4sbRCbqWbnbDpMMvXtYg0QgymioAKDs1kq/ZewZYIKhojtrbreD2o
         RHnU7dmcWtAi7ocFB4QfXUUuK9ULkSLBrVm3LUJpVqKBpols7uwT+OhFk9Tbf61o4e
         ON3l6n301kg6M/0l5vq6MXg5tdw9Xk0WMWri9oFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.17 1008/1126] ubifs: Fix ui->dirty race between do_tmpfile() and writeback work
Date:   Tue,  5 Apr 2022 09:29:15 +0200
Message-Id: <20220405070437.077153739@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 60eb3b9c9f11206996f57cb89521824304b305ad upstream.

'ui->dirty' is not protected by 'ui_mutex' in function do_tmpfile() which
may race with ubifs_write_inode[wb_workfn] to access/update 'ui->dirty',
finally dirty space is released twice.

	open(O_TMPFILE)                wb_workfn
do_tmpfile
  ubifs_budget_space(ino_req = { .dirtied_ino = 1})
  d_tmpfile // mark inode(tmpfile) dirty
  ubifs_jnl_update // without holding tmpfile's ui_mutex
    mark_inode_clean(ui)
      if (ui->dirty)
        ubifs_release_dirty_inode_budget(ui)  // release first time
                                   ubifs_write_inode
				     mutex_lock(&ui->ui_mutex)
                                     ubifs_release_dirty_inode_budget(ui)
				     // release second time
				     mutex_unlock(&ui->ui_mutex)
      ui->dirty = 0

Run generic/476 can reproduce following message easily
(See reproducer in [Link]):

  UBIFS error (ubi0:0 pid 2578): ubifs_assert_failed [ubifs]: UBIFS assert
  failed: c->bi.dd_growth >= 0, in fs/ubifs/budget.c:554
  UBIFS warning (ubi0:0 pid 2578): ubifs_ro_mode [ubifs]: switched to
  read-only mode, error -22
  Workqueue: writeback wb_workfn (flush-ubifs_0_0)
  Call Trace:
    ubifs_ro_mode+0x54/0x60 [ubifs]
    ubifs_assert_failed+0x4b/0x80 [ubifs]
    ubifs_release_budget+0x468/0x5a0 [ubifs]
    ubifs_release_dirty_inode_budget+0x53/0x80 [ubifs]
    ubifs_write_inode+0x121/0x1f0 [ubifs]
    ...
    wb_workfn+0x283/0x7b0

Fix it by holding tmpfile ubifs inode lock during ubifs_jnl_update().
Similar problem exists in whiteout renaming, but previous fix("ubifs:
Rename whiteout atomically") has solved the problem.

Fixes: 474b93704f32163 ("ubifs: Implement O_TMPFILE")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=214765
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |   60 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -397,6 +397,32 @@ out_free:
 	return ERR_PTR(err);
 }
 
+/**
+ * lock_2_inodes - a wrapper for locking two UBIFS inodes.
+ * @inode1: first inode
+ * @inode2: second inode
+ *
+ * We do not implement any tricks to guarantee strict lock ordering, because
+ * VFS has already done it for us on the @i_mutex. So this is just a simple
+ * wrapper function.
+ */
+static void lock_2_inodes(struct inode *inode1, struct inode *inode2)
+{
+	mutex_lock_nested(&ubifs_inode(inode1)->ui_mutex, WB_MUTEX_1);
+	mutex_lock_nested(&ubifs_inode(inode2)->ui_mutex, WB_MUTEX_2);
+}
+
+/**
+ * unlock_2_inodes - a wrapper for unlocking two UBIFS inodes.
+ * @inode1: first inode
+ * @inode2: second inode
+ */
+static void unlock_2_inodes(struct inode *inode1, struct inode *inode2)
+{
+	mutex_unlock(&ubifs_inode(inode2)->ui_mutex);
+	mutex_unlock(&ubifs_inode(inode1)->ui_mutex);
+}
+
 static int ubifs_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
 			 struct dentry *dentry, umode_t mode)
 {
@@ -404,7 +430,7 @@ static int ubifs_tmpfile(struct user_nam
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1};
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1 };
-	struct ubifs_inode *ui, *dir_ui = ubifs_inode(dir);
+	struct ubifs_inode *ui;
 	int err, instantiated = 0;
 	struct fscrypt_name nm;
 
@@ -452,18 +478,18 @@ static int ubifs_tmpfile(struct user_nam
 	instantiated = 1;
 	mutex_unlock(&ui->ui_mutex);
 
-	mutex_lock(&dir_ui->ui_mutex);
+	lock_2_inodes(dir, inode);
 	err = ubifs_jnl_update(c, dir, &nm, inode, 1, 0);
 	if (err)
 		goto out_cancel;
-	mutex_unlock(&dir_ui->ui_mutex);
+	unlock_2_inodes(dir, inode);
 
 	ubifs_release_budget(c, &req);
 
 	return 0;
 
 out_cancel:
-	mutex_unlock(&dir_ui->ui_mutex);
+	unlock_2_inodes(dir, inode);
 out_inode:
 	make_bad_inode(inode);
 	if (!instantiated)
@@ -690,32 +716,6 @@ static int ubifs_dir_release(struct inod
 	return 0;
 }
 
-/**
- * lock_2_inodes - a wrapper for locking two UBIFS inodes.
- * @inode1: first inode
- * @inode2: second inode
- *
- * We do not implement any tricks to guarantee strict lock ordering, because
- * VFS has already done it for us on the @i_mutex. So this is just a simple
- * wrapper function.
- */
-static void lock_2_inodes(struct inode *inode1, struct inode *inode2)
-{
-	mutex_lock_nested(&ubifs_inode(inode1)->ui_mutex, WB_MUTEX_1);
-	mutex_lock_nested(&ubifs_inode(inode2)->ui_mutex, WB_MUTEX_2);
-}
-
-/**
- * unlock_2_inodes - a wrapper for unlocking two UBIFS inodes.
- * @inode1: first inode
- * @inode2: second inode
- */
-static void unlock_2_inodes(struct inode *inode1, struct inode *inode2)
-{
-	mutex_unlock(&ubifs_inode(inode2)->ui_mutex);
-	mutex_unlock(&ubifs_inode(inode1)->ui_mutex);
-}
-
 static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
 		      struct dentry *dentry)
 {


