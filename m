Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CB5249309
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 04:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgHSCt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 22:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgHSCt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 22:49:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B077B20738;
        Wed, 19 Aug 2020 02:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597805366;
        bh=2X/sJGtDEDniiMS+r+HT2sjlpCOgn6J32jrlNyi7kII=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=B4wuAn9e4cUv9MgpappOz48C3yrJD2GoUEeg+KhtLQyYgzTn6JTdwDd2cvmdU2cu4
         Wo/iKM3fWJIAdqBZCad5OUL1ExkKwg7pJob/oolchQQRxSV0QQzJo0Sn7c8x74q5N1
         kJ9YheuiQSaxtE3V0FsNPf7mOV3vtfBj3xoO9hNk=
Date:   Tue, 18 Aug 2020 19:49:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, songliubraving@fb.com,
        srikar@linux.vnet.ibm.com, stable@vger.kernel.org,
        syzkaller@googlegroups.com
Subject:  +
 uprobes-__replace_page-avoid-bug-in-munlock_vma_page.patch added to -mm
 tree
Message-ID: <20200819024925.wmG-vrVrv%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: uprobes: __replace_page() avoid BUG in munlock_vma_page()
has been added to the -mm tree.  Its filename is
     uprobes-__replace_page-avoid-bug-in-munlock_vma_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uprobes-__replace_page-avoid-bug-in-munlock_vma_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uprobes-__replace_page-avoid-bug-in-munlock_vma_page.patch

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
Subject: uprobes: __replace_page() avoid BUG in munlock_vma_page()

syzbot crashed on the VM_BUG_ON_PAGE(PageTail) in munlock_vma_page(), when
called from uprobes __replace_page().  Which of many ways to fix it? 
Settled on not calling when PageCompound (since Head and Tail are equals
in this context, PageCompound the usual check in uprobes.c, and the prior
use of FOLL_SPLIT_PMD will have cleared PageMlocked already).

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008161338360.20413@eggly.anvils
Fixes: 5a52c9df62b4 ("uprobe: use FOLL_SPLIT_PMD instead of FOLL_SPLIT")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c~uprobes-__replace_page-avoid-bug-in-munlock_vma_page
+++ a/kernel/events/uprobes.c
@@ -205,7 +205,7 @@ static int __replace_page(struct vm_area
 		try_to_free_swap(old_page);
 	page_vma_mapped_walk_done(&pvmw);
 
-	if (vma->vm_flags & VM_LOCKED)
+	if ((vma->vm_flags & VM_LOCKED) && !PageCompound(old_page))
 		munlock_vma_page(old_page);
 	put_page(old_page);
 
_

Patches currently in -mm which might be from hughd@google.com are

uprobes-__replace_page-avoid-bug-in-munlock_vma_page.patch
khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter.patch

