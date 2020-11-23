Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DEC2C093B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388472AbgKWNFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387583AbgKWMuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE4320857;
        Mon, 23 Nov 2020 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135817;
        bh=71nMqoZGfZCUegWSMecEsOLwDxfqqQC2NfCprlOp/B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdsI8pzOobNOsABa9eKRjcI93Oq7vXOmovtvNj60aV5Sxbl3apqoCgSe7DAzGFo/H
         L+pnMEYdwS4pB2EL7pNoGVPT8H8cXALAtqvN+mteFyNE5ciAG6pSwPLuLpQQQPOY4e
         r1UTe8wfrpBedXuaYDz/bCFC3B1MA9IOTlxzTJOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 179/252] efi/x86: Free efi_pgd with free_pages()
Date:   Mon, 23 Nov 2020 13:22:09 +0100
Message-Id: <20201123121844.234431831@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit c2fe61d8be491ff8188edaf22e838f819999146b ]

Commit

  d9e9a6418065 ("x86/mm/pti: Allocate a separate user PGD")

changed the PGD allocation to allocate PGD_ALLOCATION_ORDER pages, so in
the error path it should be freed using free_pages() rather than
free_page().

Commit

    06ace26f4e6f ("x86/efi: Free efi_pgd with free_pages()")

fixed one instance of this, but missed another.

Move the freeing out-of-line to avoid code duplication and fix this bug.

Fixes: d9e9a6418065 ("x86/mm/pti: Allocate a separate user PGD")
Link: https://lore.kernel.org/r/20201110163919.1134431-1-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/efi_64.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6af4da1149bac..5ce50adb6fd0c 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -77,28 +77,30 @@ int __init efi_alloc_page_tables(void)
 	gfp_mask = GFP_KERNEL | __GFP_ZERO;
 	efi_pgd = (pgd_t *)__get_free_pages(gfp_mask, PGD_ALLOCATION_ORDER);
 	if (!efi_pgd)
-		return -ENOMEM;
+		goto fail;
 
 	pgd = efi_pgd + pgd_index(EFI_VA_END);
 	p4d = p4d_alloc(&init_mm, pgd, EFI_VA_END);
-	if (!p4d) {
-		free_page((unsigned long)efi_pgd);
-		return -ENOMEM;
-	}
+	if (!p4d)
+		goto free_pgd;
 
 	pud = pud_alloc(&init_mm, p4d, EFI_VA_END);
-	if (!pud) {
-		if (pgtable_l5_enabled())
-			free_page((unsigned long) pgd_page_vaddr(*pgd));
-		free_pages((unsigned long)efi_pgd, PGD_ALLOCATION_ORDER);
-		return -ENOMEM;
-	}
+	if (!pud)
+		goto free_p4d;
 
 	efi_mm.pgd = efi_pgd;
 	mm_init_cpumask(&efi_mm);
 	init_new_context(NULL, &efi_mm);
 
 	return 0;
+
+free_p4d:
+	if (pgtable_l5_enabled())
+		free_page((unsigned long)pgd_page_vaddr(*pgd));
+free_pgd:
+	free_pages((unsigned long)efi_pgd, PGD_ALLOCATION_ORDER);
+fail:
+	return -ENOMEM;
 }
 
 /*
-- 
2.27.0



