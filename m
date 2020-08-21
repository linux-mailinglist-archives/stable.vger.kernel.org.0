Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3124C949
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 02:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgHUAmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 20:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgHUAmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 20:42:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F296207DF;
        Fri, 21 Aug 2020 00:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970523;
        bh=+WvEgrYIHkkeUnjluxstf/SQ+TuZELLSwpag0oqeBFw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nalZHLdnZOpXk7HvdakXtnze4hoQHp4fETpt6OUptZ6lvumiyccmbVnlDXNemqxuQ
         GvwpfQaBLEL9SdRAiwa/nziUkElcDJSiGrVleDKdSJ59m6/nC6Uw79nW2kPs/FTztD
         icKdUuIT4p032cgkDIjWPvrrrAO2y9jxZPFRWhPk=
Date:   Thu, 20 Aug 2020 17:42:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        edumazet@google.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, songliubraving@fb.com, stable@vger.kernel.org,
        syzkaller@googlegroups.com, torvalds@linux-foundation.org
Subject:  [patch 03/11] khugepaged: adjust VM_BUG_ON_MM() in
 __khugepaged_enter()
Message-ID: <20200821004202.AP6gJKDLE%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()

syzbot crashes on the VM_BUG_ON_MM(khugepaged_test_exit(mm), mm) in
__khugepaged_enter(): yes, when one thread is about to dump core, has set
core_state, and is waiting for others, another might do something calling
__khugepaged_enter(), which now crashes because I lumped the core_state
test (known as "mmget_still_valid") into khugepaged_test_exit().  I still
think it's best to lump them together, so just in this exceptional case,
check mm->mm_users directly instead of khugepaged_test_exit().

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008141503370.18085@eggly.anvils
Fixes: bbe98f9cadff ("khugepaged: khugepaged_test_exit() check mmget_still_valid()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-adjust-vm_bug_on_mm-in-__khugepaged_enter
+++ a/mm/khugepaged.c
@@ -466,7 +466,7 @@ int __khugepaged_enter(struct mm_struct
 		return -ENOMEM;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
+	VM_BUG_ON_MM(atomic_read(&mm->mm_users) == 0, mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
 		free_mm_slot(mm_slot);
 		return 0;
_
