Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8642E6658
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388095AbgL1NW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgL1NW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9820A207CF;
        Mon, 28 Dec 2020 13:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161705;
        bh=hkOGyiel6DQQsHN0zdExQmw97p7GybAFPgwUZOCrP7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUrZxYsP/YS6lgBhQ+RP4mCqd7BX+u3ojWUY/7qPzpsE/nPEfM/vOqLhEPl7MuJRf
         e1c1g9DHMehT7oGRrDmR1c+5tA3FRmZMFSSmWNsMxzoRzOrUHOIraRSmx+2gCbpvu4
         Ulhst5Os6Bi6Uu/6UXeS8x/b8ZJ4VWrl9VceF1bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 4.19 023/346] x86/mm/mem_encrypt: Fix definition of PMD_FLAGS_DEC_WP
Date:   Mon, 28 Dec 2020 13:45:42 +0100
Message-Id: <20201228124920.894651104@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
 arch/x86/mm/mem_encrypt_identity.c   |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -148,6 +148,7 @@ enum page_cache_mode {
 #endif
 
 #define _PAGE_CACHE_MASK	(_PAGE_PAT | _PAGE_PCD | _PAGE_PWT)
+#define _PAGE_LARGE_CACHE_MASK	(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT_LARGE)
 #define _PAGE_NOCACHE		(cachemode2protval(_PAGE_CACHE_MODE_UC))
 #define _PAGE_CACHE_WP		(cachemode2protval(_PAGE_CACHE_MODE_WP))
 
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -47,8 +47,8 @@
 #define PMD_FLAGS_LARGE		(__PAGE_KERNEL_LARGE_EXEC & ~_PAGE_GLOBAL)
 
 #define PMD_FLAGS_DEC		PMD_FLAGS_LARGE
-#define PMD_FLAGS_DEC_WP	((PMD_FLAGS_DEC & ~_PAGE_CACHE_MASK) | \
-				 (_PAGE_PAT | _PAGE_PWT))
+#define PMD_FLAGS_DEC_WP	((PMD_FLAGS_DEC & ~_PAGE_LARGE_CACHE_MASK) | \
+				 (_PAGE_PAT_LARGE | _PAGE_PWT))
 
 #define PMD_FLAGS_ENC		(PMD_FLAGS_LARGE | _PAGE_ENC)
 


