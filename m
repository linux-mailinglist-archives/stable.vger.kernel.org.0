Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF1F13FE04
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403876AbgAPXb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391551AbgAPXbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21F5E2087E;
        Thu, 16 Jan 2020 23:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217514;
        bh=0VmsbLkFST9vywj3lsUu+bZOFqgyTE6C8+ee9JLR9+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHUZD5AVmG+euQWvj/H+cMMcUDK1KzqEPZc1BYPXaBl2byxLTDVULFWATac78eFdJ
         goXJnkoayAr3FZ6ivhQMwqL1P2bN55l1XUNDwbVenYrXIJ+fvYFOW4ZV7J2BgrKsIv
         sEPVo0uQ+OhURaseLWI2xbpqrGo8QT7H4HvrhoSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 08/71] arm64: mm: Change page table pointer name in  p[md]_set_huge()
Date:   Fri, 17 Jan 2020 00:18:06 +0100
Message-Id: <20200116231710.598555252@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@codethink.co.uk>

This is preparation for the following backported fixes.  It was done
upstream as part of commit 20a004e7b017 "arm64: mm: Use
READ_ONCE/WRITE_ONCE when accessing page tables", the rest of which
does not seem suitable for stable.

Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -913,21 +913,21 @@ int __init arch_ioremap_pmd_supported(vo
 	return !IS_ENABLED(CONFIG_ARM64_PTDUMP_DEBUGFS);
 }
 
-int pud_set_huge(pud_t *pud, phys_addr_t phys, pgprot_t prot)
+int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 {
 	pgprot_t sect_prot = __pgprot(PUD_TYPE_SECT |
 					pgprot_val(mk_sect_prot(prot)));
 	BUG_ON(phys & ~PUD_MASK);
-	set_pud(pud, pfn_pud(__phys_to_pfn(phys), sect_prot));
+	set_pud(pudp, pfn_pud(__phys_to_pfn(phys), sect_prot));
 	return 1;
 }
 
-int pmd_set_huge(pmd_t *pmd, phys_addr_t phys, pgprot_t prot)
+int pmd_set_huge(pmd_t *pmdp, phys_addr_t phys, pgprot_t prot)
 {
 	pgprot_t sect_prot = __pgprot(PMD_TYPE_SECT |
 					pgprot_val(mk_sect_prot(prot)));
 	BUG_ON(phys & ~PMD_MASK);
-	set_pmd(pmd, pfn_pmd(__phys_to_pfn(phys), sect_prot));
+	set_pmd(pmdp, pfn_pmd(__phys_to_pfn(phys), sect_prot));
 	return 1;
 }
 


