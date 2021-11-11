Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA844D016
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 03:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhKKCo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 21:44:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhKKCo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B99961284;
        Thu, 11 Nov 2021 02:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598498;
        bh=c+s2qESpWoo1DOr+MfIL1v+jz0kqCJujv/GuSUqAUG8=;
        h=Date:From:To:Subject:From;
        b=rtf4SuNJtpyz0GsOErEmBaQ18hmI/njvMA206eqpUvnNnBN+hcXtjaOf5KBg5izBX
         jYJdnVNbu4WHWZAwDSyChGr7Thryf1/1fmRMWRkGnN4yWCZf5n1jYXIn/X9kKXWl7R
         me9DO9/zDDvjn1QJ9tdTgiAzweHHByS5FIMvh+Ps=
Date:   Wed, 10 Nov 2021 18:41:38 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com,
        willy@infradead.org
Subject:  [merged] mm-remove-bogus-vm_bug_on.patch removed from -mm
 tree
Message-ID: <20211111024138.JtbCTimFk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: remove bogus VM_BUG_ON
has been removed from the -mm tree.  Its filename was
     mm-remove-bogus-vm_bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2093,7 +2093,6 @@ unsigned find_lock_entries(struct addres
 		if (!xa_is_value(page)) {
 			if (page->index < start)
 				goto put;
-			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
 			if (page->index + thp_nr_pages(page) - 1 > end)
 				goto put;
 			if (!trylock_page(page))
_

Patches currently in -mm which might be from willy@infradead.org are

hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch

