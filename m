Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79B06677F3
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240097AbjALOvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239733AbjALOuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:50:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF97313F73
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:37:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A6C36203F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968FDC433EF;
        Thu, 12 Jan 2023 14:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534250;
        bh=QVWlK2JREA0iFwVCKLsPmPAEIbc2LE4mwST9ZJ8qUZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cO+WpSp+Tg9T2o9J2m8iB3SS6uVYSmht3IIFTOHgvhPxaUFaOOk/9AwEBBLhQLqNC
         8iI4hjTxg4mj3JCJLJEP2UjFvTP67Nd2EHzv5tFvUqslHmQKu+k/T9uqjK5lC/QdpR
         chTCov7VypUOYmC8b05dtDiUY1BaT65QQeDa6Zks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 746/783] ceph: switch to vfs_inode_has_locks() to fix file lock bug
Date:   Thu, 12 Jan 2023 14:57:42 +0100
Message-Id: <20230112135558.947544681@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 461ab10ef7e6ea9b41a0571a7fc6a72af9549a3c ]

For the POSIX locks they are using the same owner, which is the
thread id. And multiple POSIX locks could be merged into single one,
so when checking whether the 'file' has locks may fail.

For a file where some openers use locking and others don't is a
really odd usage pattern though. Locks are like stoplights -- they
only work if everyone pays attention to them.

Just switch ceph_get_caps() to check whether any locks are set on
the inode. If there are POSIX/OFD/FLOCK locks on the file at the
time, we should set CHECK_FILELOCK, regardless of what fd was used
to set the lock.

Fixes: ff5d913dfc71 ("ceph: return -EIO if read/write against filp that lost file locks")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c  | 2 +-
 fs/ceph/locks.c | 4 ----
 fs/ceph/super.h | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 51562d36fa83..210496dc2fd4 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2957,7 +2957,7 @@ int ceph_get_caps(struct file *filp, int need, int want,
 
 	while (true) {
 		flags &= CEPH_FILE_MODE_MASK;
-		if (atomic_read(&fi->num_locks))
+		if (vfs_inode_has_locks(inode))
 			flags |= CHECK_FILELOCK;
 		_got = 0;
 		ret = try_get_cap_refs(inode, need, want, endoff,
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 048a435a29be..674d6ea89f71 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -32,18 +32,14 @@ void __init ceph_flock_init(void)
 
 static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 {
-	struct ceph_file_info *fi = dst->fl_file->private_data;
 	struct inode *inode = file_inode(dst->fl_file);
 	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
-	atomic_inc(&fi->num_locks);
 }
 
 static void ceph_fl_release_lock(struct file_lock *fl)
 {
-	struct ceph_file_info *fi = fl->fl_file->private_data;
 	struct inode *inode = file_inode(fl->fl_file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	atomic_dec(&fi->num_locks);
 	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
 		/* clear error when all locks are released */
 		spin_lock(&ci->i_ceph_lock);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 4db305fd2a02..8716cb618cbb 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -772,7 +772,6 @@ struct ceph_file_info {
 	struct list_head rw_contexts;
 
 	u32 filp_gen;
-	atomic_t num_locks;
 };
 
 struct ceph_dir_file_info {
-- 
2.35.1



