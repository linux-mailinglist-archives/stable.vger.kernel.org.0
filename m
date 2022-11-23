Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACD4635684
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbiKWJbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbiKWJax (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:30:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598E06164
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:29:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA430619F9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C654C433C1;
        Wed, 23 Nov 2022 09:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195769;
        bh=tYBtVuLghGj1IVRNT9l+TDsCZwlgI9Vqa/6GY+KEVGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRG1iFpuGXpvli4l4aQ/lrb89J7ojxfad51N9qSgSoU7uMXdLnm02Hx+HSiZaibZh
         4nC6zb2ArP457OM4hQ9BcGa+v0Y9ewX/YQyaYgkbAkpmMwFtYSUANwnxscxkQtbxW1
         P9Daa6w1W0wJ4mlVK1iDyhVx2uFhUe9P0YzmsEL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Shi <shy828301@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Ajay Garg <ajaygargnsit@gmail.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>
Subject: [PATCH 5.15 003/181] mm: shmem: dont truncate page if memory failure happens
Date:   Wed, 23 Nov 2022 09:49:26 +0100
Message-Id: <20221123084602.818806597@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit a7605426666196c5a460dd3de6f8dac1d3c21f00 upstream.

The current behavior of memory failure is to truncate the page cache
regardless of dirty or clean.  If the page is dirty the later access
will get the obsolete data from disk without any notification to the
users.  This may cause silent data loss.  It is even worse for shmem
since shmem is in-memory filesystem, truncating page cache means
discarding data blocks.  The later read would return all zero.

The right approach is to keep the corrupted page in page cache, any
later access would return error for syscalls or SIGBUS for page fault,
until the file is truncated, hole punched or removed.  The regular
storage backed filesystems would be more complicated so this patch is
focused on shmem.  This also unblock the support for soft offlining
shmem THP.

[akpm@linux-foundation.org: coding style fixes]
[arnd@arndb.de: fix uninitialized variable use in me_pagecache_clean()]
  Link: https://lkml.kernel.org/r/20211022064748.4173718-1-arnd@kernel.org
[Fix invalid pointer dereference in shmem_read_mapping_page_gfp() with a
 slight different implementation from what Ajay Garg <ajaygargnsit@gmail.com>
 and Muchun Song <songmuchun@bytedance.com> proposed and reworked the
 error handling of shmem_write_begin() suggested by Linus]
  Link: https://lore.kernel.org/linux-mm/20211111084617.6746-1-ajaygargnsit@gmail.com/

Link: https://lkml.kernel.org/r/20211020210755.23964-6-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20211116193247.21102-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ajay Garg <ajaygargnsit@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Andy Lavr <andy.lavr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |   14 +++++++++++---
 mm/shmem.c          |   51 +++++++++++++++++++++++++++++++++++++++++++++------
 mm/userfaultfd.c    |    5 +++++
 3 files changed, 61 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -57,6 +57,7 @@
 #include <linux/ratelimit.h>
 #include <linux/page-isolation.h>
 #include <linux/pagewalk.h>
+#include <linux/shmem_fs.h>
 #include "internal.h"
 #include "ras/ras_event.h"
 
@@ -871,6 +872,7 @@ static int me_pagecache_clean(struct pag
 {
 	int ret;
 	struct address_space *mapping;
+	bool extra_pins;
 
 	delete_from_lru_cache(p);
 
@@ -900,17 +902,23 @@ static int me_pagecache_clean(struct pag
 	}
 
 	/*
+	 * The shmem page is kept in page cache instead of truncating
+	 * so is expected to have an extra refcount after error-handling.
+	 */
+	extra_pins = shmem_mapping(mapping);
+
+	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_page(p, page_to_pfn(p), mapping);
+	if (has_extra_refcount(ps, p, extra_pins))
+		ret = MF_FAILED;
+
 out:
 	unlock_page(p);
 
-	if (has_extra_refcount(ps, p, false))
-		ret = MF_FAILED;
-
 	return ret;
 }
 
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2463,6 +2463,7 @@ shmem_write_begin(struct file *file, str
 	struct inode *inode = mapping->host;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t index = pos >> PAGE_SHIFT;
+	int ret = 0;
 
 	/* i_rwsem is held by caller */
 	if (unlikely(info->seals & (F_SEAL_GROW |
@@ -2473,7 +2474,19 @@ shmem_write_begin(struct file *file, str
 			return -EPERM;
 	}
 
-	return shmem_getpage(inode, index, pagep, SGP_WRITE);
+	ret = shmem_getpage(inode, index, pagep, SGP_WRITE);
+
+	if (ret)
+		return ret;
+
+	if (PageHWPoison(*pagep)) {
+		unlock_page(*pagep);
+		put_page(*pagep);
+		*pagep = NULL;
+		return -EIO;
+	}
+
+	return 0;
 }
 
 static int
@@ -2560,6 +2573,12 @@ static ssize_t shmem_file_read_iter(stru
 			if (sgp == SGP_CACHE)
 				set_page_dirty(page);
 			unlock_page(page);
+
+			if (PageHWPoison(page)) {
+				put_page(page);
+				error = -EIO;
+				break;
+			}
 		}
 
 		/*
@@ -3121,7 +3140,8 @@ static const char *shmem_get_link(struct
 		page = find_get_page(inode->i_mapping, 0);
 		if (!page)
 			return ERR_PTR(-ECHILD);
-		if (!PageUptodate(page)) {
+		if (PageHWPoison(page) ||
+		    !PageUptodate(page)) {
 			put_page(page);
 			return ERR_PTR(-ECHILD);
 		}
@@ -3129,6 +3149,13 @@ static const char *shmem_get_link(struct
 		error = shmem_getpage(inode, 0, &page, SGP_READ);
 		if (error)
 			return ERR_PTR(error);
+		if (!page)
+			return ERR_PTR(-ECHILD);
+		if (PageHWPoison(page)) {
+			unlock_page(page);
+			put_page(page);
+			return ERR_PTR(-ECHILD);
+		}
 		unlock_page(page);
 	}
 	set_delayed_call(done, shmem_put_link, page);
@@ -3779,6 +3806,13 @@ static void shmem_destroy_inodecache(voi
 	kmem_cache_destroy(shmem_inode_cachep);
 }
 
+/* Keep the page in page cache instead of truncating it */
+static int shmem_error_remove_page(struct address_space *mapping,
+				   struct page *page)
+{
+	return 0;
+}
+
 const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
@@ -3789,7 +3823,7 @@ const struct address_space_operations sh
 #ifdef CONFIG_MIGRATION
 	.migratepage	= migrate_page,
 #endif
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_page = shmem_error_remove_page,
 };
 EXPORT_SYMBOL(shmem_aops);
 
@@ -4197,9 +4231,14 @@ struct page *shmem_read_mapping_page_gfp
 	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE,
 				  gfp, NULL, NULL, NULL);
 	if (error)
-		page = ERR_PTR(error);
-	else
-		unlock_page(page);
+		return ERR_PTR(error);
+
+	unlock_page(page);
+	if (PageHWPoison(page)) {
+		put_page(page);
+		return ERR_PTR(-EIO);
+	}
+
 	return page;
 #else
 	/*
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -238,6 +238,11 @@ static int mcontinue_atomic_pte(struct m
 		goto out;
 	}
 
+	if (PageHWPoison(page)) {
+		ret = -EIO;
+		goto out_release;
+	}
+
 	ret = mfill_atomic_install_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
 				       page, false, wp_copy);
 	if (ret)


