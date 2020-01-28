Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C872614B6A0
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgA1OEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgA1OEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63BAB24694;
        Tue, 28 Jan 2020 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220269;
        bh=iPd/z60B6zp/AWzCXYB+uhw1cWKMiDj4+ysvjc7Ci74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiwU0K+VfEM2uThHJjNuAZTHuw0TeuCnSmTzToL9cmYSxEvH1M7DwgoLbMPyfviTQ
         922HGDb5wmwd2b1UXA8GYctcZDfUZ5SFiCdAH5gsKcU8aKMuYJ60577AYYZ6kFXSc/
         vjtBko880jYSLRUCSjn3G5t7yNp68uGVZ26X1G9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 047/104] powerpc/xive: Discard ESB load value when interrupt is invalid
Date:   Tue, 28 Jan 2020 15:00:08 +0100
Message-Id: <20200128135824.216683362@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Barrat <fbarrat@linux.ibm.com>

commit 17328f218fb760c9c6accc5b52494889243a6b98 upstream.

A load on an ESB page returning all 1's means that the underlying
device has invalidated the access to the PQ state of the interrupt
through mmio. It may happen, for example when querying a PHB interrupt
while the PHB is in an error state.

In that case, we should consider the interrupt to be invalid when
checking its state in the irq_get_irqchip_state() handler.

Fixes: da15c03b047d ("powerpc/xive: Implement get_irqchip_state method for XIVE to fix shutdown race")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
[clg: wrote a commit log, introduced XIVE_ESB_INVALID ]
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200113130118.27969-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/xive-regs.h |    1 +
 arch/powerpc/sysdev/xive/common.c    |   15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/xive-regs.h
+++ b/arch/powerpc/include/asm/xive-regs.h
@@ -39,6 +39,7 @@
 
 #define XIVE_ESB_VAL_P		0x2
 #define XIVE_ESB_VAL_Q		0x1
+#define XIVE_ESB_INVALID	0xFF
 
 /*
  * Thread Management (aka "TM") registers
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -972,12 +972,21 @@ static int xive_get_irqchip_state(struct
 				  enum irqchip_irq_state which, bool *state)
 {
 	struct xive_irq_data *xd = irq_data_get_irq_handler_data(data);
+	u8 pq;
 
 	switch (which) {
 	case IRQCHIP_STATE_ACTIVE:
-		*state = !xd->stale_p &&
-			 (xd->saved_p ||
-			  !!(xive_esb_read(xd, XIVE_ESB_GET) & XIVE_ESB_VAL_P));
+		pq = xive_esb_read(xd, XIVE_ESB_GET);
+
+		/*
+		 * The esb value being all 1's means we couldn't get
+		 * the PQ state of the interrupt through mmio. It may
+		 * happen, for example when querying a PHB interrupt
+		 * while the PHB is in an error state. We consider the
+		 * interrupt to be inactive in that case.
+		 */
+		*state = (pq != XIVE_ESB_INVALID) && !xd->stale_p &&
+			(xd->saved_p || !!(pq & XIVE_ESB_VAL_P));
 		return 0;
 	default:
 		return -EINVAL;


