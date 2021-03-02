Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD8832B004
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhCCAaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350757AbhCBMub (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:50:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EACC664F8E;
        Tue,  2 Mar 2021 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686292;
        bh=Da2w0Gzz+DvdIC28O5XHDcst4j8QW91mF7nrsHEWCi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b26bCSnzgL8rDyrnsNsUXJ32Lfg9MUdcLPtLULG9RwuRkGBJdje8Rtq8ElYQ75Ui1
         xH48XzByXXRkoN2YtHYziHHXxGxvhP12jBPKF7jQyiurmMYVh43Y4Qc6+wMHyW7qQE
         yvUR/sWY+8sfHWiftKkgaS5v2gttJ1CEDCeBMm0WJpDekUpkYzdRpVnIAHeV4dZqgD
         TFK7fHrM2FlDbr/alaRCpB8P1L2drT2BWuv5oYqXpGH3sVm+Glgrdu7zjA2KQ1xtxR
         J/NGqDFtnTp5CFHLwGXLB9ebTMwM3YoQAA8h3uyn7ZUD2N20l9pEJJOY9+SAjjlP3T
         eXNAmoOF/qddw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khalid Aziz <khalid.aziz@oracle.com>, Jann Horn <jannh@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/33] sparc64: Use arch_validate_flags() to validate ADI flag
Date:   Tue,  2 Mar 2021 06:57:33 -0500
Message-Id: <20210302115749.62653-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115749.62653-1-sashal@kernel.org>
References: <20210302115749.62653-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khalid Aziz <khalid.aziz@oracle.com>

[ Upstream commit 147d8622f2a26ef34beacc60e1ed8b66c2fa457f ]

When userspace calls mprotect() to enable ADI on an address range,
do_mprotect_pkey() calls arch_validate_prot() to validate new
protection flags. arch_validate_prot() for sparc looks at the first
VMA associated with address range to verify if ADI can indeed be
enabled on this address range. This has two issues - (1) Address
range might cover multiple VMAs while arch_validate_prot() looks at
only the first VMA, (2) arch_validate_prot() peeks at VMA without
holding mmap lock which can result in race condition.

arch_validate_flags() from commit c462ac288f2c ("mm: Introduce
arch_validate_flags()") allows for VMA flags to be validated for all
VMAs that cover the address range given by user while holding mmap
lock. This patch updates sparc code to move the VMA check from
arch_validate_prot() to arch_validate_flags() to fix above two
issues.

Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/mman.h | 54 +++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/arch/sparc/include/asm/mman.h b/arch/sparc/include/asm/mman.h
index f94532f25db1..274217e7ed70 100644
--- a/arch/sparc/include/asm/mman.h
+++ b/arch/sparc/include/asm/mman.h
@@ -57,35 +57,39 @@ static inline int sparc_validate_prot(unsigned long prot, unsigned long addr)
 {
 	if (prot & ~(PROT_READ | PROT_WRITE | PROT_EXEC | PROT_SEM | PROT_ADI))
 		return 0;
-	if (prot & PROT_ADI) {
-		if (!adi_capable())
-			return 0;
+	return 1;
+}
 
-		if (addr) {
-			struct vm_area_struct *vma;
+#define arch_validate_flags(vm_flags) arch_validate_flags(vm_flags)
+/* arch_validate_flags() - Ensure combination of flags is valid for a
+ *	VMA.
+ */
+static inline bool arch_validate_flags(unsigned long vm_flags)
+{
+	/* If ADI is being enabled on this VMA, check for ADI
+	 * capability on the platform and ensure VMA is suitable
+	 * for ADI
+	 */
+	if (vm_flags & VM_SPARC_ADI) {
+		if (!adi_capable())
+			return false;
 
-			vma = find_vma(current->mm, addr);
-			if (vma) {
-				/* ADI can not be enabled on PFN
-				 * mapped pages
-				 */
-				if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
-					return 0;
+		/* ADI can not be enabled on PFN mapped pages */
+		if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
+			return false;
 
-				/* Mergeable pages can become unmergeable
-				 * if ADI is enabled on them even if they
-				 * have identical data on them. This can be
-				 * because ADI enabled pages with identical
-				 * data may still not have identical ADI
-				 * tags on them. Disallow ADI on mergeable
-				 * pages.
-				 */
-				if (vma->vm_flags & VM_MERGEABLE)
-					return 0;
-			}
-		}
+		/* Mergeable pages can become unmergeable
+		 * if ADI is enabled on them even if they
+		 * have identical data on them. This can be
+		 * because ADI enabled pages with identical
+		 * data may still not have identical ADI
+		 * tags on them. Disallow ADI on mergeable
+		 * pages.
+		 */
+		if (vm_flags & VM_MERGEABLE)
+			return false;
 	}
-	return 1;
+	return true;
 }
 #endif /* CONFIG_SPARC64 */
 
-- 
2.30.1

