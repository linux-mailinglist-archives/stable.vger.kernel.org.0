Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D00E3A3DB4
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 10:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFKIEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 04:04:12 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:41864 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhFKIEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 04:04:10 -0400
Received: by mail-wr1-f45.google.com with SMTP id o3so5002211wri.8
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 01:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bE/KUZ9QKkdW8cpXSSyU518CP3tPDoswPEAOU9fuFew=;
        b=r1ucxI47ris1Yyujr58rPBjyNMwf0oO3T7TBdzTpWtzhzrkvdA+rkJdqLe6+CDPPzA
         2E3mwuTrlr0mW2bfVEk51AOjX+QvUVU+5euXfZJqdWVqJLOKswJDc4TErtFr0DOzkft6
         Of1o+nShLFfiUO3iUFIHe8XRT0QsJY2RYTg4H53d8uOjSH8UW1/S3GrpBF1WF7IXWMlH
         ufNmZoNkQ/Qp3R3QfTDCNXPUvFs7lH3Z5jjFNfmpM5EzVkkbWluQz3d5AQ3GtznVeHbN
         yAhSXXeEtdSXrKFNc5aZXG+1pJRV6DJOPbIwaMKFkJhckP38iuWjUYt2/MFd6msdfHBJ
         OpXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bE/KUZ9QKkdW8cpXSSyU518CP3tPDoswPEAOU9fuFew=;
        b=twj9IDhtblL+jFLBN1Wg8FPK1QlzFDH8KdSFyPyRG6DhoWch1Dil9dHLnexju2sDl7
         Ga2B24W9gJEgjmk/TFr95sq+H4+dVwpaYpPs8x4vqM3C9Sw9IyKIjze3KM15M3J3eT/B
         qOxdRqLdS3z6iQ6C2Dv/xXcB8ROofCR+phIFw/bBlCF3Y+Z20hng26MmkbgX4bKhBDJM
         sN/5e7vSf20ZOOYMCik6rzo7V1/QLsvyX+bDnxf+JTnCb5Bc9Sas7DQRIkoMTOw7jMMZ
         XgPIXGQddAjqvu4062eEECCgsvtVsaB2QzdXtUVSvJg09YS9ArMQmc8qdXZC8XQj5S5h
         Buvw==
X-Gm-Message-State: AOAM531UD+MYO48fXY67crfeYlv/mW5enXOBySgYD5AFFr2y9+iEii+y
        C1L1IvrOEosRofTcRl0d3U3XzA==
X-Google-Smtp-Source: ABdhPJwrDUmeg8YRTI7WihhIRANvJqSROo7Yhgyb7Hwx9jgOH3Lv/9V/uXxDzj6jwe46tOrjayFKzQ==
X-Received: by 2002:a5d:6b0e:: with SMTP id v14mr2502091wrw.297.1623398460461;
        Fri, 11 Jun 2021 01:01:00 -0700 (PDT)
Received: from localhost ([2a02:168:96c5:1:55ed:514f:6ad7:5bcc])
        by smtp.gmail.com with ESMTPSA id x18sm6079898wrw.19.2021.06.11.01.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 01:00:59 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] mm/gup: fix try_grab_compound_head() race with split_huge_page()
Date:   Fri, 11 Jun 2021 10:00:27 +0200
Message-Id: <20210611080027.984937-1-jannh@google.com>
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

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Fixes: 7aef4172c795 ("mm: handle PTE-mapped tail pages in gerneric fast gup=
 implementaiton")
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/gup.c | 54 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 3ded6a5f26b2..1f9c0ac15073 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -43,8 +43,21 @@ static void hpage_pincount_sub(struct page *page, int re=
fs)
=20
 	atomic_sub(refs, compound_pincount_ptr(page));
 }
=20
+/* Equivalent to calling put_page() @refs times. */
+static void put_page_refs(struct page *page, int refs)
+{
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
 /*
  * Return the compound head page with ref appropriately incremented,
  * or NULL if that failed.
  */
@@ -55,8 +68,23 @@ static inline struct page *try_get_compound_head(struct =
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
@@ -94,25 +122,28 @@ __maybe_unused struct page *try_grab_compound_head(str=
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
@@ -134,16 +165,9 @@ static void put_compound_head(struct page *page, int r=
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

