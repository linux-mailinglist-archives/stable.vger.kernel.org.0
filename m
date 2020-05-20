Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412101DB665
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgETOYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:24:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33226 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727097AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPc0-00037U-0h; Wed, 20 May 2020 15:22:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-007DWi-SJ; Wed, 20 May 2020 15:22:21 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Benjamin Coddington" <bcodding@redhat.com>,
        "Trond Myklebust" <trondmy@gmail.com>,
        "Trond Myklebust" <trond.myklebust@hammerspace.com>,
        "Anna Schumaker" <Anna.Schumaker@Netapp.com>
Date:   Wed, 20 May 2020 15:15:03 +0100
Message-ID: <lsq.1589984009.495233844@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 95/99] NFS: Fix memory leaks and corruption in readdir
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

commit 4b310319c6a8ce708f1033d57145e2aa027a883c upstream.

nfs_readdir_xdr_to_array() must not exit without having initialised
the array, so that the page cache deletion routines can safely
call nfs_readdir_clear_array().
Furthermore, we should ensure that if we exit nfs_readdir_filler()
with an error, we free up any page contents to prevent a leak
if we try to fill the page again.

Fixes: 11de3b11e08c ("NFS: Fix a memory leak in nfs_readdir")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/dir.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -169,6 +169,17 @@ typedef struct {
 	unsigned int	eof:1;
 } nfs_readdir_descriptor_t;
 
+static
+void nfs_readdir_init_array(struct page *page)
+{
+	struct nfs_cache_array *array;
+
+	array = kmap_atomic(page);
+	memset(array, 0, sizeof(struct nfs_cache_array));
+	array->eof_index = -1;
+	kunmap_atomic(array);
+}
+
 /*
  * we are freeing strings created by nfs_add_to_readdir_array()
  */
@@ -181,6 +192,7 @@ void nfs_readdir_clear_array(struct page
 	array = kmap_atomic(page);
 	for (i = 0; i < array->size; i++)
 		kfree(array->array[i].string.name);
+	array->size = 0;
 	kunmap_atomic(array);
 }
 
@@ -580,6 +592,8 @@ int nfs_readdir_xdr_to_array(nfs_readdir
 	int status = -ENOMEM;
 	unsigned int array_size = ARRAY_SIZE(pages);
 
+	nfs_readdir_init_array(page);
+
 	entry.prev_cookie = 0;
 	entry.cookie = desc->last_cookie;
 	entry.eof = 0;
@@ -596,8 +610,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir
 	}
 
 	array = kmap(page);
-	memset(array, 0, sizeof(struct nfs_cache_array));
-	array->eof_index = -1;
 
 	status = nfs_readdir_large_page(pages, array_size);
 	if (status < 0)
@@ -651,6 +663,7 @@ int nfs_readdir_filler(nfs_readdir_descr
 	unlock_page(page);
 	return 0;
  error:
+	nfs_readdir_clear_array(page);
 	unlock_page(page);
 	return ret;
 }

