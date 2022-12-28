Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1958657848
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbiL1OtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiL1Os7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:48:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5CD11C10;
        Wed, 28 Dec 2022 06:48:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A3B76154E;
        Wed, 28 Dec 2022 14:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666A9C433D2;
        Wed, 28 Dec 2022 14:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238929;
        bh=r63pfOKtcg8TmJGRRHlGIzPVcR5d2Lmkk4w3U1fdLFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkqI9LUgpKaWUFsYVbJPnXIga6XLh/U6sDB9HjBLFNiAdE0JUGauDnbPLfazKpH6U
         WrecYeoSGAmlxf/PIo+bU1a+E5l/s3pw1FvmwUymQ1yr22wwACc5bHH7OQUa7LVjK3
         BuRbdKa2IWH3BEAd2ccRcIdDmFbqDFBGFaFFIQnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-unionfs@vger.kernel.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/731] ovl: use ovl_copy_{real,upper}attr() wrappers
Date:   Wed, 28 Dec 2022 15:32:51 +0100
Message-Id: <20221228144258.407901169@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 2878dffc7db0b5a51e308ccb6b571296b57c82e7 ]

When copying inode attributes from the upper or lower layer to ovl inodes
we need to take the upper or lower layer's mount's idmapping into
account. In a lot of places we call ovl_copyattr() only on upper inodes and
in some we call it on either upper or lower inodes. Split this into two
separate helpers.

The first one should only be called on upper
inodes and is thus called ovl_copy_upperattr(). The second one can be
called on upper or lower inodes. We add ovl_copy_realattr() for this
task. The new helper makes use of the previously added ovl_i_path_real()
helper. This is needed to support idmapped base layers with overlay.

When overlay copies the inode information from an upper or lower layer
to the relevant overlay inode it will apply the idmapping of the upper
or lower layer when doing so. The ovl inode ownership will thus always
correctly reflect the ownership of the idmapped upper or lower layer.

All idmapping helpers are nops when no idmapped base layers are used.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: b306e90ffabd ("ovl: remove privs in ovl_copyfile()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/dir.c       | 10 ++++------
 fs/overlayfs/file.c      | 15 +++++++--------
 fs/overlayfs/inode.c     |  8 ++++----
 fs/overlayfs/overlayfs.h | 11 +----------
 fs/overlayfs/util.c      | 32 +++++++++++++++++++++++++++++++-
 5 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f18490813170..3fc86c51e260 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -880,7 +880,6 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 {
 	int err;
 	const struct cred *old_cred;
-	struct dentry *upperdentry;
 	bool lower_positive = ovl_lower_positive(dentry);
 	LIST_HEAD(list);
 
@@ -923,9 +922,8 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	 * Note: we fail to update ctime if there was no copy-up, only a
 	 * whiteout
 	 */
-	upperdentry = ovl_dentry_upper(dentry);
-	if (upperdentry)
-		ovl_copyattr(d_inode(upperdentry), d_inode(dentry));
+	if (ovl_dentry_upper(dentry))
+		ovl_copyattr(d_inode(dentry));
 
 out_drop_write:
 	ovl_drop_write(dentry);
@@ -1272,9 +1270,9 @@ static int ovl_rename(struct user_namespace *mnt_userns, struct inode *olddir,
 			 (d_inode(new) && ovl_type_origin(new)));
 
 	/* copy ctime: */
-	ovl_copyattr(d_inode(olddentry), d_inode(old));
+	ovl_copyattr(d_inode(old));
 	if (d_inode(new) && ovl_dentry_upper(new))
-		ovl_copyattr(d_inode(newdentry), d_inode(new));
+		ovl_copyattr(d_inode(new));
 
 out_dput:
 	dput(newdentry);
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 44fea16751f1..535da9eb4d8b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -273,7 +273,7 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 		__sb_writers_acquired(file_inode(iocb->ki_filp)->i_sb,
 				      SB_FREEZE_WRITE);
 		file_end_write(iocb->ki_filp);
-		ovl_copyattr(ovl_inode_real(inode), inode);
+		ovl_copyattr(inode);
 	}
 
 	orig_iocb->ki_pos = iocb->ki_pos;
@@ -356,7 +356,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	inode_lock(inode);
 	/* Update mode */
-	ovl_copyattr(ovl_inode_real(inode), inode);
+	ovl_copyattr(inode);
 	ret = file_remove_privs(file);
 	if (ret)
 		goto out_unlock;
@@ -381,7 +381,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 				     ovl_iocb_to_rwf(ifl));
 		file_end_write(real.file);
 		/* Update size */
-		ovl_copyattr(ovl_inode_real(inode), inode);
+		ovl_copyattr(inode);
 	} else {
 		struct ovl_aio_req *aio_req;
 
@@ -431,12 +431,11 @@ static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	struct fd real;
 	const struct cred *old_cred;
 	struct inode *inode = file_inode(out);
-	struct inode *realinode = ovl_inode_real(inode);
 	ssize_t ret;
 
 	inode_lock(inode);
 	/* Update mode */
-	ovl_copyattr(realinode, inode);
+	ovl_copyattr(inode);
 	ret = file_remove_privs(out);
 	if (ret)
 		goto out_unlock;
@@ -452,7 +451,7 @@ static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
 	file_end_write(real.file);
 	/* Update size */
-	ovl_copyattr(realinode, inode);
+	ovl_copyattr(inode);
 	revert_creds(old_cred);
 	fdput(real);
 
@@ -526,7 +525,7 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 	revert_creds(old_cred);
 
 	/* Update size */
-	ovl_copyattr(ovl_inode_real(inode), inode);
+	ovl_copyattr(inode);
 
 	fdput(real);
 
@@ -598,7 +597,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	revert_creds(old_cred);
 
 	/* Update size */
-	ovl_copyattr(ovl_inode_real(inode_out), inode_out);
+	ovl_copyattr(inode_out);
 
 	fdput(real_in);
 	fdput(real_out);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 06479bc88b7e..d41f0c8e0e2a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -80,7 +80,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		err = notify_change(&init_user_ns, upperdentry, attr, NULL);
 		revert_creds(old_cred);
 		if (!err)
-			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
+			ovl_copyattr(dentry->d_inode);
 		inode_unlock(upperdentry->d_inode);
 
 		if (winode)
@@ -377,7 +377,7 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 	revert_creds(old_cred);
 
 	/* copy c/mtime */
-	ovl_copyattr(d_inode(realdentry), inode);
+	ovl_copyattr(inode);
 
 out_drop_write:
 	ovl_drop_write(dentry);
@@ -579,7 +579,7 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 		inode_set_flags(inode, flags, OVL_COPY_I_FLAGS_MASK);
 
 		/* Update ctime */
-		ovl_copyattr(ovl_inode_real(inode), inode);
+		ovl_copyattr(inode);
 	}
 	ovl_drop_write(dentry);
 out:
@@ -789,7 +789,7 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 		oi->lowerdata = igrab(d_inode(oip->lowerdata));
 
 	realinode = ovl_inode_real(inode);
-	ovl_copyattr(realinode, inode);
+	ovl_copyattr(inode);
 	ovl_copyflags(realinode, inode);
 	ovl_map_ino(inode, ino, fsid);
 }
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 27f221962665..2df3e74cdf0f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -522,16 +522,7 @@ bool ovl_lookup_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_inode(struct super_block *sb,
 			    struct ovl_inode_params *oip);
-static inline void ovl_copyattr(struct inode *from, struct inode *to)
-{
-	to->i_uid = from->i_uid;
-	to->i_gid = from->i_gid;
-	to->i_mode = from->i_mode;
-	to->i_atime = from->i_atime;
-	to->i_mtime = from->i_mtime;
-	to->i_ctime = from->i_ctime;
-	i_size_write(to, i_size_read(from));
-}
+void ovl_copyattr(struct inode *to);
 
 /* vfs inode flags copied from real to ovl inode */
 #define OVL_COPY_I_FLAGS_MASK	(S_SYNC | S_NOATIME | S_APPEND | S_IMMUTABLE)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 2567918dc684..9d33ce385bef 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -456,7 +456,7 @@ static void ovl_dir_version_inc(struct dentry *dentry, bool impurity)
 void ovl_dir_modified(struct dentry *dentry, bool impurity)
 {
 	/* Copy mtime/ctime */
-	ovl_copyattr(d_inode(ovl_dentry_upper(dentry)), d_inode(dentry));
+	ovl_copyattr(d_inode(dentry));
 
 	ovl_dir_version_inc(dentry, impurity);
 }
@@ -1073,3 +1073,33 @@ int ovl_sync_status(struct ovl_fs *ofs)
 
 	return errseq_check(&mnt->mnt_sb->s_wb_err, ofs->errseq);
 }
+
+/*
+ * ovl_copyattr() - copy inode attributes from layer to ovl inode
+ *
+ * When overlay copies inode information from an upper or lower layer to the
+ * relevant overlay inode it will apply the idmapping of the upper or lower
+ * layer when doing so ensuring that the ovl inode ownership will correctly
+ * reflect the ownership of the idmapped upper or lower layer. For example, an
+ * idmapped upper or lower layer mapping id 1001 to id 1000 will take care to
+ * map any lower or upper inode owned by id 1001 to id 1000. These mapping
+ * helpers are nops when the relevant layer isn't idmapped.
+ */
+void ovl_copyattr(struct inode *inode)
+{
+	struct path realpath;
+	struct inode *realinode;
+	struct user_namespace *real_mnt_userns;
+
+	ovl_i_path_real(inode, &realpath);
+	realinode = d_inode(realpath.dentry);
+	real_mnt_userns = mnt_user_ns(realpath.mnt);
+
+	inode->i_uid = i_uid_into_mnt(real_mnt_userns, realinode);
+	inode->i_gid = i_gid_into_mnt(real_mnt_userns, realinode);
+	inode->i_mode = realinode->i_mode;
+	inode->i_atime = realinode->i_atime;
+	inode->i_mtime = realinode->i_mtime;
+	inode->i_ctime = realinode->i_ctime;
+	i_size_write(inode, i_size_read(realinode));
+}
-- 
2.35.1



