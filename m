Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED595332EA
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 23:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241897AbiEXVUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 17:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241900AbiEXVUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 17:20:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30A1579A7;
        Tue, 24 May 2022 14:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 840B3B81BA0;
        Tue, 24 May 2022 21:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F43C34100;
        Tue, 24 May 2022 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653427203;
        bh=SZmIGTQUGaqYt19ttS96E3Kca84+6BANmkzYj4lF1fo=;
        h=Date:To:From:Subject:From;
        b=VLkgiFld02i7dYe1twrmWKVn3sqr1Oc6evfsphuy1XnzohTjNKo1Cq1sXRkz/wjw5
         qlzvBSgVTpar8o4zAyD1du44Dv1G3U8RTBVSbhDEWGRmSlpe/PygWrg/y+YISSDRoE
         F53alb9dqWBIw1SnzGPYILjJrFL23RAFK/Jdrt/Q=
Date:   Tue, 24 May 2022 14:20:02 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-fix-huge_pmd_unshare-address-update.patch added to mm-hotfixes-unstable branch
Message-Id: <20220524212003.31F43C34100@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: fix huge_pmd_unshare address update
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-fix-huge_pmd_unshare-address-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-fix-huge_pmd_unshare-address-update.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix huge_pmd_unshare address update
Date: Tue, 24 May 2022 13:50:03 -0700

The routine huge_pmd_unshare() is passed a pointer to an address
associated with an area which may be unshared.  If unshare is successful
this address is updated to 'optimize' callers iterating over huge page
addresses.  For the optimization to work correctly, address should be
updated to the last huge page in the unmapped/unshared area.  However, in
the common case where the passed address is PUD_SIZE aligned, the address
is incorrectly updated to the address of the preceding huge page.  That
wastes CPU cycles as the unmapped/unshared range is scanned twice.

Link: https://lkml.kernel.org/r/20220524205003.126184-1-mike.kravetz@oracle.com
Fixes: 39dde65c9940 ("shared page table for hugetlb page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-fix-huge_pmd_unshare-address-update
+++ a/mm/hugetlb.c
@@ -6562,7 +6562,14 @@ int huge_pmd_unshare(struct mm_struct *m
 	pud_clear(pud);
 	put_page(virt_to_page(ptep));
 	mm_dec_nr_pmds(mm);
-	*addr = ALIGN(*addr, HPAGE_SIZE * PTRS_PER_PTE) - HPAGE_SIZE;
+	/*
+	 * This update of passed address optimizes loops sequentially
+	 * processing addresses in increments of huge page size (PMD_SIZE
+	 * in this case).  By clearing the pud, a PUD_SIZE area is unmapped.
+	 * Update address to the 'last page' in the cleared area so that
+	 * calling loop can move to first page past this area.
+	 */
+	*addr |= PUD_SIZE - PMD_SIZE;
 	return 1;
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-fix-huge_pmd_unshare-address-update.patch

