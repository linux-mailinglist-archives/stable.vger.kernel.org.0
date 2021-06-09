Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B073A0831
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 02:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhFIASF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 20:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhFIASF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 20:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA51A6128E;
        Wed,  9 Jun 2021 00:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623197758;
        bh=jWVpNrw/5++zRYEiUneVF65cnHi03Dj3NZ2w3QDDuXk=;
        h=Date:From:To:Subject:From;
        b=ESaSkFAyjv7ZccEyXHNJKKVWK0YPtmdrMX79R7eGAzhBhnl6ARbgYKbgMLDuTaTMk
         QFDXiJDCr27OFK1pWwILeAVsA04IxES4WlpDM456jBeRZbPNT/wQuwp1Egw6UHsiBQ
         8iAWgGTo9VFWgVxtjGXqkM/NTmw6vRQYhpRdRW6U=
Date:   Tue, 08 Jun 2021 17:15:57 -0700
From:   akpm@linux-foundation.org
To:     gavin.dg@linux.alibaba.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, willy@infradead.org, xuyu@linux.alibaba.com
Subject:  + mm-thp-use-head-page-in-__migration_entry_wait.patch
 added to -mm tree
Message-ID: <20210609001557.ZaGZCalCW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, thp: use head page in __migration_entry_wait
has been added to the -mm tree.  Its filename is
     mm-thp-use-head-page-in-__migration_entry_wait.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-use-head-page-in-__migration_entry_wait.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-use-head-page-in-__migration_entry_wait.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xu Yu <xuyu@linux.alibaba.com>
Subject: mm, thp: use head page in __migration_entry_wait

We notice that hung task happens in a corner but practical scenario when
CONFIG_PREEMPT_NONE is enabled, as follows.

Process 0                       Process 1                     Process 2..Inf
split_huge_page_to_list
    unmap_page
        split_huge_pmd_address
                                __migration_entry_wait(head)
                                                              __migration_entry_wait(tail)
    remap_page (roll back)
        remove_migration_ptes
            rmap_walk_anon
                cond_resched

Where __migration_entry_wait(tail) is occurred in kernel space, e.g.,
copy_to_user in fstat, which will immediately fault again without
rescheduling, and thus occupy the cpu fully.

When there are too many processes performing __migration_entry_wait on
tail page, remap_page will never be done after cond_resched.

This makes __migration_entry_wait operate on the compound head page, thus
waits for remap_page to complete, whether the THP is split successfully or
roll back.

Note that put_and_wait_on_page_locked helps to drop the page reference
acquired with get_page_unless_zero, as soon as the page is on the wait
queue, before actually waiting.  So splitting the THP is only prevented
for a brief interval.

Link: https://lkml.kernel.org/r/b9836c1dd522e903891760af9f0c86a2cce987eb.1623144009.git.xuyu@linux.alibaba.com
Fixes: ba98828088ad ("thp: add option to setup migration entries during PMD split")
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Gang Deng <gavin.dg@linux.alibaba.com>
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/migrate.c~mm-thp-use-head-page-in-__migration_entry_wait
+++ a/mm/migrate.c
@@ -295,6 +295,7 @@ void __migration_entry_wait(struct mm_st
 		goto out;
 
 	page = migration_entry_to_page(entry);
+	page = compound_head(page);
 
 	/*
 	 * Once page cache replacement of page migration started, page_count
_

Patches currently in -mm which might be from xuyu@linux.alibaba.com are

mm-thp-use-head-page-in-__migration_entry_wait.patch

