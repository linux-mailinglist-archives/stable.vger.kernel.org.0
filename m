Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43402156A3B
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 13:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgBIM5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:57:51 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56595 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBIM5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:57:51 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A691321AA4;
        Sun,  9 Feb 2020 07:57:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 07:57:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mIwUpj
        G9VKSrexVopvPWjHy4Qzz9G77DbqTGOqaUvIw=; b=c6eBHuFuTR71snZt2r6ZkA
        ACpCR91Eq4dAdwCA2RkAOH5HD7NqOILMzdEikPx3XJ7N9rN3S66bHZTjxPERs2Y3
        uPtg/8QzbtpKtQu8BRCzvK1h1OSz+ijpTSnEVmMEcdkOeZ7O5GMZRVcfBwCjcsLZ
        gREQ1fivyInWx86bcmp6poI1IG0RWeDgwCakR3rKd+dsSkD+ufZnddCirP+6rvls
        ARgnocFNpp7HppkX/lbNI/790fYal8sCwuXVsx4SAHaA+JzVOkJeA6AAsI7TdCmJ
        Kj7tgPVqIeMXXZx/KTjHTs3srwa66g9HmFiCt7IHSS6/1GIom9u7qCd5F7AXBtKw
        ==
X-ME-Sender: <xms:zgFAXgD1xYjsmaWObOhB4-vM6P4CfxPj7rREMRsv4Rlsi-rR_hoaHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepfeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zgFAXjZlqlHn6Cl81wPorwN6BkqYRCfMhKW63Lw8WxXJY60fK2HvQA>
    <xmx:zgFAXnxHzPDLooZljU5iVoq84CqvRF2bmoGuze9eM4DyloRi3YYhfw>
    <xmx:zgFAXplS2fY_5mI07KGuZ6PNiiZZvUtci1G79jlwZt8PEoVuq2GNEw>
    <xmx:zgFAXmRQfg4NQLIxQlBERvd-IDtjMWIWj3wFSgQVg9ZwpP9hHUCX2A>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F0453060272;
        Sun,  9 Feb 2020 07:57:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] NFS: Directory page cache pages need to be locked when read" failed to apply to 4.4-stable tree
To:     trondmy@gmail.com, Anna.Schumaker@Netapp.com, bcodding@redhat.com,
        trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:24:35 +0100
Message-ID: <158124747522521@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

