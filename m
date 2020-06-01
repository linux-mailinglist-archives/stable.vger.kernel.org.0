Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8D81EAF0D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgFAR5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbgFAR5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5B662073B;
        Mon,  1 Jun 2020 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034243;
        bh=YYkXeT0qG5PVYrGeJGIoToGBNE1ZhrA2NGX8vI6bL6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWmGAjDB9UV7ybE3yoLIsFAcyAjhP8Z7jUUpxfu+EaRg4zwqvUrJuQZCO9HSKx2Hj
         1PYdRWiMJKmGgdGR/2W0R30BYccd2i8TypnJXZ4JxlpJewuVZgzdHRvOsOXOwhvb98
         dDRPtlMy+p3R8fg0fqiUFWOBNKW9VOcxK6M9BKmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 39/48] mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()
Date:   Mon,  1 Jun 2020 19:53:49 +0200
Message-Id: <20200601174003.327414437@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

commit 6988f31d558aa8c744464a7f6d91d34ada48ad12 upstream.

Replace superfluous VM_BUG_ON() with comment about correct usage.

Technically reverts commit 1d148e218a0d ("mm: add VM_BUG_ON_PAGE() to
page_mapcount()"), but context lines have changed.

Function isolate_migratepages_block() runs some checks out of lru_lock
when choose pages for migration.  After checking PageLRU() it checks
extra page references by comparing page_count() and page_mapcount().
Between these two checks page could be removed from lru, freed and taken
by slab.

As a result this race triggers VM_BUG_ON(PageSlab()) in page_mapcount().
Race window is tiny.  For certain workload this happens around once a
year.

    page:ffffea0105ca9380 count:1 mapcount:0 mapping:ffff88ff7712c180 index:0x0 compound_mapcount: 0
    flags: 0x500000000008100(slab|head)
    raw: 0500000000008100 dead000000000100 dead000000000200 ffff88ff7712c180
    raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
    page dumped because: VM_BUG_ON_PAGE(PageSlab(page))
    ------------[ cut here ]------------
    kernel BUG at ./include/linux/mm.h:628!
    invalid opcode: 0000 [#1] SMP NOPTI
    CPU: 77 PID: 504 Comm: kcompactd1 Tainted: G        W         4.19.109-27 #1
    Hardware name: Yandex T175-N41-Y3N/MY81-EX0-Y3N, BIOS R05 06/20/2019
    RIP: 0010:isolate_migratepages_block+0x986/0x9b0

The code in isolate_migratepages_block() was added in commit
119d6d59dcc0 ("mm, compaction: avoid isolating pinned pages") before
adding VM_BUG_ON into page_mapcount().

This race has been predicted in 2015 by Vlastimil Babka (see link
below).

[akpm@linux-foundation.org: comment tweaks, per Hugh]
Fixes: 1d148e218a0d ("mm: add VM_BUG_ON_PAGE() to page_mapcount()")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/159032779896.957378.7852761411265662220.stgit@buzz
Link: https://lore.kernel.org/lkml/557710E1.6060103@suse.cz/
Link: https://lore.kernel.org/linux-mm/158937872515.474360.5066096871639561424.stgit@buzz/T/ (v1)
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -446,7 +446,6 @@ static inline void page_mapcount_reset(s
 
 static inline int page_mapcount(struct page *page)
 {
-	VM_BUG_ON_PAGE(PageSlab(page), page);
 	return atomic_read(&page->_mapcount) + 1;
 }
 


