Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEAA8BD18
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 17:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfHMP2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 11:28:20 -0400
Received: from 8bytes.org ([81.169.241.247]:49040 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbfHMP2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 11:28:18 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id BA464476; Tue, 13 Aug 2019 17:28:17 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/3] x86/mm: Sync also unmappings in vmalloc_sync_all()
Date:   Tue, 13 Aug 2019 17:28:13 +0200
Message-Id: <20190813152814.5354-3-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813152814.5354-1-joro@8bytes.org>
References: <20190813152814.5354-1-joro@8bytes.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 8e998fc24de47c55b47a887f6c95ab91acd4a720 upstream.

With huge-page ioremap areas the unmappings also need to be synced between
all page-tables. Otherwise it can cause data corruption when a region is
unmapped and later re-used.

Make the vmalloc_sync_one() function ready to sync unmappings and make sure
vmalloc_sync_all() iterates over all page-tables even when an unmapped PMD
is found.

Fixes: 5d72b4fba40ef ('x86, mm: support huge I/O mapping capability I/F')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20190719184652.11391-3-joro@8bytes.org
---
 arch/x86/mm/fault.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 499331be9bfe..26a8b4b1b9ed 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -194,11 +194,12 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 
 	pmd = pmd_offset(pud, address);
 	pmd_k = pmd_offset(pud_k, address);
-	if (!pmd_present(*pmd_k))
-		return NULL;
 
-	if (!pmd_present(*pmd))
+	if (pmd_present(*pmd) != pmd_present(*pmd_k))
 		set_pmd(pmd, *pmd_k);
+
+	if (!pmd_present(*pmd_k))
+		return NULL;
 	else
 		BUG_ON(pmd_pfn(*pmd) != pmd_pfn(*pmd_k));
 
@@ -220,17 +221,13 @@ void vmalloc_sync_all(void)
 		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			spinlock_t *pgt_lock;
-			pmd_t *ret;
 
 			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 
 			spin_lock(pgt_lock);
-			ret = vmalloc_sync_one(page_address(page), address);
+			vmalloc_sync_one(page_address(page), address);
 			spin_unlock(pgt_lock);
-
-			if (!ret)
-				break;
 		}
 		spin_unlock(&pgd_lock);
 	}
-- 
2.16.4

