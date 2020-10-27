Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D562629B400
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780627AbgJ0Oyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1774823AbgJ0OwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:52:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E89207DE;
        Tue, 27 Oct 2020 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810322;
        bh=fslIBsPHp4jjoZR+pdao1rJp6y2LLiemfcDXhHuFw5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoLZ7+B5a0SBUB0TiQmsbmjuSfQLJt5wB1zoEnW19eHfWCCRWzd5hbdlc9b4vWmEW
         AeQTmJqKdbpVGTkmt10Nl8B3928OBLyZ+a1oJTCU44QxAyDfLM0Gc7VzNxSbd8l9pG
         +CIIRUfOfI9So0wtB1Qpteo0itbV/ITF099iWufg=
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
Subject: [PATCH 5.8 098/633] pinctrl: qcom: Set IRQCHIP_SET_TYPE_MASKED and IRQCHIP_MASK_ON_SUSPEND flags
Date:   Tue, 27 Oct 2020 14:47:21 +0100
Message-Id: <20201027135527.296099812@linuxfoundation.org>
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

[ Upstream commit c5f72aeb659eb2f809b9531d759651514d42aa3a ]

Both IRQCHIP_SET_TYPE_MASKED and IRQCHIP_MASK_ON_SUSPEND flags are already
set for msmgpio's parent PDC irqchip but GPIO interrupts do not get masked
during suspend or during setting irq type since genirq checks irqchip flag
of msmgpio irqchip which forwards these calls to its parent PDC irqchip.

Add irqchip specific flags for msmgpio irqchip to mask non wakeirqs during
suspend and mask before setting irq type. Masking before changing type make
sures any spurious interrupt is not detected during this operation.

Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Signed-off-by: Maulik Shah <mkshah@codeaurora.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/1601267524-20199-2-git-send-email-mkshah@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index c322f30a20648..a28a96ac2b671 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1226,6 +1226,8 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	pctrl->irq_chip.irq_release_resources = msm_gpio_irq_relres;
 	pctrl->irq_chip.irq_set_affinity = msm_gpio_irq_set_affinity;
 	pctrl->irq_chip.irq_set_vcpu_affinity = msm_gpio_irq_set_vcpu_affinity;
+	pctrl->irq_chip.flags = IRQCHIP_MASK_ON_SUSPEND |
+				IRQCHIP_SET_TYPE_MASKED;
 
 	np = of_parse_phandle(pctrl->dev->of_node, "wakeup-parent", 0);
 	if (np) {
-- 
2.25.1



