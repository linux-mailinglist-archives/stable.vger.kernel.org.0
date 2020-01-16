Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E2913FEAC
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389119AbgAPXhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391107AbgAPXbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A244D20661;
        Thu, 16 Jan 2020 23:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217466;
        bh=SKk62hgPbXoCxXpnUj5XJblGn1m21tA2Mh2HExM3X9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XphB3qtSsmBFkb1WzBv3254QJ8WsHNSVtJSM7auPuSUZqoLBXlUeJ2+4APbKhC/tt
         XnB59XPDBrmEeaPn9ULoKmkpaZ+hyMJuo2dUIHYjzsOjx05x2WxWwawF7Uv7jms70v
         3YaIEFwr76vEwiqiLjf8vbHNbDoDGCqmkK/QfED8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Peter Robinson <pbrobinson@gmail.com>,
        Laura Abbott <labbott@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 10/71] arm64: Make sure permission updates happen for pmd/pud
Date:   Fri, 17 Jan 2020 00:18:08 +0100
Message-Id: <20200116231710.926122766@linuxfoundation.org>
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

From: Laura Abbott <labbott@redhat.com>

commit 82034c23fcbc2389c73d97737f61fa2dd6526413 upstream.

Commit 15122ee2c515 ("arm64: Enforce BBM for huge IO/VMAP mappings")
disallowed block mappings for ioremap since that code does not honor
break-before-make. The same APIs are also used for permission updating
though and the extra checks prevent the permission updates from happening,
even though this should be permitted. This results in read-only permissions
not being fully applied. Visibly, this can occasionaly be seen as a failure
on the built in rodata test when the test data ends up in a section or
as an odd RW gap on the page table dump. Fix this by using
pgattr_change_is_safe instead of p*d_present for determining if the
change is permitted.

Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Reported-by: Peter Robinson <pbrobinson@gmail.com>
Fixes: 15122ee2c515 ("arm64: Enforce BBM for huge IO/VMAP mappings")
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -917,13 +917,15 @@ int pud_set_huge(pud_t *pudp, phys_addr_
 {
 	pgprot_t sect_prot = __pgprot(PUD_TYPE_SECT |
 					pgprot_val(mk_sect_prot(prot)));
+	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), sect_prot);
 
-	/* ioremap_page_range doesn't honour BBM */
-	if (pud_present(READ_ONCE(*pudp)))
+	/* Only allow permission changes for now */
+	if (!pgattr_change_is_safe(READ_ONCE(pud_val(*pudp)),
+				   pud_val(new_pud)))
 		return 0;
 
 	BUG_ON(phys & ~PUD_MASK);
-	set_pud(pudp, pfn_pud(__phys_to_pfn(phys), sect_prot));
+	set_pud(pudp, new_pud);
 	return 1;
 }
 
@@ -931,13 +933,15 @@ int pmd_set_huge(pmd_t *pmdp, phys_addr_
 {
 	pgprot_t sect_prot = __pgprot(PMD_TYPE_SECT |
 					pgprot_val(mk_sect_prot(prot)));
+	pmd_t new_pmd = pfn_pmd(__phys_to_pfn(phys), sect_prot);
 
-	/* ioremap_page_range doesn't honour BBM */
-	if (pmd_present(READ_ONCE(*pmdp)))
+	/* Only allow permission changes for now */
+	if (!pgattr_change_is_safe(READ_ONCE(pmd_val(*pmdp)),
+				   pmd_val(new_pmd)))
 		return 0;
 
 	BUG_ON(phys & ~PMD_MASK);
-	set_pmd(pmdp, pfn_pmd(__phys_to_pfn(phys), sect_prot));
+	set_pmd(pmdp, new_pmd);
 	return 1;
 }
 


