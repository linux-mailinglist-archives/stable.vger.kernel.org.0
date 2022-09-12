Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331A55B52D6
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 05:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiILDci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 23:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiILDah (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 23:30:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6D9F5B1;
        Sun, 11 Sep 2022 20:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D978661169;
        Mon, 12 Sep 2022 03:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C74AC433C1;
        Mon, 12 Sep 2022 03:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953377;
        bh=6R5mwzvO7OWFHz1BIwigDG8GJ04gn2lLzJgyI2uCb3Y=;
        h=Date:To:From:Subject:From;
        b=KZDXNBhfw8/QmOb7Smjt374BzqvX84+fqbk9jzgR3fCCFVL11Ejzrsdy87YEBYdCi
         qJyzfOG9sctdBbZeB1Qf90n4aTsfWc25+L61t9MR4pOE2b7DqyAetgB+wGXg5YF56i
         tRGEiIz6W8BZ5JpyU/x8oGXuA9xCxdXPNA7Dz/9k=
Date:   Sun, 11 Sep 2022 20:29:36 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, sj@kernel.org, mike.kravetz@oracle.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch removed from -mm tree
Message-Id: <20220912032937.3C74AC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: validate if the pmd entry is present before accessing
has been removed from the -mm tree.  Its filename was
     mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/damon: validate if the pmd entry is present before accessing
Date: Thu, 18 Aug 2022 15:37:43 +0800

pmd_huge() is used to validate if the pmd entry is mapped by a huge page,
also including the case of non-present (migration or hwpoisoned) pmd entry
on arm64 or x86 architectures.  This means that pmd_pfn() can not get the
correct pfn number for a non-present pmd entry, which will cause
damon_get_page() to get an incorrect page struct (also may be NULL by
pfn_to_online_page()), making the access statistics incorrect.

This means that the DAMON may make incorrect decision according to the
incorrect statistics, for example, DAMON may can not reclaim cold page
in time due to this cold page was regarded as accessed mistakenly if
DAMOS_PAGEOUT operation is specified.

Moreover it does not make sense that we still waste time to get the page
of the non-present entry.  Just treat it as not-accessed and skip it,
which maintains consistency with non-present pte level entries.

So add pmd entry present validation to fix the above issues.

Link: https://lkml.kernel.org/r/58b1d1f5fbda7db49ca886d9ef6783e3dcbbbc98.1660805030.git.baolin.wang@linux.alibaba.com
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-validate-if-the-pmd-entry-is-present-before-accessing
+++ a/mm/damon/vaddr.c
@@ -304,6 +304,11 @@ static int damon_mkold_pmd_entry(pmd_t *
 
 	if (pmd_huge(*pmd)) {
 		ptl = pmd_lock(walk->mm, pmd);
+		if (!pmd_present(*pmd)) {
+			spin_unlock(ptl);
+			return 0;
+		}
+
 		if (pmd_huge(*pmd)) {
 			damon_pmdp_mkold(pmd, walk->mm, addr);
 			spin_unlock(ptl);
@@ -431,6 +436,11 @@ static int damon_young_pmd_entry(pmd_t *
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_huge(*pmd)) {
 		ptl = pmd_lock(walk->mm, pmd);
+		if (!pmd_present(*pmd)) {
+			spin_unlock(ptl);
+			return 0;
+		}
+
 		if (!pmd_huge(*pmd)) {
 			spin_unlock(ptl);
 			goto regular_page;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page.patch
mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch

