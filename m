Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54523833C3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbhEQPB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242555AbhEQO7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3706561076;
        Mon, 17 May 2021 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261596;
        bh=EAJYEYU5VuRvy/fFHAdA7Z4lndIPPzrD4C8VIWd7y0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihpfb6yC3R4u76y3+xU100FbjaS1hX8wqFu2YRWCEEKSb2QW5E2tM+oT5rpkHCzJ7
         IynuA9OPxS3tKdFyKLIOeyvRVYzSunRwM2vt9oLiSe0jH3MVHwP6eSrYT5LjwYEd1W
         vis9fiNL7RlEvRserNVIrlUWq1IvF0SM0zFmh+dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 133/329] NFS: Fix handling of cookie verifier in uncached_readdir()
Date:   Mon, 17 May 2021 16:00:44 +0200
Message-Id: <20210517140306.614219788@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 13884ff2bef01df37c450c6dd09122f92333dccc ]

If we're doing uncached readdir(), then the readdir cookie could be
different from the one cached in the nfs_inode. We should therefore
ensure that we save that one in the struct nfs_open_dir_context.

Fixes: 35df59d3ef69 ("NFS: Reduce number of RPC calls when doing uncached readdir")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index c3618b6abfc0..ca1dddc81436 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -975,10 +975,10 @@ static int readdir_search_pagecache(struct nfs_readdir_descriptor *desc)
 /*
  * Once we've found the start of the dirent within a page: fill 'er up...
  */
-static void nfs_do_filldir(struct nfs_readdir_descriptor *desc)
+static void nfs_do_filldir(struct nfs_readdir_descriptor *desc,
+			   const __be32 *verf)
 {
 	struct file	*file = desc->file;
-	struct nfs_inode *nfsi = NFS_I(file_inode(file));
 	struct nfs_cache_array *array;
 	unsigned int i = 0;
 
@@ -992,7 +992,7 @@ static void nfs_do_filldir(struct nfs_readdir_descriptor *desc)
 			desc->eof = true;
 			break;
 		}
-		memcpy(desc->verf, nfsi->cookieverf, sizeof(desc->verf));
+		memcpy(desc->verf, verf, sizeof(desc->verf));
 		if (i < (array->size-1))
 			desc->dir_cookie = array->array[i+1].cookie;
 		else
@@ -1049,7 +1049,7 @@ static int uncached_readdir(struct nfs_readdir_descriptor *desc)
 
 	for (i = 0; !desc->eof && i < sz && arrays[i]; i++) {
 		desc->page = arrays[i];
-		nfs_do_filldir(desc);
+		nfs_do_filldir(desc, verf);
 	}
 	desc->page = NULL;
 
@@ -1070,6 +1070,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct dentry	*dentry = file_dentry(file);
 	struct inode	*inode = d_inode(dentry);
+	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_open_dir_context *dir_ctx = file->private_data;
 	struct nfs_readdir_descriptor *desc;
 	int res;
@@ -1123,7 +1124,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 			break;
 		}
 		if (res == -ETOOSMALL && desc->plus) {
-			clear_bit(NFS_INO_ADVISE_RDPLUS, &NFS_I(inode)->flags);
+			clear_bit(NFS_INO_ADVISE_RDPLUS, &nfsi->flags);
 			nfs_zap_caches(inode);
 			desc->page_index = 0;
 			desc->plus = false;
@@ -1133,7 +1134,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 		if (res < 0)
 			break;
 
-		nfs_do_filldir(desc);
+		nfs_do_filldir(desc, nfsi->cookieverf);
 		nfs_readdir_page_unlock_and_put_cached(desc);
 	} while (!desc->eof);
 
-- 
2.30.2



