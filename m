Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B412C40DA
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 14:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgKYNDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 08:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729463AbgKYNDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 08:03:52 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37C0C0613D4;
        Wed, 25 Nov 2020 05:03:52 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id w187so2265512pfd.5;
        Wed, 25 Nov 2020 05:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uQ7/J6mWOfsN3BtZkGR34q6jzAZOvIhIm2QhqT8hJ+4=;
        b=LKBK29mq4xYlzKuelsVSpFU01nKVQPcMKk3Uc1YFKYkJwYzxQDmZys82AL8wAKzOiD
         hIg2tHtLpdIp6zcqPv8cAmOjfWguY039LdcXt0MR7G6S1KNsCX0q35MkdfLEdEAZxlGh
         uUEaemS3AnOT0uYSb0SX9GPkCpdhTGH5uybgKoLbV+WsZwr7tGlGtA+XWcQvaE3zKE2s
         JBwEsTe1HpnmH2hrPmjtdcHMDRGPHyaS7RKwoAFXFvJokBX9mxrYhxCmZvhc+vwilo+3
         bDAGZha1iF1JnDmkehTLnFVv+W9tR5j20B+nZ16orLywkaEZRuTeOfgcE8Dqw9DONh7z
         r+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uQ7/J6mWOfsN3BtZkGR34q6jzAZOvIhIm2QhqT8hJ+4=;
        b=N5IQ9iF2I94ewcyetr7QF5vGz0/lcGOKbTz4s16ocHjjsfeJaIE/STRTeqGptdTA+v
         QjLdSzYuZpTg+ZBafe5gSHmg0a81Z3AFSYi5t6nUipCEoUIAPz7qZavkocIHOKc1F5sM
         B38Xg/vH0bijVBuGmManqg8qOCZGso9yf5vXjHGGjgzmuINww660DuzBYcynNiCnkzpc
         cxTALvR9G6203WmTmaY2EqNdNmwWHW61m7UbrPvXLkB8x1tNwB8p5vm0lNadHQrSIwX2
         vvJs8V9fOFP/g5ZVrVg6UvdYG2LA8gqpnCW5CdWjpoUwp669SCBpmCnNSrshHP7rhhVR
         FlvA==
X-Gm-Message-State: AOAM530W3x3MHCDHaukVdfst2AejRTyP2s1U0vXBI61wZ+ODnlgwIsVT
        tYbpeA8N262knowSJ8gujjA=
X-Google-Smtp-Source: ABdhPJwO2cGC3EIwce2u/NFzrQ2Z1QJLdPcXECOp1Q1Jw8T/TKp5EwK8babL1H+KiNhkfESy703U8A==
X-Received: by 2002:a17:90b:104c:: with SMTP id gq12mr3989452pjb.167.1606309432333;
        Wed, 25 Nov 2020 05:03:52 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id b21sm2881961pji.24.2020.11.25.05.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 05:03:51 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-gpio@vger.kernel.org, Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4] pinctrl: amd: remove debounce filter setting in IRQ type setting
Date:   Wed, 25 Nov 2020 21:03:19 +0800
Message-Id: <20201125130320.311059-1-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Debounce filter setting should be independent from IRQ type setting
because according to the ACPI specs, there are separate arguments for
specifying debounce timeout and IRQ type in GpioIo() and GpioInt().

Together with commit 06abe8291bc31839950f7d0362d9979edc88a666
("pinctrl: amd: fix incorrect way to disable debounce filter") and
Andy's patch "gpiolib: acpi: Take into account debounce settings" [1],
this will fix broken touchpads for laptops whose BIOS set the
debounce timeout to a relatively large value. For example, the BIOS
of Lenovo AMD gaming laptops including Legion-5 15ARH05 (R7000),
Legion-5P (R7000P) and IdeaPad Gaming 3 15ARH05, set the debounce
timeout to 124.8ms. This led to the kernel receiving only ~7 HID
reports per second from the Synaptics touchpad
(MSFT0001:00 06CB:7F28).

Existing touchpads like [2][3] are not troubled by this bug because
the debounce timeout has been set to 0 by the BIOS before enabling
the debounce filter in setting IRQ type.

[1] https://lore.kernel.org/linux-gpio/20201111222008.39993-11-andriy.shevchenko@linux.intel.com/
[2] https://github.com/Syniurge/i2c-amd-mp2/issues/11#issuecomment-721331582
[3] https://forum.manjaro.org/t/random-short-touchpad-freezes/30832/28

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190
Link: https://lore.kernel.org/linux-gpio/CAHp75VcwiGREBUJ0A06EEw-SyabqYsp%2Bdqs2DpSrhaY-2GVdAA%40mail.gmail.com/
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
Changelog v4:
 - Note in the commit message that this patch depends on other two
   patches to fix the broken touchpad [Hans de Goede]
 - Add in the commit message that one more touchpad could be fixed.

Changelog v3:
 - Explain why the driver mistakenly took the slightly deviated value
   of debounce timeout in the commit message (patch 2/4) [Andy Shevchenko]
 - Explain why other touchpads are affected by the issue of setting debounce
   filter in IRQ type setting in the commit message (patch 4/4)

Changelog v2:
 - Message-Id to Link and grammar fixes for commit messages [Andy Shevchenko]
---
 drivers/pinctrl/pinctrl-amd.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 4aea3e05e8c6..899c16c17b6d 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -429,7 +429,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
-		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_edge_irq);
 		break;

@@ -437,7 +436,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
-		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_edge_irq);
 		break;

@@ -445,7 +443,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= BOTH_EADGE << ACTIVE_LEVEL_OFF;
-		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_edge_irq);
 		break;

@@ -453,8 +450,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
-		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
-		pin_reg |= DB_TYPE_PRESERVE_LOW_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_level_irq);
 		break;

@@ -462,8 +457,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
-		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
-		pin_reg |= DB_TYPE_PRESERVE_HIGH_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_level_irq);
 		break;

--
2.29.2

