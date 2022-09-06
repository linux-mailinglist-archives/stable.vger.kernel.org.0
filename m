Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164275AE6A8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiIFLdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiIFLdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B5E4F645
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F2C26134E
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79880C433C1;
        Tue,  6 Sep 2022 11:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662464028;
        bh=Gmjv7hAdpdAKB+8axmMUyUYwBwGGLbjdOfqy/yEnhLM=;
        h=Subject:To:Cc:From:Date:From;
        b=egJqFm3BZrXbPQn2bz1HUoW6Bic+ciKn6J3XhSbsWGHBt8O4DLP0qVzoWw2YHGCME
         tyygGO+unUFZua8dlJyuBwPakEFK1JQnTss5xmxWraA96TUIFV/N18KnkwOa0GozsX
         jWZpEB29UwBVOXp5hvSXoiVB9XULtfw4UHJ0gqWo=
Subject: FAILED: patch "[PATCH] smb3: fix temporary data corruption in collapse range" failed to apply to 5.15-stable tree
To:     stfrench@microsoft.com, dhowells@redhat.com, lsahlber@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:33:35 +0200
Message-ID: <1662464015247184@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fa30a81f255a56cccd89552cd6ce7ea6e8d8acc4 Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Tue, 23 Aug 2022 14:07:41 +0100
Subject: [PATCH] smb3: fix temporary data corruption in collapse range

collapse range doesn't discard the affected cached region
so can risk temporarily corrupting the file data. This
fixes xfstest generic/031

I also decided to merge a minor cleanup to this into the same patch
(avoiding rereading inode size repeatedly unnecessarily) to make it
clearer.

Cc: stable@vger.kernel.org
Fixes: 5476b5dd82c8b ("cifs: add support for FALLOC_FL_COLLAPSE_RANGE")
Reported-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
cc: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 674cf187fb0f..5b5ddc1b4638 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3669,41 +3669,47 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 {
 	int rc;
 	unsigned int xid;
-	struct inode *inode;
+	struct inode *inode = file_inode(file);
 	struct cifsFileInfo *cfile = file->private_data;
-	struct cifsInodeInfo *cifsi;
+	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	__le64 eof;
+	loff_t old_eof;
 
 	xid = get_xid();
 
-	inode = d_inode(cfile->dentry);
-	cifsi = CIFS_I(inode);
+	inode_lock(inode);
 
-	if (off >= i_size_read(inode) ||
-	    off + len >= i_size_read(inode)) {
+	old_eof = i_size_read(inode);
+	if ((off >= old_eof) ||
+	    off + len >= old_eof) {
 		rc = -EINVAL;
 		goto out;
 	}
 
+	filemap_invalidate_lock(inode->i_mapping);
 	filemap_write_and_wait(inode->i_mapping);
+	truncate_pagecache_range(inode, off, old_eof);
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
-				  i_size_read(inode) - off - len, off);
+				  old_eof - off - len, off);
 	if (rc < 0)
-		goto out;
+		goto out_2;
 
-	eof = cpu_to_le64(i_size_read(inode) - len);
+	eof = cpu_to_le64(old_eof - len);
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, &eof);
 	if (rc < 0)
-		goto out;
+		goto out_2;
 
 	rc = 0;
 
 	cifsi->server_eof = i_size_read(inode) - len;
 	truncate_setsize(inode, cifsi->server_eof);
 	fscache_resize_cookie(cifs_inode_cookie(inode), cifsi->server_eof);
+out_2:
+	filemap_invalidate_unlock(inode->i_mapping);
  out:
+	inode_unlock(inode);
 	free_xid(xid);
 	return rc;
 }

