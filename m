Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139B86BB079
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjCOMSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjCOMSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673A46A1D4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:18:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9440B81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6FFC433EF;
        Wed, 15 Mar 2023 12:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882688;
        bh=/7bd01ZmKSDFQlQVBukHXH839hkriH5jGuE/jk2JFzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZzEZGvhsOsN63dRU3DoENbiY8ZSeJN8xGGbgzAifTK4xCuNNcwh/IKCTyaeTnanP
         qRprHwZBsct8AtNoj3dBl0OaXwL/yJ+u8JAD0EniP8cZV067sLaoe3I5oQi4v7l4JX
         89/L0G/U94FzORw/SkD5VnH2Sjb037GPRBMomd7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/68] SMB3: Backup intent flag missing from some more ops
Date:   Wed, 15 Mar 2023 13:12:26 +0100
Message-Id: <20230315115727.352840046@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 0f060936e490c6279dfe773d75d526d3d3d77111 ]

When "backup intent" is requested on the mount (e.g. backupuid or
backupgid mount options), the corresponding flag was missing from
some of the operations.

Change all operations to use the macro cifs_create_options() to
set the backup intent flag if needed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: d447e794a372 ("cifs: Fix uninitialized memory read in smb3_qfs_tcon()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsacl.c   | 14 +++-----
 fs/cifs/cifsfs.c    |  2 +-
 fs/cifs/cifsglob.h  |  6 ++--
 fs/cifs/cifsproto.h |  8 +++++
 fs/cifs/connect.c   |  2 +-
 fs/cifs/dir.c       |  5 +--
 fs/cifs/file.c      | 10 ++----
 fs/cifs/inode.c     |  8 ++---
 fs/cifs/ioctl.c     |  2 +-
 fs/cifs/link.c      | 18 +++-------
 fs/cifs/smb1ops.c   | 19 +++++------
 fs/cifs/smb2inode.c |  9 ++---
 fs/cifs/smb2ops.c   | 81 +++++++++++++++------------------------------
 fs/cifs/smb2proto.h |  2 +-
 14 files changed, 68 insertions(+), 118 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 1f55072aa3023..1766d6d077f26 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1056,7 +1056,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 	struct cifs_ntsd *pntsd = NULL;
 	int oplock = 0;
 	unsigned int xid;
-	int rc, create_options = 0;
+	int rc;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
 	struct cifs_fid fid;
@@ -1068,13 +1068,10 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 	tcon = tlink_tcon(tlink);
 	xid = get_xid();
 
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
-
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = READ_CONTROL;
-	oparms.create_options = create_options;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.disposition = FILE_OPEN;
 	oparms.path = path;
 	oparms.fid = &fid;
@@ -1119,7 +1116,7 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 {
 	int oplock = 0;
 	unsigned int xid;
-	int rc, access_flags, create_options = 0;
+	int rc, access_flags;
 	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
@@ -1132,9 +1129,6 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 	tcon = tlink_tcon(tlink);
 	xid = get_xid();
 
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
-
 	if (aclflag == CIFS_ACL_OWNER || aclflag == CIFS_ACL_GROUP)
 		access_flags = WRITE_OWNER;
 	else
@@ -1143,7 +1137,7 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = access_flags;
-	oparms.create_options = create_options;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.disposition = FILE_OPEN;
 	oparms.path = path;
 	oparms.fid = &fid;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index aa7827da7b178..871a7b044c1b8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -275,7 +275,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_ffree = 0;	/* unlimited */
 
 	if (server->ops->queryfs)
-		rc = server->ops->queryfs(xid, tcon, buf);
+		rc = server->ops->queryfs(xid, tcon, cifs_sb, buf);
 
 	free_xid(xid);
 	return rc;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7c0eb110e2630..253321adc2664 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -300,7 +300,8 @@ struct smb_version_operations {
 			     const char *, struct dfs_info3_param **,
 			     unsigned int *, const struct nls_table *, int);
 	/* informational QFS call */
-	void (*qfs_tcon)(const unsigned int, struct cifs_tcon *);
+	void (*qfs_tcon)(const unsigned int, struct cifs_tcon *,
+			 struct cifs_sb_info *);
 	/* check if a path is accessible or not */
 	int (*is_path_accessible)(const unsigned int, struct cifs_tcon *,
 				  struct cifs_sb_info *, const char *);
@@ -408,7 +409,7 @@ struct smb_version_operations {
 			       struct cifsInodeInfo *);
 	/* query remote filesystem */
 	int (*queryfs)(const unsigned int, struct cifs_tcon *,
-		       struct kstatfs *);
+		       struct cifs_sb_info *, struct kstatfs *);
 	/* send mandatory brlock to the server */
 	int (*mand_lock)(const unsigned int, struct cifsFileInfo *, __u64,
 			 __u64, __u32, int, int, bool);
@@ -489,6 +490,7 @@ struct smb_version_operations {
 	/* ioctl passthrough for query_info */
 	int (*ioctl_query_info)(const unsigned int xid,
 				struct cifs_tcon *tcon,
+				struct cifs_sb_info *cifs_sb,
 				__le16 *path, int is_dir,
 				unsigned long p);
 	/* make unix special files (block, char, fifo, socket) */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 56a4740ae93ab..a5fab9afd699f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -600,4 +600,12 @@ static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
 }
 #endif
 
+static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
+{
+	if (backup_cred(cifs_sb))
+		return options | CREATE_OPEN_BACKUP_INTENT;
+	else
+		return options;
+}
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 25a2a98ebda8d..6c8dd7c0b83a2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4319,7 +4319,7 @@ static int mount_get_conns(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 
 	/* do not care if a following call succeed - informational */
 	if (!tcon->pipe && server->ops->qfs_tcon) {
-		server->ops->qfs_tcon(*xid, tcon);
+		server->ops->qfs_tcon(*xid, tcon, cifs_sb);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE) {
 			if (tcon->fsDevInfo.DeviceCharacteristics &
 			    cpu_to_le32(FILE_READ_ONLY_DEVICE))
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 9ae9a514676c3..548047a709bfc 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -357,13 +357,10 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
 		create_options |= CREATE_OPTION_READONLY;
 
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
-
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = desired_access;
-	oparms.create_options = create_options;
+	oparms.create_options = cifs_create_options(cifs_sb, create_options);
 	oparms.disposition = disposition;
 	oparms.path = full_path;
 	oparms.fid = fid;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index eb9b34442b1d3..86924831fd4ba 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -223,9 +223,6 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 	if (!buf)
 		return -ENOMEM;
 
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
-
 	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
 	if (f_flags & O_SYNC)
 		create_options |= CREATE_WRITE_THROUGH;
@@ -236,7 +233,7 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = desired_access;
-	oparms.create_options = create_options;
+	oparms.create_options = cifs_create_options(cifs_sb, create_options);
 	oparms.disposition = disposition;
 	oparms.path = full_path;
 	oparms.fid = fid;
@@ -751,9 +748,6 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 
 	desired_access = cifs_convert_flags(cfile->f_flags);
 
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
-
 	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
 	if (cfile->f_flags & O_SYNC)
 		create_options |= CREATE_WRITE_THROUGH;
@@ -767,7 +761,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = desired_access;
-	oparms.create_options = create_options;
+	oparms.create_options = cifs_create_options(cifs_sb, create_options);
 	oparms.disposition = disposition;
 	oparms.path = full_path;
 	oparms.fid = &cfile->fid;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index fd9e289f3e72a..af0980c720c78 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -472,9 +472,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_READ;
-	oparms.create_options = CREATE_NOT_DIR;
-	if (backup_cred(cifs_sb))
-		oparms.create_options |= CREATE_OPEN_BACKUP_INTENT;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
 	oparms.disposition = FILE_OPEN;
 	oparms.path = path;
 	oparms.fid = &fid;
@@ -1225,7 +1223,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = DELETE | FILE_WRITE_ATTRIBUTES;
-	oparms.create_options = CREATE_NOT_DIR;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
 	oparms.disposition = FILE_OPEN;
 	oparms.path = full_path;
 	oparms.fid = &fid;
@@ -1763,7 +1761,7 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 	oparms.cifs_sb = cifs_sb;
 	/* open the file to be renamed -- we need DELETE perms */
 	oparms.desired_access = DELETE;
-	oparms.create_options = CREATE_NOT_DIR;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
 	oparms.disposition = FILE_OPEN;
 	oparms.path = from_path;
 	oparms.fid = &fid;
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 9266dddd4b1eb..bc08d856ee05f 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -65,7 +65,7 @@ static long cifs_ioctl_query_info(unsigned int xid, struct file *filep,
 
 	if (tcon->ses->server->ops->ioctl_query_info)
 		rc = tcon->ses->server->ops->ioctl_query_info(
-				xid, tcon, utf16_path,
+				xid, tcon, cifs_sb, utf16_path,
 				filep->private_data ? 0 : 1, p);
 	else
 		rc = -EOPNOTSUPP;
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index b4b15d611deda..02949a2f28608 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -318,7 +318,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_READ;
-	oparms.create_options = CREATE_NOT_DIR;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
 	oparms.disposition = FILE_OPEN;
 	oparms.path = path;
 	oparms.fid = &fid;
@@ -356,15 +356,11 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms;
-	int create_options = CREATE_NOT_DIR;
-
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = create_options;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
 	oparms.disposition = FILE_CREATE;
 	oparms.path = path;
 	oparms.fid = &fid;
@@ -405,9 +401,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_READ;
-	oparms.create_options = CREATE_NOT_DIR;
-	if (backup_cred(cifs_sb))
-		oparms.create_options |= CREATE_OPEN_BACKUP_INTENT;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
 	oparms.disposition = FILE_OPEN;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
@@ -460,14 +454,10 @@ smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms;
-	int create_options = CREATE_NOT_DIR;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct kvec iov[2];
 
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
-
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, path);
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
@@ -477,7 +467,7 @@ smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = create_options;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
 	oparms.disposition = FILE_CREATE;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index e523c05a44876..b130efaf8feb2 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -504,7 +504,8 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 }
 
 static void
-cifs_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
+cifs_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
+	      struct cifs_sb_info *cifs_sb)
 {
 	CIFSSMBQFSDeviceInfo(xid, tcon);
 	CIFSSMBQFSAttributeInfo(xid, tcon);
@@ -565,7 +566,7 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		oparms.tcon = tcon;
 		oparms.cifs_sb = cifs_sb;
 		oparms.desired_access = FILE_READ_ATTRIBUTES;
-		oparms.create_options = 0;
+		oparms.create_options = cifs_create_options(cifs_sb, 0);
 		oparms.disposition = FILE_OPEN;
 		oparms.path = full_path;
 		oparms.fid = &fid;
@@ -793,7 +794,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = SYNCHRONIZE | FILE_WRITE_ATTRIBUTES;
-	oparms.create_options = CREATE_NOT_DIR;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
 	oparms.disposition = FILE_OPEN;
 	oparms.path = full_path;
 	oparms.fid = &fid;
@@ -872,7 +873,7 @@ cifs_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 
 static int
 cifs_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
-	     struct kstatfs *buf)
+	     struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
 {
 	int rc = -EOPNOTSUPP;
 
@@ -970,7 +971,8 @@ cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.create_options = OPEN_REPARSE_POINT;
+	oparms.create_options = cifs_create_options(cifs_sb,
+						    OPEN_REPARSE_POINT);
 	oparms.disposition = FILE_OPEN;
 	oparms.path = full_path;
 	oparms.fid = &fid;
@@ -1029,7 +1031,6 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct inode *newinode = NULL;
 	int rc = -EPERM;
-	int create_options = CREATE_NOT_DIR | CREATE_OPTION_SPECIAL;
 	FILE_ALL_INFO *buf = NULL;
 	struct cifs_io_parms io_parms;
 	__u32 oplock = 0;
@@ -1090,13 +1091,11 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 		goto out;
 	}
 
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
-
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = create_options;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
+						    CREATE_OPTION_SPECIAL);
 	oparms.disposition = FILE_CREATE;
 	oparms.path = full_path;
 	oparms.fid = &fid;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index f2a6f7f28340d..c9abda93d65b4 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -98,9 +98,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.desired_access = desired_access;
 	oparms.disposition = create_disposition;
-	oparms.create_options = create_options;
-	if (backup_cred(cifs_sb))
-		oparms.create_options |= CREATE_OPEN_BACKUP_INTENT;
+	oparms.create_options = cifs_create_options(cifs_sb, create_options);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 	oparms.mode = mode;
@@ -456,7 +454,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* If it is a root and its handle is cached then use it */
 	if (!strlen(full_path) && !no_cached_open) {
-		rc = open_shroot(xid, tcon, &fid);
+		rc = open_shroot(xid, tcon, cifs_sb, &fid);
 		if (rc)
 			goto out;
 
@@ -473,9 +471,6 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		goto out;
 	}
 
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
-
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN, create_options,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 944c575a4a705..a3bb2c7468c75 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -644,7 +644,8 @@ smb2_cached_lease_break(struct work_struct *work)
 /*
  * Open the directory at the root of a share
  */
-int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
+int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
+		struct cifs_sb_info *cifs_sb, struct cifs_fid *pfid)
 {
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server = ses->server;
@@ -696,7 +697,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms.tcon = tcon;
-	oparms.create_options = 0;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
 	oparms.disposition = FILE_OPEN;
 	oparms.fid = pfid;
@@ -812,7 +813,8 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 }
 
 static void
-smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
+smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
+	      struct cifs_sb_info *cifs_sb)
 {
 	int rc;
 	__le16 srch_path = 0; /* Null - open root of share */
@@ -824,7 +826,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
 	oparms.disposition = FILE_OPEN;
-	oparms.create_options = 0;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
@@ -832,7 +834,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 		rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 			       NULL);
 	else
-		rc = open_shroot(xid, tcon, &fid);
+		rc = open_shroot(xid, tcon, cifs_sb, &fid);
 
 	if (rc)
 		return;
@@ -854,7 +856,8 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 }
 
 static void
-smb2_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
+smb2_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
+	      struct cifs_sb_info *cifs_sb)
 {
 	int rc;
 	__le16 srch_path = 0; /* Null - open root of share */
@@ -865,7 +868,7 @@ smb2_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
 	oparms.disposition = FILE_OPEN;
-	oparms.create_options = 0;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
@@ -900,10 +903,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
 	oparms.disposition = FILE_OPEN;
-	if (backup_cred(cifs_sb))
-		oparms.create_options = CREATE_OPEN_BACKUP_INTENT;
-	else
-		oparms.create_options = 0;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
@@ -1179,10 +1179,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_WRITE_EA;
 	oparms.disposition = FILE_OPEN;
-	if (backup_cred(cifs_sb))
-		oparms.create_options = CREATE_OPEN_BACKUP_INTENT;
-	else
-		oparms.create_options = 0;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
@@ -1414,6 +1411,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 static int
 smb2_ioctl_query_info(const unsigned int xid,
 		      struct cifs_tcon *tcon,
+		      struct cifs_sb_info *cifs_sb,
 		      __le16 *path, int is_dir,
 		      unsigned long p)
 {
@@ -1439,6 +1437,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	struct kvec close_iov[1];
 	unsigned int size[2];
 	void *data[2];
+	int create_options = is_dir ? CREATE_NOT_FILE : CREATE_NOT_DIR;
 
 	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
@@ -1474,10 +1473,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	memset(&oparms, 0, sizeof(oparms));
 	oparms.tcon = tcon;
 	oparms.disposition = FILE_OPEN;
-	if (is_dir)
-		oparms.create_options = CREATE_NOT_FILE;
-	else
-		oparms.create_options = CREATE_NOT_DIR;
+	oparms.create_options = cifs_create_options(cifs_sb, create_options);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
@@ -2074,10 +2070,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
 	oparms.disposition = FILE_OPEN;
-	if (backup_cred(cifs_sb))
-		oparms.create_options = CREATE_OPEN_BACKUP_INTENT;
-	else
-		oparms.create_options = 0;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.fid = fid;
 	oparms.reconnect = false;
 
@@ -2278,10 +2271,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.desired_access = desired_access;
 	oparms.disposition = FILE_OPEN;
-	if (cifs_sb && backup_cred(cifs_sb))
-		oparms.create_options = CREATE_OPEN_BACKUP_INTENT;
-	else
-		oparms.create_options = 0;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
@@ -2337,7 +2327,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int
 smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
-	     struct kstatfs *buf)
+	     struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
 {
 	struct smb2_query_info_rsp *rsp;
 	struct smb2_fs_full_size_info *info = NULL;
@@ -2374,7 +2364,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int
 smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
-	     struct kstatfs *buf)
+	       struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
 {
 	int rc;
 	__le16 srch_path = 0; /* Null - open root of share */
@@ -2383,12 +2373,12 @@ smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 
 	if (!tcon->posix_extensions)
-		return smb2_queryfs(xid, tcon, buf);
+		return smb2_queryfs(xid, tcon, cifs_sb, buf);
 
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
 	oparms.disposition = FILE_OPEN;
-	oparms.create_options = 0;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
@@ -2657,6 +2647,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_create_rsp *create_rsp;
 	struct smb2_ioctl_rsp *ioctl_rsp;
 	struct reparse_data_buffer *reparse_buf;
+	int create_options = is_reparse_point ? OPEN_REPARSE_POINT : 0;
 	u32 plen;
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
@@ -2683,14 +2674,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
 	oparms.disposition = FILE_OPEN;
-
-	if (backup_cred(cifs_sb))
-		oparms.create_options = CREATE_OPEN_BACKUP_INTENT;
-	else
-		oparms.create_options = 0;
-	if (is_reparse_point)
-		oparms.create_options = OPEN_REPARSE_POINT;
-
+	oparms.create_options = cifs_create_options(cifs_sb, create_options);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
@@ -2869,11 +2853,6 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 	tcon = tlink_tcon(tlink);
 	xid = get_xid();
 
-	if (backup_cred(cifs_sb))
-		oparms.create_options = CREATE_OPEN_BACKUP_INTENT;
-	else
-		oparms.create_options = 0;
-
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path) {
 		rc = -ENOMEM;
@@ -2884,6 +2863,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 	oparms.tcon = tcon;
 	oparms.desired_access = READ_CONTROL;
 	oparms.disposition = FILE_OPEN;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
@@ -2925,11 +2905,6 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 	tcon = tlink_tcon(tlink);
 	xid = get_xid();
 
-	if (backup_cred(cifs_sb))
-		oparms.create_options = CREATE_OPEN_BACKUP_INTENT;
-	else
-		oparms.create_options = 0;
-
 	if (aclflag == CIFS_ACL_OWNER || aclflag == CIFS_ACL_GROUP)
 		access_flags = WRITE_OWNER;
 	else
@@ -2944,6 +2919,7 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 
 	oparms.tcon = tcon;
 	oparms.desired_access = access_flags;
+	oparms.create_options = cifs_create_options(cifs_sb, 0);
 	oparms.disposition = FILE_OPEN;
 	oparms.path = path;
 	oparms.fid = &fid;
@@ -4481,7 +4457,6 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	int rc = -EPERM;
-	int create_options = CREATE_NOT_DIR | CREATE_OPTION_SPECIAL;
 	FILE_ALL_INFO *buf = NULL;
 	struct cifs_io_parms io_parms;
 	__u32 oplock = 0;
@@ -4517,13 +4492,11 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 		goto out;
 	}
 
-	if (backup_cred(cifs_sb))
-		create_options |= CREATE_OPEN_BACKUP_INTENT;
-
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = create_options;
+	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
+						    CREATE_OPTION_SPECIAL);
 	oparms.disposition = FILE_CREATE;
 	oparms.path = full_path;
 	oparms.fid = &fid;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 57f7075a35871..4d4c0faa3d8a3 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -67,7 +67,7 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 				 struct mid_q_entry *mid);
 
 extern int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
-			struct cifs_fid *pfid);
+		       struct cifs_sb_info *cifs_sb, struct cifs_fid *pfid);
 extern void close_shroot(struct cached_fid *cfid);
 extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
 				   struct smb2_file_all_info *src);
-- 
2.39.2



