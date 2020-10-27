Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BB429B402
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780688AbgJ0Oyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1774898AbgJ0OwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:52:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DCDC21556;
        Tue, 27 Oct 2020 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810324;
        bh=8cdHXiz2haHL8AoZUxJTqV+Z1jOsc86PgTXTv2ZWsYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCgALPcahiFXcbOgbStVmbk59T18gzxSQXu3NjLLHIdl6oFaVlKwI/gWX5JHnkGXn
         IjHsWZv1DH2sFxzI/JAlvaBszuJT/+1DN6+WzTE/zUVhpkDeNmu/tweSRN2auv8eKp
         s6s4ojdlMbOauQusW++Gw+C5c1ItWK5wzm+slQ34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maulik Shah <mkshah@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 099/633] pinctrl: qcom: Use return value from irq_set_wake() call
Date:   Tue, 27 Oct 2020 14:47:22 +0100
Message-Id: <20201027135527.346165461@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maulik Shah <mkshah@codeaurora.org>

[ Upstream commit f41aaca593377a4fe3984459fd4539481263b4cd ]

msmgpio irqchip was not using return value of irq_set_irq_wake() callback
since previously GIC-v3 irqchip neither had IRQCHIP_SKIP_SET_WAKE flag nor
it implemented .irq_set_wake callback. This lead to irq_set_irq_wake()
return error -ENXIO.

However from 'commit 4110b5cbb014 ("irqchip/gic-v3: Allow interrupt to be
configured as wake-up sources")' GIC irqchip has IRQCHIP_SKIP_SET_WAKE
flag.

Use return value from irq_set_irq_wake() and irq_chip_set_wake_parent()
instead of always returning success.

Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Signed-off-by: Maulik Shah <mkshah@codeaurora.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/1601267524-20199-3-git-send-email-mkshah@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index a28a96ac2b671..22283ba797cd0 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1060,12 +1060,10 @@ static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	 * when TLMM is powered on. To allow that, enable the GPIO
 	 * summary line to be wakeup capable at GIC.
 	 */
-	if (d->parent_data)
-		irq_chip_set_wake_parent(d, on);
-
-	irq_set_irq_wake(pctrl->irq, on);
+	if (d->parent_data && test_bit(d->hwirq, pctrl->skip_wake_irqs))
+		return irq_chip_set_wake_parent(d, on);
 
-	return 0;
+	return irq_set_irq_wake(pctrl->irq, on);
 }
 
 static int msm_gpio_irq_reqres(struct irq_data *d)
-- 
2.25.1



