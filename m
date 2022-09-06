Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F79A5AE6A9
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiIFLd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiIFLdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:33:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B4E4C639
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D42261495
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEC0C433C1;
        Tue,  6 Sep 2022 11:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662464031;
        bh=PWGZ0oeUQZnWbZAaSFi0JfyPs7XVs4g59NpfixJbNR4=;
        h=Subject:To:Cc:From:Date:From;
        b=ACmwekb/GRsa+oFhhJqfAc23B40qK7T0dql5vnJMbjmK5FwIow1NdEt4liJa5zwO1
         ToYn//RwnCUZQ8YZAMwyvGk6rKBnEkQjUY6i1aEgKiG4wbI/KSN0EgSoTWPoEyveyL
         Gfqg/0wDo2ehS7C3KgSOODCJ/MW5Ghu184bZT9cQ=
Subject: FAILED: patch "[PATCH] smb3: use filemap_write_and_wait_range instead of" failed to apply to 5.19-stable tree
To:     stfrench@microsoft.com, dhowells@redhat.com, pc@cjr.nz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:33:40 +0200
Message-ID: <1662464020117131@kroah.com>
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

From 3e3761f1ec7df67d88cfca5e2ea98538f529e645 Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Mon, 29 Aug 2022 11:53:41 -0500
Subject: [PATCH] smb3: use filemap_write_and_wait_range instead of
 filemap_write_and_wait

When doing insert range and collapse range we should be
writing out the cached pages for the ranges affected but not
the whole file.

Fixes: c3a72bb21320 ("smb3: Move the flush out of smb2_copychunk_range() into its callers")
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e9fb338b8e7e..8042d7280dec 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1219,8 +1219,6 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 
 	cifs_dbg(FYI, "copychunk range\n");
 
-	filemap_write_and_wait(src_inode->i_mapping);
-
 	if (!src_file->private_data || !dst_file->private_data) {
 		rc = -EBADF;
 		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
@@ -1250,6 +1248,12 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	lock_two_nondirectories(target_inode, src_inode);
 
 	cifs_dbg(FYI, "about to flush pages\n");
+
+	rc = filemap_write_and_wait_range(src_inode->i_mapping, off,
+					  off + len - 1);
+	if (rc)
+		goto out;
+
 	/* should we flush first and last page first */
 	truncate_inode_pages(&target_inode->i_data, 0);
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7c941ce1e7a9..421be43af425 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3687,7 +3687,10 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
 	filemap_invalidate_lock(inode->i_mapping);
-	filemap_write_and_wait(inode->i_mapping);
+	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof - 1);
+	if (rc < 0)
+		goto out_2;
+
 	truncate_pagecache_range(inode, off, old_eof);
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
@@ -3738,7 +3741,9 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	eof = cpu_to_le64(old_eof + len);
 
 	filemap_invalidate_lock(inode->i_mapping);
-	filemap_write_and_wait(inode->i_mapping);
+	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof + len - 1);
+	if (rc < 0)
+		goto out_2;
 	truncate_pagecache_range(inode, off, old_eof);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,

