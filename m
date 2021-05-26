Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B20C392355
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 01:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhEZXmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 19:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234010AbhEZXmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 19:42:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC323613D3;
        Wed, 26 May 2021 23:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622072475;
        bh=7irwvTCR0r1tKVpjTLGJSu7WuEmSn8CZAvRyxpsA9wc=;
        h=Date:From:To:Subject:From;
        b=kEgyd6osKVODKLg44k0qMs/QT6YPJbnmHGsFg9OQgFe1J0rZNHMRJiPNcxxtNgdGh
         /Yxoe2IqyE2uRnvyGhk7NsfaljZ230lh0o0qH8L1dZZZ1vfX6tdtWvkyY1hHP1ZMyV
         syJBjHzgiYPQMJYsZRM6H27fssZ9ZarghSDlui6M=
Date:   Wed, 26 May 2021 16:41:15 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dinghui@sangfor.com.cn,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, stable@vger.kernel.org
Subject:  +
 mm-page_alloc-fix-counting-of-free-pages-after-take-off-from-buddy.patch
 added to -mm tree
Message-ID: <20210526234115.0YhW-QUsd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix counting of free pages after take off from buddy
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-counting-of-free-pages-after-take-off-from-buddy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-counting-of-free-pages-after-take-off-from-buddy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-counting-of-free-pages-after-take-off-from-buddy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ding Hui <dinghui@sangfor.com.cn>
Subject: mm/page_alloc: fix counting of free pages after take off from buddy

Recently we found that there is a lot MemFree left in /proc/meminfo after
do a lot of pages soft offline, it's not quite correct.

Before Oscar rework soft offline for free pages [1], if we soft offline
free pages, these pages are left in buddy with HWPoison flag, and
NR_FREE_PAGES is not updated immediately.  So the difference between
NR_FREE_PAGES and real number of available free pages is also even big at
the beginning.

However, with the workload running, when we catch HWPoison page in any
alloc functions subsequently, we will remove it from buddy, meanwhile
update the NR_FREE_PAGES and try again, so the NR_FREE_PAGES will get more
and more closer to the real number of available free pages.  (regardless
of unpoison_memory())

Now, for offline free pages, after a successful call
take_page_off_buddy(), the page is no longer belong to buddy allocator,
and will not be used any more, but we missed accounting NR_FREE_PAGES in
this situation, and there is no chance to be updated later.

Do update in take_page_off_buddy() like rmqueue() does, but avoid double
counting if some one already set_migratetype_isolate() on the page.

[1]: commit 06be6ff3d2ec ("mm,hwpoison: rework soft offline for free pages")

Link: https://lkml.kernel.org/r/20210526075247.11130-1-dinghui@sangfor.com.cn
Fixes: 06be6ff3d2ec ("mm,hwpoison: rework soft offline for free pages")
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-fix-counting-of-free-pages-after-take-off-from-buddy
+++ a/mm/page_alloc.c
@@ -9158,6 +9158,8 @@ bool take_page_off_buddy(struct page *pa
 			del_page_from_free_list(page_head, zone, page_order);
 			break_down_buddy_pages(zone, page_head, page, 0,
 						page_order, migratetype);
+			if (!is_migrate_isolate(migratetype))
+				__mod_zone_freepage_state(zone, -1, migratetype);
 			ret = true;
 			break;
 		}
_

Patches currently in -mm which might be from dinghui@sangfor.com.cn are

mm-page_alloc-fix-counting-of-free-pages-after-take-off-from-buddy.patch

