Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CD3382FC0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbhEQOUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236996AbhEQOSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2715761360;
        Mon, 17 May 2021 14:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260618;
        bh=tk0iYPFDw5h/n0cZ+mlXZmyCzH8dxrX7cPlTfjNce7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYSmlsExGMM47A6aYm7NVcUigom4LzwzuIwkddHcHREiY3g9Qntpm/APK/N/Dgra1
         4WwGSqM/+bsxzGNG5alyRlIrUPljMWjXHTWAhsdU4+8z5XrxZ4AL98bACMuq8uHMnt
         sxAQgMh30pGW7xJ2UAKLIgM39zLtRYaF2KNBktAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 163/363] NFSv42: Copy offload should update the file size when appropriate
Date:   Mon, 17 May 2021 16:00:29 +0200
Message-Id: <20210517140308.114834232@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 94d202d5ca39d0eb757d16ef2624b013fb64f64d ]

If the result of a copy offload or clone operation is to grow the
destination file size, then we should update it. The reason is that when
a client holds a delegation, it is authoritative for the file size.

Fixes: 16abd2a0c124 ("NFSv4.2: fix client's attribute cache management for copy_file_range")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 8d64eb953347..3875120ef3ef 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -269,6 +269,33 @@ out:
 	return status;
 }
 
+/**
+ * nfs42_copy_dest_done - perform inode cache updates after clone/copy offload
+ * @inode: pointer to destination inode
+ * @pos: destination offset
+ * @len: copy length
+ *
+ * Punch a hole in the inode page cache, so that the NFS client will
+ * know to retrieve new data.
+ * Update the file size if necessary, and then mark the inode as having
+ * invalid cached values for change attribute, ctime, mtime and space used.
+ */
+static void nfs42_copy_dest_done(struct inode *inode, loff_t pos, loff_t len)
+{
+	loff_t newsize = pos + len;
+	loff_t end = newsize - 1;
+
+	truncate_pagecache_range(inode, pos, end);
+	spin_lock(&inode->i_lock);
+	if (newsize > i_size_read(inode))
+		i_size_write(inode, newsize);
+	nfs_set_cache_invalid(inode, NFS_INO_INVALID_CHANGE |
+					     NFS_INO_INVALID_CTIME |
+					     NFS_INO_INVALID_MTIME |
+					     NFS_INO_INVALID_BLOCKS);
+	spin_unlock(&inode->i_lock);
+}
+
 static ssize_t _nfs42_proc_copy(struct file *src,
 				struct nfs_lock_context *src_lock,
 				struct file *dst,
@@ -362,14 +389,8 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 			goto out;
 	}
 
-	truncate_pagecache_range(dst_inode, pos_dst,
-				 pos_dst + res->write_res.count);
-	spin_lock(&dst_inode->i_lock);
-	nfs_set_cache_invalid(
-		dst_inode, NFS_INO_REVAL_PAGECACHE | NFS_INO_REVAL_FORCED |
-				   NFS_INO_INVALID_SIZE | NFS_INO_INVALID_ATTR |
-				   NFS_INO_INVALID_DATA);
-	spin_unlock(&dst_inode->i_lock);
+	nfs42_copy_dest_done(dst_inode, pos_dst, res->write_res.count);
+
 	spin_lock(&src_inode->i_lock);
 	nfs_set_cache_invalid(src_inode, NFS_INO_REVAL_PAGECACHE |
 						 NFS_INO_REVAL_FORCED |
@@ -1055,8 +1076,10 @@ static int _nfs42_proc_clone(struct rpc_message *msg, struct file *src_f,
 
 	status = nfs4_call_sync(server->client, server, msg,
 				&args.seq_args, &res.seq_res, 0);
-	if (status == 0)
+	if (status == 0) {
+		nfs42_copy_dest_done(dst_inode, dst_offset, count);
 		status = nfs_post_op_update_inode(dst_inode, res.dst_fattr);
+	}
 
 	kfree(res.dst_fattr);
 	return status;
-- 
2.30.2



