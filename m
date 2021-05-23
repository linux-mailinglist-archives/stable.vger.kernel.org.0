Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6539E38D808
	for <lists+stable@lfdr.de>; Sun, 23 May 2021 02:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhEWAnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 20:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhEWAnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 May 2021 20:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A4006100A;
        Sun, 23 May 2021 00:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621730507;
        bh=3fW0FdmKsOra4/oaJJ8MdrIu64EXewmHrtjyfJU8dRs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=n5pwPKVO7Ui5sJuOA/TZDKGQrzzfgGnjgJIsDljw2ScUt2dooJWEFKm0/f5/ITtqV
         gyn4wgcb2fCorfukNfZLWjpoyH0Pl1nq6/fnpwmw67j0lzfKDZzv52KHeRzz7Bz0ZA
         n4YDFF8WHOGiKDXxA4Q1jTSMMB5DjInvVCdmaKnU=
Date:   Sat, 22 May 2021 17:41:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        yaoaili@kingsoft.com
Subject:  [patch 02/10] Revert "mm/gup: check page posion status
 for coredump."
Message-ID: <20210523004146.Uqko6SWcY%akpm@linux-foundation.org>
In-Reply-To: <20210522174113.47fd4c853c0a1470c57deefa@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: Revert "mm/gup: check page posion status for coredump."

While reviewing
http://lkml.kernel.org/r/20210429122519.15183-4-david@redhat.com I have
crossed d3378e86d182 ("mm/gup: check page posion status for coredump.")
and noticed that this patch is broken in two ways.  First it doesn't
really prevent hwpoison pages from being dumped because hwpoison pages can
be marked asynchornously at any time after the check.  Secondly, and more
importantly, the patch introduces a ref count leak because get_dump_page
takes a reference on the page which is not released.

It also seems that the patch was merged incorrectly because there were
follow up changes not included as well as discussions on how to address
the underlying problem
http://lkml.kernel.org/r/57ac524c-b49a-99ec-c1e4-ef5027bfb61b@redhat.com

Therefore revert the original patch.

Link: https://lkml.kernel.org/r/20210505135407.31590-1-mhocko@kernel.org
Fixes: d3378e86d182 ("mm/gup: check page posion status for coredump.")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c      |    4 ----
 mm/internal.h |   20 --------------------
 2 files changed, 24 deletions(-)

--- a/mm/gup.c~revert-mm-gup-check-page-posion-status-for-coredump
+++ a/mm/gup.c
@@ -1593,10 +1593,6 @@ struct page *get_dump_page(unsigned long
 				      FOLL_FORCE | FOLL_DUMP | FOLL_GET);
 	if (locked)
 		mmap_read_unlock(mm);
-
-	if (ret == 1 && is_page_poisoned(page))
-		return NULL;
-
 	return (ret == 1) ? page : NULL;
 }
 #endif /* CONFIG_ELF_CORE */
--- a/mm/internal.h~revert-mm-gup-check-page-posion-status-for-coredump
+++ a/mm/internal.h
@@ -96,26 +96,6 @@ static inline void set_page_refcounted(s
 	set_page_count(page, 1);
 }
 
-/*
- * When kernel touch the user page, the user page may be have been marked
- * poison but still mapped in user space, if without this page, the kernel
- * can guarantee the data integrity and operation success, the kernel is
- * better to check the posion status and avoid touching it, be good not to
- * panic, coredump for process fatal signal is a sample case matching this
- * scenario. Or if kernel can't guarantee the data integrity, it's better
- * not to call this function, let kernel touch the poison page and get to
- * panic.
- */
-static inline bool is_page_poisoned(struct page *page)
-{
-	if (PageHWPoison(page))
-		return true;
-	else if (PageHuge(page) && PageHWPoison(compound_head(page)))
-		return true;
-
-	return false;
-}
-
 extern unsigned long highest_memmap_pfn;
 
 /*
_
