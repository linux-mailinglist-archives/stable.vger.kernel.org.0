Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01861EA5E4
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 16:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFAOam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 10:30:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:49575 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgFAOal (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 10:30:41 -0400
IronPort-SDR: Z5Vx6EOQEgosVfWzJ2Xyck5xHW+qYjjN5ZcK0WX/3+B8RF9QzPFm0/ZCHgX21g7EF9omddyOY4
 AwEA/Ho2eeqQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 07:30:27 -0700
IronPort-SDR: yHvYqzy6k12P3vdvR9FtkJ0aGHuD5ri/ttRnJXZQ3IhQuFqAC6DJ75da7FZDgBwUUXqtG2VDpB
 iLcWswtAu4Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,461,1583222400"; 
   d="scan'208";a="444309232"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 01 Jun 2020 07:30:25 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id A729C23F; Mon,  1 Jun 2020 17:30:23 +0300 (EEST)
Date:   Mon, 1 Jun 2020 17:30:23 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Yalin.Wang@sonymobile.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: FAILED: patch "[PATCH] mm: add VM_BUG_ON_PAGE() to
 page_mapcount()" failed to apply to 4.4-stable tree
Message-ID: <20200601143023.pzwhggnbwplqral6@black.fi.intel.com>
References: <159100964424864@kroah.com>
 <20200601140519.rm5lthhe6cf45567@black.fi.intel.com>
 <20200601141522.GA722623@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601141522.GA722623@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 01, 2020 at 04:15:22PM +0200, Greg KH wrote:
> On Mon, Jun 01, 2020 at 05:05:19PM +0300, Kirill A. Shutemov wrote:
> > On Mon, Jun 01, 2020 at 01:07:24PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 4.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > Please don't.
> > 
> > The patch known to cause trouble and going to be effectively reverted:
> > 
> > https://lore.kernel.org/r/159032779896.957378.7852761411265662220.stgit@buzz
> 
> Oops, I ment to say that 6988f31d558a ("mm: remove VM_BUG_ON(PageSlab())
> from page_mapcount()") did not apply to the 4.4 tree and needs a working
> backport.
> 
> I put in the wrong id as that is the commit that 6988f31d558a fixes.
> 
> So, if you could provide a working backport, that would be wonderful.

The patch below should do. I've dropped the comments. They are not
relevant for v4.4.

From e0568884b6bab1658d4e97d38b22b25c2e6eddeb Mon Sep 17 00:00:00 2001
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Date: Wed, 27 May 2020 22:20:47 -0700
Subject: [PATCH] mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

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
---
 include/linux/mm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 69fa3df9e712..03cf5526e445 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -446,7 +446,6 @@ static inline void page_mapcount_reset(struct page *page)
 
 static inline int page_mapcount(struct page *page)
 {
-	VM_BUG_ON_PAGE(PageSlab(page), page);
 	return atomic_read(&page->_mapcount) + 1;
 }
 
-- 
 Kirill A. Shutemov
