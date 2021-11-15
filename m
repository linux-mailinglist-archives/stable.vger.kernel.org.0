Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3720E452245
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377415AbhKPBKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245136AbhKOTTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30CAC61547;
        Mon, 15 Nov 2021 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000937;
        bh=lmK6jN2Xbbcmtyel6K/GevwNQIxS//y04To2B659sXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvIqv7iRe3ge2Y7vcYB8UUheAbrEYeYPkRKKHKqR6JbWQjfkE8VJ1dT5NaYQXCpvR
         xMNJfd4YVkfS5bKPLAMo+7z8zhCsFxzfAItxQbipzkqBhGcuADviYLdgvsemmHhzVz
         nOtU1gV+88KhTSSWahjrCsWsB/fQnQV1A5bH8oNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.14 848/849] pinctrl: amd: Handle wake-up interrupt
Date:   Mon, 15 Nov 2021 18:05:31 +0100
Message-Id: <20211115165448.937606448@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit acd47b9f28e55b505aedb842131b40904e151d7c upstream.

Enable/disable power management wakeup mode, which is disabled by
default. enable_irq_wake enables wakes the system from sleep.

Hence added enable/disable irq_wake to handle wake-up interrupt.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20210831120613.1514899-3-Basavaraj.Natikar@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -445,6 +445,7 @@ static int amd_gpio_irq_set_wake(struct
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
 	u32 wake_mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3);
+	int err;
 
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 	pin_reg = readl(gpio_dev->base + (d->hwirq)*4);
@@ -457,6 +458,15 @@ static int amd_gpio_irq_set_wake(struct
 	writel(pin_reg, gpio_dev->base + (d->hwirq)*4);
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 
+	if (on)
+		err = enable_irq_wake(gpio_dev->irq);
+	else
+		err = disable_irq_wake(gpio_dev->irq);
+
+	if (err)
+		dev_err(&gpio_dev->pdev->dev, "failed to %s wake-up interrupt\n",
+			on ? "enable" : "disable");
+
 	return 0;
 }
 


