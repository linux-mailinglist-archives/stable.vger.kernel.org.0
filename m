Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAC25B6FC1
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiIMOPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbiIMOOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:14:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64F560520;
        Tue, 13 Sep 2022 07:10:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8D2D1CE126A;
        Tue, 13 Sep 2022 14:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6003DC43147;
        Tue, 13 Sep 2022 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078237;
        bh=fs1NE+R8dgmjtfsp91/WD1nsUfPU13sE7t+lAua2ids=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/GKKdMUhEOmUqvbg/mLDI30LS8Bs8IDpZ8Ja9kyjLgNyDXZhqJlIBKszuZ1PstVZ
         v59MyIw0gIGmcBMP9t0ANxKcuYiXshMHAAAJLl5c0QCBwZj+Ye+SkkG1N9tafOUeLa
         Wiu7YfHdgKP8p6fcWRD8XLr/OQXRbgBKKDwJYCNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 063/192] smb3: missing inode locks in zero range
Date:   Tue, 13 Sep 2022 16:02:49 +0200
Message-Id: <20220913140413.093111719@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit c919c164fc87bcca8e80b3b9224492fa5b6455ba ]

smb3 fallocate zero range was not grabbing the inode or filemap_invalidate
locks so could have race with pagemap reinstantiating the page.

Cc: stable@vger.kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 55 ++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 33357846a01b1..e8a8daa82ed76 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3590,26 +3590,43 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
 	return pntsd;
 }
 
+static long smb3_zero_data(struct file *file, struct cifs_tcon *tcon,
+			     loff_t offset, loff_t len, unsigned int xid)
+{
+	struct cifsFileInfo *cfile = file->private_data;
+	struct file_zero_data_information fsctl_buf;
+
+	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
+
+	fsctl_buf.FileOffset = cpu_to_le64(offset);
+	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
+
+	return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+			  cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
+			  (char *)&fsctl_buf,
+			  sizeof(struct file_zero_data_information),
+			  0, NULL, NULL);
+}
+
 static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len, bool keep_size)
 {
 	struct cifs_ses *ses = tcon->ses;
-	struct inode *inode;
-	struct cifsInodeInfo *cifsi;
+	struct inode *inode = file_inode(file);
+	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
-	struct file_zero_data_information fsctl_buf;
 	long rc;
 	unsigned int xid;
 	__le64 eof;
 
 	xid = get_xid();
 
-	inode = d_inode(cfile->dentry);
-	cifsi = CIFS_I(inode);
-
 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 
+	inode_lock(inode);
+	filemap_invalidate_lock(inode->i_mapping);
+
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
 	 * first, otherwise the data may be inconsistent with the server.
@@ -3617,26 +3634,12 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	truncate_pagecache_range(inode, offset, offset + len - 1);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
-	if (!CIFS_CACHE_READ(cifsi))
-		if (keep_size == false) {
-			rc = -EOPNOTSUPP;
-			trace_smb3_zero_err(xid, cfile->fid.persistent_fid,
-				tcon->tid, ses->Suid, offset, len, rc);
-			free_xid(xid);
-			return rc;
-		}
-
-	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
-
-	fsctl_buf.FileOffset = cpu_to_le64(offset);
-	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
+	rc = -EOPNOTSUPP;
+	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
+		goto zero_range_exit;
 
-	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
-			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
-			(char *)&fsctl_buf,
-			sizeof(struct file_zero_data_information),
-			0, NULL, NULL);
-	if (rc)
+	rc = smb3_zero_data(file, tcon, offset, len, xid);
+	if (rc < 0)
 		goto zero_range_exit;
 
 	/*
@@ -3649,6 +3652,8 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
  zero_range_exit:
+	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
-- 
2.35.1



