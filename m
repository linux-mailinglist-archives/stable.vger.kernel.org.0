Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677551EAD5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 11:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfEOJTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 05:19:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbfEOJTX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 05:19:23 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4D2EBFCF3FD474F23B96;
        Wed, 15 May 2019 17:19:21 +0800 (CST)
Received: from FRA1000014316.huawei.com (100.126.230.97) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Wed, 15 May 2019 17:19:11 +0800
From:   Jonathan Cameron <Jonathan.Cameron@huawei.com>
To:     <shameerali.kolothum.thodi@huawei.com>
CC:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        <stable@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 47/60] arm64: Save and restore OSDLR_EL1 across suspend/resume
Date:   Wed, 15 May 2019 17:17:24 +0800
Message-ID: <20190515091737.18578-47-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190515091737.18578-1-Jonathan.Cameron@huawei.com>
References: <20190515091737.18578-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [100.126.230.97]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

When the CPU comes out of suspend, the firmware may have modified the OS
Double Lock Register. Save it in an unused slot of cpu_suspend_ctx, and
restore it on resume.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 arch/arm64/mm/proc.S | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index aa0817c9c4c36..fdd626d34274f 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -65,24 +65,25 @@ ENTRY(cpu_do_suspend)
 	mrs	x2, tpidr_el0
 	mrs	x3, tpidrro_el0
 	mrs	x4, contextidr_el1
-	mrs	x5, cpacr_el1
-	mrs	x6, tcr_el1
-	mrs	x7, vbar_el1
-	mrs	x8, mdscr_el1
-	mrs	x9, oslsr_el1
-	mrs	x10, sctlr_el1
+	mrs	x5, osdlr_el1
+	mrs	x6, cpacr_el1
+	mrs	x7, tcr_el1
+	mrs	x8, vbar_el1
+	mrs	x9, mdscr_el1
+	mrs	x10, oslsr_el1
+	mrs	x11, sctlr_el1
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-	mrs	x11, tpidr_el1
+	mrs	x12, tpidr_el1
 alternative_else
-	mrs	x11, tpidr_el2
+	mrs	x12, tpidr_el2
 alternative_endif
-	mrs	x12, sp_el0
+	mrs	x13, sp_el0
 	stp	x2, x3, [x0]
-	stp	x4, xzr, [x0, #16]
-	stp	x5, x6, [x0, #32]
-	stp	x7, x8, [x0, #48]
-	stp	x9, x10, [x0, #64]
-	stp	x11, x12, [x0, #80]
+	stp	x4, x5, [x0, #16]
+	stp	x6, x7, [x0, #32]
+	stp	x8, x9, [x0, #48]
+	stp	x10, x11, [x0, #64]
+	stp	x12, x13, [x0, #80]
 	ret
 ENDPROC(cpu_do_suspend)
 
@@ -105,8 +106,8 @@ ENTRY(cpu_do_resume)
 	msr	cpacr_el1, x6
 
 	/* Don't change t0sz here, mask those bits when restoring */
-	mrs	x5, tcr_el1
-	bfi	x8, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
+	mrs	x7, tcr_el1
+	bfi	x8, x7, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
 
 	msr	tcr_el1, x8
 	msr	vbar_el1, x9
@@ -130,6 +131,7 @@ alternative_endif
 	/*
 	 * Restore oslsr_el1 by writing oslar_el1
 	 */
+	msr	osdlr_el1, x5
 	ubfx	x11, x11, #1, #1
 	msr	oslar_el1, x11
 	reset_pmuserenr_el0 x0			// Disable PMU access from EL0
-- 
2.19.1

