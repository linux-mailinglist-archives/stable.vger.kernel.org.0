Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F026AF18A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjCGSpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbjCGSpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:45:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EB2AD011
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:34:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1C7C6152C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0655C433EF;
        Tue,  7 Mar 2023 18:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214040;
        bh=uQBYmtah22M1smVU7PvVCvYpHdhx40ghsrx3W1twCJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oV5nC4tOrwPBr2BknSvyCjirZLqLirulGw/7UK9m4plaVA0fjYxBvpD+eoqkqi/Uh
         0AgERxn9MI2oKS2GBZfrQFW0bMMdw9A8UHyLdlypqKBZ3BoIp70czIIrq/gGK0IwqF
         DlHsSBPTKZ5J493OlGJLZe9Nmms0KovzDVg9UD2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Volker Lendecke <vl@samba.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 671/885] cifs: Fix uninitialized memory reads for oparms.mode
Date:   Tue,  7 Mar 2023 18:00:05 +0100
Message-Id: <20230307170031.309015814@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Volker Lendecke <vl@samba.org>

commit de036dcaca65cf94bf7ff09c571c077f02bc92b4 upstream.

Use a struct assignment with implicit member initialization

Signed-off-by: Volker Lendecke <vl@samba.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cached_dir.c |   13 +--
 fs/cifs/cifsacl.c    |   34 ++++-----
 fs/cifs/cifssmb.c    |   17 ++--
 fs/cifs/dir.c        |   19 ++---
 fs/cifs/file.c       |   35 +++++----
 fs/cifs/inode.c      |   53 +++++++-------
 fs/cifs/link.c       |   66 +++++++++--------
 fs/cifs/smb1ops.c    |   72 ++++++++++---------
 fs/cifs/smb2inode.c  |   17 ++--
 fs/cifs/smb2ops.c    |  191 ++++++++++++++++++++++++++-------------------------
 10 files changed, 274 insertions(+), 243 deletions(-)

--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -181,12 +181,13 @@ int open_cached_dir(unsigned int xid, st
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	oparms.tcon = tcon;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.fid = pfid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.fid = pfid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1423,14 +1423,15 @@ static struct cifs_ntsd *get_cifs_acl_by
 	tcon = tlink_tcon(tlink);
 	xid = get_xid();
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = READ_CONTROL;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = READ_CONTROL,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (!rc) {
@@ -1489,14 +1490,15 @@ int set_cifs_acl(struct cifs_ntsd *pnnts
 	else
 		access_flags = WRITE_DAC;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = access_flags;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = access_flags,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc) {
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5314,14 +5314,15 @@ CIFSSMBSetPathInfoFB(const unsigned int
 	struct cifs_fid fid;
 	int rc;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = fileName;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.disposition = FILE_OPEN,
+		.path = fileName,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc)
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -295,15 +295,16 @@ static int cifs_do_create(struct inode *
 	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
 		create_options |= CREATE_OPTION_READONLY;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = desired_access;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.disposition = disposition;
-	oparms.path = full_path;
-	oparms.fid = fid;
-	oparms.reconnect = false;
-	oparms.mode = mode;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = desired_access,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.disposition = disposition,
+		.path = full_path,
+		.fid = fid,
+		.mode = mode,
+	};
 	rc = server->ops->open(xid, &oparms, oplock, buf);
 	if (rc) {
 		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -260,14 +260,15 @@ static int cifs_nt_open(const char *full
 	if (f_flags & O_DIRECT)
 		create_options |= CREATE_NO_BUFFER;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = desired_access;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.disposition = disposition;
-	oparms.path = full_path;
-	oparms.fid = fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = desired_access,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.disposition = disposition,
+		.path = full_path,
+		.fid = fid,
+	};
 
 	rc = server->ops->open(xid, &oparms, oplock, buf);
 	if (rc)
@@ -848,14 +849,16 @@ cifs_reopen_file(struct cifsFileInfo *cf
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &cfile->fid);
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = desired_access;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.disposition = disposition;
-	oparms.path = full_path;
-	oparms.fid = &cfile->fid;
-	oparms.reconnect = true;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = desired_access,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.disposition = disposition,
+		.path = full_path,
+		.fid = &cfile->fid,
+		.reconnect = true,
+	};
 
 	/*
 	 * Can not refresh inode by passing in file_info buf to be returned by
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -508,14 +508,15 @@ cifs_sfu_type(struct cifs_fattr *fattr,
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_READ;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_READ,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;
@@ -1513,14 +1514,15 @@ cifs_rename_pending_delete(const char *f
 		goto out;
 	}
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = DELETE | FILE_WRITE_ATTRIBUTES;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = DELETE | FILE_WRITE_ATTRIBUTES,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc != 0)
@@ -2107,15 +2109,16 @@ cifs_do_rename(const unsigned int xid, s
 	if (to_dentry->d_parent != from_dentry->d_parent)
 		goto do_rename_exit;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	/* open the file to be renamed -- we need DELETE perms */
-	oparms.desired_access = DELETE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = from_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		/* open the file to be renamed -- we need DELETE perms */
+		.desired_access = DELETE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = from_path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc == 0) {
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -271,14 +271,15 @@ cifs_query_mf_symlink(unsigned int xid,
 	int buf_type = CIFS_NO_BUFFER;
 	FILE_ALL_INFO file_info;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_READ;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_READ,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, &file_info);
 	if (rc)
@@ -313,14 +314,15 @@ cifs_create_mf_symlink(unsigned int xid,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_CREATE;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_CREATE,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc)
@@ -355,13 +357,14 @@ smb3_query_mf_symlink(unsigned int xid,
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct smb2_file_all_info *pfile_info = NULL;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_READ;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_READ,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.fid = &fid,
+	};
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (utf16_path == NULL)
@@ -421,14 +424,15 @@ smb3_create_mf_symlink(unsigned int xid,
 	if (!utf16_path)
 		return -ENOMEM;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_CREATE;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
-	oparms.mode = 0644;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_CREATE,
+		.fid = &fid,
+		.mode = 0644,
+	};
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -576,14 +576,15 @@ static int cifs_query_path_info(const un
 		if (!(le32_to_cpu(fi.Attributes) & ATTR_REPARSE))
 			return 0;
 
-		oparms.tcon = tcon;
-		oparms.cifs_sb = cifs_sb;
-		oparms.desired_access = FILE_READ_ATTRIBUTES;
-		oparms.create_options = cifs_create_options(cifs_sb, 0);
-		oparms.disposition = FILE_OPEN;
-		oparms.path = full_path;
-		oparms.fid = &fid;
-		oparms.reconnect = false;
+		oparms = (struct cifs_open_parms) {
+			.tcon = tcon,
+			.cifs_sb = cifs_sb,
+			.desired_access = FILE_READ_ATTRIBUTES,
+			.create_options = cifs_create_options(cifs_sb, 0),
+			.disposition = FILE_OPEN,
+			.path = full_path,
+			.fid = &fid,
+		};
 
 		/* Need to check if this is a symbolic link or not */
 		tmprc = CIFS_open(xid, &oparms, &oplock, NULL);
@@ -823,14 +824,15 @@ smb_set_file_info(struct inode *inode, c
 		goto out;
 	}
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = SYNCHRONIZE | FILE_WRITE_ATTRIBUTES;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = SYNCHRONIZE | FILE_WRITE_ATTRIBUTES,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	cifs_dbg(FYI, "calling SetFileInfo since SetPathInfo for times not supported by this server\n");
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
@@ -998,15 +1000,16 @@ cifs_query_symlink(const unsigned int xi
 		goto out;
 	}
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.create_options = cifs_create_options(cifs_sb,
-						    OPEN_REPARSE_POINT);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.create_options = cifs_create_options(cifs_sb,
+						      OPEN_REPARSE_POINT),
+		.disposition = FILE_OPEN,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc)
@@ -1115,15 +1118,16 @@ cifs_make_node(unsigned int xid, struct
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
-						    CREATE_OPTION_SPECIAL);
-	oparms.disposition = FILE_CREATE;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
+						      CREATE_OPTION_SPECIAL),
+		.disposition = FILE_CREATE,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -104,14 +104,15 @@ static int smb2_compound_op(const unsign
 		goto finished;
 	}
 
-	vars->oparms.tcon = tcon;
-	vars->oparms.desired_access = desired_access;
-	vars->oparms.disposition = create_disposition;
-	vars->oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	vars->oparms.fid = &fid;
-	vars->oparms.reconnect = false;
-	vars->oparms.mode = mode;
-	vars->oparms.cifs_sb = cifs_sb;
+	vars->oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = desired_access,
+		.disposition = create_disposition,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.fid = &fid,
+		.mode = mode,
+		.cifs_sb = cifs_sb,
+	};
 
 	rqst[num_rqst].rq_iov = &vars->open_iov[0];
 	rqst[num_rqst].rq_nvec = SMB2_CREATE_IOV_SIZE;
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -772,12 +772,13 @@ smb2_qfs_tcon(const unsigned int xid, st
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 		       NULL, NULL);
@@ -817,12 +818,13 @@ smb2_is_path_accessible(const unsigned i
 	if (!utf16_path)
 		return -ENOMEM;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       &err_iov, &err_buftype);
@@ -1098,13 +1100,13 @@ smb2_set_ea(const unsigned int xid, stru
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_WRITE_EA;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_WRITE_EA,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -1454,12 +1456,12 @@ smb2_ioctl_query_info(const unsigned int
 	rqst[0].rq_iov = &vars->open_iov[0];
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon = tcon;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.fid = &fid,
+	};
 
 	if (qi.flags & PASSTHRU_FSCTL) {
 		switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
@@ -2089,12 +2091,13 @@ smb3_notify(const unsigned int xid, stru
 	}
 
 	tcon = cifs_sb_master_tcon(cifs_sb);
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
 		       NULL);
@@ -2160,12 +2163,13 @@ smb2_query_dir_first(const unsigned int
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -2491,12 +2495,13 @@ smb2_query_info_compound(const unsigned
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = desired_access;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = desired_access,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -2624,12 +2629,13 @@ smb311_queryfs(const unsigned int xid, s
 	if (!tcon->posix_extensions)
 		return smb2_queryfs(xid, tcon, cifs_sb, buf);
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 		       NULL, NULL);
@@ -2917,13 +2923,13 @@ smb2_query_symlink(const unsigned int xi
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -3057,13 +3063,13 @@ smb2_query_reparse_tag(const unsigned in
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, OPEN_REPARSE_POINT);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, OPEN_REPARSE_POINT),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -3197,17 +3203,20 @@ get_smb2_acl_by_path(struct cifs_sb_info
 		return ERR_PTR(rc);
 	}
 
-	oparms.tcon = tcon;
-	oparms.desired_access = READ_CONTROL;
-	oparms.disposition = FILE_OPEN;
-	/*
-	 * When querying an ACL, even if the file is a symlink we want to open
-	 * the source not the target, and so the protocol requires that the
-	 * client specify this flag when opening a reparse point
-	 */
-	oparms.create_options = cifs_create_options(cifs_sb, 0) | OPEN_REPARSE_POINT;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = READ_CONTROL,
+		.disposition = FILE_OPEN,
+		/*
+		 * When querying an ACL, even if the file is a symlink
+		 * we want to open the source not the target, and so
+		 * the protocol requires that the client specify this
+		 * flag when opening a reparse point
+		 */
+		.create_options = cifs_create_options(cifs_sb, 0) |
+				  OPEN_REPARSE_POINT,
+		.fid = &fid,
+	};
 
 	if (info & SACL_SECINFO)
 		oparms.desired_access |= SYSTEM_SECURITY;
@@ -3266,13 +3275,14 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, _
 		return rc;
 	}
 
-	oparms.tcon = tcon;
-	oparms.desired_access = access_flags;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = access_flags,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
@@ -5134,15 +5144,16 @@ smb2_make_node(unsigned int xid, struct
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
-						    CREATE_OPTION_SPECIAL);
-	oparms.disposition = FILE_CREATE;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
+						      CREATE_OPTION_SPECIAL),
+		.disposition = FILE_CREATE,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;


