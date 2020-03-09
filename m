Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD2417E38D
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 16:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCIP0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 11:26:10 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43285 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgCIP0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 11:26:10 -0400
Received: by mail-lj1-f195.google.com with SMTP id r7so10378310ljp.10
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 08:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n2G0KJizTTOJ4ehEUzWr6CGXlUcOSYAVKuBsGihIoBo=;
        b=l9uMC/7OGHVpByY57dMcWSod0Pgt6xYh1UOTZtkZbca5i5uzN2PGzmqQPsJVhoRddK
         sdPl4a/RHYl+TJQW8S0h5r3czciP6Y3dA8E2unKQiimqpwF6oWZ0jVlcpdmd1N9JSwIR
         +4Zd+jDHSakBYsEw9U3VZeoQTJDmVOog3u9Xjn4pOTPpiP8MV45RyfqgzZd6AGQJAUNM
         7aoYpM+OGrw5G1NOtcdz0FMdfklrWhyQxYraUohp/1R/QfbJvG3XG4XDDyOy0kCSWGL3
         Et6MGnhy5QfRZp7/MTlKQiDouprrOOqPv7gKogf1fdzGmwnPfkCXginPqxqCN0WJb5at
         VniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n2G0KJizTTOJ4ehEUzWr6CGXlUcOSYAVKuBsGihIoBo=;
        b=Abtr8Vsghs/kiS0bKmkVua1BfOrvQDKW6+HZjUwudEn2GWrbiewVXFKmHTTw01P9tB
         bqKvsEm6lMV1vqVhWIPeV2KvqzVH8OHu3TOqFuQdp/fuzxBJOGJZbQOvbHY6Uvv7FH2M
         0HJHtM3Ctt6zgKOulf2D0Yf+Zl4MrBQ/H6n3YFIWaG7StbdOnP3+HEQ+ykKUaFLFcc2m
         p7QGwQcD9vL1LHBJ7xbq3KKGlkZ8i1YXMWXSYrPZiRLk9uqZel0v0yN3ti9aOULBDfuD
         cC4DIFopuji82H3PKZ4/GLfXaPiDgCvUp9s/IU69u2iCjQ+4dKAYuZ52PL9MqjMGH1qH
         UqNQ==
X-Gm-Message-State: ANhLgQ3MOu3JGaCV1EDJFNr8qZ9/Vx+yhWQDwV67P0uLDpXgfEb/BKAL
        7EHjxfiWKXlLDBbgecY8etsecA==
X-Google-Smtp-Source: ADFU+vu/mPFMTwZzvD4SLct2qUyLQ3MOBNjuvflCxGLDc1sZJ2r+xIaGSsFNHSfJN1x/29WE6U671A==
X-Received: by 2002:a2e:b6c6:: with SMTP id m6mr10138727ljo.3.1583767566796;
        Mon, 09 Mar 2020 08:26:06 -0700 (PDT)
Received: from genomnajs.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id w24sm21270925ljh.26.2020.03.09.08.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:26:06 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-gpio@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v4] pinctrl: qcom: Assign irq_eoi conditionally
Date:   Mon,  9 Mar 2020 16:26:04 +0100
Message-Id: <20200309152604.585112-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Marc Zyngier <maz@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org
Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Link: https://lore.kernel.org/r/20200306121221.1231296-1-linus.walleij@linaro.org
Link: https://lore.kernel.org/r/20200309125207.571840-1-linus.walleij@linaro.org
Tested-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Fix the patch subject too, doh.
ChangeLog v2->v3:
- Keep .irq_disable() around, just make the assignment of
  .irq_eoi() conditional.
ChangeLog v1->v2:
- Noticed that the previous solution doesn't actually work,
  the machine hangs and reboots intead (even if it got rid of
  the most obvious crash). Make a more thorough solution that
  completely avoids using these callbacks if we don't have
  a parent.
- v1 was called "Guard irq_eoi()"
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 9a8daa256a32..1a948c3f54b7 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1104,7 +1104,6 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	pctrl->irq_chip.irq_mask = msm_gpio_irq_mask;
 	pctrl->irq_chip.irq_unmask = msm_gpio_irq_unmask;
 	pctrl->irq_chip.irq_ack = msm_gpio_irq_ack;
-	pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
 	pctrl->irq_chip.irq_set_type = msm_gpio_irq_set_type;
 	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
 	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
@@ -1118,7 +1117,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 		if (!chip->irq.parent_domain)
 			return -EPROBE_DEFER;
 		chip->irq.child_to_parent_hwirq = msm_gpio_wakeirq;
-
+		pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
 		/*
 		 * Let's skip handling the GPIOs, if the parent irqchip
 		 * is handling the direct connect IRQ of the GPIO.
-- 
2.24.1

