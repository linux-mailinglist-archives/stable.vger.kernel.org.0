Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955E52E6778
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgL1QZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbgL1NJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:09:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF3FF2076D;
        Mon, 28 Dec 2020 13:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160938;
        bh=jlEoGlvam1dqY/S4LvxCZltUWdzE35GaNWLiSc1IZGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsuW50L1PF+T6Jzaw+/OguA3E/UleUobvvvCaJJP3hzDawtRRCDulVb6zMlnn2DiR
         zkcGbWAwCybVqSv5QmLW2FMmLlVIyKGcurvYL3n50SgxOBVp3jNDtzK+wNLsV6hhb5
         hk+PVNmfjN04/X0WoeCtiQnIovVEI+v1AySVi/Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 4.14 015/242] x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP
Date:   Mon, 28 Dec 2020 13:47:00 +0100
Message-Id: <20201228124905.415751134@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

commit 29ac40cbed2bc06fa218ca25d7f5e280d3d08a25 upstream.

The PAT bit is in different locations for 4k and 2M/1G page table
entries.

Add a definition for _PAGE_LARGE_CACHE_MASK to represent the three
caching bits (PWT, PCD, PAT), similar to _PAGE_CACHE_MASK for 4k pages,
and use it in the definition of PMD_FLAGS_DEC_WP to get the correct PAT
index for write-protected pages.

Fixes: 6ebcb060713f ("x86/mm: Add support to encrypt the kernel in-place")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201111160946.147341-1-nivedita@alum.mit.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/mm/mem_encrypt.c            |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -148,6 +148,7 @@ enum page_cache_mode {
 #endif
 
 #define _PAGE_CACHE_MASK	(_PAGE_PAT | _PAGE_PCD | _PAGE_PWT)
+#define _PAGE_LARGE_CACHE_MASK	(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT_LARGE)
 #define _PAGE_NOCACHE		(cachemode2protval(_PAGE_CACHE_MODE_UC))
 #define _PAGE_CACHE_WP		(cachemode2protval(_PAGE_CACHE_MODE_WP))
 
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -248,8 +248,8 @@ static void __init sme_clear_pgd(struct
 #define PMD_FLAGS_LARGE		(__PAGE_KERNEL_LARGE_EXEC & ~_PAGE_GLOBAL)
 
 #define PMD_FLAGS_DEC		PMD_FLAGS_LARGE
-#define PMD_FLAGS_DEC_WP	((PMD_FLAGS_DEC & ~_PAGE_CACHE_MASK) | \
-				 (_PAGE_PAT | _PAGE_PWT))
+#define PMD_FLAGS_DEC_WP	((PMD_FLAGS_DEC & ~_PAGE_LARGE_CACHE_MASK) | \
+				 (_PAGE_PAT_LARGE | _PAGE_PWT))
 
 #define PMD_FLAGS_ENC		(PMD_FLAGS_LARGE | _PAGE_ENC)
 


