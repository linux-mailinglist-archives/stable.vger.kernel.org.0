Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDB31DB658
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgETOYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:24:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33178 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727063AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbz-00037c-Qy; Wed, 20 May 2020 15:22:23 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-007DWY-Q5; Wed, 20 May 2020 15:22:21 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Fabian Frederick" <fabf@skynet.be>,
        "Trond Myklebust" <trond.myklebust@primarydata.com>
Date:   Wed, 20 May 2020 15:15:02 +0100
Message-ID: <lsq.1589984009.804184108@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 94/99] nfs: use kmap/kunmap directly
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Frederick <fabf@skynet.be>

commit 0795bf8357c1887e2a95e6e4f5b89d0896a0d929 upstream.

This patch removes useless nfs_readdir_get_array() and
nfs_readdir_release_array() as suggested by Trond Myklebust

nfs_readdir() calls nfs_revalidate_mapping() before
readdir_search_pagecache() , nfs_do_filldir(), uncached_readdir()
so mapping should be correct.

While kmap() can't fail, all subsequent error checks were removed
as well as unused labels.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/dir.c | 67 ++++++++++------------------------------------------
 1 file changed, 12 insertions(+), 55 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -170,27 +170,6 @@ typedef struct {
 } nfs_readdir_descriptor_t;
 
 /*
- * The caller is responsible for calling nfs_readdir_release_array(page)
- */
-static
-struct nfs_cache_array *nfs_readdir_get_array(struct page *page)
-{
-	void *ptr;
-	if (page == NULL)
-		return ERR_PTR(-EIO);
-	ptr = kmap(page);
-	if (ptr == NULL)
-		return ERR_PTR(-ENOMEM);
-	return ptr;
-}
-
-static
-void nfs_readdir_release_array(struct page *page)
-{
-	kunmap(page);
-}
-
-/*
  * we are freeing strings created by nfs_add_to_readdir_array()
  */
 static
@@ -229,13 +208,10 @@ int nfs_readdir_make_qstr(struct qstr *s
 static
 int nfs_readdir_add_to_array(struct nfs_entry *entry, struct page *page)
 {
-	struct nfs_cache_array *array = nfs_readdir_get_array(page);
+	struct nfs_cache_array *array = kmap(page);
 	struct nfs_cache_array_entry *cache_entry;
 	int ret;
 
-	if (IS_ERR(array))
-		return PTR_ERR(array);
-
 	cache_entry = &array->array[array->size];
 
 	/* Check that this entry lies within the page bounds */
@@ -254,7 +230,7 @@ int nfs_readdir_add_to_array(struct nfs_
 	if (entry->eof != 0)
 		array->eof_index = array->size;
 out:
-	nfs_readdir_release_array(page);
+	kunmap(page);
 	return ret;
 }
 
@@ -343,11 +319,7 @@ int nfs_readdir_search_array(nfs_readdir
 	struct nfs_cache_array *array;
 	int status;
 
-	array = nfs_readdir_get_array(desc->page);
-	if (IS_ERR(array)) {
-		status = PTR_ERR(array);
-		goto out;
-	}
+	array = kmap(desc->page);
 
 	if (*desc->dir_cookie == 0)
 		status = nfs_readdir_search_for_pos(array, desc);
@@ -359,8 +331,7 @@ int nfs_readdir_search_array(nfs_readdir
 		desc->current_index += array->size;
 		desc->page_index++;
 	}
-	nfs_readdir_release_array(desc->page);
-out:
+	kunmap(desc->page);
 	return status;
 }
 
@@ -551,13 +522,10 @@ int nfs_readdir_page_filler(nfs_readdir_
 	} while (!entry->eof);
 
 	if (count == 0 || (status == -EBADCOOKIE && entry->eof != 0)) {
-		array = nfs_readdir_get_array(page);
-		if (!IS_ERR(array)) {
-			array->eof_index = array->size;
-			status = 0;
-			nfs_readdir_release_array(page);
-		} else
-			status = PTR_ERR(array);
+		array = kmap(page);
+		array->eof_index = array->size;
+		status = 0;
+		kunmap(page);
 	}
 
 	put_page(scratch);
@@ -627,11 +595,7 @@ int nfs_readdir_xdr_to_array(nfs_readdir
 		goto out;
 	}
 
-	array = nfs_readdir_get_array(page);
-	if (IS_ERR(array)) {
-		status = PTR_ERR(array);
-		goto out_label_free;
-	}
+	array = kmap(page);
 	memset(array, 0, sizeof(struct nfs_cache_array));
 	array->eof_index = -1;
 
@@ -655,8 +619,7 @@ int nfs_readdir_xdr_to_array(nfs_readdir
 
 	nfs_readdir_free_large_page(pages_ptr, pages, array_size);
 out_release_array:
-	nfs_readdir_release_array(page);
-out_label_free:
+	kunmap(page);
 	nfs4_label_free(entry.label);
 out:
 	nfs_free_fattr(entry.fattr);
@@ -754,12 +717,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 	struct nfs_cache_array *array = NULL;
 	struct nfs_open_dir_context *ctx = file->private_data;
 
-	array = nfs_readdir_get_array(desc->page);
-	if (IS_ERR(array)) {
-		res = PTR_ERR(array);
-		goto out;
-	}
-
+	array = kmap(desc->page);
 	for (i = desc->cache_entry_index; i < array->size; i++) {
 		struct nfs_cache_array_entry *ent;
 
@@ -780,8 +738,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 	if (array->eof_index >= 0)
 		desc->eof = 1;
 
-	nfs_readdir_release_array(desc->page);
-out:
+	kunmap(desc->page);
 	cache_page_release(desc);
 	dfprintk(DIRCACHE, "NFS: nfs_do_filldir() filling ended @ cookie %Lu; returning = %d\n",
 			(unsigned long long)*desc->dir_cookie, res);

