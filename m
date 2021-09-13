Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD80840943D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345958AbhIMO3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345462AbhIMO0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:26:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BD7E61B62;
        Mon, 13 Sep 2021 13:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540948;
        bh=lTmFjbFJNaynfMHEyg/jKzXMsCObDxdudbkUztee5/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imVBZjxvbzCbE9yj2B/2rMdahJiEIMtNE55ShHNXXoQSDnepiDPXF/qsOKCvPbmHc
         GgQMZ9tNnEaDgv1puIN4hYVcXbuwIFKBB9UrXRNAEmks43trGig5yz8qSparC80JEa
         Spr1FcDN4h5VD5jMA8vB+cBC+tJH+k7usNvLkhKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Peter <sven@svenpeter.dev>,
        Hector Martin <marcan@marcan.st>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 068/334] irqchip/apple-aic: Fix irq_disable from within irq handlers
Date:   Mon, 13 Sep 2021 15:12:02 +0200
Message-Id: <20210913131115.707554063@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index b8c06bd8659e..6fc145aacaf0 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -226,7 +226,7 @@ static void aic_irq_eoi(struct irq_data *d)
 	 * Reading the interrupt reason automatically acknowledges and masks
 	 * the IRQ, so we just unmask it here if needed.
 	 */
-	if (!irqd_irq_disabled(d) && !irqd_irq_masked(d))
+	if (!irqd_irq_masked(d))
 		aic_irq_unmask(d);
 }
 
-- 
2.30.2



