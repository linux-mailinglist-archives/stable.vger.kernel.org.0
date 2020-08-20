Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EDA24BB8A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbgHTJvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729788AbgHTJvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:51:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F16472078D;
        Thu, 20 Aug 2020 09:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917066;
        bh=7HHKGc3ZY9MsR7dZjfof1I8hHOlnpQN05gY57xtXUoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOcZPb0EJ5b/9U7ODZxFb0NWs8exh0oyzsgfRT5ka+zlNKYEko4hNjNL8SL3J5HHn
         0RCV8+eN25d0QRyVX6VbH+ZEQlOJb6kXul4lWQa/Ug1C3ITGLAgobSQovFwTAzXpxj
         WQPPUCoqk87Wwkz6H2s1vdFlvKkMSVPS/ILeUPcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/152] nfs: ensure correct writeback errors are returned on close()
Date:   Thu, 20 Aug 2020 11:21:22 +0200
Message-Id: <20200820091559.647346613@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 67dd23f9e6fbaf163431912ef5599c5e0693476c ]

nfs_wb_all() calls filemap_write_and_wait(), which uses
filemap_check_errors() to determine the error to return.
filemap_check_errors() only looks at the mapping->flags and will
therefore only return either -ENOSPC or -EIO.  To ensure that the
correct error is returned on close(), nfs{,4}_file_flush() should call
filemap_check_wb_err() which looks at the errseq value in
mapping->wb_err without consuming it.

Fixes: 6fbda89b257f ("NFS: Replace custom error reporting mechanism with
generic one")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c     | 5 ++++-
 fs/nfs/nfs4file.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 95dc90570786c..348f67c8f3224 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -140,6 +140,7 @@ static int
 nfs_file_flush(struct file *file, fl_owner_t id)
 {
 	struct inode	*inode = file_inode(file);
+	errseq_t since;
 
 	dprintk("NFS: flush(%pD2)\n", file);
 
@@ -148,7 +149,9 @@ nfs_file_flush(struct file *file, fl_owner_t id)
 		return 0;
 
 	/* Flush writes to the server and return any errors */
-	return nfs_wb_all(inode);
+	since = filemap_sample_wb_err(file->f_mapping);
+	nfs_wb_all(inode);
+	return filemap_check_wb_err(file->f_mapping, since);
 }
 
 ssize_t
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index fb55c04cdc6bd..534b6fd70ffdb 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -109,6 +109,7 @@ static int
 nfs4_file_flush(struct file *file, fl_owner_t id)
 {
 	struct inode	*inode = file_inode(file);
+	errseq_t since;
 
 	dprintk("NFS: flush(%pD2)\n", file);
 
@@ -124,7 +125,9 @@ nfs4_file_flush(struct file *file, fl_owner_t id)
 		return filemap_fdatawrite(file->f_mapping);
 
 	/* Flush writes to the server and return any errors */
-	return nfs_wb_all(inode);
+	since = filemap_sample_wb_err(file->f_mapping);
+	nfs_wb_all(inode);
+	return filemap_check_wb_err(file->f_mapping, since);
 }
 
 #ifdef CONFIG_NFS_V4_2
-- 
2.25.1



