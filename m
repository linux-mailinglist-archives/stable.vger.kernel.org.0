Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF0D5FEF8B
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiJNOBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 10:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiJNOBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 10:01:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9DCC7044;
        Fri, 14 Oct 2022 07:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36521CE2664;
        Fri, 14 Oct 2022 13:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8C0C433D6;
        Fri, 14 Oct 2022 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755700;
        bh=hYbyl7EMfe0bnqNXOD0lVeI25wCK+h+XO7/dvfni/Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0qCU3imW00BiOheqHPzWFbOwWKDuNBdnYUjnSYacBkoTImtIEi9ZzpScEE/GF8c6
         Y9YiBuJlavE3FcpXdJ4FRUhTYn0PmJ2tHCFs/SmUYurbO1dsRKM/Pa4I6eUPxvog8E
         yyiDQdcwxjkBSu1ATDbtiQ1HWIkP0ugLuFY0isUbr4w9ABpdE5CQd5owVeOFiuKNVr
         l0QV++34gj66D1NNFWa4H4q2lxiR+9xL3oD6otdF1WtRtbAjYZJ1Y075A4XGbLKw8N
         pKaeavqG1n62DcYr2qstixctxql3J99pwTO3Sxx4OD/u0sVh379u4hx35lA13guavC
         Kb3aLB9cTJEGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        npiggin@gmail.com, yaozhenguo1@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 4/4] powerpc/mm: Fix UBSAN warning reported on hugetlb
Date:   Fri, 14 Oct 2022 09:54:47 -0400
Message-Id: <20221014135448.2110152-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135448.2110152-1-sashal@kernel.org>
References: <20221014135448.2110152-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit 7dd3a7b90bca2c12e2146a47d63cf69a2f5d7e89 ]

Powerpc architecture supports 16GB hugetlb pages with hash translation.
For 4K page size, this is implemented as a hugepage directory entry at
PGD level and for 64K it is implemented as a huge page pte at PUD level

With 16GB hugetlb size, offset within a page is greater than 32 bits.
Hence switch to use unsigned long type when using hugepd_shift.

In order to keep things simpler, we make sure we always use unsigned
long type when using hugepd_shift() even though all the hugetlb page
size won't require that.

The hugetlb_free_p*d_range changes are all related to nohash usage where
we can have multiple pgd entries pointing to the same hugepd entries.
Hence on book3s64 where we can have > 4GB hugetlb page size we will
always find more < next even if we compute the value of more correctly.

Hence there is no functional change in this patch except that it fixes
the below warning.

  UBSAN: shift-out-of-bounds in arch/powerpc/mm/hugetlbpage.c:499:21
  shift exponent 34 is too large for 32-bit type 'int'
  CPU: 39 PID: 1673 Comm: a.out Not tainted 6.0.0-rc2-00327-gee88a56e8517-dirty #1
  Call Trace:
    dump_stack_lvl+0x98/0xe0 (unreliable)
    ubsan_epilogue+0x18/0x70
    __ubsan_handle_shift_out_of_bounds+0x1bc/0x390
    hugetlb_free_pgd_range+0x5d8/0x600
    free_pgtables+0x114/0x290
    exit_mmap+0x150/0x550
    mmput+0xcc/0x210
    do_exit+0x420/0xdd0
    do_group_exit+0x4c/0xd0
    sys_exit_group+0x24/0x30
    system_call_exception+0x250/0x600
    system_call_common+0xec/0x250

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
[mpe: Drop generic change to be sent separately, change 1ULL to 1UL]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220908072440.258301-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/hugetlbpage.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index e2d929ddad7f..ae8278dc1e30 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -363,7 +363,7 @@ static void hugetlb_free_pmd_range(struct mmu_gather *tlb, pud_t *pud,
 		 * single hugepage, but all of them point to
 		 * the same kmem cache that holds the hugepte.
 		 */
-		more = addr + (1 << hugepd_shift(*(hugepd_t *)pmd));
+		more = addr + (1UL << hugepd_shift(*(hugepd_t *)pmd));
 		if (more > next)
 			next = more;
 
@@ -413,7 +413,7 @@ static void hugetlb_free_pud_range(struct mmu_gather *tlb, pgd_t *pgd,
 			 * single hugepage, but all of them point to
 			 * the same kmem cache that holds the hugepte.
 			 */
-			more = addr + (1 << hugepd_shift(*(hugepd_t *)pud));
+			more = addr + (1UL << hugepd_shift(*(hugepd_t *)pud));
 			if (more > next)
 				next = more;
 
@@ -480,7 +480,7 @@ void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 			 * for a single hugepage, but all of them point to the
 			 * same kmem cache that holds the hugepte.
 			 */
-			more = addr + (1 << hugepd_shift(*(hugepd_t *)pgd));
+			more = addr + (1UL << hugepd_shift(*(hugepd_t *)pgd));
 			if (more > next)
 				next = more;
 
-- 
2.35.1

