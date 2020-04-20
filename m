Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747691B0B6E
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgDTMpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbgDTMpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BAEC206E9;
        Mon, 20 Apr 2020 12:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386706;
        bh=2Ie6yKzF7v/mul/AuyrteBRsfgDx4BWHEpn8CwEjUOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Us0vPc2RutNEiPPCxc9PPAT7H8+4dHnArOwBTa7Jm+wH1fvuxHQuLofcmtEUeAu5W
         xRqDEMU/4aHO7JW96gRAmO884+dMDAMIKM72Sg8K7mKXWzuy+p5tJEyQ+twglQe4SC
         lB01+ElcpyPNywNYYCHwXtpm28GullDFWBSQjERY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marc Zyngier <maz@kernel.org>,
        Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 5.6 66/71] irqchip/ti-sci-inta: Fix processing of masked irqs
Date:   Mon, 20 Apr 2020 14:39:20 +0200
Message-Id: <20200420121522.206830941@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit 3688b0db5c331f4ec3fa5eb9f670a4b04f530700 upstream.

The ti_sci_inta_irq_handler() does not take into account INTA IRQs state
(masked/unmasked) as it uses INTA_STATUS_CLEAR_j register to get INTA IRQs
status, which provides raw status value.
This causes hard IRQ handlers to be called or threaded handlers to be
scheduled many times even if corresponding INTA IRQ is masked.
Above, first of all, affects the LEVEL interrupts processing and causes
unexpected behavior up the system stack or crash.

Fix it by using the Interrupt Masked Status INTA_STATUSM_j register which
provides masked INTA IRQs status.

Fixes: 9f1463b86c13 ("irqchip/ti-sci-inta: Add support for Interrupt Aggregator driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>
Link: https://lore.kernel.org/r/20200408191532.31252-1-grygorii.strashko@ti.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-ti-sci-inta.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-ti-sci-inta.c
+++ b/drivers/irqchip/irq-ti-sci-inta.c
@@ -37,6 +37,7 @@
 #define VINT_ENABLE_SET_OFFSET	0x0
 #define VINT_ENABLE_CLR_OFFSET	0x8
 #define VINT_STATUS_OFFSET	0x18
+#define VINT_STATUS_MASKED_OFFSET	0x20
 
 /**
  * struct ti_sci_inta_event_desc - Description of an event coming to
@@ -116,7 +117,7 @@ static void ti_sci_inta_irq_handler(stru
 	chained_irq_enter(irq_desc_get_chip(desc), desc);
 
 	val = readq_relaxed(inta->base + vint_desc->vint_id * 0x1000 +
-			    VINT_STATUS_OFFSET);
+			    VINT_STATUS_MASKED_OFFSET);
 
 	for_each_set_bit(bit, &val, MAX_EVENTS_PER_VINT) {
 		virq = irq_find_mapping(domain, vint_desc->events[bit].hwirq);


