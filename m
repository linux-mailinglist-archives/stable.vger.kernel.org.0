Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5B81199F8
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbfLJVsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:48:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbfLJVI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D87C246A2;
        Tue, 10 Dec 2019 21:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012138;
        bh=IPISsr+p/bORCfOnSV6jSyXFJaecA7DIzkirlm7ZsDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLkCpXKLgb5t0yQS4Es2w/Pv22eroYASe9g3BVee9Pthdc/65HQNT90x88LcyooaZ
         FRnbaVSy9gtzsP82ttbE9zMFbzWpDGCBV4vsxP3oPY1kAO64Kl9Nu7o3xvr3KV3w+X
         uVgKXarCVjS72JL8NjE4Z2DWv+5K/GzArhH2EjMI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@surriel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 104/350] x86/mm: Use the correct function type for native_set_fixmap()
Date:   Tue, 10 Dec 2019 16:03:29 -0500
Message-Id: <20191210210735.9077-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit f53e2cd0b8ab7d9e390414470bdbd830f660133f ]

We call native_set_fixmap indirectly through the function pointer
struct pv_mmu_ops::set_fixmap, which expects the first parameter to be
'unsigned' instead of 'enum fixed_addresses'. This patch changes the
function type for native_set_fixmap to match the pointer, which fixes
indirect call mismatches with Control-Flow Integrity (CFI) checking.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H . Peter Anvin <hpa@zytor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190913211402.193018-1-samitolvanen@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/fixmap.h | 2 +-
 arch/x86/mm/pgtable.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 0c47aa82e2e22..28183ee3cc42a 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -156,7 +156,7 @@ extern pte_t *kmap_pte;
 extern pte_t *pkmap_page_table;
 
 void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
-void native_set_fixmap(enum fixed_addresses idx,
+void native_set_fixmap(unsigned /* enum fixed_addresses */ idx,
 		       phys_addr_t phys, pgprot_t flags);
 
 #ifndef CONFIG_PARAVIRT_XXL
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 3e4b9035bb9a8..7bd2c3a52297f 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -643,8 +643,8 @@ void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
 	fixmaps_set++;
 }
 
-void native_set_fixmap(enum fixed_addresses idx, phys_addr_t phys,
-		       pgprot_t flags)
+void native_set_fixmap(unsigned /* enum fixed_addresses */ idx,
+		       phys_addr_t phys, pgprot_t flags)
 {
 	/* Sanitize 'prot' against any unsupported bits: */
 	pgprot_val(flags) &= __default_kernel_pte_mask;
-- 
2.20.1

