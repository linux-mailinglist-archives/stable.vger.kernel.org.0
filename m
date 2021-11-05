Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D22D4469CA
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhKEUjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhKEUjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EB9760E05;
        Fri,  5 Nov 2021 20:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144631;
        bh=tolFhU/6c0H5j6/fvNY0DHTPCF/4Lqm1K9ZS2GAWqOM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2s8/x+FiI09Nb4WDj7o+PyiSi7JTvfnaJKlopsruiH7qp7QGi8Fb7qEaAXHHxDtvY
         KIS1mLIoL7M2G0eCY397vhzaJ50vrqHHOP5ans8sfOJscwwBiXdVSsAzK9xcr1+cP4
         dv0hlSHlzlGrd+DAV1Tsy0x1n55dYJYPQzYZGYZw=
Date:   Fri, 05 Nov 2021 13:37:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 048/262] mm/filemap.c: remove bogus VM_BUG_ON
Message-ID: <20211105203710.7ygSi-fQI%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap.c: remove bogus VM_BUG_ON

It is not safe to check page->index without holding the page lock.  It can
be changed if the page is moved between the swap cache and the page cache
for a shmem file, for example.  There is a VM_BUG_ON below which checks
page->index is correct after taking the page lock.

Link: https://lkml.kernel.org/r/20210818144932.940640-1-willy@infradead.org
Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: <syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/filemap.c~mm-remove-bogus-vm_bug_on
+++ a/mm/filemap.c
@@ -2093,7 +2093,6 @@ unsigned find_lock_entries(struct addres
 		if (!xa_is_value(page)) {
 			if (page->index < start)
 				goto put;
-			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
 			if (page->index + thp_nr_pages(page) - 1 > end)
 				goto put;
 			if (!trylock_page(page))
_
