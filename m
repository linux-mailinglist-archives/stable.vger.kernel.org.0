Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5620644F2D7
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 12:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhKMLng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 06:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232651AbhKMLnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 06:43:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C98F461139;
        Sat, 13 Nov 2021 11:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636803643;
        bh=MUMq5DWPGVtCI7I4xMLAKmW+NzuExXyn2T6xSPZSuJw=;
        h=Subject:To:Cc:From:Date:From;
        b=XdHQZ4Z2VusPfgbD9xLvAoiqTSkUahBFhRBBP6zu0h67buvBK0+YK4FKNMC3nfB8N
         UD3oAczY6kPRIZNO2jbHYUZ9x0IrH6b6qK2qX0G28WAsaXFhojCwC4GR9SKttk+scK
         NnHfg2QwtcPMlMkVbxzT2vAkMudHpWp4rRq0YpIg=
Subject: FAILED: patch "[PATCH] parisc: Fix set_fixmap() on PA1.x CPUs" failed to apply to 5.4-stable tree
To:     deller@gmx.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 12:40:40 +0100
Message-ID: <1636803640188229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6e866a462867b60841202e900f10936a0478608c Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Sun, 31 Oct 2021 21:58:12 +0100
Subject: [PATCH] parisc: Fix set_fixmap() on PA1.x CPUs

Fix a kernel crash which happens on PA1.x CPUs while initializing the
FTRACE/KPROBE breakpoints.  The PTE table entries for the fixmap area
were not created correctly.

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: ccfbc68d41c2 ("parisc: add set_fixmap()/clear_fixmap()")
Cc: stable@vger.kernel.org # v5.2+

diff --git a/arch/parisc/mm/fixmap.c b/arch/parisc/mm/fixmap.c
index 24426a7e1a5e..cc15d737fda6 100644
--- a/arch/parisc/mm/fixmap.c
+++ b/arch/parisc/mm/fixmap.c
@@ -20,12 +20,9 @@ void notrace set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
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

