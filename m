Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B621579C9
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgBJNSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728973AbgBJMh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EEF320838;
        Mon, 10 Feb 2020 12:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338277;
        bh=1iLSJo26RCT4stMBqRTZAFylN/S4Au55QZXe5a9TujI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnUI5fU7WdM6p/akUsFfogV0JgFsBcNcrwQCUU0mLGDaLxH0xio58STTiB7mUbzs3
         nh59AAn+oi9uKYOWKiQsTWPCA/J+GluLZoeU1d/G28EUkoNCodUAjM89xaKxIXaSNG
         DT0GyFk6e5pwlLpQwrGxKiVvA8wfFPHKiIxIAkqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 165/309] NFS: Fix memory leaks and corruption in readdir
Date:   Mon, 10 Feb 2020 04:32:01 -0800
Message-Id: <20200210122422.120751373@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 4b310319c6a8ce708f1033d57145e2aa027a883c upstream.

nfs_readdir_xdr_to_array() must not exit without having initialised
the array, so that the page cache deletion routines can safely
call nfs_readdir_clear_array().
Furthermore, we should ensure that if we exit nfs_readdir_filler()
with an error, we free up any page contents to prevent a leak
if we try to fill the page again.

Fixes: 11de3b11e08c ("NFS: Fix a memory leak in nfs_readdir")
Cc: stable@vger.kernel.org # v2.6.37+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/dir.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -162,6 +162,17 @@ typedef struct {
 	bool eof;
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
@@ -174,6 +185,7 @@ void nfs_readdir_clear_array(struct page
 	array = kmap_atomic(page);
 	for (i = 0; i < array->size; i++)
 		kfree(array->array[i].string.name);
+	array->size = 0;
 	kunmap_atomic(array);
 }
 
@@ -610,6 +622,8 @@ int nfs_readdir_xdr_to_array(nfs_readdir
 	int status = -ENOMEM;
 	unsigned int array_size = ARRAY_SIZE(pages);
 
+	nfs_readdir_init_array(page);
+
 	entry.prev_cookie = 0;
 	entry.cookie = desc->last_cookie;
 	entry.eof = 0;
@@ -626,8 +640,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir
 	}
 
 	array = kmap(page);
-	memset(array, 0, sizeof(struct nfs_cache_array));
-	array->eof_index = -1;
 
 	status = nfs_readdir_alloc_pages(pages, array_size);
 	if (status < 0)
@@ -682,6 +694,7 @@ int nfs_readdir_filler(void *data, struc
 	unlock_page(page);
 	return 0;
  error:
+	nfs_readdir_clear_array(page);
 	unlock_page(page);
 	return ret;
 }


