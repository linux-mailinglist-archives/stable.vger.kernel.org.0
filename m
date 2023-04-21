Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E9F6EB3F4
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 23:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjDUVzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 17:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjDUVzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 17:55:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A694210E6;
        Fri, 21 Apr 2023 14:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4275F60CFB;
        Fri, 21 Apr 2023 21:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972F1C433D2;
        Fri, 21 Apr 2023 21:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682114117;
        bh=P/AGfusnGXAfnbC4MzlAXXi1DzP3UAvyhhn7brScnwE=;
        h=Date:To:From:Subject:From;
        b=DCZTlF57UI/gz1XOUyf4bb/jm3ttPdrbNcfio5mUit7f1QjYiV4zdHy9qJEpyBkm1
         GFEcP8BO2gP+lHiZzJ6rk9opd2kE75l+NBsh27IdVsRFjQceLfczFvu7e2NZuMF+Tc
         VmMBfgFsqQMptOtgiqFJ6QgYNRZfyYWxxiOxcZjA=
Date:   Fri, 21 Apr 2023 14:55:16 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@kernel.org, mike.kravetz@oracle.com, ardb@kernel.org,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-fix-an-addr-to-taddr-in-huge_pte_offset.patch removed from -mm tree
Message-Id: <20230421215517.972F1C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: ia64: fix an addr to taddr in huge_pte_offset()
has been removed from the -mm tree.  Its filename was
     ia64-fix-an-addr-to-taddr-in-huge_pte_offset.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ia64: fix an addr to taddr in huge_pte_offset()
Date: Sun, 16 Apr 2023 22:17:05 -0700 (PDT)

I know nothing of ia64 htlbpage_to_page(), but guess that the p4d
line should be using taddr rather than addr, like everywhere else.

Link: https://lkml.kernel.org/r/732eae88-3beb-246-2c72-281de786740@google.com
Fixes: c03ab9e32a2c ("ia64: add support for folded p4d page tables")
Signed-off-by: Hugh Dickins <hughd@google.com
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/mm/hugetlbpage.c~ia64-fix-an-addr-to-taddr-in-huge_pte_offset
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -58,7 +58,7 @@ huge_pte_offset (struct mm_struct *mm, u
 
 	pgd = pgd_offset(mm, taddr);
 	if (pgd_present(*pgd)) {
-		p4d = p4d_offset(pgd, addr);
+		p4d = p4d_offset(pgd, taddr);
 		if (p4d_present(*p4d)) {
 			pud = pud_offset(p4d, taddr);
 			if (pud_present(*pud)) {
_

Patches currently in -mm which might be from hughd@google.com are


