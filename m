Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBA72D5996
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 12:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388030AbgLJLpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 06:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732885AbgLJLo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 06:44:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8E8C061793;
        Thu, 10 Dec 2020 03:44:17 -0800 (PST)
Date:   Thu, 10 Dec 2020 11:44:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607600655;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9ZggfT5Wgyj7L/mvbAGMIlzUrXCA6F2CAUaSPt1KRk=;
        b=sQazjDxRl4zrmcSkTN6t0Cq12Xf0nBHgnx47vuHxCTeqmrSdzAj4eVCyrXIL1kqHAFbQxy
        mwDMZoYUVOKSzpcMXUM3i1OTfxbjsf0BEfC6uxoRifFSE4ThVzDF14051AR5zhnvfDRmp6
        AZtMaJ/Y3yIqWQUubL+snCbJsoCWtn69IDZauWUeqePnBf0936u7simHU+RUDOe1j6lE7y
        9CR0HPKZAD/sWvF999z9HLK1w9slJlt/uq7ggJYbrdS49ELT8ScCihZXwT+IhOU/d15djY
        6KWKu0cvEVYmbDQZR3DCIr8wmd/DzqvnrPK0hykcS5g/yWixcnzotcT9dMpaiA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607600655;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9ZggfT5Wgyj7L/mvbAGMIlzUrXCA6F2CAUaSPt1KRk=;
        b=mGis3PyEnW+8c6X7LJ725VABMZEi9+mIMLv7Or+XM/YLh0yp6IFycFmACAY5a4CVHMtVe+
        ZJP0vQNp7dlittAg==
From:   "tip-bot2 for Arvind Sankar" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20201111160946.147341-1-nivedita@alum.mit.edu>
References: <20201111160946.147341-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Message-ID: <160760065470.3364.9118672083291010559.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     29ac40cbed2bc06fa218ca25d7f5e280d3d08a25
Gitweb:        https://git.kernel.org/tip/29ac40cbed2bc06fa218ca25d7f5e280d3d08a25
Author:        Arvind Sankar <nivedita@alum.mit.edu>
AuthorDate:    Wed, 11 Nov 2020 11:09:45 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 10 Dec 2020 12:28:06 +01:00

x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP

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
---
 arch/x86/include/asm/pgtable_types.h | 1 +
 arch/x86/mm/mem_encrypt_identity.c   | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 816b31c..394757e 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -155,6 +155,7 @@ enum page_cache_mode {
 #define _PAGE_ENC		(_AT(pteval_t, sme_me_mask))
 
 #define _PAGE_CACHE_MASK	(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)
+#define _PAGE_LARGE_CACHE_MASK	(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT_LARGE)
 
 #define _PAGE_NOCACHE		(cachemode2protval(_PAGE_CACHE_MODE_UC))
 #define _PAGE_CACHE_WP		(cachemode2protval(_PAGE_CACHE_MODE_WP))
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 733b983..6c5eb6f 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -45,8 +45,8 @@
 #define PMD_FLAGS_LARGE		(__PAGE_KERNEL_LARGE_EXEC & ~_PAGE_GLOBAL)
 
 #define PMD_FLAGS_DEC		PMD_FLAGS_LARGE
-#define PMD_FLAGS_DEC_WP	((PMD_FLAGS_DEC & ~_PAGE_CACHE_MASK) | \
-				 (_PAGE_PAT | _PAGE_PWT))
+#define PMD_FLAGS_DEC_WP	((PMD_FLAGS_DEC & ~_PAGE_LARGE_CACHE_MASK) | \
+				 (_PAGE_PAT_LARGE | _PAGE_PWT))
 
 #define PMD_FLAGS_ENC		(PMD_FLAGS_LARGE | _PAGE_ENC)
 
