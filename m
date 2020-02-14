Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1473915E8F4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394301AbgBNRDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392508AbgBNQPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0695C246F4;
        Fri, 14 Feb 2020 16:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696946;
        bh=3TZXsTWy+GWOyXb49qV/Qbo9WyB4oDNA5l7odcnIJfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1z+M09/xWS2RGELAr1pkPybO1rBSzsL7H8il2Pjob9iuV+v/FAf4/ZARQ6ygE9AD
         0bPj1YsQs5A8kHc0dUSHLUU4DN+wQK1Zr8GNbIVPpQXwhhQ6aEHpLoiC3JR5f8OxRv
         GRjOqDXV8OM5I4YeD2LTJ6NrQlRQ+zSEHFj1mxD0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 188/252] x86/mm: Fix NX bit clearing issue in kernel_map_pages_in_pgd
Date:   Fri, 14 Feb 2020 11:10:43 -0500
Message-Id: <20200214161147.15842-188-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 75fbef0a8b6b4bb19b9a91b5214f846c2dc5139e ]

The following commit:

  15f003d20782 ("x86/mm/pat: Don't implicitly allow _PAGE_RW in kernel_map_pages_in_pgd()")

modified kernel_map_pages_in_pgd() to manage writable permissions
of memory mappings in the EFI page table in a different way, but
in the process, it removed the ability to clear NX attributes from
read-only mappings, by clobbering the clear mask if _PAGE_RW is not
being requested.

Failure to remove the NX attribute from read-only mappings is
unlikely to be a security issue, but it does prevent us from
tightening the permissions in the EFI page tables going forward,
so let's fix it now.

Fixes: 15f003d20782 ("x86/mm/pat: Don't implicitly allow _PAGE_RW in kernel_map_pages_in_pgd()
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200113172245.27925-5-ardb@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pageattr.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e2d4b25c7aa44..101f3ad0d6ad1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -2126,19 +2126,13 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 		.pgd = pgd,
 		.numpages = numpages,
 		.mask_set = __pgprot(0),
-		.mask_clr = __pgprot(0),
+		.mask_clr = __pgprot(~page_flags & (_PAGE_NX|_PAGE_RW)),
 		.flags = 0,
 	};
 
 	if (!(__supported_pte_mask & _PAGE_NX))
 		goto out;
 
-	if (!(page_flags & _PAGE_NX))
-		cpa.mask_clr = __pgprot(_PAGE_NX);
-
-	if (!(page_flags & _PAGE_RW))
-		cpa.mask_clr = __pgprot(_PAGE_RW);
-
 	if (!(page_flags & _PAGE_ENC))
 		cpa.mask_clr = pgprot_encrypted(cpa.mask_clr);
 
-- 
2.20.1

