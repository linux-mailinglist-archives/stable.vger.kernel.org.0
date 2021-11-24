Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B048545BEFB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245420AbhKXMyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344291AbhKXMvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:51:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA1C26152B;
        Wed, 24 Nov 2021 12:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757003;
        bh=pZ4yCa9s6GHCd+RZNLKa6zvIXrNKpEr+EYjxFtPlmzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsBbjax/BOTAtWiAZmKar2uRNN8GNtAGlGMg2NI/TKcvX/0aoXZt4tuCbrdJKYP+W
         Xx+r3WCI8oPuLlOYpQHtfEhdgUHdB5OFVtXFNXEDZyp5r4hqlesTF0fgGM9rWcQcaY
         o0mR/NnVcheFF6uSYzsmANve19nr1rK2HBP2Ull4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 4.19 024/323] x86/sme: Use #define USE_EARLY_PGTABLE_L5 in mem_encrypt_identity.c
Date:   Wed, 24 Nov 2021 12:53:34 +0100
Message-Id: <20211124115719.683105577@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -29,6 +29,15 @@
 #undef CONFIG_PARAVIRT
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


