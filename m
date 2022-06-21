Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9938553EEA
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 01:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355172AbiFUX2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 19:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353746AbiFUX2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 19:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529F6656E;
        Tue, 21 Jun 2022 16:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC363615AB;
        Tue, 21 Jun 2022 23:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69365C3411C;
        Tue, 21 Jun 2022 23:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655854087;
        bh=MLCTqfOs6yAgR0NZ52fYuUxM9X9CcUe4vvLHeay2chU=;
        h=Date:To:From:Subject:From;
        b=XQBznSr1B1q2+dQhUabNmEz+3G227xzesdKCZv7aKPRH8frJBkySHRTkIa2GliAil
         HyvEzAqq1+SlNWppWrLCDUUtWvcJxlufz7bGwMN4GaJRLEJGzsO5kB9Ys2vhCHwx2K
         Z8Ha6szPGbCtoQwvqekWgLAtNUnMXhBzWcJwc/lQ=
Date:   Tue, 21 Jun 2022 16:27:59 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-use-set_huge_pte_at-to-make-huge-pte-old.patch added to mm-hotfixes-unstable branch
Message-Id: <20220621232806.69365C3411C@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon: use set_huge_pte_at() to make huge pte old
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-use-set_huge_pte_at-to-make-huge-pte-old.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-use-set_huge_pte_at-to-make-huge-pte-old.patch

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

mm-damon-use-set_huge_pte_at-to-make-huge-pte-old.patch
mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch
mm-rmap-simplify-the-hugetlb-handling-when-unmapping-or-migration.patch

