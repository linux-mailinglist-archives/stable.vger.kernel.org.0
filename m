Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4897C7F9B6
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390701AbfHBN2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394473AbfHBN0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:26:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4130E21851;
        Fri,  2 Aug 2019 13:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752363;
        bh=BsIIg/t2bOk/QUA0+R9ajwXxCny3OqWWrviU1c1/d5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zy4+GcALNgO7cqigLWfTpaDsnLwf7N3NAx1lHTKdRdqMxSEjR+/GME7uWweHMCnyV
         ptpi7D9i6IrPox4CtMqctvZ7rg0fCoMSSfC0ZgSViyIPUlAFMhMoUYtqQDNfsthxjL
         6fV5HlOGS1MzV1u1Maeu+2CKW8X2nKr+0YHlu48Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 06/22] x86/mm: Sync also unmappings in vmalloc_sync_all()
Date:   Fri,  2 Aug 2019 09:25:30 -0400
Message-Id: <20190802132547.14517-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132547.14517-1-sashal@kernel.org>
References: <20190802132547.14517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 8e998fc24de47c55b47a887f6c95ab91acd4a720 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/fault.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2870424bda1ff..7f4b3c59df475 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -273,11 +273,12 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 
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
 
@@ -299,17 +300,13 @@ void vmalloc_sync_all(void)
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
2.20.1

