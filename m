Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B31B5A43F8
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiH2Hly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiH2Hlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44364BD30
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B66261146
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133F0C433D6;
        Mon, 29 Aug 2022 07:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661758906;
        bh=pE2I6I70UelmhWeN/S88oxr0eC4y/joSKcALPbpGe3k=;
        h=Subject:To:Cc:From:Date:From;
        b=WYHGZtWtmHo8z2t1VTU1+jfIJ73B8eeeV0oChu/WK/j7apfexoiBPj5lEKcjxfUPn
         Yarpok0fTlGD+vn2NcgaOa3/vOuQMuE7sQCRwSotaKnb9dgixabJNSNC9xs83rNGwl
         ZfR9ZJ2tbw8rPgfC/c+VossdhWuHm2B03Hebpo18=
Subject: FAILED: patch "[PATCH] smb3: missing inode locks in zero range" failed to apply to 5.19-stable tree
To:     dhowells@redhat.com, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:41:31 +0200
Message-ID: <16617588911001@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c919c164fc87bcca8e80b3b9224492fa5b6455ba Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Tue, 23 Aug 2022 01:01:36 -0500
Subject: [PATCH] smb3: missing inode locks in zero range

smb3 fallocate zero range was not grabbing the inode or filemap_invalidate
locks so could have race with pagemap reinstantiating the page.

Cc: stable@vger.kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 96f3b0573606..a6fe54281fd3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3307,26 +3307,43 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
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
@@ -3334,26 +3351,12 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
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
@@ -3366,6 +3369,8 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
  zero_range_exit:
+	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	free_xid(xid);
 	if (rc)
 		trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,

