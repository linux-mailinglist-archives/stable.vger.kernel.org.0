Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25426C85F8
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 20:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCXT2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 15:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjCXT2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 15:28:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4803A1BF;
        Fri, 24 Mar 2023 12:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D946862C6A;
        Fri, 24 Mar 2023 19:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3B2C433D2;
        Fri, 24 Mar 2023 19:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679686077;
        bh=NYA/ypeeAcEOPXKAoqmtxh5c/9Q4S1tB4PaXSKuTbuY=;
        h=Date:To:From:Subject:From;
        b=r+I3FpSuY+AWzT20DtXLJBpJpSvIv1GzFMWGA4fRWINSS4B54oANUvcu3W2zi72UM
         FocGSjjWjdXXgSWa42ekaaaJSTfYVG+Alua0TnQ0WZZyD1JZyejDFVQP3smj5Y40CE
         FqUbOiNQLDLRNFCCBojygOcqnyQaLyaQYKCUWaS0=
Date:   Fri, 24 Mar 2023 12:27:56 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        stable@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20230324192757.3B3B2C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3
Date: Fri, 24 Mar 2023 10:26:20 -0400

Link: https://lkml.kernel.org/r/20230324142620.2344140-1-peterx@redhat.com
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-stable <stable@vger.kernel.org>
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3
+++ a/mm/hugetlb.c
@@ -5491,11 +5491,11 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	 * Never handle CoW for uffd-wp protected pages.  It should be only
 	 * handled when the uffd-wp protection is removed.
 	 *
-	 * Note that only the CoW optimization path can trigger this and
-	 * got skipped, because hugetlb_fault() will always resolve uffd-wp
-	 * bit first.
+	 * Note that only the CoW optimization path (in hugetlb_no_page())
+	 * can trigger this, because hugetlb_fault() will always resolve
+	 * uffd-wp bit first.
 	 */
-	if (huge_pte_uffd_wp(pte))
+	if (!unshare && huge_pte_uffd_wp(pte))
 		return 0;
 
 	/*
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch

