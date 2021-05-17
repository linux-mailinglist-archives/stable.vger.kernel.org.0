Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9776D382FDA
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbhEQOV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239299AbhEQOT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:19:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F541613B5;
        Mon, 17 May 2021 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260657;
        bh=p4+9Y6gsQVpVcJTV/sSTUtPM58rj3sS9gNE/aZntvXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DV06ZnBmWlSktupXaZhiTRSf/BW+WfD6DfAFg6j6ySub2HCbdLqrm2IxOGEVqMs4V
         +BBZxe8KKSrg8mIbdR4uyjeXHZAVXmNht9mEP2wcRgOOehtfDTSArI0lwT+XLTAFL4
         js0g5PPcI2kKztCGMPlm92VAQLiKkRgx1TamBPdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 146/363] NFS: Fix handling of cookie verifier in uncached_readdir()
Date:   Mon, 17 May 2021 16:00:12 +0200
Message-Id: <20210517140307.554430717@linuxfoundation.org>
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
index 08a1e2e31d0b..2cf2a7d92faf 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -976,10 +976,10 @@ static int readdir_search_pagecache(struct nfs_readdir_descriptor *desc)
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
 
@@ -993,7 +993,7 @@ static void nfs_do_filldir(struct nfs_readdir_descriptor *desc)
 			desc->eof = true;
 			break;
 		}
-		memcpy(desc->verf, nfsi->cookieverf, sizeof(desc->verf));
+		memcpy(desc->verf, verf, sizeof(desc->verf));
 		if (i < (array->size-1))
 			desc->dir_cookie = array->array[i+1].cookie;
 		else
@@ -1050,7 +1050,7 @@ static int uncached_readdir(struct nfs_readdir_descriptor *desc)
 
 	for (i = 0; !desc->eof && i < sz && arrays[i]; i++) {
 		desc->page = arrays[i];
-		nfs_do_filldir(desc);
+		nfs_do_filldir(desc, verf);
 	}
 	desc->page = NULL;
 
@@ -1071,6 +1071,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct dentry	*dentry = file_dentry(file);
 	struct inode	*inode = d_inode(dentry);
+	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_open_dir_context *dir_ctx = file->private_data;
 	struct nfs_readdir_descriptor *desc;
 	int res;
@@ -1124,7 +1125,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 			break;
 		}
 		if (res == -ETOOSMALL && desc->plus) {
-			clear_bit(NFS_INO_ADVISE_RDPLUS, &NFS_I(inode)->flags);
+			clear_bit(NFS_INO_ADVISE_RDPLUS, &nfsi->flags);
 			nfs_zap_caches(inode);
 			desc->page_index = 0;
 			desc->plus = false;
@@ -1134,7 +1135,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 		if (res < 0)
 			break;
 
-		nfs_do_filldir(desc);
+		nfs_do_filldir(desc, nfsi->cookieverf);
 		nfs_readdir_page_unlock_and_put_cached(desc);
 	} while (!desc->eof);
 
-- 
2.30.2



