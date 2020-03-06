Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4541417BC66
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 13:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgCFMLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 07:11:38 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39501 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgCFMLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 07:11:38 -0500
Received: by mail-lf1-f65.google.com with SMTP id j15so1725235lfk.6
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 04:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VEqsZXiHi8Vzu3E0Qtt3LIyZX6LwUkCnc30Vn2vU9Ak=;
        b=zFzQtOSjjltDX5jVktEU59kiyFn9FNMw9kPaMuvIeQSuE1/pSTIGxkEUj1l+uWxbmA
         vOAdR6z/PwAp3hDJe5Ei9H6LmApPc2mJX0ZqOhdJwk8gUyAdbk9IHBZlQL1evSk/7yo2
         /QZoiJdAUyrmyj0h+IBf41cet/T/YGQNeg55i1KHKjNDUzvc9Vi7xg1X5AOgLMfE2s5F
         UCw4rGDarFv/1Bh4+LCL+PWtCc6f96F9g0q4yaOpKO7PDW5sUS23V2rdRgBiBLFDgakv
         El8iV9dXC2jtFgPpsfggeY/p3g+3ihL7B8Q3tZOZt2ihNo757ETaZimIWeckb1ugxLT0
         jBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VEqsZXiHi8Vzu3E0Qtt3LIyZX6LwUkCnc30Vn2vU9Ak=;
        b=R0fypwaAxOkO6vUNKqbj9IpzXtCpI4tuKFavXOmEVY1a2KYU4hIuQe32G1JOjLtWnD
         4Lj1bOvFTHJN44gtav1Ny/HRdAaihUeptrJexpDId8kByc0IE8IBSbdgSe8kikTFrlmF
         jyS+Z8SddbaXJEEzk0uiyod74ftI8K0rN8zRg+DXm7jfvSUxmwve/jzkjyiuYQSruv/z
         pCC9VE1k+2ykwELE1Biwrn8fNhCwglFXd1c81KSpfeuIY5LyJaNBFMDbPNOJTh7Al3zi
         Gmy72tK5XvZVXo229yaYPrmaQSA2HxgXRTrrW933hX6SXbC9ai+d3tHzrQ1tVLJxN6sd
         unFw==
X-Gm-Message-State: ANhLgQ0Xw/+YDFlPHsGF9FRRPKUSWNSQgx1NtZiyzd6UYvkWsdKgU/K9
        6cEglRC6U3ftxMamQeO4rMy1Qg==
X-Google-Smtp-Source: ADFU+vusWHxWM2090L+QurVMnY/Ly7V8ZOTLsBWN8+l/yUDFL+8P6FUZWAbES3kVGO6/Xp3Rz8IRgg==
X-Received: by 2002:ac2:5468:: with SMTP id e8mr1738377lfn.193.1583496695868;
        Fri, 06 Mar 2020 04:11:35 -0800 (PST)
Received: from genomnajs.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id m15sm5178759ljo.52.2020.03.06.04.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 04:11:35 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-gpio@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] pinctrl: qcom: Guard irq_eoi()
Date:   Fri,  6 Mar 2020 13:11:29 +0100
Message-Id: <20200306121129.1231159-1-linus.walleij@linaro.org>
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

