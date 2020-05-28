Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878D31E5667
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 07:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgE1FUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 01:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgE1FUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 01:20:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6451F21475;
        Thu, 28 May 2020 05:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590643244;
        bh=MrCAZlU4EB5nz5nzwXu8l+1jDN7Xtlc8i+XkLVS6kdo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jk9BWgPlC3v5l/HxJTpEEWyhl9NGR08RaxRt/yoecO83q7Mej/NWvo2pwFSaedzDX
         5i7unq2zoqwWPeaR1hWKb4gtcBl4KcZGKnZ719ZSBRKBHZw1mqQ8s5ZLHgSASAOWGT
         jYO9C2m+LDy9TQwz7GxwiZIVx/eBHXPuYNIWUNk0=
Date:   Wed, 27 May 2020 22:20:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, riel@surriel.com,
        songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 2/5] mm,thp: stop leaking unreleased file pages
Message-ID: <20200528052043.TKW9wStFk%akpm@linux-foundation.org>
In-Reply-To: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm,thp: stop leaking unreleased file pages

When collapse_file() calls try_to_release_page(), it has already isolated
the page: so if releasing buffers happens to fail (as it sometimes does),
remember to putback_lru_page(): otherwise that page is left unreclaimable
and unfreeable, and the file extent uncollapsible.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2005231837500.1766@eggly.anvils
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/khugepaged.c~mmthp-stop-leaking-unreleased-file-pages
+++ a/mm/khugepaged.c
@@ -1692,6 +1692,7 @@ static void collapse_file(struct mm_stru
 		if (page_has_private(page) &&
 		    !try_to_release_page(page, GFP_KERNEL)) {
 			result = SCAN_PAGE_HAS_PRIVATE;
+			putback_lru_page(page);
 			goto out_unlock;
 		}
 
_
