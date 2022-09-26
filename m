Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AE45EA3E0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiIZLfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238223AbiIZLe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:34:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FAD6E8A7;
        Mon, 26 Sep 2022 03:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5429C60B60;
        Mon, 26 Sep 2022 10:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1B4C433D6;
        Mon, 26 Sep 2022 10:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188902;
        bh=9WSwyR/5B55U+zFq6JuO1ZPxrcKHAm4xYzfZ9iqMYRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQPx4fpGwlYS6JI8mx2iewcgXE0m4llIgMTosAzjqSJURBNdSyVwTQDMFWjB5eeIo
         1XRNoYplnXppt50oOAt3T6bXdNpzdHC5eNQug0BR+LucExW4ohdCIxcprkzHrHbWVx
         qXBP7Eh2VqHWJx/GJYpLGqWs7lLSSzxvd3Cg6TfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 010/207] smb3: fix temporary data corruption in insert range
Date:   Mon, 26 Sep 2022 12:09:59 +0200
Message-Id: <20220926100806.953961741@linuxfoundation.org>
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

[ Upstream commit 9c8b7a293f50253e694f19161c045817a938e551 ]

insert range doesn't discard the affected cached region
so can risk temporarily corrupting file data.

Also includes some minor cleanup (avoiding rereading
inode size repeatedly unnecessarily) to make it clearer.

Cc: stable@vger.kernel.org
Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 8e55495c4f7e..774c6e5f6584 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4005,35 +4005,43 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	struct inode *inode = file_inode(file);
 	__le64 eof;
-	__u64  count;
+	__u64  count, old_eof;
 
 	xid = get_xid();
 
-	if (off >= i_size_read(inode)) {
+	inode_lock(inode);
+
+	old_eof = i_size_read(inode);
+	if (off >= old_eof) {
 		rc = -EINVAL;
 		goto out;
 	}
 
-	count = i_size_read(inode) - off;
-	eof = cpu_to_le64(i_size_read(inode) + len);
+	count = old_eof - off;
+	eof = cpu_to_le64(old_eof + len);
 
+	filemap_invalidate_lock(inode->i_mapping);
 	filemap_write_and_wait(inode->i_mapping);
+	truncate_pagecache_range(inode, off, old_eof);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, &eof);
 	if (rc < 0)
-		goto out;
+		goto out_2;
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off, count, off + len);
 	if (rc < 0)
-		goto out;
+		goto out_2;
 
-	rc = smb3_zero_range(file, tcon, off, len, 1);
+	rc = smb3_zero_data(file, tcon, off, len, xid);
 	if (rc < 0)
-		goto out;
+		goto out_2;
 
 	rc = 0;
+out_2:
+	filemap_invalidate_unlock(inode->i_mapping);
  out:
+	inode_unlock(inode);
 	free_xid(xid);
 	return rc;
 }
-- 
2.35.1



