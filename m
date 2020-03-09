Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD5417E09B
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 13:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgCIMwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 08:52:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39013 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgCIMwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 08:52:13 -0400
Received: by mail-lj1-f195.google.com with SMTP id f10so9781605ljn.6
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 05:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jYBuqb72AK3TYTrpjzcg5ppPY/IO7sFjcVnsEoUJUs=;
        b=u0L8Y1dkuQof2IQS0cJbbgpuEDPnAhllOQrrD4TX1NmbRjv8aJ2gsymPzjuFZjRxYj
         oxz1LVWqxSF4QhVMK8X8S7Npkt5idEIRYNDx/BvEFz+GVcqyNPi1P2xaxfmBBS8cCCkQ
         +xYNgr0K61EANA6R+4lrfB19k7BMdO+6ETuZx5ecVoqSSazYcWWzZg1fRcXFFWYZGw6N
         68y+1jdPc+S0QI7CAUbdi5Wl/VjdJ/xb0hyLmZ6giJH7C4YpRL22/Z3YhRCG+Ld2ULWp
         NBQizi2sKA+R/U9MZX1fLqajpR9ymuKmGwCFY9edZ+OiGlG10BubQa7ypTuSzt9f9SkX
         GTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jYBuqb72AK3TYTrpjzcg5ppPY/IO7sFjcVnsEoUJUs=;
        b=QV2L1iVL6rvU95RQSsB3kqPGjyFRXyMdF5dh88C9GWjglY/jkmWuMb+G15MDW3f8/J
         7dp4tHix/XDgyCZn2C71ZsnC0/t6jYl6Iuuw74bIoLidLZtNFlQo8QkzSkLMYRQV1QeH
         rUVErQ6nalM+zznRLwwQNCNwXJf6NdJtCsew9faEM27Y8shH4n+vJXlBEWcvDSNI7Vm6
         KCzyF7k7gSbkmE2sURO/ZGJTwz06w4Uujv150/XIRwWjl1fnEdxZ8OxScOCWwvApYla7
         HGiTIh+UMOjGjMHznB5XSJLTAOyeel6CXOVHwv5p7lFK0XkX0Pu2vRiBnBUoSv9HJhg3
         p7Mw==
X-Gm-Message-State: ANhLgQ3AhktmzqKhXYtQmDqCuhsI73p3hxuB5XwR8WqCtJHlESC4GPpa
        4ydd2rB46ZfBRjgZpiw+AIslTA==
X-Google-Smtp-Source: ADFU+vu/HK0rkNYZal/GmZ0rmHgzPK1yezejj8bxI79CUI04kMjtXjxPmfi3xnEhFcK/mo4kIegmVA==
X-Received: by 2002:a2e:3210:: with SMTP id y16mr5093105ljy.49.1583758330651;
        Mon, 09 Mar 2020 05:52:10 -0700 (PDT)
Received: from genomnajs.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id 133sm3122755ljj.91.2020.03.09.05.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 05:52:10 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-gpio@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2] pinctrl: qcom: Assign irq_disable/eoi conditionally
Date:   Mon,  9 Mar 2020 13:52:07 +0100
Message-Id: <20200309125207.571840-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The hierarchical parts of MSM pinctrl/GPIO is only
used when the device tree has a "wakeup-parent" as
a phandle, but the .irq_disable and .irq_eoi are anyway
assigned leading to semantic problems on elder
Qualcomm chipsets.

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

As a solution, just assign the .irq_disable and .irq_eoi
condtionally if we are actually using a wakeup parent.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Lina Iyer <ilina@codeaurora.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org
Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Noticed that the previous solution doesn't actually work,
  the machine hangs and reboots intead (even if it got rid of
  the most obvious crash). Make a more thorough solution that
  completely avoids using these callbacks if we don't have
  a parent.
- v1 was called "Guard irq_eoi()"
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 9a8daa256a32..fe3c53ae25f4 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1100,11 +1100,9 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 
 	pctrl->irq_chip.name = "msmgpio";
 	pctrl->irq_chip.irq_enable = msm_gpio_irq_enable;
-	pctrl->irq_chip.irq_disable = msm_gpio_irq_disable;
 	pctrl->irq_chip.irq_mask = msm_gpio_irq_mask;
 	pctrl->irq_chip.irq_unmask = msm_gpio_irq_unmask;
 	pctrl->irq_chip.irq_ack = msm_gpio_irq_ack;
-	pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
 	pctrl->irq_chip.irq_set_type = msm_gpio_irq_set_type;
 	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
 	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
@@ -1118,7 +1116,8 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 		if (!chip->irq.parent_domain)
 			return -EPROBE_DEFER;
 		chip->irq.child_to_parent_hwirq = msm_gpio_wakeirq;
-
+		pctrl->irq_chip.irq_disable = msm_gpio_irq_disable;
+		pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
 		/*
 		 * Let's skip handling the GPIOs, if the parent irqchip
 		 * is handling the direct connect IRQ of the GPIO.
-- 
2.24.1

