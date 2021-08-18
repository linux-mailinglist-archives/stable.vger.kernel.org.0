Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A4E3F0BCD
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 21:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhHRTby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 15:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhHRTbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 15:31:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B364760187;
        Wed, 18 Aug 2021 19:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629315077;
        bh=gBkrc5pTyF+PTg7DJ6cYMeoQZqR0Ivobx1vz0nXwWmk=;
        h=Date:From:To:Subject:From;
        b=ImJPh/ZjpryZkeWXSvilN/qPLNLVHYGQlaFgJdVgvQMWYfY4Wxb4kAaY+Jba0PXpW
         Zozm1O9Tks//zxbleZs7+8Ylbjf6Dxe5W7XMRarUgn5bZ5jDSVJ1B158HbMylodeAd
         kSGQubdkxe7zrBLiwvs3rZ8/hq4f22N6rIMjivCE=
Date:   Wed, 18 Aug 2021 12:31:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org,
        syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com,
        stable@vger.kernel.org, hughd@google.com, willy@infradead.org
Subject:  + mm-remove-bogus-vm_bug_on.patch added to -mm tree
Message-ID: <20210818193117.Fn2hT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: remove bogus VM_BUG_ON
has been added to the -mm tree.  Its filename is
     mm-remove-bogus-vm_bug_on.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-bogus-vm_bug_on.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-bogus-vm_bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2038,7 +2038,6 @@ unsigned find_lock_entries(struct addres
 		if (!xa_is_value(page)) {
 			if (page->index < start)
 				goto put;
-			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
 			if (page->index + thp_nr_pages(page) - 1 > end)
 				goto put;
 			if (!trylock_page(page))
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-bogus-vm_bug_on.patch
mm-report-a-more-useful-address-for-reclaim-acquisition.patch
mm-mark-idle-page-tracking-as-broken.patch
avoid-a-warning-in-sparse-memory-support.patch
mm-move-kvmalloc-related-functions-to-slabh.patch

