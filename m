Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6340676FEA
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjAVP0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjAVP0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0B722A31
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:26:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3174BB80B1A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4EAC433D2;
        Sun, 22 Jan 2023 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401192;
        bh=CzZ5c+8wNhX09Nh3I/fGNS4V66detL5nl3Rg3TqYx+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8jhbUsqS68TDT7wasDv+cI7JTQW8bzZuo/Auo8F2gKxobZELGgv6SZ6EpdU0Wayf
         58LU7SLt9NZWFcnN9TD+Z4xchScXIbIhsSpalC3P6KS0zxxjVrOQGv9+qVHs7YR7RY
         +qfey035BFA8HZvayHhvHBRnuzk1Svfy5f1Fxxkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 146/193] cifs: reduce roundtrips on create/qinfo requests
Date:   Sun, 22 Jan 2023 16:04:35 +0100
Message-Id: <20230122150253.067388762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit c877ce47e1378dbafa6f1bf84c0c83a05ca8972a upstream.

To work around some Window servers that return
STATUS_OBJECT_NAME_INVALID on query infos under DFS namespaces that
contain non-ASCII characters, we started checking for -ENOENT on every
file open, and if so, then send additional requests to figure out
whether it is a DFS link or not.  It means that all those requests
will be sent to every non-existing file.

So, in order to reduce the number of roundtrips, check earlier whether
status code is STATUS_OBJECT_NAME_INVALID and tcon supports dfs, and
if so, then map -ENOENT to -EREMOTE so mount or automount will take
care of chasing the DFS link -- if it isn't an DFS link, then -ENOENT
will be returned appropriately.

Before patch

  SMB2 438 Create Request File: ada.test\dfs\foo;GetInfo Request...
  SMB2 310 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;...
  SMB2 228 Ioctl Request FSCTL_DFS_GET_REFERRALS, File: \ada.test\dfs\foo
  SMB2 143 Ioctl Response, Error: STATUS_OBJECT_PATH_NOT_FOUND
  SMB2 438 Create Request File: ada.test\dfs\foo;GetInfo Request...
  SMB2 310 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;...
  SMB2 228 Ioctl Request FSCTL_DFS_GET_REFERRALS, File: \ada.test\dfs\foo
  SMB2 143 Ioctl Response, Error: STATUS_OBJECT_PATH_NOT_FOUND

After patch

  SMB2 438 Create Request File: ada.test\dfs\foo;GetInfo Request...
  SMB2 310 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;...
  SMB2 438 Create Request File: ada.test\dfs\foo;GetInfo Request...
  SMB2 310 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;...

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c   |   16 ----------------
 fs/cifs/inode.c     |    6 ------
 fs/cifs/misc.c      |   45 ---------------------------------------------
 fs/cifs/smb2inode.c |   45 ++++++++++++++++++++++++++++++++-------------
 fs/cifs/smb2ops.c   |   28 ++++++++++++++++++++++++----
 5 files changed, 56 insertions(+), 84 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3554,9 +3554,6 @@ static int is_path_remote(struct mount_c
 	struct cifs_tcon *tcon = mnt_ctx->tcon;
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	char *full_path;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
-#endif
 
 	if (!server->ops->is_path_accessible)
 		return -EOPNOTSUPP;
@@ -3573,19 +3570,6 @@ static int is_path_remote(struct mount_c
 
 	rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
 					     full_path);
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	if (nodfs) {
-		if (rc == -EREMOTE)
-			rc = -EOPNOTSUPP;
-		goto out;
-	}
-
-	/* path *might* exist with non-ASCII characters in DFS root
-	 * try again with full path (only if nodfs is not set) */
-	if (rc == -ENOENT && is_tcon_dfs(tcon))
-		rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon, cifs_sb,
-							full_path);
-#endif
 	if (rc != 0 && rc != -EREMOTE)
 		goto out;
 
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -991,12 +991,6 @@ int cifs_get_inode_info(struct inode **i
 		}
 		rc = server->ops->query_path_info(xid, tcon, cifs_sb, full_path, &tmp_data,
 						  &adjust_tz, &is_reparse_point);
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		if (rc == -ENOENT && is_tcon_dfs(tcon))
-			rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon,
-								cifs_sb,
-								full_path);
-#endif
 		data = &tmp_data;
 	}
 
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1314,49 +1314,4 @@ int cifs_update_super_prepath(struct cif
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	return 0;
 }
-
-/** cifs_dfs_query_info_nonascii_quirk
- * Handle weird Windows SMB server behaviour. It responds with
- * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
- * for "\<server>\<dfsname>\<linkpath>" DFS reference,
- * where <dfsname> contains non-ASCII unicode symbols.
- *
- * Check such DFS reference.
- */
-int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
-				       struct cifs_tcon *tcon,
-				       struct cifs_sb_info *cifs_sb,
-				       const char *linkpath)
-{
-	char *treename, *dfspath, sep;
-	int treenamelen, linkpathlen, rc;
-
-	treename = tcon->tree_name;
-	/* MS-DFSC: All paths in REQ_GET_DFS_REFERRAL and RESP_GET_DFS_REFERRAL
-	 * messages MUST be encoded with exactly one leading backslash, not two
-	 * leading backslashes.
-	 */
-	sep = CIFS_DIR_SEP(cifs_sb);
-	if (treename[0] == sep && treename[1] == sep)
-		treename++;
-	linkpathlen = strlen(linkpath);
-	treenamelen = strnlen(treename, MAX_TREE_SIZE + 1);
-	dfspath = kzalloc(treenamelen + linkpathlen + 1, GFP_KERNEL);
-	if (!dfspath)
-		return -ENOMEM;
-	if (treenamelen)
-		memcpy(dfspath, treename, treenamelen);
-	memcpy(dfspath + treenamelen, linkpath, linkpathlen);
-	rc = dfs_cache_find(xid, tcon->ses, cifs_sb->local_nls,
-			    cifs_remap(cifs_sb), dfspath, NULL, NULL);
-	if (rc == 0) {
-		cifs_dbg(FYI, "DFS ref '%s' is found, emulate -EREMOTE\n",
-			 dfspath);
-		rc = -EREMOTE;
-	} else {
-		cifs_dbg(FYI, "%s: dfs_cache_find returned %d\n", __func__, rc);
-	}
-	kfree(dfspath);
-	return rc;
-}
 #endif
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -540,22 +540,41 @@ int smb2_query_path_info(const unsigned
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_QUERY_INFO, cfile,
 			      err_iov, err_buftype);
-	if (rc == -EOPNOTSUPP) {
-		if (err_iov[0].iov_base && err_buftype[0] != CIFS_NO_BUFFER &&
-		    ((struct smb2_hdr *)err_iov[0].iov_base)->Command == SMB2_CREATE &&
-		    ((struct smb2_hdr *)err_iov[0].iov_base)->Status == STATUS_STOPPED_ON_SYMLINK) {
-			rc = smb2_parse_symlink_response(cifs_sb, err_iov, &data->symlink_target);
+	if (rc) {
+		struct smb2_hdr *hdr = err_iov[0].iov_base;
+
+		if (unlikely(!hdr || err_buftype[0] == CIFS_NO_BUFFER))
+			goto out;
+		if (rc == -EOPNOTSUPP && hdr->Command == SMB2_CREATE &&
+		    hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
+			rc = smb2_parse_symlink_response(cifs_sb, err_iov,
+							 &data->symlink_target);
 			if (rc)
 				goto out;
-		}
-		*reparse = true;
-		create_options |= OPEN_REPARSE_POINT;
 
-		/* Failed on a symbolic link - query a reparse point info */
-		cifs_get_readable_path(tcon, full_path, &cfile);
-		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES,
-				      FILE_OPEN, create_options, ACL_NO_MODE, data,
-				      SMB2_OP_QUERY_INFO, cfile, NULL, NULL);
+			*reparse = true;
+			create_options |= OPEN_REPARSE_POINT;
+
+			/* Failed on a symbolic link - query a reparse point info */
+			cifs_get_readable_path(tcon, full_path, &cfile);
+			rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+					      FILE_READ_ATTRIBUTES, FILE_OPEN,
+					      create_options, ACL_NO_MODE, data,
+					      SMB2_OP_QUERY_INFO, cfile, NULL, NULL);
+			goto out;
+		} else if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
+			   hdr->Status == STATUS_OBJECT_NAME_INVALID) {
+			/*
+			 * Handle weird Windows SMB server behaviour. It responds with
+			 * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
+			 * for "\<server>\<dfsname>\<linkpath>" DFS reference,
+			 * where <dfsname> contains non-ASCII unicode symbols.
+			 */
+			rc = -EREMOTE;
+		}
+		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
+		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
+			rc = -EOPNOTSUPP;
 	}
 
 out:
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -797,7 +797,9 @@ smb2_is_path_accessible(const unsigned i
 	int rc;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	int err_buftype = CIFS_NO_BUFFER;
 	struct cifs_open_parms oparms;
+	struct kvec err_iov = {};
 	struct cifs_fid fid;
 	struct cached_fid *cfid;
 
@@ -821,14 +823,32 @@ smb2_is_path_accessible(const unsigned i
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
-		       NULL);
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
+		       &err_iov, &err_buftype);
 	if (rc) {
-		kfree(utf16_path);
-		return rc;
+		struct smb2_hdr *hdr = err_iov.iov_base;
+
+		if (unlikely(!hdr || err_buftype == CIFS_NO_BUFFER))
+			goto out;
+		/*
+		 * Handle weird Windows SMB server behaviour. It responds with
+		 * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
+		 * for "\<server>\<dfsname>\<linkpath>" DFS reference,
+		 * where <dfsname> contains non-ASCII unicode symbols.
+		 */
+		if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
+		    hdr->Status == STATUS_OBJECT_NAME_INVALID)
+			rc = -EREMOTE;
+		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
+		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
+			rc = -EOPNOTSUPP;
+		goto out;
 	}
 
 	rc = SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+
+out:
+	free_rsp_buf(err_buftype, err_iov.iov_base);
 	kfree(utf16_path);
 	return rc;
 }


