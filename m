Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422122E4031
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438017AbgL1OVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438007AbgL1OVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ED7220731;
        Mon, 28 Dec 2020 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165286;
        bh=KGRqtiI5xb2QCWAhkMOzJAqSPuxxarizS8R6E19JfFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDcp+HwAS7IJHQTOwuuC7Jm2Ln+if2OQdcYmrnwboVmLUsStHApKycLcj30E3aqFd
         jN/usJqcJ2B0crEEbQIdVURPIuG4qpEACtOjrJjEdPOlGdV6v3U75pE/uCQLj29bru
         1PLjco/h8U/aozRNBHEa7LPkQpu99jta2kBbpSWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Shuah Khan <shuah@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 448/717] mm/gup: combine put_compound_head() and unpin_user_page()
Date:   Mon, 28 Dec 2020 13:47:26 +0100
Message-Id: <20201228125042.438862914@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 4509b42c38963f495b49aa50209c34337286ecbe ]

These functions accomplish the same thing but have different
implementations.

unpin_user_page() has a bug where it calls mod_node_page_state() after
calling put_page() which creates a risk that the page could have been
hot-uplugged from the system.

Fix this by using put_compound_head() as the only implementation.

__unpin_devmap_managed_user_page() and related can be deleted as well in
favour of the simpler, but slower, version in put_compound_head() that has
an extra atomic page_ref_sub, but always calls put_page() which internally
contains the special devmap code.

Move put_compound_head() to be directly after try_grab_compound_head() so
people can find it in future.

Link: https://lkml.kernel.org/r/0-v1-6730d4ee0d32+40e6-gup_combine_put_jgg@nvidia.com
Fixes: 1970dc6f5226 ("mm/gup: /proc/vmstat: pin_user_pages (FOLL_PIN) reporting")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
CC: Joao Martins <joao.m.martins@oracle.com>
CC: Jonathan Corbet <corbet@lwn.net>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jane Chu <jane.chu@oracle.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Michal Hocko <mhocko@suse.com>
CC: Mike Kravetz <mike.kravetz@oracle.com>
CC: Shuah Khan <shuah@kernel.org>
CC: Muchun Song <songmuchun@bytedance.com>
CC: Vlastimil Babka <vbabka@suse.cz>
CC: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 103 +++++++++++++------------------------------------------
 1 file changed, 23 insertions(+), 80 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 9c6a2f5001c5c..054ff923d3d92 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -123,6 +123,28 @@ static __maybe_unused struct page *try_grab_compound_head(struct page *page,
 	return NULL;
 }
 
+static void put_compound_head(struct page *page, int refs, unsigned int flags)
+{
+	if (flags & FOLL_PIN) {
+		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED,
+				    refs);
+
+		if (hpage_pincount_available(page))
+			hpage_pincount_sub(page, refs);
+		else
+			refs *= GUP_PIN_COUNTING_BIAS;
+	}
+
+	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
+	/*
+	 * Calling put_page() for each ref is unnecessarily slow. Only the last
+	 * ref needs a put_page().
+	 */
+	if (refs > 1)
+		page_ref_sub(page, refs - 1);
+	put_page(page);
+}
+
 /**
  * try_grab_page() - elevate a page's refcount by a flag-dependent amount
  *
@@ -177,41 +199,6 @@ bool __must_check try_grab_page(struct page *page, unsigned int flags)
 	return true;
 }
 
-#ifdef CONFIG_DEV_PAGEMAP_OPS
-static bool __unpin_devmap_managed_user_page(struct page *page)
-{
-	int count, refs = 1;
-
-	if (!page_is_devmap_managed(page))
-		return false;
-
-	if (hpage_pincount_available(page))
-		hpage_pincount_sub(page, 1);
-	else
-		refs = GUP_PIN_COUNTING_BIAS;
-
-	count = page_ref_sub_return(page, refs);
-
-	mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED, 1);
-	/*
-	 * devmap page refcounts are 1-based, rather than 0-based: if
-	 * refcount is 1, then the page is free and the refcount is
-	 * stable because nobody holds a reference on the page.
-	 */
-	if (count == 1)
-		free_devmap_managed_page(page);
-	else if (!count)
-		__put_page(page);
-
-	return true;
-}
-#else
-static bool __unpin_devmap_managed_user_page(struct page *page)
-{
-	return false;
-}
-#endif /* CONFIG_DEV_PAGEMAP_OPS */
-
 /**
  * unpin_user_page() - release a dma-pinned page
  * @page:            pointer to page to be released
@@ -223,28 +210,7 @@ static bool __unpin_devmap_managed_user_page(struct page *page)
  */
 void unpin_user_page(struct page *page)
 {
-	int refs = 1;
-
-	page = compound_head(page);
-
-	/*
-	 * For devmap managed pages we need to catch refcount transition from
-	 * GUP_PIN_COUNTING_BIAS to 1, when refcount reach one it means the
-	 * page is free and we need to inform the device driver through
-	 * callback. See include/linux/memremap.h and HMM for details.
-	 */
-	if (__unpin_devmap_managed_user_page(page))
-		return;
-
-	if (hpage_pincount_available(page))
-		hpage_pincount_sub(page, 1);
-	else
-		refs = GUP_PIN_COUNTING_BIAS;
-
-	if (page_ref_sub_and_test(page, refs))
-		__put_page(page);
-
-	mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED, 1);
+	put_compound_head(compound_head(page), 1, FOLL_PIN);
 }
 EXPORT_SYMBOL(unpin_user_page);
 
@@ -2062,29 +2028,6 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  * This code is based heavily on the PowerPC implementation by Nick Piggin.
  */
 #ifdef CONFIG_HAVE_FAST_GUP
-
-static void put_compound_head(struct page *page, int refs, unsigned int flags)
-{
-	if (flags & FOLL_PIN) {
-		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED,
-				    refs);
-
-		if (hpage_pincount_available(page))
-			hpage_pincount_sub(page, refs);
-		else
-			refs *= GUP_PIN_COUNTING_BIAS;
-	}
-
-	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
-	/*
-	 * Calling put_page() for each ref is unnecessarily slow. Only the last
-	 * ref needs a put_page().
-	 */
-	if (refs > 1)
-		page_ref_sub(page, refs - 1);
-	put_page(page);
-}
-
 #ifdef CONFIG_GUP_GET_PTE_LOW_HIGH
 
 /*
-- 
2.27.0



