Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105A45EA3B4
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbiIZLbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiIZLap (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:30:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B2B6C105;
        Mon, 26 Sep 2022 03:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64800B80977;
        Mon, 26 Sep 2022 10:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1463C433D6;
        Mon, 26 Sep 2022 10:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188912;
        bh=avOiRSD0S5RoPyIj8d8waMaD+KxGfn527ZqGmOkuKVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YahPqy1ap8JP4yEjjzo9r0jnxuP0RU91/cCkPMRM8P3QkGgojKmkquu1Wl6CCmQMH
         7ThDNdsKsuQFXacKS5hcbB6/996W9PYYw3moAjdObEAGImZC9fl/m/RSVvPtGXDLAS
         HPUJduJ2vtXyrXzMhohz4Qc5y9t74SQU2wSbi3Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        David Howells <dhowells@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 013/207] smb3: use filemap_write_and_wait_range instead of filemap_write_and_wait
Date:   Mon, 26 Sep 2022 12:10:02 +0200
Message-Id: <20220926100807.074513699@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 3e3761f1ec7df67d88cfca5e2ea98538f529e645 ]

When doing insert range and collapse range we should be
writing out the cached pages for the ranges affected but not
the whole file.

Fixes: c3a72bb21320 ("smb3: Move the flush out of smb2_copychunk_range() into its callers")
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c  | 8 ++++++--
 fs/cifs/smb2ops.c | 9 +++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 2b51f0cbf4d2..97278c43f8dc 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1203,8 +1203,6 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 
 	cifs_dbg(FYI, "copychunk range\n");
 
-	filemap_write_and_wait(src_inode->i_mapping);
-
 	if (!src_file->private_data || !dst_file->private_data) {
 		rc = -EBADF;
 		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
@@ -1234,6 +1232,12 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
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
index 774c6e5f6584..cc180d37b8ce 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3970,7 +3970,10 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
 	filemap_invalidate_lock(inode->i_mapping);
-	filemap_write_and_wait(inode->i_mapping);
+	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof - 1);
+	if (rc < 0)
+		goto out_2;
+
 	truncate_pagecache_range(inode, off, old_eof);
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
@@ -4021,7 +4024,9 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	eof = cpu_to_le64(old_eof + len);
 
 	filemap_invalidate_lock(inode->i_mapping);
-	filemap_write_and_wait(inode->i_mapping);
+	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof + len - 1);
+	if (rc < 0)
+		goto out_2;
 	truncate_pagecache_range(inode, off, old_eof);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-- 
2.35.1



