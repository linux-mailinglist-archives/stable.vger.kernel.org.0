Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADD6564A59
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 00:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiGCWnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 18:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiGCWnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 18:43:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F176B1F;
        Sun,  3 Jul 2022 15:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04334B80909;
        Sun,  3 Jul 2022 22:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58FBC341C6;
        Sun,  3 Jul 2022 22:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656888226;
        bh=INQfb09ZlAmk39s9Nui8T3H1hzg3QVbA4X29QJKYvs8=;
        h=Date:To:From:Subject:From;
        b=2L1cQWeigB+hzdUiTWWgFseEi4OQYIeYFxgSsIIPqSoA10iDFbFVEYOYrPyQPmwTX
         EQ/n0c+cv7PdpEsaSF3GIxq9yKz69KO5UG57fbzn0ZhCaXFGm35On+DubXWuGSidmy
         Bx4RuPr0LUICEJaIbZMAwnKk/lx/olxppAve4bwk=
Date:   Sun, 03 Jul 2022 15:43:46 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, sj@kernel.org, mike.kravetz@oracle.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-use-set_huge_pte_at-to-make-huge-pte-old.patch removed from -mm tree
Message-Id: <20220703224346.B58FBC341C6@smtp.kernel.org>
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
     Subject: mm/damon: use set_huge_pte_at() to make huge pte old
has been removed from the -mm tree.  Its filename was
     mm-damon-use-set_huge_pte_at-to-make-huge-pte-old.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/damon: use set_huge_pte_at() to make huge pte old
Date: Mon, 20 Jun 2022 10:34:42 +0800

The huge_ptep_set_access_flags() can not make the huge pte old according
to the discussion [1], that means we will always mornitor the young state
of the hugetlb though we stopped accessing the hugetlb, as a result DAMON
will get inaccurate accessing statistics.

So changing to use set_huge_pte_at() to make the huge pte old to fix this
issue.

[1] https://lore.kernel.org/all/Yqy97gXI4Nqb7dYo@arm.com/

Link: https://lkml.kernel.org/r/1655692482-28797-1-git-send-email-baolin.wang@linux.alibaba.com
Fixes: 49f4203aae06 ("mm/damon: add access checking for hugetlb pages")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-use-set_huge_pte_at-to-make-huge-pte-old
+++ a/mm/damon/vaddr.c
@@ -336,8 +336,7 @@ static void damon_hugetlb_mkold(pte_t *p
 	if (pte_young(entry)) {
 		referenced = true;
 		entry = pte_mkold(entry);
-		huge_ptep_set_access_flags(vma, addr, pte, entry,
-					   vma->vm_flags & VM_WRITE);
+		set_huge_pte_at(mm, addr, pte, entry);
 	}
 
 #ifdef CONFIG_MMU_NOTIFIER
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch
mm-rmap-simplify-the-hugetlb-handling-when-unmapping-or-migration.patch
arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch
arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix.patch

