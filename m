Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11BF156A3A
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 13:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgBIM5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:57:42 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41493 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBIM5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:57:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 126B521AA4;
        Sun,  9 Feb 2020 07:57:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 07:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EdqpuK
        sVXHqIYFZiuYrJxwBfS4hwjHMU9ADwkAvZvLk=; b=tuyof6ORWg+ivLFXrexbw7
        Ay5AZe4urGoGc4bG6aB2sP9n+UYVJmKD2gm6TB+w0Q02lDUEKW8mOnFrSELvjyFy
        2EPTs/604PZFnXqgrDc6Rqja958bO6NVCrEhp1t7FrIqF4wC9he3pP1z5IAzHhyV
        /f2ivzQiXMQ1qEwmxpWN0hzV8WcNb1HKJKIuEN33wH98oOYEDx8E0PLX8xKr0r99
        Fc69DbjcgzeHxiR68j3gO7F5ZQZOYrcgWy8pz7oqZjqh7177jbzSB0uDE5L9k5Mn
        /VN8jYeLnYKeH8j05cjBw6TLciJnlVjZS6Xf5c/reFEiR0HpxMyM42k8On9VUSOA
        ==
X-ME-Sender: <xms:xAFAXiKb1fqV-3Ys_DDyPBjgKiMKaAFGMFgfe2QTDbIav3kDXBDAJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:xAFAXmBskCxJ1_VvV8pEVkh_HRIdBEkvSs7-UUUwN7gsiHnA5z-5nQ>
    <xmx:xAFAXvt_J7NvZ-C4pEj9dScVgQtZ95p3G2zffwnHKt6by6Dr5TwX1w>
    <xmx:xAFAXsRqYid_j1RBhCe8IAlWmpIp2Mf_Ow1twdX8AFUNGA8Mu5yGCw>
    <xmx:xQFAXhG2r-nK79zoCcX8J5oVBumKZrGAGh4AtR8L8ng2k6K00_ghMw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id C09D0328005D;
        Sun,  9 Feb 2020 07:57:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] NFS: Directory page cache pages need to be locked when read" failed to apply to 4.9-stable tree
To:     trondmy@gmail.com, Anna.Schumaker@Netapp.com, bcodding@redhat.com,
        trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:24:34 +0100
Message-ID: <1581247474219231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 114de38225d9b300f027e2aec9afbb6e0def154b Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trondmy@gmail.com>
Date: Sun, 2 Feb 2020 17:53:54 -0500
Subject: [PATCH] NFS: Directory page cache pages need to be locked when read

When a NFS directory page cache page is removed from the page cache,
its contents are freed through a call to nfs_readdir_clear_array().
To prevent the removal of the page cache entry until after we've
finished reading it, we must take the page lock.

Fixes: 11de3b11e08c ("NFS: Fix a memory leak in nfs_readdir")
Cc: stable@vger.kernel.org # v2.6.37+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 451c48cdb1c2..d95c2c94bd87 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -702,8 +702,6 @@ int nfs_readdir_filler(void *data, struct page* page)
 static
 void cache_page_release(nfs_readdir_descriptor_t *desc)
 {
-	if (!desc->page->mapping)
-		nfs_readdir_clear_array(desc->page);
 	put_page(desc->page);
 	desc->page = NULL;
 }
@@ -717,19 +715,28 @@ struct page *get_cache_page(nfs_readdir_descriptor_t *desc)
 
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
 
@@ -744,7 +751,7 @@ int readdir_search_pagecache(nfs_readdir_descriptor_t *desc)
 		desc->last_cookie = 0;
 	}
 	do {
-		res = find_cache_page(desc);
+		res = find_and_lock_cache_page(desc);
 	} while (res == -EAGAIN);
 	return res;
 }
@@ -783,7 +790,6 @@ int nfs_do_filldir(nfs_readdir_descriptor_t *desc)
 		desc->eof = true;
 
 	kunmap(desc->page);
-	cache_page_release(desc);
 	dfprintk(DIRCACHE, "NFS: nfs_do_filldir() filling ended @ cookie %Lu; returning = %d\n",
 			(unsigned long long)*desc->dir_cookie, res);
 	return res;
@@ -829,13 +835,13 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc)
 
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
@@ -900,6 +906,8 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 			break;
 
 		res = nfs_do_filldir(desc);
+		unlock_page(desc->page);
+		cache_page_release(desc);
 		if (res < 0)
 			break;
 	} while (!desc->eof);

