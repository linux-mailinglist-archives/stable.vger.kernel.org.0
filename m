Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4966369F9
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiKWTju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236773AbiKWTjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:39:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A33990397;
        Wed, 23 Nov 2022 11:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30FE5B823F7;
        Wed, 23 Nov 2022 19:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13C7C433D6;
        Wed, 23 Nov 2022 19:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669232384;
        bh=NqB7fjXSXREj5w+riNZDiqESLtEo082PwrKzNQWSkpY=;
        h=Date:To:From:Subject:From;
        b=U+ULnYURNS/U12OUC3hbjkQh6oBwCKAILHCHdTm0p1NHW5ydjkIBh3f9uHjHmVeEY
         qJSulPrXbV0yp3eGn57K7UlVSswrrPw/LDp6knSAskI7hEOxarqkWSuFNwWQqQg44E
         1CV5inEb9h3UEhH6nG9BOa7TJfpEhaWDS6Vb0DX0=
Date:   Wed, 23 Nov 2022 11:39:44 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, peterx@redhat.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, david@redhat.com, jannh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmu_gather-use-macro-arguments-more-carefully.patch added to mm-hotfixes-unstable branch
Message-Id: <20221123193944.C13C7C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mmu_gather: Use macro arguments more carefully
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmu_gather-use-macro-arguments-more-carefully.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmu_gather-use-macro-arguments-more-carefully.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mmu_gather: Use macro arguments more carefully
Date: Wed, 23 Nov 2022 17:56:50 +0100

Avoid breaking stuff when the tlb parameter is an expression like "&tlb". 
The following commit relies on this when calling pte_free_tlb().

(Going forward it would probably be a good idea to change macros like this
into inline functions...)

Link: https://lkml.kernel.org/r/20221123165652.2204925-3-jannh@google.com
Fixes: a6d60245d6d9 ("asm-generic/tlb: Track which levels of the page table=
s have been cleared")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/asm-generic/tlb.h~mmu_gather-use-macro-arguments-more-carefully
+++ a/include/asm-generic/tlb.h
@@ -630,7 +630,7 @@ static inline void tlb_flush_p4d_range(s
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
 		tlb_flush_pmd_range(tlb, address, PAGE_SIZE);	\
-		tlb->freed_tables = 1;				\
+		(tlb)->freed_tables = 1;			\
 		__pte_free_tlb(tlb, ptep, address);		\
 	} while (0)
 #endif
@@ -639,7 +639,7 @@ static inline void tlb_flush_p4d_range(s
 #define pmd_free_tlb(tlb, pmdp, address)			\
 	do {							\
 		tlb_flush_pud_range(tlb, address, PAGE_SIZE);	\
-		tlb->freed_tables = 1;				\
+		(tlb)->freed_tables = 1;			\
 		__pmd_free_tlb(tlb, pmdp, address);		\
 	} while (0)
 #endif
@@ -648,7 +648,7 @@ static inline void tlb_flush_p4d_range(s
 #define pud_free_tlb(tlb, pudp, address)			\
 	do {							\
 		tlb_flush_p4d_range(tlb, address, PAGE_SIZE);	\
-		tlb->freed_tables = 1;				\
+		(tlb)->freed_tables = 1;			\
 		__pud_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif
@@ -657,7 +657,7 @@ static inline void tlb_flush_p4d_range(s
 #define p4d_free_tlb(tlb, pudp, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address, PAGE_SIZE);	\
-		tlb->freed_tables = 1;				\
+		(tlb)->freed_tables = 1;			\
 		__p4d_free_tlb(tlb, pudp, address);		\
 	} while (0)
 #endif
_

Patches currently in -mm which might be from jannh@google.com are

mm-khugepaged-take-the-right-locks-for-page-table-retraction.patch
mmu_gather-use-macro-arguments-more-carefully.patch
mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather.patch
mm-khugepaged-invoke-mmu-notifiers-in-shmem-file-collapse-paths.patch

