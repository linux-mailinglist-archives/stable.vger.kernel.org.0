Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6755E6C755
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390644AbfGRDII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390121AbfGRDII (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:08 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC1222077C;
        Thu, 18 Jul 2019 03:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419287;
        bh=f/vlrT7KsR6TjfdCOFeh2Y7lHRcriwJ9EhQmW6ho/Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/dOjItufsb3B1irYOkaHJY794TFl61FQewh4AYssjm1h8s3gEM933OdF1bNBiWZa
         Ae6JATLUWx6mI3VvJSm1aLfe0ykmS3cMwOG6Av2duB0HVoWxTLT0rkd1tJcf87kCwa
         hKgEX2Qx8VVnovkT7KkvvRMRQbstliQ0vcPzXdmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Sean Wang <sean.wang@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/47] pinctrl: mediatek: Update cur_mask in mask/mask ops
Date:   Thu, 18 Jul 2019 12:01:42 +0900
Message-Id: <20190718030051.111797703@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
References: <20190718030045.780672747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9d957a959bc8c3dfe37572ac8e99affb5a885965 ]

During suspend/resume, mtk_eint_mask may be called while
wake_mask is active. For example, this happens if a wake-source
with an active interrupt handler wakes the system:
irq/pm.c:irq_pm_check_wakeup would disable the interrupt, so
that it can be handled later on in the resume flow.

However, this may happen before mtk_eint_do_resume is called:
in this case, wake_mask is loaded, and cur_mask is restored
from an older copy, re-enabling the interrupt, and causing
an interrupt storm (especially for level interrupts).

Step by step, for a line that has both wake and interrupt enabled:
 1. cur_mask[irq] = 1; wake_mask[irq] = 1; EINT_EN[irq] = 1 (interrupt
    enabled at hardware level)
 2. System suspends, resumes due to that line (at this stage EINT_EN
    == wake_mask)
 3. irq_pm_check_wakeup is called, and disables the interrupt =>
    EINT_EN[irq] = 0, but we still have cur_mask[irq] = 1
 4. mtk_eint_do_resume is called, and restores EINT_EN = cur_mask, so
    it reenables EINT_EN[irq] = 1 => interrupt storm as the driver
    is not yet ready to handle the interrupt.

This patch fixes the issue in step 3, by recording all mask/unmask
changes in cur_mask. This also avoids the need to read the current
mask in eint_do_suspend, and we can remove mtk_eint_chip_read_mask
function.

The interrupt will be re-enabled properly later on, sometimes after
mtk_eint_do_resume, when the driver is ready to handle it.

Fixes: 58a5e1b64bb0 ("pinctrl: mediatek: Implement wake handler and suspend resume")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Acked-by: Sean Wang <sean.wang@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index b9f3c02ba59d..564cfaee129d 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -113,6 +113,8 @@ static void mtk_eint_mask(struct irq_data *d)
 	void __iomem *reg = mtk_eint_get_offset(eint, d->hwirq,
 						eint->regs->mask_set);
 
+	eint->cur_mask[d->hwirq >> 5] &= ~mask;
+
 	writel(mask, reg);
 }
 
@@ -123,6 +125,8 @@ static void mtk_eint_unmask(struct irq_data *d)
 	void __iomem *reg = mtk_eint_get_offset(eint, d->hwirq,
 						eint->regs->mask_clr);
 
+	eint->cur_mask[d->hwirq >> 5] |= mask;
+
 	writel(mask, reg);
 
 	if (eint->dual_edge[d->hwirq])
@@ -217,19 +221,6 @@ static void mtk_eint_chip_write_mask(const struct mtk_eint *eint,
 	}
 }
 
-static void mtk_eint_chip_read_mask(const struct mtk_eint *eint,
-				    void __iomem *base, u32 *buf)
-{
-	int port;
-	void __iomem *reg;
-
-	for (port = 0; port < eint->hw->ports; port++) {
-		reg = base + eint->regs->mask + (port << 2);
-		buf[port] = ~readl_relaxed(reg);
-		/* Mask is 0 when irq is enabled, and 1 when disabled. */
-	}
-}
-
 static int mtk_eint_irq_request_resources(struct irq_data *d)
 {
 	struct mtk_eint *eint = irq_data_get_irq_chip_data(d);
@@ -384,7 +375,6 @@ static void mtk_eint_irq_handler(struct irq_desc *desc)
 
 int mtk_eint_do_suspend(struct mtk_eint *eint)
 {
-	mtk_eint_chip_read_mask(eint, eint->base, eint->cur_mask);
 	mtk_eint_chip_write_mask(eint, eint->base, eint->wake_mask);
 
 	return 0;
-- 
2.20.1



