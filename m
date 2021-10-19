Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0F543372B
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 15:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbhJSNik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 09:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhJSNik (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 09:38:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283B5C06161C;
        Tue, 19 Oct 2021 06:36:26 -0700 (PDT)
Date:   Tue, 19 Oct 2021 13:36:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634650585;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H9vpxmc3uoQ8BzIH6Nuu1RVcNf73jIVZb5PSf9M3I+k=;
        b=sXycVEHeQCfBmTUNG9uBHQULwgUIT6TzsDn3MdPw7ZeBe7gkKpVOPJxivGWQsc4YXoVlUM
        9f5X6dB3/OBQRsnzKJJTkdURUJTTIwDfetxoY7E0z7uaoj2RgOTw4Nt4+ncaAw9AMfIzrp
        ypJxnnT04TlnAEmqV9iDa9zwQjXCnkt4iSBuAR/nJo+kGEaZ9jiFdV9xbAYZUPZ9zlYzlf
        zrXeH7ZUqpjjSoXLjYH4geMO/QDCCsL2YSdfPq62Qceke6AZwBZ5lzxmXjoIrVzLjSABHW
        rtBUF2BJ5mKbJjb9QvDMFwO1vI7UabSJ6woJi5sJenu5C5iHwTquGjG9TvYUEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634650585;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H9vpxmc3uoQ8BzIH6Nuu1RVcNf73jIVZb5PSf9M3I+k=;
        b=+dh2SRXsJDtKxX9us6obRvON0aD2CJ32gl4cQZ4weOkgN8WMeJMmzyvAdZV1VSvSEK3Urx
        Jl4eJUEX7kF1ImCg==
From:   "tip-bot2 for Tom Lendacky" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/sev] x86/sme: Use #define USE_EARLY_PGTABLE_L5 in
 mem_encrypt_identity.c
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C2cb8329655f5c753905812d951e212022a480475=2E16343?=
 =?utf-8?q?18656=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
References: =?utf-8?q?=3C2cb8329655f5c753905812d951e212022a480475=2E163431?=
 =?utf-8?q?8656=2Egit=2Ethomas=2Elendacky=40amd=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <163465058366.25758.3434027960137456326.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/sev branch of tip:

Commit-ID:     e7d445ab26db833d6640d4c9a08bee176777cc82
Gitweb:        https://git.kernel.org/tip/e7d445ab26db833d6640d4c9a08bee176777cc82
Author:        Tom Lendacky <thomas.lendacky@amd.com>
AuthorDate:    Fri, 15 Oct 2021 12:24:16 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 19 Oct 2021 14:07:17 +02:00

x86/sme: Use #define USE_EARLY_PGTABLE_L5 in mem_encrypt_identity.c

When runtime support for converting between 4-level and 5-level pagetables
was added to the kernel, the SME code that built pagetables was updated
to use the pagetable functions, e.g. p4d_offset(), etc., in order to
simplify the code. However, the use of the pagetable functions in early
boot code requires the use of the USE_EARLY_PGTABLE_L5 #define in order to
ensure that the proper definition of pgtable_l5_enabled() is used.

Without the #define, pgtable_l5_enabled() is #defined as
cpu_feature_enabled(X86_FEATURE_LA57). In early boot, the CPU features
have not yet been discovered and populated, so pgtable_l5_enabled() will
return false even when 5-level paging is enabled. This causes the SME code
to always build 4-level pagetables to perform the in-place encryption.
If 5-level paging is enabled, switching to the SME pagetables results in
a page-fault that kills the boot.

Adding the #define results in pgtable_l5_enabled() using the
__pgtable_l5_enabled variable set in early boot and the SME code building
pagetables for the proper paging level.

Fixes: aad983913d77 ("x86/mm/encrypt: Simplify sme_populate_pgd() and sme_populate_pgd_large()")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org> # 4.18.x
Link: https://lkml.kernel.org/r/2cb8329655f5c753905812d951e212022a480475.1634318656.git.thomas.lendacky@amd.com
---
 arch/x86/mm/mem_encrypt_identity.c |  9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 470b202..700ce8f 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -27,6 +27,15 @@
 #undef CONFIG_PARAVIRT_XXL
 #undef CONFIG_PARAVIRT_SPINLOCKS
 
+/*
+ * This code runs before CPU feature bits are set. By default, the
+ * pgtable_l5_enabled() function uses bit X86_FEATURE_LA57 to determine if
+ * 5-level paging is active, so that won't work here. USE_EARLY_PGTABLE_L5
+ * is provided to handle this situation and, instead, use a variable that
+ * has been set by the early boot code.
+ */
+#define USE_EARLY_PGTABLE_L5
+
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
