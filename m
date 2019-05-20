Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B2B23643
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389231AbfETM1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389565AbfETM1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:27:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E204B20645;
        Mon, 20 May 2019 12:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355271;
        bh=rEAbe9tJjKeSiNz+SGz1+y60zU+ppV1EBFLMiGPkidg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=katH2zM/zgEc1tlQ0C9AQHzbLP9Ssv/5bGisedOJzXIurDVTvyw1aAzdKoEWkuMkk
         rH7OeVCKAy/ku+GzHJHLneLucjayhyR6Bj6Ur3WlcdvTqwgwSJe1CIGK7jpp8D7J6s
         qfsfx+N+LRj+TnTRwVM7KejMwyCrZ4WN0KsX/1dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 5.0 018/123] arm64: Save and restore OSDLR_EL1 across suspend/resume
Date:   Mon, 20 May 2019 14:13:18 +0200
Message-Id: <20190520115246.153498043@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

commit 827a108e354db633698f0b4a10c1ffd2b1f8d1d0 upstream.

When the CPU comes out of suspend, the firmware may have modified the OS
Double Lock Register. Save it in an unused slot of cpu_suspend_ctx, and
restore it on resume.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/proc.S |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -76,24 +76,25 @@ ENTRY(cpu_do_suspend)
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
 
@@ -116,8 +117,8 @@ ENTRY(cpu_do_resume)
 	msr	cpacr_el1, x6
 
 	/* Don't change t0sz here, mask those bits when restoring */
-	mrs	x5, tcr_el1
-	bfi	x8, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
+	mrs	x7, tcr_el1
+	bfi	x8, x7, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
 
 	msr	tcr_el1, x8
 	msr	vbar_el1, x9
@@ -141,6 +142,7 @@ alternative_endif
 	/*
 	 * Restore oslsr_el1 by writing oslar_el1
 	 */
+	msr	osdlr_el1, x5
 	ubfx	x11, x11, #1, #1
 	msr	oslar_el1, x11
 	reset_pmuserenr_el0 x0			// Disable PMU access from EL0


