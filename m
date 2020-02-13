Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D880215C6C1
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbgBMQDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387409AbgBMPYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:17 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BEAC24699;
        Thu, 13 Feb 2020 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607456;
        bh=kWwyWvUBhJhc5hQF30HJTDBbfzUBx12TZnbi1NDDsRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b48Xm5LCjSt8og1svc2dygZPuelFgoQs3w7QaO3RdHN6bT36J8/SrhvJSnJwAEMU+
         ENT7Pf38h+fza5Cjh6uCj9T0D3PZmsqBx55AkYAL5xQ8WdL4qNhLq8/JGAsJYE0yIa
         p436ySNmuDyZCAhrW6eo1DMkE45Z6tS84kEk/VhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 076/116] NFS: switch back to to ->iterate()
Date:   Thu, 13 Feb 2020 07:20:20 -0800
Message-Id: <20200213151912.263891370@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit b044f64513843e960f4b8d8e2e042abca1b7c029 ]

NFS has some optimizations for readdir to choose between using READDIR or
READDIRPLUS based on workload, and which NFS operation to use is determined
by subsequent interactions with lookup, d_revalidate, and getattr.

Concurrent use of nfs_readdir() via ->iterate_shared() can cause those
optimizations to repeatedly invalidate the pagecache used to store
directory entries during readdir(), which causes some very bad performance
for directories with many entries (more than about 10000).

There's a couple ways to fix this in NFS, but no fix would be as simple as
going back to ->iterate() to serialize nfs_readdir(), and neither fix I
tested performed as well as going back to ->iterate().

The first required taking the directory's i_lock for each entry, with the
result of terrible contention.

The second way adds another flag to the nfs_inode, and so keeps the
optimizations working for large directories.  The difference from using
->iterate() here is that much more memory is consumed for a given workload
without any performance gain.

The workings of nfs_readdir() are such that concurrent users are serialized
within read_cache_page() waiting to retrieve pages of entries from the
server.  By serializing this work in iterate_dir() instead, contention for
cache pages is reduced.  Waiting processes can have an uncontended pass at
the entirety of the directory's pagecache once previous processes have
completed filling it.

v2 - Keep the bits needed for parallel lookup

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 1e5321d1ed226..a41df7d44bd7a 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -57,7 +57,7 @@ static void nfs_readdir_clear_array(struct page*);
 const struct file_operations nfs_dir_operations = {
 	.llseek		= nfs_llseek_dir,
 	.read		= generic_read_dir,
-	.iterate_shared	= nfs_readdir,
+	.iterate	= nfs_readdir,
 	.open		= nfs_opendir,
 	.release	= nfs_closedir,
 	.fsync		= nfs_fsync_dir,
@@ -145,7 +145,6 @@ struct nfs_cache_array_entry {
 };
 
 struct nfs_cache_array {
-	atomic_t refcount;
 	int size;
 	int eof_index;
 	u64 last_cookie;
@@ -201,20 +200,11 @@ void nfs_readdir_clear_array(struct page *page)
 	int i;
 
 	array = kmap_atomic(page);
-	if (atomic_dec_and_test(&array->refcount))
-		for (i = 0; i < array->size; i++)
-			kfree(array->array[i].string.name);
+	for (i = 0; i < array->size; i++)
+		kfree(array->array[i].string.name);
 	kunmap_atomic(array);
 }
 
-static bool grab_page(struct page *page)
-{
-	struct nfs_cache_array *array = kmap_atomic(page);
-	bool res = atomic_inc_not_zero(&array->refcount);
-	kunmap_atomic(array);
-	return res;
-}
-
 /*
  * the caller is responsible for freeing qstr.name
  * when called by nfs_readdir_add_to_array, the strings will be freed in
@@ -674,7 +664,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 		goto out_label_free;
 	}
 	memset(array, 0, sizeof(struct nfs_cache_array));
-	atomic_set(&array->refcount, 1);
 	array->eof_index = -1;
 
 	status = nfs_readdir_alloc_pages(pages, array_size);
@@ -737,7 +726,8 @@ int nfs_readdir_filler(nfs_readdir_descriptor_t *desc, struct page* page)
 static
 void cache_page_release(nfs_readdir_descriptor_t *desc)
 {
-	nfs_readdir_clear_array(desc->page);
+	if (!desc->page->mapping)
+		nfs_readdir_clear_array(desc->page);
 	put_page(desc->page);
 	desc->page = NULL;
 }
@@ -745,16 +735,8 @@ void cache_page_release(nfs_readdir_descriptor_t *desc)
 static
 struct page *get_cache_page(nfs_readdir_descriptor_t *desc)
 {
-	struct page *page;
-
-	for (;;) {
-		page = read_cache_page(desc->file->f_mapping,
+	return read_cache_page(desc->file->f_mapping,
 			desc->page_index, (filler_t *)nfs_readdir_filler, desc);
-		if (IS_ERR(page) || grab_page(page))
-			break;
-		put_page(page);
-	}
-	return page;
 }
 
 /*
@@ -960,11 +942,13 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 
 static loff_t nfs_llseek_dir(struct file *filp, loff_t offset, int whence)
 {
+	struct inode *inode = file_inode(filp);
 	struct nfs_open_dir_context *dir_ctx = filp->private_data;
 
 	dfprintk(FILE, "NFS: llseek dir(%pD2, %lld, %d)\n",
 			filp, offset, whence);
 
+	inode_lock(inode);
 	switch (whence) {
 		case 1:
 			offset += filp->f_pos;
@@ -972,13 +956,16 @@ static loff_t nfs_llseek_dir(struct file *filp, loff_t offset, int whence)
 			if (offset >= 0)
 				break;
 		default:
-			return -EINVAL;
+			offset = -EINVAL;
+			goto out;
 	}
 	if (offset != filp->f_pos) {
 		filp->f_pos = offset;
 		dir_ctx->dir_cookie = 0;
 		dir_ctx->duped = 0;
 	}
+out:
+	inode_unlock(inode);
 	return offset;
 }
 
-- 
2.20.1



