Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F383451282
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346760AbhKOTgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:36:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244728AbhKOTRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E91B96108D;
        Mon, 15 Nov 2021 18:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000602;
        bh=c/jpbdtY4rrPtEz/JZ/lUDJYscs4qspt8O2ustMnsto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqJS90QbCCFGqQ8YIuLObK5bRYvXjYhWS6ODhFWeILtHsf7dNRS5oECAwurbD7uFz
         p5Su+EcaLrIOXU7ilKddZcDh0QS8QyJFJqws49ShOINYLuVwcdnT9R7ZdWPwJ/U+4h
         SfSn4RHkOVSIGaW+3TTyC3EQLWPprPIH84vBkxn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 722/849] openrisc: fix SMP tlb flush NULL pointer dereference
Date:   Mon, 15 Nov 2021 18:03:25 +0100
Message-Id: <20211115165444.679466961@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 27dff9a9c247d4e38d82c2e7234914cfe8499294 ]

Throughout the OpenRISC kernel port VMA is passed as NULL when flushing
kernel tlb entries.  Somehow this was missed when I was testing
c28b27416da9 ("openrisc: Implement proper SMP tlb flushing") and now the
SMP kernel fails to completely boot.

In OpenRISC VMA is used only to determine which cores need to have their
TLB entries flushed.

This patch updates the logic to flush tlbs on all cores when the VMA is
passed as NULL.  Also, we update places VMA is passed as NULL to use
flush_tlb_kernel_range instead.  Now, the only place VMA is passed as
NULL is in the implementation of flush_tlb_kernel_range.

Fixes: c28b27416da9 ("openrisc: Implement proper SMP tlb flushing")
Reported-by: Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/dma.c | 4 ++--
 arch/openrisc/kernel/smp.c | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/openrisc/kernel/dma.c b/arch/openrisc/kernel/dma.c
index 1b16d97e7da7f..a82b2caaa560d 100644
--- a/arch/openrisc/kernel/dma.c
+++ b/arch/openrisc/kernel/dma.c
@@ -33,7 +33,7 @@ page_set_nocache(pte_t *pte, unsigned long addr,
 	 * Flush the page out of the TLB so that the new page flags get
 	 * picked up next time there's an access
 	 */
-	flush_tlb_page(NULL, addr);
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 
 	/* Flush page out of dcache */
 	for (cl = __pa(addr); cl < __pa(next); cl += cpuinfo->dcache_block_size)
@@ -56,7 +56,7 @@ page_clear_nocache(pte_t *pte, unsigned long addr,
 	 * Flush the page out of the TLB so that the new page flags get
 	 * picked up next time there's an access
 	 */
-	flush_tlb_page(NULL, addr);
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 
 	return 0;
 }
diff --git a/arch/openrisc/kernel/smp.c b/arch/openrisc/kernel/smp.c
index 415e209732a3d..ba78766cf00b5 100644
--- a/arch/openrisc/kernel/smp.c
+++ b/arch/openrisc/kernel/smp.c
@@ -272,7 +272,7 @@ static inline void ipi_flush_tlb_range(void *info)
 	local_flush_tlb_range(NULL, fd->addr1, fd->addr2);
 }
 
-static void smp_flush_tlb_range(struct cpumask *cmask, unsigned long start,
+static void smp_flush_tlb_range(const struct cpumask *cmask, unsigned long start,
 				unsigned long end)
 {
 	unsigned int cpuid;
@@ -320,7 +320,9 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 void flush_tlb_range(struct vm_area_struct *vma,
 		     unsigned long start, unsigned long end)
 {
-	smp_flush_tlb_range(mm_cpumask(vma->vm_mm), start, end);
+	const struct cpumask *cmask = vma ? mm_cpumask(vma->vm_mm)
+					  : cpu_online_mask;
+	smp_flush_tlb_range(cmask, start, end);
 }
 
 /* Instruction cache invalidate - performed on each cpu */
-- 
2.33.0



