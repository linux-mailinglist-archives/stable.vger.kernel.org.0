Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B698C2A513C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbgKCUif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729946AbgKCUie (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76BE322277;
        Tue,  3 Nov 2020 20:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435913;
        bh=wE0Iuk8i8IjIpdXPCXDazwgAk2UsB8khscJbYXWDHb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfBzFAKZMFcdsNlOnjDQxAJK8lsUBplLVh3V5vPy5MmWXPCIEIep9HSifXFLK6ViH
         +Srwa//x01Lji4b7mmIh4SEY2z628O+otWq8IFGeMOOI9HtyMemtfkumrmJs8ndsKQ
         bZXomAcqkcHrFEV5Sa4RJq2bm6quCWQ5ifSEtNjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 037/391] afs: Fix dirty-region encoding on ppc32 with 64K pages
Date:   Tue,  3 Nov 2020 21:31:28 +0100
Message-Id: <20201103203350.197422076@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2d9900f26ad61e63a34f239bc76c80d2f8a6ff41 ]

The dirty region bounds stored in page->private on an afs page are 15 bits
on a 32-bit box and can, at most, represent a range of up to 32K within a
32K page with a resolution of 1 byte.  This is a problem for powerpc32 with
64K pages enabled.

Further, transparent huge pages may get up to 2M, which will be a problem
for the afs filesystem on all 32-bit arches in the future.

Fix this by decreasing the resolution.  For the moment, a 64K page will
have a resolution determined from PAGE_SIZE.  In the future, the page will
need to be passed in to the helper functions so that the page size can be
assessed and the resolution determined dynamically.

Note that this might not be the ideal way to handle this, since it may
allow some leakage of undirtied zero bytes to the server's copy in the case
of a 3rd-party conflict.  Fixing that would require a separately allocated
record and is a more complicated fix.

Fixes: 4343d00872e1 ("afs: Get rid of the afs_writeback record")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h | 24 ++++++++++++++++++++----
 fs/afs/write.c    |  5 -----
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index dbe4120e9a422..17336cbb8419f 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -860,7 +860,8 @@ struct afs_vnode_cache_aux {
 /*
  * We use page->private to hold the amount of the page that we've written to,
  * splitting the field into two parts.  However, we need to represent a range
- * 0...PAGE_SIZE inclusive, so we can't support 64K pages on a 32-bit system.
+ * 0...PAGE_SIZE, so we reduce the resolution if the size of the page
+ * exceeds what we can encode.
  */
 #ifdef CONFIG_64BIT
 #define __AFS_PAGE_PRIV_MASK	0x7fffffffUL
@@ -872,19 +873,34 @@ struct afs_vnode_cache_aux {
 #define __AFS_PAGE_PRIV_MMAPPED	0x8000UL
 #endif
 
+static inline unsigned int afs_page_dirty_resolution(void)
+{
+	int shift = PAGE_SHIFT - (__AFS_PAGE_PRIV_SHIFT - 1);
+	return (shift > 0) ? shift : 0;
+}
+
 static inline size_t afs_page_dirty_from(unsigned long priv)
 {
-	return priv & __AFS_PAGE_PRIV_MASK;
+	unsigned long x = priv & __AFS_PAGE_PRIV_MASK;
+
+	/* The lower bound is inclusive */
+	return x << afs_page_dirty_resolution();
 }
 
 static inline size_t afs_page_dirty_to(unsigned long priv)
 {
-	return ((priv >> __AFS_PAGE_PRIV_SHIFT) & __AFS_PAGE_PRIV_MASK) + 1;
+	unsigned long x = (priv >> __AFS_PAGE_PRIV_SHIFT) & __AFS_PAGE_PRIV_MASK;
+
+	/* The upper bound is immediately beyond the region */
+	return (x + 1) << afs_page_dirty_resolution();
 }
 
 static inline unsigned long afs_page_dirty(size_t from, size_t to)
 {
-	return ((unsigned long)(to - 1) << __AFS_PAGE_PRIV_SHIFT) | from;
+	unsigned int res = afs_page_dirty_resolution();
+	from >>= res;
+	to = (to - 1) >> res;
+	return (to << __AFS_PAGE_PRIV_SHIFT) | from;
 }
 
 static inline unsigned long afs_page_dirty_mmapped(unsigned long priv)
diff --git a/fs/afs/write.c b/fs/afs/write.c
index a2511e3ad2cca..50371207f3273 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -90,11 +90,6 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
 	_enter("{%llx:%llu},{%lx},%u,%u",
 	       vnode->fid.vid, vnode->fid.vnode, index, from, to);
 
-	/* We want to store information about how much of a page is altered in
-	 * page->private.
-	 */
-	BUILD_BUG_ON(PAGE_SIZE - 1 > __AFS_PAGE_PRIV_MASK && sizeof(page->private) < 8);
-
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
-- 
2.27.0



