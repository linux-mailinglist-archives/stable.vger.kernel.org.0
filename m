Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6D04090F7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244566AbhIMN5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244824AbhIMNzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:55:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81FB46124A;
        Mon, 13 Sep 2021 13:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540134;
        bh=E6Ko0Dh8PQIrm2t1fWvgN2n4AudnrxF/bkAePU23Rgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=opbsK47FLiGj7uc/9trZ8yw/X/qlm15rFikLSDXdEQuDGPX543Bxq++akRk2xIJQ+
         thn4lUIcsrr4HxvoJH0+zYcU2zQtTAQZ4loZ0cOU7PnFQQ5O0exZuAr9axCvhig1Al
         HqU823plZBLarevORxiNy4CV5siEs3x+DsSu6EzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Peter <sven@svenpeter.dev>,
        Hector Martin <marcan@marcan.st>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 066/300] irqchip/apple-aic: Fix irq_disable from within irq handlers
Date:   Mon, 13 Sep 2021 15:12:07 +0200
Message-Id: <20210913131111.595522253@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 60a1cd10b222e004f860d14651e80089c77e8e6b ]

When disable_irq_nosync for an interrupt is called from within its
interrupt handler, this interrupt is only marked as disabled with the
intention to mask it when it triggers again.
The AIC hardware however automatically masks the interrupt when it is read.
aic_irq_eoi then unmasks it again if it's not disabled *and* not masked.
This results in a state mismatch between the hardware state and the
state kept in irq_data: The hardware interrupt is masked but
IRQD_IRQ_MASKED is not set. Any further calls to unmask_irq will directly
return and the interrupt can never be enabled again.

Fix this by keeping the hardware and irq_data state in sync by unmasking in
aic_irq_eoi if and only if the irq_data state also assumes the interrupt to
be unmasked.

Fixes: 76cde2639411 ("irqchip/apple-aic: Add support for the Apple Interrupt Controller")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Acked-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210812100942.17206-1-sven@svenpeter.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-apple-aic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index c179e27062fd..151aab408fa6 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -225,7 +225,7 @@ static void aic_irq_eoi(struct irq_data *d)
 	 * Reading the interrupt reason automatically acknowledges and masks
 	 * the IRQ, so we just unmask it here if needed.
 	 */
-	if (!irqd_irq_disabled(d) && !irqd_irq_masked(d))
+	if (!irqd_irq_masked(d))
 		aic_irq_unmask(d);
 }
 
-- 
2.30.2



