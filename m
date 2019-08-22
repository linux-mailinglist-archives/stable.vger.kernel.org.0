Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C5399D82
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405462AbfHVRnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391494AbfHVRXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:31 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15DEC23406;
        Thu, 22 Aug 2019 17:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494611;
        bh=b0aCbWO7BBEEMuz1CaPk9B3H8UIz8O29Qy3+OQF4CpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6IszvUtBpUttICxscWBQVkgFgA2y6oBNTI7nx1rahS7YfYkBJJ5REevAKX84JMLQ
         mAGu7rL8I0t46EPvpP6FBAMR5lDPJj/Bqwg2FzJriaEk0ikvigbEMLGfEvdBrxRWDM
         fW6PWd1STsz+rDIu7+IN8mdfanOmOk7W0z0b72CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 4.9 005/103] x86/mm: Sync also unmappings in vmalloc_sync_all()
Date:   Thu, 22 Aug 2019 10:17:53 -0700
Message-Id: <20190822171728.829608283@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/fault.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -273,11 +273,12 @@ static inline pmd_t *vmalloc_sync_one(pg
 
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


