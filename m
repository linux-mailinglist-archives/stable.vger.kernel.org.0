Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A210419CB2
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhI0RbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238626AbhI0R3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:29:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27E5B61502;
        Mon, 27 Sep 2021 17:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763068;
        bh=X8iF+tJ2hl1S2xvDLGUFSfPhNmzlcxy+rfmzsjAJNqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXLMV/ygbn7iIs2u2fQGyXKy3jJL+QFFQeZa18Gixk9pYn7il39tIfLyD1qDJkB/R
         IXpWqSRnAxoFFP9x6vMXNdCuFDUdXydC/o/OFn7VIwLPv0LrJmAzvHBUc3JDKjkw9g
         vvRD/HEtTvt2UJtB/dtqFhBVI09da06JMMuBahDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: [PATCH 5.14 154/162] irqchip/armada-370-xp: Fix ack/eoi breakage
Date:   Mon, 27 Sep 2021 19:03:20 +0200
Message-Id: <20210927170238.760864204@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 2a7313dc81e88adc7bb09d0f056985fa8afc2b89 upstream.

When converting the driver to using handle_percpu_devid_irq,
we forgot to repaint the irq_eoi() callback into irq_ack(),
as handle_percpu_devid_fasteoi_ipi() was actually using EOI
really early in the handling. Yes this was a stupid idea.

Fix this by using the HW ack method as irq_ack().

Fixes: e52e73b7e9f7 ("irqchip/armada-370-xp: Make IPIs use handle_percpu_devid_irq()")
Reported-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Tested-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87tuiexq5f.fsf@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-armada-370-xp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -359,16 +359,16 @@ static void armada_370_xp_ipi_send_mask(
 		ARMADA_370_XP_SW_TRIG_INT_OFFS);
 }
 
-static void armada_370_xp_ipi_eoi(struct irq_data *d)
+static void armada_370_xp_ipi_ack(struct irq_data *d)
 {
 	writel(~BIT(d->hwirq), per_cpu_int_base + ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS);
 }
 
 static struct irq_chip ipi_irqchip = {
 	.name		= "IPI",
+	.irq_ack	= armada_370_xp_ipi_ack,
 	.irq_mask	= armada_370_xp_ipi_mask,
 	.irq_unmask	= armada_370_xp_ipi_unmask,
-	.irq_eoi	= armada_370_xp_ipi_eoi,
 	.ipi_send_mask	= armada_370_xp_ipi_send_mask,
 };
 


