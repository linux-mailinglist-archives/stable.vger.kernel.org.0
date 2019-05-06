Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA6314D05
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfEFOrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729000AbfEFOrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F7382053B;
        Mon,  6 May 2019 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154027;
        bh=6OLcQgIjS7NVKbmeXUd0NWX6d9Ro1I2XL7AtRspSGts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2cR26MMpEHiLRrSyPw+F+0hy3ZKAr1kr6KRjNU5xVXh+OX9Nn9ugz9dAxqZwr8iV
         w590LGCo1gOsfsgn6pprgra1GmM60o/IaEZIa2BlnODTdk4/okalAj9FzTsbfQ0PNZ
         8fn6h8+nInwDdLE0L24sgSiRfM6UANU5RerF2Iwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Laura Abbott <labbott@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.9 11/62] mm/kasan: Switch to using __pa_symbol and lm_alias
Date:   Mon,  6 May 2019 16:32:42 +0200
Message-Id: <20190506143052.072825443@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@redhat.com>

commit 5c6a84a3f4558a6115fef1b59343c7ae56b3abc3 upstream.

__pa_symbol is the correct API to find the physical address of symbols.
Switch to it to allow for debugging APIs to work correctly. Other
functions such as p*d_populate may call __pa internally. Ensure that the
address passed is in the linear region by calling lm_alias.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/kasan/kasan_init.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/kasan/kasan_init.c
+++ b/mm/kasan/kasan_init.c
@@ -15,6 +15,7 @@
 #include <linux/kasan.h>
 #include <linux/kernel.h>
 #include <linux/memblock.h>
+#include <linux/mm.h>
 #include <linux/pfn.h>
 
 #include <asm/page.h>
@@ -49,7 +50,7 @@ static void __init zero_pte_populate(pmd
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	pte_t zero_pte;
 
-	zero_pte = pfn_pte(PFN_DOWN(__pa(kasan_zero_page)), PAGE_KERNEL);
+	zero_pte = pfn_pte(PFN_DOWN(__pa_symbol(kasan_zero_page)), PAGE_KERNEL);
 	zero_pte = pte_wrprotect(zero_pte);
 
 	while (addr + PAGE_SIZE <= end) {
@@ -69,7 +70,7 @@ static void __init zero_pmd_populate(pud
 		next = pmd_addr_end(addr, end);
 
 		if (IS_ALIGNED(addr, PMD_SIZE) && end - addr >= PMD_SIZE) {
-			pmd_populate_kernel(&init_mm, pmd, kasan_zero_pte);
+			pmd_populate_kernel(&init_mm, pmd, lm_alias(kasan_zero_pte));
 			continue;
 		}
 
@@ -92,9 +93,9 @@ static void __init zero_pud_populate(pgd
 		if (IS_ALIGNED(addr, PUD_SIZE) && end - addr >= PUD_SIZE) {
 			pmd_t *pmd;
 
-			pud_populate(&init_mm, pud, kasan_zero_pmd);
+			pud_populate(&init_mm, pud, lm_alias(kasan_zero_pmd));
 			pmd = pmd_offset(pud, addr);
-			pmd_populate_kernel(&init_mm, pmd, kasan_zero_pte);
+			pmd_populate_kernel(&init_mm, pmd, lm_alias(kasan_zero_pte));
 			continue;
 		}
 
@@ -135,11 +136,11 @@ void __init kasan_populate_zero_shadow(c
 			 * puds,pmds, so pgd_populate(), pud_populate()
 			 * is noops.
 			 */
-			pgd_populate(&init_mm, pgd, kasan_zero_pud);
+			pgd_populate(&init_mm, pgd, lm_alias(kasan_zero_pud));
 			pud = pud_offset(pgd, addr);
-			pud_populate(&init_mm, pud, kasan_zero_pmd);
+			pud_populate(&init_mm, pud, lm_alias(kasan_zero_pmd));
 			pmd = pmd_offset(pud, addr);
-			pmd_populate_kernel(&init_mm, pmd, kasan_zero_pte);
+			pmd_populate_kernel(&init_mm, pmd, lm_alias(kasan_zero_pte));
 			continue;
 		}
 


