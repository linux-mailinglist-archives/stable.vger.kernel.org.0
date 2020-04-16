Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD01AC3B1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898636AbgDPNqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:32822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898629AbgDPNqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:46:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F9121734;
        Thu, 16 Apr 2020 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044811;
        bh=EK/Cuxjn3w46ZMpO2v2XOHxAZrlG7GWtQElkScPysAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2JUJ0VF0GUC8YNTl63elFnsOVMxm9rPv79FGlx7zVYUwAvf9z9vmA5muTqlhCD6r
         YkdGQm27OLIb/YNrOw2QfP71jZbk/w6B0GeTr+zEIhJjRjuJ+UckGweoNzkcLtc1ku
         9AdDYeWgnVj71XRrtLmVJCCYON8Lk6POfJk/py9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sungbo Eo <mans0n@gorani.run>,
        Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 111/232] irqchip/versatile-fpga: Apply clear-mask earlier
Date:   Thu, 16 Apr 2020 15:23:25 +0200
Message-Id: <20200416131329.017834513@linuxfoundation.org>
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

commit 6a214a28132f19ace3d835a6d8f6422ec80ad200 upstream.

Clear its own IRQs before the parent IRQ get enabled, so that the
remaining IRQs do not accidentally interrupt the parent IRQ controller.

This patch also fixes a reboot bug on OX820 SoC, where the remaining
rps-timer IRQ raises a GIC interrupt that is left pending. After that,
the rps-timer IRQ is cleared during driver initialization, and there's
no IRQ left in rps-irq when local_irq_enable() is called, which evokes
an error message "unexpected IRQ trap".

Fixes: bdd272cbb97a ("irqchip: versatile FPGA: support cascaded interrupts from DT")
Signed-off-by: Sungbo Eo <mans0n@gorani.run>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200321133842.2408823-1-mans0n@gorani.run
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-versatile-fpga.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/irqchip/irq-versatile-fpga.c
+++ b/drivers/irqchip/irq-versatile-fpga.c
@@ -212,6 +212,9 @@ int __init fpga_irq_of_init(struct devic
 	if (of_property_read_u32(node, "valid-mask", &valid_mask))
 		valid_mask = 0;
 
+	writel(clear_mask, base + IRQ_ENABLE_CLEAR);
+	writel(clear_mask, base + FIQ_ENABLE_CLEAR);
+
 	/* Some chips are cascaded from a parent IRQ */
 	parent_irq = irq_of_parse_and_map(node, 0);
 	if (!parent_irq) {
@@ -221,9 +224,6 @@ int __init fpga_irq_of_init(struct devic
 
 	fpga_irq_init(base, node->name, 0, parent_irq, valid_mask, node);
 
-	writel(clear_mask, base + IRQ_ENABLE_CLEAR);
-	writel(clear_mask, base + FIQ_ENABLE_CLEAR);
-
 	/*
 	 * On Versatile AB/PB, some secondary interrupts have a direct
 	 * pass-thru to the primary controller for IRQs 20 and 22-31 which need


