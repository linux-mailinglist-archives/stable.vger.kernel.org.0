Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F08F43A378
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbhJYT7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239542AbhJYT5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 803D361152;
        Mon, 25 Oct 2021 19:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191213;
        bh=r8cSDJtgsROUmIHtz5+qJhizqs/JF3DnIj86G3u4u8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nk+3vvX641068w4FvV2E94vqVaoccjVmcfyjWX5NPyWcsKEVlYNh0XD+B1hIviom5
         SwfvAcjHER9igAGyPDK0NGtj9oTRwO5SNT+JulrjjUW87ADUJ7Lf3XNzjIBFH9ylSK
         bijetQ2/9xxHVPkV2Ja+O1JZa9ljGwjeOiem91D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Yang Shi <shy828301@gmail.com>, sfoon.kim@samsung.com,
        Song Liu <songliubraving@fb.com>,
        Rik van Riel <riel@surriel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <hdanton@sina.com>,
        Hugh Dickins <hughd@google.com>,
        William Kucharski <william.kucharski@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 153/169] mm/thp: decrease nr_thps in files mapping on THP split
Date:   Mon, 25 Oct 2021 21:15:34 +0200
Message-Id: <20211025191036.865976319@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 1ca7554d05ac038c98271f8968ed821266ecaa9c ]

Decrease nr_thps counter in file's mapping to ensure that the page cache
won't be dropped excessively on file write access if page has been
already split.

I've tried a test scenario running a big binary, kernel remaps it with
THPs, then force a THP split with /sys/kernel/debug/split_huge_pages.
During any further open of that binary with O_RDWR or O_WRITEONLY kernel
drops page cache for it, because of non-zero thps counter.

Link: https://lkml.kernel.org/r/20211012120237.2600-1-m.szyprowski@samsung.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 09d91cda0e82 ("mm,thp: avoid writes to file with THP in pagecache")
Fixes: 06d3eff62d9d ("mm/thp: fix node page state in split_huge_page_to_list()")
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: <sfoon.kim@samsung.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afff3ac87067..163c2da2a654 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2724,12 +2724,14 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		if (mapping) {
 			int nr = thp_nr_pages(head);
 
-			if (PageSwapBacked(head))
+			if (PageSwapBacked(head)) {
 				__mod_lruvec_page_state(head, NR_SHMEM_THPS,
 							-nr);
-			else
+			} else {
 				__mod_lruvec_page_state(head, NR_FILE_THPS,
 							-nr);
+				filemap_nr_thps_dec(mapping);
+			}
 		}
 
 		__split_huge_page(page, list, end);
-- 
2.33.0



