Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D834706DE
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 18:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhLJRX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 12:23:28 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42560 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbhLJRX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 12:23:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D9044CE2C3E;
        Fri, 10 Dec 2021 17:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B585BC00446;
        Fri, 10 Dec 2021 17:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639156790;
        bh=xzfSclflMqjFmBhxRH926LdWqzo74s6tLGO08wx37Rg=;
        h=Date:From:To:Subject:From;
        b=07mN/sAlzMoJgbmA5HgzSZ9X/wGaIOCpoReWwMjhxB+UyIoRYQ7o3DFyARzbuEYhr
         MKSh3i61CyiG6VunDkjM85EbI3rPNs3q2BiOPGeKTjb1O5IfbT9oMKiqYDhNHighRD
         +fo8MAOn76iU/DqF5uYLqi0cVra0A/5LGoqCl3Yk=
Date:   Fri, 10 Dec 2021 09:19:49 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        stable@vger.kernel.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  +
 mm-delete-unsafe-bug-from-page_cache_add_speculative.patch added to -mm
 tree
Message-ID: <20211210171949.n1LCDzHMZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: delete unsafe BUG from page_cache_add_speculative()
has been added to the -mm tree.  Its filename is
     mm-delete-unsafe-bug-from-page_cache_add_speculative.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-delete-unsafe-bug-from-page_cache_add_speculative.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-delete-unsafe-bug-from-page_cache_add_speculative.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: delete unsafe BUG from page_cache_add_speculative()

It is not easily reproducible, but on 5.16-rc I have several times hit the
VM_BUG_ON_PAGE(PageTail(page), page) in page_cache_add_speculative():
usually from filemap_get_read_batch() for an ext4 read, yesterday from
next_uptodate_page() from filemap_map_pages() for a shmem fault.

That BUG used to be placed where page_ref_add_unless() had succeeded, but
now it is placed before folio_ref_add_unless() is attempted: that is not
safe, since it is only the acquired reference which makes the page safe
from racing THP collapse or split.

We could keep the BUG, checking PageTail only when folio_ref_try_add_rcu()
has succeeded; but I don't think it adds much value - just delete it.

Link: https://lkml.kernel.org/r/8b98fc6f-3439-8614-c3f3-945c659a1aba@google.com
Fixes: 020853b6f5ea ("mm: Add folio_try_get_rcu()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/pagemap.h~mm-delete-unsafe-bug-from-page_cache_add_speculative
+++ a/include/linux/pagemap.h
@@ -285,7 +285,6 @@ static inline struct inode *folio_inode(
 
 static inline bool page_cache_add_speculative(struct page *page, int count)
 {
-	VM_BUG_ON_PAGE(PageTail(page), page);
 	return folio_ref_try_add_rcu((struct folio *)page, count);
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-delete-unsafe-bug-from-page_cache_add_speculative.patch

