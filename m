Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B42417BC6A
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 13:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCFMMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 07:12:25 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46388 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgCFMMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 07:12:25 -0500
Received: by mail-lf1-f68.google.com with SMTP id v6so1689704lfo.13
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 04:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MdGLbXy1B+XD+XeVWDRp+Nncre/eMQNyqszADUGHI/E=;
        b=U98TlMWc0ETX7ITPk2EBkznugDxokNO8grELVoCdAPYy56inrAKLX4QoKdie2XeLt8
         7bQe7zuoXKVdZmGxFof9IkKlO/WEuuLm2C6sTbbmsIqWLGpTXOavL8v62CsjQJrCA7Ty
         r2ytlDJCL5zMvOqaTyd5ZTW/YU+Cf7jV1k9O7+V0D571UUwmYvAo3kL967Qfa+I7TcSn
         fvmdCup28viSct+XkpWPBtlRhZ6Gtbto3NS6XqsdYDjEK3qyOGIqote42SkPLBnQe7fq
         TO0d2tFF6gAHFz035c88r+39Owf3kqreeALQWwkIvW6AiCIJ19MxjQ2eAOxlopVvilMD
         fVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MdGLbXy1B+XD+XeVWDRp+Nncre/eMQNyqszADUGHI/E=;
        b=TM+jz9grw+jpnz1wTB46xWX4M77aMts9oA/VW4sGMSzmZX+R5RyQ3wkbcMU2GnVU/8
         wQrs7RV7+AtF36VgkIdmCYybByBpFdE9hrL1wigyafDub+zJQlhkaNlJC7sJgciXBZjp
         gz7Or/Yyjcnh6YedUtxFnsEz4RwrH4DLCu2548j4PCh4OvSptiAKm51+d1E0RZBLc557
         D05wgnDMH0ouHYSHT5xIOjZI1oueh0ACHhUOvlvfXymXru2KP9anUTYOnGEZgtqQkYX8
         aiixY2oSnoV817fpyhqLuhpPhkijptmhTl+8FqPuMXCU4RxtHbDa0jtiscs+f2H2o2S6
         RoHw==
X-Gm-Message-State: ANhLgQ12ykAe+4aEKzNqlPxvnknhKYzhU5EhGN42kvw4fVExu0RyhPqY
        W/Hv48FWztk8CZgtc6mfBCguuw==
X-Google-Smtp-Source: ADFU+vsdxv9EKXCC75n0AXj6pYl9BU2DcF9kaZTVaUWJGGSi0JL+PM1v6wqQ65nQvY1SRw4LrBHxCw==
X-Received: by 2002:ac2:529c:: with SMTP id q28mr1798946lfm.59.1583496743953;
        Fri, 06 Mar 2020 04:12:23 -0800 (PST)
Received: from genomnajs.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id u16sm16829780lfl.23.2020.03.06.04.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 04:12:23 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-gpio@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] pinctrl: qcom: Guard irq_eoi()
Date:   Fri,  6 Mar 2020 13:12:21 +0100
Message-Id: <20200306121221.1231296-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the commit setting up the qcom/msm pin controller to
be hierarchical some callbacks were careful to check that
d->parent_data on irq_data was valid before calling the
parent function, however irq_chip_eoi_parent() was called
unconditionally which doesn't work with elder Qualcomm
platforms such as APQ8060.

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

Implement a local stub just avoiding to call down to
irq_chip_eoi_parent() if d->parent_data is not set.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Lina Iyer <ilina@codeaurora.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org
Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 9a8daa256a32..511f596cf2c3 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -828,6 +828,12 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
 	msm_gpio_irq_clear_unmask(d, false);
 }
 
+static void msm_gpio_irq_eoi(struct irq_data *d)
+{
+	if (d->parent_data)
+		irq_chip_eoi_parent(d);
+}
+
 static void msm_gpio_irq_ack(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
@@ -1104,7 +1110,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	pctrl->irq_chip.irq_mask = msm_gpio_irq_mask;
 	pctrl->irq_chip.irq_unmask = msm_gpio_irq_unmask;
 	pctrl->irq_chip.irq_ack = msm_gpio_irq_ack;
-	pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
+	pctrl->irq_chip.irq_eoi = msm_gpio_irq_eoi;
 	pctrl->irq_chip.irq_set_type = msm_gpio_irq_set_type;
 	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
 	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
-- 
2.24.1

