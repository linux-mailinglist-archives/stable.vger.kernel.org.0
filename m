Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209723A7406
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 04:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFOCgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 22:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhFOCgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 22:36:17 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3198EC061767
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 19:34:13 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id d184so13218082wmd.0
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 19:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WsHTdi4affw30a5Ryh/aJhuuDaRiVeVGTWV2LSDYltw=;
        b=Y9CIDNA9+PJpGpqjDeFy9aBkGT862LX2E2ObThBSALgXaKEn/nHMaez4LtX2iTAl0n
         7vfVxEz2/dGG+bxckEcqh/vDoqj56Ff0OCobKCGQwLcwFwk5I2B+ELHs4TjegJYr/6wI
         TgjGhKz/wGlvDI4caan4ah4ojmVTf1Em2/rjX511J0L5CM0CrPyf2kDvyX4wCJmveHFX
         OwYXS1X3gbuzGLjcY4tSEqmSFOUWgpNpeH3R6jmtYclNd/koqpgWifYMuXMOSEfd5SZk
         mB4GlxkrmY7sAgLe9/zPgnFxU/zbvWNrDtKPaK3Qo6xDS2U/A108U7A951Tq6Jw63/ND
         o26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WsHTdi4affw30a5Ryh/aJhuuDaRiVeVGTWV2LSDYltw=;
        b=XZT1SHSBvxNHfD0VXBB6n0tl6R2Lbs5ZkTHLmdjcVxD4Mg2NzSQET/MrD2DYKjYkaE
         tT3I+v8Z4RCDSKl32Pbf08n9JBwzdwQn4NRyswARqw7SOb6CQepoZ0xb6mQiQ0XiN315
         EJQn39XeaAyOMIBWOaKwuicDs592DaRXaj2gnaGFiGbkXuNMZrgpi6NiqQpc8GGDCFH9
         9wQ3BbxJ+hIZT0sZzA2kbwGFZVeqvJgxNbvDVidF2evN7/V/v2JSyEvX4sffFegV9nvI
         pqfUnu4wi6l5uJrBiLwQlKuqP02dXqQUSLKgKapQ8LjDKstocT+pJM0Bo1Tv39l1JRcs
         ZE5Q==
X-Gm-Message-State: AOAM531Mmjue4YOXMFIXJUcVHF0lJIzyl6VWFPr37sFxgpCGUG4cH081
        PBTN//mGDXJSjF7bgUCfb3ITLwCqJib9IlJu
X-Google-Smtp-Source: ABdhPJzj4iNrUtz/l0s+9hDTS//Bgqg6MCpAhG4k1cPgYq+NZuCa+g15S24f7ZM66xqP+XDv7vQnpw==
X-Received: by 2002:a7b:c8c3:: with SMTP id f3mr2102189wml.178.1623720026934;
        Mon, 14 Jun 2021 18:20:26 -0700 (PDT)
Received: from localhost ([2a02:168:96c5:1:55ed:514f:6ad7:5bcc])
        by smtp.gmail.com with ESMTPSA id s5sm16363540wrn.38.2021.06.14.18.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 18:20:26 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH v2] mm/gup: fix try_grab_compound_head() race with split_huge_page()
Date:   Tue, 15 Jun 2021 03:20:14 +0200
Message-Id: <20210615012014.1100672-1-jannh@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

try_grab_compound_head() is used to grab a reference to a page from
get_user_pages_fast(), which is only protected against concurrent
freeing of page tables (via local_irq_save()), but not against
concurrent TLB flushes, freeing of data pages, or splitting of compound
pages.

Because no reference is held to the page when try_grab_compound_head()
is called, the page may have been freed and reallocated by the time its
refcount has been elevated; therefore, once we're holding a stable
reference to the page, the caller re-checks whether the PTE still points
to the same page (with the same access rights).

The problem is that try_grab_compound_head() has to grab a reference on
the head page; but between the time we look up what the head page is and
the time we actually grab a reference on the head page, the compound
page may have been split up (either explicitly through split_huge_page()
or by freeing the compound page to the buddy allocator and then
allocating its individual order-0 pages).
If that happens, get_user_pages_fast() may end up returning the right
page but lifting the refcount on a now-unrelated page, leading to
use-after-free of pages.

To fix it:
Re-check whether the pages still belong together after lifting the
refcount on the head page.
Move anything else that checks compound_head(page) below the refcount
increment.

This can't actually happen on bare-metal x86 (because there, disabling
IRQs locks out remote TLB flushes), but it can happen on virtualized x86
(e.g. under KVM) and probably also on arm64. The race window is pretty
narrow, and constantly allocating and shattering hugepages isn't exactly
fast; for now I've only managed to reproduce this in an x86 KVM guest with
an artificially widened timing window (by adding a loop that repeatedly
calls `inl(0x3f8 + 5)` in `try_get_compound_head()` to force VM exits,
so that PV TLB flushes are used instead of IPIs).

As requested on the list, also replace the existing VM_BUG_ON_PAGE()
with a warning and bailout. Since the existing code only performed the
BUG_ON check on DEBUG_VM kernels, ensure that the new code also only
performs the check under that configuration - I don't want to mix two
logically separate changes together too much.
The macro VM_WARN_ON_ONCE_PAGE() doesn't return a value on !DEBUG_VM,
so wrap the whole check in an #ifdef block.
An alternative would be to change the VM_WARN_ON_ONCE_PAGE() definition
for !DEBUG_VM such that it always returns false, but since that would
differ from the behavior of the normal WARN macros, it might be too
confusing for readers.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Fixes: 7aef4172c795 ("mm: handle PTE-mapped tail pages in gerneric fast gup=
 implementaiton")
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/gup.c | 58 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 3ded6a5f26b2..90262e448552 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -43,8 +43,25 @@ static void hpage_pincount_sub(struct page *page, int re=
fs)
=20
 	atomic_sub(refs, compound_pincount_ptr(page));
 }
=20
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
  */
@@ -55,8 +72,23 @@ static inline struct page *try_get_compound_head(struct =
page *page, int refs)
 	if (WARN_ON_ONCE(page_ref_count(head) < 0))
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
+	if (unlikely(compound_head(page) !=3D head)) {
+		put_page_refs(head, refs);
+		return NULL;
+	}
+
 	return head;
 }
=20
 /*
@@ -94,25 +126,28 @@ __maybe_unused struct page *try_grab_compound_head(str=
uct page *page,
 		if (unlikely((flags & FOLL_LONGTERM) &&
 			     !is_pinnable_page(page)))
 			return NULL;
=20
+		/*
+		 * CAUTION: Don't use compound_head() on the page before this
+		 * point, the result won't be stable.
+		 */
+		page =3D try_get_compound_head(page, refs);
+		if (!page)
+			return NULL;
+
 		/*
 		 * When pinning a compound page of order > 1 (which is what
 		 * hpage_pincount_available() checks for), use an exact count to
 		 * track it, via hpage_pincount_add/_sub().
 		 *
 		 * However, be sure to *also* increment the normal page refcount
 		 * field at least once, so that the page really is pinned.
 		 */
-		if (!hpage_pincount_available(page))
-			refs *=3D GUP_PIN_COUNTING_BIAS;
-
-		page =3D try_get_compound_head(page, refs);
-		if (!page)
-			return NULL;
-
 		if (hpage_pincount_available(page))
 			hpage_pincount_add(page, refs);
+		else
+			page_ref_add(page, refs * (GUP_PIN_COUNTING_BIAS - 1));
=20
 		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED,
 				    orig_refs);
=20
@@ -134,16 +169,9 @@ static void put_compound_head(struct page *page, int r=
efs, unsigned int flags)
 		else
 			refs *=3D GUP_PIN_COUNTING_BIAS;
 	}
=20
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
=20
 /**
  * try_grab_page() - elevate a page's refcount by a flag-dependent amount

base-commit: 614124bea77e452aa6df7a8714e8bc820b489922
--=20
2.32.0.272.g935e593368-goog

