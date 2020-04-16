Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73F21AC9E1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442430AbgDPP2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898421AbgDPNoC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:44:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1CDB2076D;
        Thu, 16 Apr 2020 13:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044641;
        bh=7RdBcKbcSA8txvE3ou1/hXYhwhq2DHXO8rive13W17M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfxOS3sUxLoquHCNZ54SKnJ4yAGCHd9tTM3TYCBOGQMltF97kO7S2+Oz5AAkGMksX
         U3aIF4xoRFhKp8mD0NqYJUz/HbvDh3X81EsEqQtbmMkSbgTU9BwM1w78I2Gq9MTWBY
         vjkbUnwSJ3Ch5KD339GomVw+X+52Y7/ka/M5obHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sungbo Eo <mans0n@gorani.run>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/232] irqchip/versatile-fpga: Handle chained IRQs properly
Date:   Thu, 16 Apr 2020 15:22:14 +0200
Message-Id: <20200416131320.890660320@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sungbo Eo <mans0n@gorani.run>

[ Upstream commit 486562da598c59e9f835b551d7cf19507de2d681 ]

Enclose the chained handler with chained_irq_{enter,exit}(), so that the
muxed interrupts get properly acked.

This patch also fixes a reboot bug on OX820 SoC, where the jiffies timer
interrupt is never acked. The kernel waits a clock tick forever in
calibrate_delay_converge(), which leads to a boot hang.

Fixes: c41b16f8c9d9 ("ARM: integrator/versatile: consolidate FPGA IRQ handling code")
Signed-off-by: Sungbo Eo <mans0n@gorani.run>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200319023448.1479701-1-mans0n@gorani.run
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-versatile-fpga.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-versatile-fpga.c b/drivers/irqchip/irq-versatile-fpga.c
index 928858dada756..70e2cfff8175f 100644
--- a/drivers/irqchip/irq-versatile-fpga.c
+++ b/drivers/irqchip/irq-versatile-fpga.c
@@ -6,6 +6,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/irqchip.h>
+#include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/versatile-fpga.h>
 #include <linux/irqdomain.h>
 #include <linux/module.h>
@@ -68,12 +69,16 @@ static void fpga_irq_unmask(struct irq_data *d)
 
 static void fpga_irq_handle(struct irq_desc *desc)
 {
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct fpga_irq_data *f = irq_desc_get_handler_data(desc);
-	u32 status = readl(f->base + IRQ_STATUS);
+	u32 status;
+
+	chained_irq_enter(chip, desc);
 
+	status = readl(f->base + IRQ_STATUS);
 	if (status == 0) {
 		do_bad_IRQ(desc);
-		return;
+		goto out;
 	}
 
 	do {
@@ -82,6 +87,9 @@ static void fpga_irq_handle(struct irq_desc *desc)
 		status &= ~(1 << irq);
 		generic_handle_irq(irq_find_mapping(f->domain, irq));
 	} while (status);
+
+out:
+	chained_irq_exit(chip, desc);
 }
 
 /*
-- 
2.20.1



