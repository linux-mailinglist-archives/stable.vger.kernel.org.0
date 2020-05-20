Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE181DB666
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgETOYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:24:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33216 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727083AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPc0-00036v-5j; Wed, 20 May 2020 15:22:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-007DWt-11; Wed, 20 May 2020 15:22:22 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Anna Schumaker" <Anna.Schumaker@Netapp.com>,
        "Trond Myklebust" <trond.myklebust@hammerspace.com>,
        "Trond Myklebust" <trondmy@gmail.com>,
        "Benjamin Coddington" <bcodding@redhat.com>
Date:   Wed, 20 May 2020 15:15:04 +0100
Message-ID: <lsq.1589984009.319006088@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 96/99] NFS: Directory page cache pages need to be
 locked when read
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

From: Trond Myklebust <trondmy@gmail.com>

commit 114de38225d9b300f027e2aec9afbb6e0def154b upstream.

When a NFS directory page cache page is removed from the page cache,
its contents are freed through a call to nfs_readdir_clear_array().
To prevent the removal of the page cache entry until after we've
finished reading it, we must take the page lock.

Fixes: 11de3b11e08c ("NFS: Fix a memory leak in nfs_readdir")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/dir.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -671,8 +671,6 @@ int nfs_readdir_filler(nfs_readdir_descr
 static
 void cache_page_release(nfs_readdir_descriptor_t *desc)
 {
-	if (!desc->page->mapping)
-		nfs_readdir_clear_array(desc->page);
 	page_cache_release(desc->page);
 	desc->page = NULL;
 }
@@ -686,19 +684,28 @@ struct page *get_cache_page(nfs_readdir_
 
 /*
  * Returns 0 if desc->dir_cookie was found on page desc->page_index
+ * and locks the page to prevent removal from the page cache.
  */
 static
-int find_cache_page(nfs_readdir_descriptor_t *desc)
+int find_and_lock_cache_page(nfs_readdir_descriptor_t *desc)
 {
 	int res;
 
 	desc->page = get_cache_page(desc);
 	if (IS_ERR(desc->page))
 		return PTR_ERR(desc->page);
-
-	res = nfs_readdir_search_array(desc);
+	res = lock_page_killable(desc->page);
 	if (res != 0)
-		cache_page_release(desc);
+		goto error;
+	res = -EAGAIN;
+	if (desc->page->mapping != NULL) {
+		res = nfs_readdir_search_array(desc);
+		if (res == 0)
+			return 0;
+	}
+	unlock_page(desc->page);
+error:
+	cache_page_release(desc);
 	return res;
 }
 
@@ -713,7 +720,7 @@ int readdir_search_pagecache(nfs_readdir
 		desc->last_cookie = 0;
 	}
 	do {
-		res = find_cache_page(desc);
+		res = find_and_lock_cache_page(desc);
 	} while (res == -EAGAIN);
 	return res;
 }
@@ -752,7 +759,6 @@ int nfs_do_filldir(nfs_readdir_descripto
 		desc->eof = 1;
 
 	kunmap(desc->page);
-	cache_page_release(desc);
 	dfprintk(DIRCACHE, "NFS: nfs_do_filldir() filling ended @ cookie %Lu; returning = %d\n",
 			(unsigned long long)*desc->dir_cookie, res);
 	return res;
@@ -798,13 +804,13 @@ int uncached_readdir(nfs_readdir_descrip
 
 	status = nfs_do_filldir(desc);
 
+ out_release:
+	nfs_readdir_clear_array(desc->page);
+	cache_page_release(desc);
  out:
 	dfprintk(DIRCACHE, "NFS: %s: returns %d\n",
 			__func__, status);
 	return status;
- out_release:
-	cache_page_release(desc);
-	goto out;
 }
 
 /* The file offset position represents the dirent entry number.  A
@@ -870,6 +876,8 @@ static int nfs_readdir(struct file *file
 			break;
 
 		res = nfs_do_filldir(desc);
+		unlock_page(desc->page);
+		cache_page_release(desc);
 		if (res < 0)
 			break;
 	} while (!desc->eof);

