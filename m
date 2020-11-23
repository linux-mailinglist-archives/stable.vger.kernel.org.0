Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711E62C0B8B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbgKWN0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731061AbgKWMcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A422076E;
        Mon, 23 Nov 2020 12:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134740;
        bh=Z5JMkm7C9kNof7AufHhAzVITBeL4cSYnwBaAICVj3l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNbfLpsNohGfdpdOIc6Tph2HVpFf1zCWa3z6rBRELCm+alyzUcGXzlYE9x3HoXD53
         VtyPwXxMaDU/murl3klOCCIUNKcbwwuGR7CdnJpGIQ8CwjyRUsVHfGvXcwmQ3aeoGf
         FQ61YwF1M5OIT/4GgejcRFYfP+yT1MLnzXLJbWPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 64/91] efi/x86: Free efi_pgd with free_pages()
Date:   Mon, 23 Nov 2020 13:22:24 +0100
Message-Id: <20201123121812.432161315@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
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
index 52dd59af873ee..77d05b56089a2 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -214,28 +214,30 @@ int __init efi_alloc_page_tables(void)
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



