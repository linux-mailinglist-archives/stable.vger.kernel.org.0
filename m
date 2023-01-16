Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A4966C4AA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjAPP53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjAPP5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E601E15543
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E0A961030
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D31DC433F0;
        Mon, 16 Jan 2023 15:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884607;
        bh=dkdohJDEl1IesWSAYNd0A29hwys0C34LS9RHYFPeMBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJgetxWJDUC6TvG9iMiUJezm+pYqq2gawj2qM/cL87/ixYfV+Vhbl37FvmlfHRR3u
         mzNIpzDhaRTYQSyncYhCjRmrsrmH/sSExQQHZiCETGTI0xvO/PxFjZYTjsjLHKDKGg
         X84IVcitpBMm+6sA+5v7IZPDuL43yUYvmqpExGnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 040/183] cifs: fix file info setting in cifs_open_file()
Date:   Mon, 16 Jan 2023 16:49:23 +0100
Message-Id: <20230116154805.077616563@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Paulo Alcantara <pc@cjr.nz>

commit ba5d4c1596cada37793d405dd18d695cd3508902 upstream.

In cifs_open_file(), @buf must hold a pointer to a cifs_open_info_data
structure which is passed by cifs_nt_open(), so assigning @buf
directly to @fi was obviously wrong.

Fix this by passing a valid FILE_ALL_INFO structure to SMBLegacyOpen()
and CIFS_open(), and then copy the set structure to the corresponding
cifs_open_info_data::fi field with move_cifs_info_to_smb2() helper.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216889
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb1ops.c | 54 ++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 5fe2c2f8ef41..4cb364454e13 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -719,17 +719,25 @@ cifs_mkdir_setinfo(struct inode *inode, const char *full_path,
 static int cifs_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32 *oplock,
 			  void *buf)
 {
-	FILE_ALL_INFO *fi = buf;
+	struct cifs_open_info_data *data = buf;
+	FILE_ALL_INFO fi = {};
+	int rc;
 
 	if (!(oparms->tcon->ses->capabilities & CAP_NT_SMBS))
-		return SMBLegacyOpen(xid, oparms->tcon, oparms->path,
-				     oparms->disposition,
-				     oparms->desired_access,
-				     oparms->create_options,
-				     &oparms->fid->netfid, oplock, fi,
-				     oparms->cifs_sb->local_nls,
-				     cifs_remap(oparms->cifs_sb));
-	return CIFS_open(xid, oparms, oplock, fi);
+		rc = SMBLegacyOpen(xid, oparms->tcon, oparms->path,
+				   oparms->disposition,
+				   oparms->desired_access,
+				   oparms->create_options,
+				   &oparms->fid->netfid, oplock, &fi,
+				   oparms->cifs_sb->local_nls,
+				   cifs_remap(oparms->cifs_sb));
+	else
+		rc = CIFS_open(xid, oparms, oplock, &fi);
+
+	if (!rc && data)
+		move_cifs_info_to_smb2(&data->fi, &fi);
+
+	return rc;
 }
 
 static void
@@ -1053,7 +1061,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct inode *newinode = NULL;
 	int rc = -EPERM;
-	FILE_ALL_INFO *buf = NULL;
+	struct cifs_open_info_data buf = {};
 	struct cifs_io_parms io_parms;
 	__u32 oplock = 0;
 	struct cifs_fid fid;
@@ -1085,14 +1093,14 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 					    cifs_sb->local_nls,
 					    cifs_remap(cifs_sb));
 		if (rc)
-			goto out;
+			return rc;
 
 		rc = cifs_get_inode_info_unix(&newinode, full_path,
 					      inode->i_sb, xid);
 
 		if (rc == 0)
 			d_instantiate(dentry, newinode);
-		goto out;
+		return rc;
 	}
 
 	/*
@@ -1100,19 +1108,13 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	 * support block and char device (no socket & fifo)
 	 */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		goto out;
+		return rc;
 
 	if (!S_ISCHR(mode) && !S_ISBLK(mode))
-		goto out;
+		return rc;
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
 
-	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-	if (buf == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	oparms.tcon = tcon;
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_WRITE;
@@ -1127,21 +1129,21 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 		oplock = REQ_OPLOCK;
 	else
 		oplock = 0;
-	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, buf);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, &buf);
 	if (rc)
-		goto out;
+		return rc;
 
 	/*
 	 * BB Do not bother to decode buf since no local inode yet to put
 	 * timestamps in, but we can reuse it safely.
 	 */
 
-	pdev = (struct win_dev *)buf;
+	pdev = (struct win_dev *)&buf.fi;
 	io_parms.pid = current->tgid;
 	io_parms.tcon = tcon;
 	io_parms.offset = 0;
 	io_parms.length = sizeof(struct win_dev);
-	iov[1].iov_base = buf;
+	iov[1].iov_base = &buf.fi;
 	iov[1].iov_len = sizeof(struct win_dev);
 	if (S_ISCHR(mode)) {
 		memcpy(pdev->type, "IntxCHR", 8);
@@ -1160,8 +1162,8 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	d_drop(dentry);
 
 	/* FIXME: add code here to set EAs */
-out:
-	kfree(buf);
+
+	cifs_free_open_info(&buf);
 	return rc;
 }
 
-- 
2.39.0



