Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0065D3C4BB9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241609AbhGLG7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:32804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239541AbhGLG6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 943B66102A;
        Mon, 12 Jul 2021 06:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072933;
        bh=uYegv75YXwXYGm3pbXDEJRlo5vmTRcR5qItmqKXASVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jiq+XTr/wUmQypLdc9VBLjckSvC02DR/PSMPqnWSmPvkJZ3dFyskcfACf2WZT70xy
         i/0tEvHmD8UmtjmVe8eR12zBZ0FKTeky6yfnOHQav5ra96g7kcSJLwqJalgBEr6XW0
         igvdGspndA2BG7kCwBmp2uWkpQ+QMwlXPQ7XOe6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 068/700] mm/gup: fix try_grab_compound_head() race with split_huge_page()
Date:   Mon, 12 Jul 2021 08:02:31 +0200
Message-Id: <20210712060934.314878937@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit c24d37322548a6ec3caec67100d28b9c1f89f60a upstream.

try_grab_compound_head() is used to grab a reference to a page from
get_user_pages_fast(), which is only protected against concurrent freeing
of page tables (via local_irq_save()), but not against concurrent TLB
flushes, freeing of data pages, or splitting of compound pages.

Because no reference is held to the page when try_grab_compound_head() is
called, the page may have been freed and reallocated by the time its
refcount has been elevated; therefore, once we're holding a stable
reference to the page, the caller re-checks whether the PTE still points
to the same page (with the same access rights).

The problem is that try_grab_compound_head() has to grab a reference on
the head page; but between the time we look up what the head page is and
the time we actually grab a reference on the head page, the compound page
may have been split up (either explicitly through split_huge_page() or by
freeing the compound page to the buddy allocator and then allocating its
individual order-0 pages).  If that happens, get_user_pages_fast() may end
up returning the right page but lifting the refcount on a now-unrelated
page, leading to use-after-free of pages.

To fix it: Re-check whether the pages still belong together after lifting
the refcount on the head page.  Move anything else that checks
compound_head(page) below the refcount increment.

This can't actually happen on bare-metal x86 (because there, disabling
IRQs locks out remote TLB flushes), but it can happen on virtualized x86
(e.g.  under KVM) and probably also on arm64.  The race window is pretty
narrow, and constantly allocating and shattering hugepages isn't exactly
fast; for now I've only managed to reproduce this in an x86 KVM guest with
an artificially widened timing window (by adding a loop that repeatedly
calls `inl(0x3f8 + 5)` in `try_get_compound_head()` to force VM exits, so
that PV TLB flushes are used instead of IPIs).

As requested on the list, also replace the existing VM_BUG_ON_PAGE() with
a warning and bailout.  Since the existing code only performed the BUG_ON
check on DEBUG_VM kernels, ensure that the new code also only performs the
check under that configuration - I don't want to mix two logically
separate changes together too much.  The macro VM_WARN_ON_ONCE_PAGE()
doesn't return a value on !DEBUG_VM, so wrap the whole check in an #ifdef
block.  An alternative would be to change the VM_WARN_ON_ONCE_PAGE()
definition for !DEBUG_VM such that it always returns false, but since that
would differ from the behavior of the normal WARN macros, it might be too
confusing for readers.

Link: https://lkml.kernel.org/r/20210615012014.1100672-1-jannh@google.com
Fixes: 7aef4172c795 ("mm: handle PTE-mapped tail pages in gerneric fast gup implementaiton")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/gup.c |   58 +++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 15 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -44,6 +44,23 @@ static void hpage_pincount_sub(struct pa
 	atomic_sub(refs, compound_pincount_ptr(page));
 }
 
+/* Equivalent to calling put_page() @refs times. */
+static void put_page_refs(struct page *page, int refs)
+{
+#ifdef CONFIG_DEBUG_VM
+	if (VM_WARN_ON_ONCE_PAGE(page_ref_count(page) < refs, page))
+		return;
+#endif
+
+	/*
+	 * Calling put_page() for each ref is unnecessarily slow. Only the last
+	 * ref needs a put_page().
+	 */
+	if (refs > 1)
+		page_ref_sub(page, refs - 1);
+	put_page(page);
+}
+
 /*
  * Return the compound head page with ref appropriately incremented,
  * or NULL if that failed.
@@ -56,6 +73,21 @@ static inline struct page *try_get_compo
 		return NULL;
 	if (unlikely(!page_cache_add_speculative(head, refs)))
 		return NULL;
+
+	/*
+	 * At this point we have a stable reference to the head page; but it
+	 * could be that between the compound_head() lookup and the refcount
+	 * increment, the compound page was split, in which case we'd end up
+	 * holding a reference on a page that has nothing to do with the page
+	 * we were given anymore.
+	 * So now that the head page is stable, recheck that the pages still
+	 * belong together.
+	 */
+	if (unlikely(compound_head(page) != head)) {
+		put_page_refs(head, refs);
+		return NULL;
+	}
+
 	return head;
 }
 
@@ -95,6 +127,14 @@ __maybe_unused struct page *try_grab_com
 			return NULL;
 
 		/*
+		 * CAUTION: Don't use compound_head() on the page before this
+		 * point, the result won't be stable.
+		 */
+		page = try_get_compound_head(page, refs);
+		if (!page)
+			return NULL;
+
+		/*
 		 * When pinning a compound page of order > 1 (which is what
 		 * hpage_pincount_available() checks for), use an exact count to
 		 * track it, via hpage_pincount_add/_sub().
@@ -102,15 +142,10 @@ __maybe_unused struct page *try_grab_com
 		 * However, be sure to *also* increment the normal page refcount
 		 * field at least once, so that the page really is pinned.
 		 */
-		if (!hpage_pincount_available(page))
-			refs *= GUP_PIN_COUNTING_BIAS;
-
-		page = try_get_compound_head(page, refs);
-		if (!page)
-			return NULL;
-
 		if (hpage_pincount_available(page))
 			hpage_pincount_add(page, refs);
+		else
+			page_ref_add(page, refs * (GUP_PIN_COUNTING_BIAS - 1));
 
 		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED,
 				    orig_refs);
@@ -134,14 +169,7 @@ static void put_compound_head(struct pag
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
 
-	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
-	/*
-	 * Calling put_page() for each ref is unnecessarily slow. Only the last
-	 * ref needs a put_page().
-	 */
-	if (refs > 1)
-		page_ref_sub(page, refs - 1);
-	put_page(page);
+	put_page_refs(page, refs);
 }
 
 /**


