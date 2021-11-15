Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7953C450C72
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhKORiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236966AbhKORhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:37:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11451632CA;
        Mon, 15 Nov 2021 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997075;
        bh=9KTEY2DSYPcZCVckqyP5Q3mnxm2Fb1tQzwkEICwZsgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFALWkOsYNAvznJ0wBk6jeVpQE0zZS40cpLKGTflWc4Y8elfZLxHOX+M7scRdVfVL
         D1NOmzxgmRII8sVOTxCQPkxE+cKTBBqhCjWdo6Ojiuobeoa/ez/8IKnC0vj/LyES7n
         CkCp0jM1344hZTdXWwOJAacs6YcsMk+DDY7X02Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 017/575] parisc: Fix set_fixmap() on PA1.x CPUs
Date:   Mon, 15 Nov 2021 17:55:42 +0100
Message-Id: <20211115165344.208970916@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 6e866a462867b60841202e900f10936a0478608c upstream.

Fix a kernel crash which happens on PA1.x CPUs while initializing the
FTRACE/KPROBE breakpoints.  The PTE table entries for the fixmap area
were not created correctly.

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: ccfbc68d41c2 ("parisc: add set_fixmap()/clear_fixmap()")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/mm/fixmap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/parisc/mm/fixmap.c
+++ b/arch/parisc/mm/fixmap.c
@@ -20,12 +20,9 @@ void notrace set_fixmap(enum fixed_addre
 	pte_t *pte;
 
 	if (pmd_none(*pmd))
-		pmd = pmd_alloc(NULL, pud, vaddr);
-
-	pte = pte_offset_kernel(pmd, vaddr);
-	if (pte_none(*pte))
 		pte = pte_alloc_kernel(pmd, vaddr);
 
+	pte = pte_offset_kernel(pmd, vaddr);
 	set_pte_at(&init_mm, vaddr, pte, __mk_pte(phys, PAGE_KERNEL_RWX));
 	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
 }


