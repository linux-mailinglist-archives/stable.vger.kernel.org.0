Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A030F15C5B2
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgBMPYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387401AbgBMPYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:05 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F0B24690;
        Thu, 13 Feb 2020 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607444;
        bh=GWlmbiMV461p8XNCPKbPV1piO8V7/KlUIQoYLE7tbUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQ/xyLZdNvypx+ZZ5zTdh3fOVg2+Ut1nxpX3gzLahJOr9BQPwSQ5u9Kgm8nLWpwAC
         2il65/jGmmLjlinaiLQ3kYb7Bec1Ev0FPfQVLFi5OWaAqryvcgCZv/k0c0rDb0jJ8P
         AB7TmtW7xcPWTUCVKsNUUNlbcI4FpbfiTQ/+NZp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 077/116] NFS: Fix memory leaks and corruption in readdir
Date:   Thu, 13 Feb 2020 07:20:21 -0800
Message-Id: <20200213151912.623470526@linuxfoundation.org>
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

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 4b310319c6a8ce708f1033d57145e2aa027a883c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index a41df7d44bd7a..5936c54ac5fdb 100644
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
  * The caller is responsible for calling nfs_readdir_release_array(page)
  */
@@ -202,6 +213,7 @@ void nfs_readdir_clear_array(struct page *page)
 	array = kmap_atomic(page);
 	for (i = 0; i < array->size; i++)
 		kfree(array->array[i].string.name);
+	array->size = 0;
 	kunmap_atomic(array);
 }
 
@@ -643,6 +655,8 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 	int status = -ENOMEM;
 	unsigned int array_size = ARRAY_SIZE(pages);
 
+	nfs_readdir_init_array(page);
+
 	entry.prev_cookie = 0;
 	entry.cookie = desc->last_cookie;
 	entry.eof = 0;
@@ -663,8 +677,8 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 		status = PTR_ERR(array);
 		goto out_label_free;
 	}
-	memset(array, 0, sizeof(struct nfs_cache_array));
-	array->eof_index = -1;
+
+	array = kmap(page);
 
 	status = nfs_readdir_alloc_pages(pages, array_size);
 	if (status < 0)
@@ -719,6 +733,7 @@ int nfs_readdir_filler(nfs_readdir_descriptor_t *desc, struct page* page)
 	unlock_page(page);
 	return 0;
  error:
+	nfs_readdir_clear_array(page);
 	unlock_page(page);
 	return ret;
 }
-- 
2.20.1



