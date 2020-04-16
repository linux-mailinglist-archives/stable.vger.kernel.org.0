Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B39B1AC67D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393381AbgDPOka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409468AbgDPOBf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03EEC20786;
        Thu, 16 Apr 2020 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045694;
        bh=28OW14Pg6V+cY9SZW+S9pbIyd0BluxIjxSwJPQi4yws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYK+C+uXEjLmMFyzUemRLiKUK3xaThSc51KIE2VZlo1ZnHCXxcnVkSPpOzqbdZOCX
         zFSZ8FkOyQ7bFsaBIJa7Marza7sFHHzy5/EZ7nVe3vNjHe4l8dXptBdcaymo8Qpxyq
         CCIy8wdFzKmWNsIPPD92BGeNa92SC0nzPCyqNk18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.6 240/254] powerpc/xive: Use XIVE_BAD_IRQ instead of zero to catch non configured IPIs
Date:   Thu, 16 Apr 2020 15:25:29 +0200
Message-Id: <20200416131355.484276649@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit b1a504a6500df50e83b701b7946b34fce27ad8a3 upstream.

When a CPU is brought up, an IPI number is allocated and recorded
under the XIVE CPU structure. Invalid IPI numbers are tracked with
interrupt number 0x0.

On the PowerNV platform, the interrupt number space starts at 0x10 and
this works fine. However, on the sPAPR platform, it is possible to
allocate the interrupt number 0x0 and this raises an issue when CPU 0
is unplugged. The XIVE spapr driver tracks allocated interrupt numbers
in a bitmask and it is not correctly updated when interrupt number 0x0
is freed. It stays allocated and it is then impossible to reallocate.

Fix by using the XIVE_BAD_IRQ value instead of zero on both platforms.

Reported-by: David Gibson <david@gibson.dropbear.id.au>
Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Tested-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200306150143.5551-2-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/sysdev/xive/common.c        |   12 +++---------
 arch/powerpc/sysdev/xive/native.c        |    4 ++--
 arch/powerpc/sysdev/xive/spapr.c         |    4 ++--
 arch/powerpc/sysdev/xive/xive-internal.h |    7 +++++++
 4 files changed, 14 insertions(+), 13 deletions(-)

--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -68,13 +68,6 @@ static u32 xive_ipi_irq;
 /* Xive state for each CPU */
 static DEFINE_PER_CPU(struct xive_cpu *, xive_cpu);
 
-/*
- * A "disabled" interrupt should never fire, to catch problems
- * we set its logical number to this
- */
-#define XIVE_BAD_IRQ		0x7fffffff
-#define XIVE_MAX_IRQ		(XIVE_BAD_IRQ - 1)
-
 /* An invalid CPU target */
 #define XIVE_INVALID_TARGET	(-1)
 
@@ -1150,7 +1143,7 @@ static int xive_setup_cpu_ipi(unsigned i
 	xc = per_cpu(xive_cpu, cpu);
 
 	/* Check if we are already setup */
-	if (xc->hw_ipi != 0)
+	if (xc->hw_ipi != XIVE_BAD_IRQ)
 		return 0;
 
 	/* Grab an IPI from the backend, this will populate xc->hw_ipi */
@@ -1187,7 +1180,7 @@ static void xive_cleanup_cpu_ipi(unsigne
 	/* Disable the IPI and free the IRQ data */
 
 	/* Already cleaned up ? */
-	if (xc->hw_ipi == 0)
+	if (xc->hw_ipi == XIVE_BAD_IRQ)
 		return;
 
 	/* Mask the IPI */
@@ -1343,6 +1336,7 @@ static int xive_prepare_cpu(unsigned int
 		if (np)
 			xc->chip_id = of_get_ibm_chip_id(np);
 		of_node_put(np);
+		xc->hw_ipi = XIVE_BAD_IRQ;
 
 		per_cpu(xive_cpu, cpu) = xc;
 	}
--- a/arch/powerpc/sysdev/xive/native.c
+++ b/arch/powerpc/sysdev/xive/native.c
@@ -312,7 +312,7 @@ static void xive_native_put_ipi(unsigned
 	s64 rc;
 
 	/* Free the IPI */
-	if (!xc->hw_ipi)
+	if (xc->hw_ipi == XIVE_BAD_IRQ)
 		return;
 	for (;;) {
 		rc = opal_xive_free_irq(xc->hw_ipi);
@@ -320,7 +320,7 @@ static void xive_native_put_ipi(unsigned
 			msleep(OPAL_BUSY_DELAY_MS);
 			continue;
 		}
-		xc->hw_ipi = 0;
+		xc->hw_ipi = XIVE_BAD_IRQ;
 		break;
 	}
 }
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -560,11 +560,11 @@ static int xive_spapr_get_ipi(unsigned i
 
 static void xive_spapr_put_ipi(unsigned int cpu, struct xive_cpu *xc)
 {
-	if (!xc->hw_ipi)
+	if (xc->hw_ipi == XIVE_BAD_IRQ)
 		return;
 
 	xive_irq_bitmap_free(xc->hw_ipi);
-	xc->hw_ipi = 0;
+	xc->hw_ipi = XIVE_BAD_IRQ;
 }
 #endif /* CONFIG_SMP */
 
--- a/arch/powerpc/sysdev/xive/xive-internal.h
+++ b/arch/powerpc/sysdev/xive/xive-internal.h
@@ -5,6 +5,13 @@
 #ifndef __XIVE_INTERNAL_H
 #define __XIVE_INTERNAL_H
 
+/*
+ * A "disabled" interrupt should never fire, to catch problems
+ * we set its logical number to this
+ */
+#define XIVE_BAD_IRQ		0x7fffffff
+#define XIVE_MAX_IRQ		(XIVE_BAD_IRQ - 1)
+
 /* Each CPU carry one of these with various per-CPU state */
 struct xive_cpu {
 #ifdef CONFIG_SMP


