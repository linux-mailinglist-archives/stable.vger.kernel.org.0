Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC861880CE
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgCQLNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729478AbgCQLNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:13:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35082071C;
        Tue, 17 Mar 2020 11:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443610;
        bh=zEk5EsMyM/P5rjclWB9KLkBKcIJ17aHR4IY1NTv7k0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wltW4OzlPKUXvew/lY+yQCxVX4snBaHGxU+37HrMQC4zDvuyhaS9xClcTpVoAWn8J
         mBCWhptKcR4lXgJqXEia1pvgjmFOfnm9GlYtVcJhcRWB/FNQCQS4GFNyS1kUS3VopR
         A1lsQWEpez2Prfike6WTf7aEbVV+4x4oCGJrWqjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.5 093/151] pinctrl: qcom: Assign irq_eoi conditionally
Date:   Tue, 17 Mar 2020 11:55:03 +0100
Message-Id: <20200317103333.056214806@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 1cada2f307665e208a486d7ac2294ed9a6f74a6f upstream.

The hierarchical parts of MSM pinctrl/GPIO is only
used when the device tree has a "wakeup-parent" as
a phandle, but the .irq_eoi is anyway assigned leading
to semantic problems on elder Qualcomm chipsets.

When the drivers/mfd/qcom-pm8xxx.c driver calls
chained_irq_exit() that call will in turn call chip->irq_eoi()
which is set to irq_chip_eoi_parent() by default on a
hierachical IRQ chip, and the parent is pinctrl-msm.c
so that will in turn unconditionally call
irq_chip_eoi_parent() again, but its parent is invalid
so we get the following crash:

 Unnable to handle kernel NULL pointer dereference at
 virtual address 00000010
 pgd = (ptrval)
 [00000010] *pgd=00000000
 Internal error: Oops: 5 [#1] PREEMPT SMP ARM
 (...)
 PC is at irq_chip_eoi_parent+0x4/0x10
 LR is at pm8xxx_irq_handler+0x1b4/0x2d8

If we solve this crash by avoiding to call up to
irq_chip_eoi_parent(), the machine will hang and get
reset by the watchdog, because of semantic issues,
probably inside irq_chip.

As a solution, just assign the .irq_eoi conditionally if
we are actually using a wakeup parent.

Cc: David Heidelberg <david@ixit.cz>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Lina Iyer <ilina@codeaurora.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org
Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Link: https://lore.kernel.org/r/20200306121221.1231296-1-linus.walleij@linaro.org
Link: https://lore.kernel.org/r/20200309125207.571840-1-linus.walleij@linaro.org
Link: https://lore.kernel.org/r/20200309152604.585112-1-linus.walleij@linaro.org
Tested-by: David Heidelberg <david@ixit.cz>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/qcom/pinctrl-msm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1104,7 +1104,6 @@ static int msm_gpio_init(struct msm_pinc
 	pctrl->irq_chip.irq_mask = msm_gpio_irq_mask;
 	pctrl->irq_chip.irq_unmask = msm_gpio_irq_unmask;
 	pctrl->irq_chip.irq_ack = msm_gpio_irq_ack;
-	pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
 	pctrl->irq_chip.irq_set_type = msm_gpio_irq_set_type;
 	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
 	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
@@ -1118,7 +1117,7 @@ static int msm_gpio_init(struct msm_pinc
 		if (!chip->irq.parent_domain)
 			return -EPROBE_DEFER;
 		chip->irq.child_to_parent_hwirq = msm_gpio_wakeirq;
-
+		pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
 		/*
 		 * Let's skip handling the GPIOs, if the parent irqchip
 		 * is handling the direct connect IRQ of the GPIO.


