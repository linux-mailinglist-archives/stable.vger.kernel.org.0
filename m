Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3BC3A0242
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbhFHTCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237355AbhFHTA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5732B616EC;
        Tue,  8 Jun 2021 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177821;
        bh=iM5ZmtoZdBCNsWVHnKOBVR/qRxBynWGEmhlaGLNsyLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwsHljg2LbhdXJjKtkLf6cQIv2UQDgFWKXtNTDoHnkiZKdTroInHqQ8zwCv3pfj0b
         END7y5+RriHEuqOoO9+koc0h0YjKoVFdOxkNgu1EgD+ppHh/bO8kGo51+pFAmSaQzg
         k1AAqEIfo8YIl4665sA4s3Yp8Bl8Uh5tr2yA2560=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ding Hui <dinghui@sangfor.com.cn>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 111/137] mm/page_alloc: fix counting of free pages after take off from buddy
Date:   Tue,  8 Jun 2021 20:27:31 +0200
Message-Id: <20210608175946.141394283@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Hui <dinghui@sangfor.com.cn>

commit bac9c6fa1f929213bbd0ac9cdf21e8e2f0916828 upstream.

Recently we found that there is a lot MemFree left in /proc/meminfo
after do a lot of pages soft offline, it's not quite correct.

Before Oscar's rework of soft offline for free pages [1], if we soft
offline free pages, these pages are left in buddy with HWPoison flag,
and NR_FREE_PAGES is not updated immediately.  So the difference between
NR_FREE_PAGES and real number of available free pages is also even big
at the beginning.

However, with the workload running, when we catch HWPoison page in any
alloc functions subsequently, we will remove it from buddy, meanwhile
update the NR_FREE_PAGES and try again, so the NR_FREE_PAGES will get
more and more closer to the real number of available free pages.
(regardless of unpoison_memory())

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
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8870,6 +8870,8 @@ bool take_page_off_buddy(struct page *pa
 			del_page_from_free_list(page_head, zone, page_order);
 			break_down_buddy_pages(zone, page_head, page, 0,
 						page_order, migratetype);
+			if (!is_migrate_isolate(migratetype))
+				__mod_zone_freepage_state(zone, -1, migratetype);
 			ret = true;
 			break;
 		}


