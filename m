Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D361DF4F8
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 07:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387604AbgEWFXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 01:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387426AbgEWFXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 01:23:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BD4120759;
        Sat, 23 May 2020 05:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590211389;
        bh=g/DG0Q1vP/78so7jEV/MZHqyxIO+yDBIS8HFEnWDdcc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GXomZemswploVnapD2guWass1nun1A0sT02zHDrKW11CcWqaHKQopqRRz/xuqH4H4
         WdEtbolsckMeiHYpSBB1cWfFrEB3QiWGieTZiOIPXzR2HegIrbMFMM5wVVFDnqXLrO
         Aw1LGNbB6v/AmumYdMU/369PqdeqUnp3Xfazi/Tk=
Date:   Fri, 22 May 2020 22:23:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davem@davemloft.net, linux-mm@kvack.org,
        lkp@intel.com, matorola@gmail.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 09/11] sparc32: use PUD rather than PGD to get PMD
 in srmmu_nocache_init()
Message-ID: <20200523052309.4caVN81-C%akpm@linux-foundation.org>
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()

The kbuild test robot reported the following warning:

arch/sparc/mm/srmmu.c: In function 'srmmu_nocache_init':
>> arch/sparc/mm/srmmu.c:300:9: error: variable 'pud' set but not used
>> [-Werror=unused-but-set-variable]
300 |  pud_t *pud;

This warning is caused by misprint in the page table traversal in
srmmu_nocache_init() function which accessed a PMD entry using PGD rather
than PUD.

Since sparc32 has only 3 page table levels, the PGD and PUD are
essentially the same and usage of __nocache_fix() removed the type
checking.

Use PUD for the consistency and to silence the compiler warning.

Link: http://lkml.kernel.org/r/20200520132005.GM1059226@linux.ibm.com
Fixes: 7235db268a2777bc38 ("sparc32: use pgtable-nopud instead of 4level-fixup")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kbuild test robot <lkp@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anatoly Pugachev <matorola@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/srmmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/mm/srmmu.c~sparc32-use-pud-rather-than-pgd-to-get-pmd-in-srmmu_nocache_init
+++ a/arch/sparc/mm/srmmu.c
@@ -333,7 +333,7 @@ static void __init srmmu_nocache_init(vo
 		pgd = pgd_offset_k(vaddr);
 		p4d = p4d_offset(__nocache_fix(pgd), vaddr);
 		pud = pud_offset(__nocache_fix(p4d), vaddr);
-		pmd = pmd_offset(__nocache_fix(pgd), vaddr);
+		pmd = pmd_offset(__nocache_fix(pud), vaddr);
 		pte = pte_offset_kernel(__nocache_fix(pmd), vaddr);
 
 		pteval = ((paddr >> 4) | SRMMU_ET_PTE | SRMMU_PRIV);
_
