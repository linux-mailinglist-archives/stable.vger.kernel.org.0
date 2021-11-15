Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5D1451313
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344329AbhKOTpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:45:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245329AbhKOTUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E13763461;
        Mon, 15 Nov 2021 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001161;
        bh=Ko5D5mV1DDGZ+ZCRNSmh6+HpGcoSQ6mZgJejfpXHfCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgN6XeFU5xhePPKUg9l8yhoE4YrV+5hxJIyeR1xoMm3zabw39B7LU5HvUPTOSTjji
         PLbmf0OCuRppRq6LTrFW228sOm/FOGgnqawnarDv1pnJa/V3Oei0v+v9bPLQGw9tlr
         CrGBiEP0HBVk/fOmipBDdrFoLOyEXNqBslSwWWk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 5.15 057/917] x86/sme: Use #define USE_EARLY_PGTABLE_L5 in mem_encrypt_identity.c
Date:   Mon, 15 Nov 2021 17:52:32 +0100
Message-Id: <20211115165430.701868352@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit e7d445ab26db833d6640d4c9a08bee176777cc82 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/mem_encrypt_identity.c |    9 +++++++++
 1 file changed, 9 insertions(+)

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


