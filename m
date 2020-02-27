Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 957F0171A65
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731213AbgB0NxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731657AbgB0NxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:53:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ACD624656;
        Thu, 27 Feb 2020 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811595;
        bh=4AjuisLq/Q618j1pGEwedVKONd7Arpt8wzmOlrKxZqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqhjfmgyetNU6sEBcQjrgEtIAQ6lovE7suVMZGSO4kQkYNnAKEMjrnzcJ7sOZQuTK
         RY0mijj1Yr82VP7rjS2DNy68R/1p38oU3Z3Rut1CAif76jTnmT3daicAjSEVBUKS6g
         iheYJUu7gZMHrf2UXr3jeH6/O1GRlr47O2d61QMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Shawn Guo <shawnguo@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 4.14 027/237] serial: imx: Only handle irqs that are actually enabled
Date:   Thu, 27 Feb 2020 14:34:01 +0100
Message-Id: <20200227132258.427992937@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 437768962f754d9501e5ba4d98b1f2a89dc62028 upstream.

Handling an irq that isn't enabled can have some undesired side effects.
Some of these are mentioned in the newly introduced code comment. Some
of the irq sources already had their handling right, some don't. Handle
them all in the same consistent way.

The change for USR1_RRDY and USR1_AGTIM drops the check for
dma_is_enabled. This is correct as UCR1_RRDYEN and UCR2_ATEN are always
off if dma is enabled.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Shawn Guo <shawnguo@kernel.org>
[Backport to v4.14]
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |   53 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 14 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -843,14 +843,42 @@ static void imx_mctrl_check(struct imx_p
 static irqreturn_t imx_int(int irq, void *dev_id)
 {
 	struct imx_port *sport = dev_id;
-	unsigned int sts;
-	unsigned int sts2;
+	unsigned int usr1, usr2, ucr1, ucr2, ucr3, ucr4;
 	irqreturn_t ret = IRQ_NONE;
 
-	sts = readl(sport->port.membase + USR1);
-	sts2 = readl(sport->port.membase + USR2);
+	usr1 = readl(sport->port.membase + USR1);
+	usr2 = readl(sport->port.membase + USR2);
+	ucr1 = readl(sport->port.membase + UCR1);
+	ucr2 = readl(sport->port.membase + UCR2);
+	ucr3 = readl(sport->port.membase + UCR3);
+	ucr4 = readl(sport->port.membase + UCR4);
+
+	/*
+	 * Even if a condition is true that can trigger an irq only handle it if
+	 * the respective irq source is enabled. This prevents some undesired
+	 * actions, for example if a character that sits in the RX FIFO and that
+	 * should be fetched via DMA is tried to be fetched using PIO. Or the
+	 * receiver is currently off and so reading from URXD0 results in an
+	 * exception. So just mask the (raw) status bits for disabled irqs.
+	 */
+	if ((ucr1 & UCR1_RRDYEN) == 0)
+		usr1 &= ~USR1_RRDY;
+	if ((ucr2 & UCR2_ATEN) == 0)
+		usr1 &= ~USR1_AGTIM;
+	if ((ucr1 & UCR1_TXMPTYEN) == 0)
+		usr1 &= ~USR1_TRDY;
+	if ((ucr4 & UCR4_TCEN) == 0)
+		usr2 &= ~USR2_TXDC;
+	if ((ucr3 & UCR3_DTRDEN) == 0)
+		usr1 &= ~USR1_DTRD;
+	if ((ucr1 & UCR1_RTSDEN) == 0)
+		usr1 &= ~USR1_RTSD;
+	if ((ucr3 & UCR3_AWAKEN) == 0)
+		usr1 &= ~USR1_AWAKE;
+	if ((ucr4 & UCR4_OREN) == 0)
+		usr2 &= ~USR2_ORE;
 
-	if (sts & (USR1_RRDY | USR1_AGTIM)) {
+	if (usr1 & (USR1_RRDY | USR1_AGTIM)) {
 		if (sport->dma_is_enabled)
 			imx_dma_rxint(sport);
 		else
@@ -858,18 +886,15 @@ static irqreturn_t imx_int(int irq, void
 		ret = IRQ_HANDLED;
 	}
 
-	if ((sts & USR1_TRDY &&
-	     readl(sport->port.membase + UCR1) & UCR1_TXMPTYEN) ||
-	    (sts2 & USR2_TXDC &&
-	     readl(sport->port.membase + UCR4) & UCR4_TCEN)) {
+	if ((usr1 & USR1_TRDY) || (usr2 & USR2_TXDC)) {
 		imx_txint(irq, dev_id);
 		ret = IRQ_HANDLED;
 	}
 
-	if (sts & USR1_DTRD) {
+	if (usr1 & USR1_DTRD) {
 		unsigned long flags;
 
-		if (sts & USR1_DTRD)
+		if (usr1 & USR1_DTRD)
 			writel(USR1_DTRD, sport->port.membase + USR1);
 
 		spin_lock_irqsave(&sport->port.lock, flags);
@@ -879,17 +904,17 @@ static irqreturn_t imx_int(int irq, void
 		ret = IRQ_HANDLED;
 	}
 
-	if (sts & USR1_RTSD) {
+	if (usr1 & USR1_RTSD) {
 		imx_rtsint(irq, dev_id);
 		ret = IRQ_HANDLED;
 	}
 
-	if (sts & USR1_AWAKE) {
+	if (usr1 & USR1_AWAKE) {
 		writel(USR1_AWAKE, sport->port.membase + USR1);
 		ret = IRQ_HANDLED;
 	}
 
-	if (sts2 & USR2_ORE) {
+	if (usr2 & USR2_ORE) {
 		sport->port.icount.overrun++;
 		writel(USR2_ORE, sport->port.membase + USR2);
 		ret = IRQ_HANDLED;


