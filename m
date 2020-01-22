Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40BBB14517D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgAVJeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:34:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730718AbgAVJeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:34:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 483EC24686;
        Wed, 22 Jan 2020 09:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685640;
        bh=0iire2u+csQBAnlzznt/6eKi2CtAWpcBo13qZl4lMLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6HRasPSYeI0tc1ppUJGiMpiaC9Gb5teLZgbvSEN4+wWnJOjgk5H3Qv8vvbjys5rm
         bmt/i1OHLBl+l5e83B6/05qpLezqbhlwxwLSwuLiiMMwp4tdMaxDL8UxCgyrsFgacV
         yRPamnSLqJHlqyjOpAVwfyd0j5eIREexFGYu7wCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 09/97] arm64: mm: Change page table pointer name in p[md]_set_huge()
Date:   Wed, 22 Jan 2020 10:28:13 +0100
Message-Id: <20200122092757.285061029@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
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
@@ -795,21 +795,21 @@ int __init arch_ioremap_pmd_supported(vo
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
 


