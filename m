Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60C05DBCD
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfGCCSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbfGCCSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:18:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8251C21873;
        Wed,  3 Jul 2019 02:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120309;
        bh=6hQsemkxImaDJCUqYWKffBbCMlJUrsMfuYi1mxHeXl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tn/qju4QJdXXsLu1kSF63L9bDgzzLkg7+hU5953GEVOVqemSe0mdSR2H2ifhAZKfQ
         wG54wd5ZDN/K8iB7oLVTJoz2cDq4nWDIHwbFpg/TRMhshbX+T1N3M661LGY+ANn3nP
         RguqY3rnDvXuwn36JAY2TRT1UulUBiFHDfCHK+IM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 11/13] x86/boot/64: Fix crash if kernel image crosses page table boundary
Date:   Tue,  2 Jul 2019 22:18:12 -0400
Message-Id: <20190703021814.18385-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021814.18385-1-sashal@kernel.org>
References: <20190703021814.18385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

[ Upstream commit 81c7ed296dcd02bc0b4488246d040e03e633737a ]

A kernel which boots in 5-level paging mode crashes in a small percentage
of cases if KASLR is enabled.

This issue was tracked down to the case when the kernel image unpacks in a
way that it crosses an 1G boundary. The crash is caused by an overrun of
the PMD page table in __startup_64() and corruption of P4D page table
allocated next to it. This particular issue is not visible with 4-level
paging as P4D page tables are not used.

But the P4D and the PUD calculation have similar problems.

The PMD index calculation is wrong due to operator precedence, which fails
to confine the PMDs in the PMD array on wrap around.

The P4D calculation for 5-level paging and the PUD calculation calculate
the first index correctly, but then blindly increment it which causes the
same issue when a kernel image is located across a 512G and for 5-level
paging across a 46T boundary.

This wrap around mishandling was introduced when these parts moved from
assembly to C.

Restore it to the correct behaviour.

Fixes: c88d71508e36 ("x86/boot/64: Rewrite startup_64() in C")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20190620112345.28833-1-kirill.shutemov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/head64.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 45b5c6c4a55e..7c67d8939f3e 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -117,26 +117,27 @@ unsigned long __head __startup_64(unsigned long physaddr,
 		pgd[i + 0] = (pgdval_t)p4d + pgtable_flags;
 		pgd[i + 1] = (pgdval_t)p4d + pgtable_flags;
 
-		i = (physaddr >> P4D_SHIFT) % PTRS_PER_P4D;
-		p4d[i + 0] = (pgdval_t)pud + pgtable_flags;
-		p4d[i + 1] = (pgdval_t)pud + pgtable_flags;
+		i = physaddr >> P4D_SHIFT;
+		p4d[(i + 0) % PTRS_PER_P4D] = (pgdval_t)pud + pgtable_flags;
+		p4d[(i + 1) % PTRS_PER_P4D] = (pgdval_t)pud + pgtable_flags;
 	} else {
 		i = (physaddr >> PGDIR_SHIFT) % PTRS_PER_PGD;
 		pgd[i + 0] = (pgdval_t)pud + pgtable_flags;
 		pgd[i + 1] = (pgdval_t)pud + pgtable_flags;
 	}
 
-	i = (physaddr >> PUD_SHIFT) % PTRS_PER_PUD;
-	pud[i + 0] = (pudval_t)pmd + pgtable_flags;
-	pud[i + 1] = (pudval_t)pmd + pgtable_flags;
+	i = physaddr >> PUD_SHIFT;
+	pud[(i + 0) % PTRS_PER_PUD] = (pudval_t)pmd + pgtable_flags;
+	pud[(i + 1) % PTRS_PER_PUD] = (pudval_t)pmd + pgtable_flags;
 
 	pmd_entry = __PAGE_KERNEL_LARGE_EXEC & ~_PAGE_GLOBAL;
 	pmd_entry += sme_get_me_mask();
 	pmd_entry +=  physaddr;
 
 	for (i = 0; i < DIV_ROUND_UP(_end - _text, PMD_SIZE); i++) {
-		int idx = i + (physaddr >> PMD_SHIFT) % PTRS_PER_PMD;
-		pmd[idx] = pmd_entry + i * PMD_SIZE;
+		int idx = i + (physaddr >> PMD_SHIFT);
+
+		pmd[idx % PTRS_PER_PMD] = pmd_entry + i * PMD_SIZE;
 	}
 
 	/*
-- 
2.20.1

