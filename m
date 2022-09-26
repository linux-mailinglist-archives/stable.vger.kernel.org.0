Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF61A5EA411
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbiIZLjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238254AbiIZLin (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:38:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CF9DF53;
        Mon, 26 Sep 2022 03:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D28DF604F5;
        Mon, 26 Sep 2022 10:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24A7C433C1;
        Mon, 26 Sep 2022 10:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188983;
        bh=RPY5zWmkon6xdL9dtCBQBZz/2MPROkphoiQZMo9BrOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeYcUcJhh43DS02EyOmrDdV2ltIIaF9HpMKr+CatEu+JVD5PEZceNoNC19jn7NRSF
         LrbCAu6xjB1//jwf1Fk5YSWTQyYBQj22U/0rr+B/9oLKoEbu9tVO7uHIYWaRMOKpuP
         UtFp0dyEGay1N81e78+TIN18F73VkV9Ocsx4HsOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 008/207] smb3: Move the flush out of smb2_copychunk_range() into its callers
Date:   Mon, 26 Sep 2022 12:09:57 +0200
Message-Id: <20220926100806.856190602@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c3a72bb213209adfe981a4a92ea5746a778323e4 ]

Move the flush out of smb2_copychunk_range() into its callers.  This will
allow the pagecache to be invalidated between the flush and the operation
in smb3_collapse_range() and smb3_insert_range().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: fa30a81f255a ("smb3: fix temporary data corruption in collapse range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c  |  2 ++
 fs/cifs/smb2ops.c | 20 ++++++++------------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8f2e003e0590..2b51f0cbf4d2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1203,6 +1203,8 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 
 	cifs_dbg(FYI, "copychunk range\n");
 
+	filemap_write_and_wait(src_inode->i_mapping);
+
 	if (!src_file->private_data || !dst_file->private_data) {
 		rc = -EBADF;
 		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e8a8daa82ed7..ef8cb7fbabeb 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1886,17 +1886,8 @@ smb2_copychunk_range(const unsigned int xid,
 	int chunks_copied = 0;
 	bool chunk_sizes_updated = false;
 	ssize_t bytes_written, total_bytes_written = 0;
-	struct inode *inode;
 
 	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
-
-	/*
-	 * We need to flush all unwritten data before we can send the
-	 * copychunk ioctl to the server.
-	 */
-	inode = d_inode(trgtfile->dentry);
-	filemap_write_and_wait(inode->i_mapping);
-
 	if (pcchunk == NULL)
 		return -ENOMEM;
 
@@ -3977,6 +3968,8 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 	}
 
+	filemap_write_and_wait(inode->i_mapping);
+
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
 				  i_size_read(inode) - off - len, off);
 	if (rc < 0)
@@ -4004,18 +3997,21 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	int rc;
 	unsigned int xid;
 	struct cifsFileInfo *cfile = file->private_data;
+	struct inode *inode = file_inode(file);
 	__le64 eof;
 	__u64  count;
 
 	xid = get_xid();
 
-	if (off >= i_size_read(file->f_inode)) {
+	if (off >= i_size_read(inode)) {
 		rc = -EINVAL;
 		goto out;
 	}
 
-	count = i_size_read(file->f_inode) - off;
-	eof = cpu_to_le64(i_size_read(file->f_inode) + len);
+	count = i_size_read(inode) - off;
+	eof = cpu_to_le64(i_size_read(inode) + len);
+
+	filemap_write_and_wait(inode->i_mapping);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, &eof);
-- 
2.35.1



