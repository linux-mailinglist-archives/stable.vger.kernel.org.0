Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFBB1A3FA2
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgDJDuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgDJDuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:50:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1625220BED;
        Fri, 10 Apr 2020 03:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490615;
        bh=vSXvfk+ZBHDHOnvNignHEMR/sPicw9FxaumxDke6jfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRXEZB6hA5Kl3aDgzxY7FqtMlqd+4HH8MAvQyMG3SIRJvZpROlfMhHCMG4YS3irXy
         Bgph8WJ8vGH12eMzEE3w8HbfOGYOvkN+/QjXF21PYoT6HqModcDK9S9mM/tVTiwIP3
         kaVYdT7qXZM/nn5NvcFVsrwDpaoZAhapT+GiAN10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Hellstrom <thellstrom@vmware.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 08/32] x86: Don't let pgprot_modify() change the page encryption bit
Date:   Thu,  9 Apr 2020 23:49:41 -0400
Message-Id: <20200410035005.9371-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410035005.9371-1-sashal@kernel.org>
References: <20200410035005.9371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

[ Upstream commit 6db73f17c5f155dbcfd5e48e621c706270b84df0 ]

When SEV or SME is enabled and active, vm_get_page_prot() typically
returns with the encryption bit set. This means that users of
pgprot_modify(, vm_get_page_prot()) (mprotect_fixup(), do_mmap()) end up
with a value of vma->vm_pg_prot that is not consistent with the intended
protection of the PTEs.

This is also important for fault handlers that rely on the VMA
vm_page_prot to set the page protection. Fix this by not allowing
pgprot_modify() to change the encryption bit, similar to how it's done
for PAT bits.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lkml.kernel.org/r/20200304114527.3636-2-thomas_os@shipmail.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pgtable.h       | 7 +++++--
 arch/x86/include/asm/pgtable_types.h | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 690c0307afed0..2e1ed12c65f82 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -608,12 +608,15 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 	return __pmd(val);
 }
 
-/* mprotect needs to preserve PAT bits when updating vm_page_prot */
+/*
+ * mprotect needs to preserve PAT and encryption bits when updating
+ * vm_page_prot
+ */
 #define pgprot_modify pgprot_modify
 static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 {
 	pgprotval_t preservebits = pgprot_val(oldprot) & _PAGE_CHG_MASK;
-	pgprotval_t addbits = pgprot_val(newprot);
+	pgprotval_t addbits = pgprot_val(newprot) & ~_PAGE_CHG_MASK;
 	return __pgprot(preservebits | addbits);
 }
 
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 106b7d0e2dae5..71ea49e7db747 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -124,7 +124,7 @@
  */
 #define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
 			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY |	\
-			 _PAGE_SOFT_DIRTY | _PAGE_DEVMAP)
+			 _PAGE_SOFT_DIRTY | _PAGE_DEVMAP | _PAGE_ENC)
 #define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE)
 
 /*
-- 
2.20.1

