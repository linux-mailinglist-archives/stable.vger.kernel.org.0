Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE9D38F010
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbhEXQBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235732AbhEXQAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C1E761983;
        Mon, 24 May 2021 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871144;
        bh=FZnToX2z0oAl1US0eKd6Wkh3tYpXf5ETtnv04u1DLoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFunuuvBz8dnx5afEnyObAphZlUFdyowdDyqcaCC/F6sH5I+9pNApEDCfaL2mHZv3
         K51qdwtBtiT94p/gf73fnLYPQaeCwvjUQfVcGe5XmGHqJa6df7AedKBtQgaGNvk/rx
         UQRRO6/qsG554szV+Kib899rEgYrB/YkKjVCRoFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        Aili Yao <yaoaili@kingsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 092/127] Revert "mm/gup: check page posion status for coredump."
Date:   Mon, 24 May 2021 17:26:49 +0200
Message-Id: <20210524152337.967378225@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

commit f10628d2f613195132532e0fbda439eeed8d12a2 upstream.

While reviewing [1] I came across commit d3378e86d182 ("mm/gup: check
page posion status for coredump.") and noticed that this patch is broken
in two ways.  First it doesn't really prevent hwpoison pages from being
dumped because hwpoison pages can be marked asynchornously at any time
after the check.  Secondly, and more importantly, the patch introduces a
ref count leak because get_dump_page takes a reference on the page which
is not released.

It also seems that the patch was merged incorrectly because there were
follow up changes not included as well as discussions on how to address
the underlying problem [2]

Therefore revert the original patch.

Link: http://lkml.kernel.org/r/20210429122519.15183-4-david@redhat.com [1]
Link: http://lkml.kernel.org/r/57ac524c-b49a-99ec-c1e4-ef5027bfb61b@redhat.com [2]
Link: https://lkml.kernel.org/r/20210505135407.31590-1-mhocko@kernel.org
Fixes: d3378e86d182 ("mm/gup: check page posion status for coredump.")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c      |    4 ----
 mm/internal.h |   20 --------------------
 2 files changed, 24 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1535,10 +1535,6 @@ struct page *get_dump_page(unsigned long
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
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -97,26 +97,6 @@ static inline void set_page_refcounted(s
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


