Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F53C2A8A94
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 00:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbgKEXTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 18:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732619AbgKEXTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 18:19:51 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C979C0613CF;
        Thu,  5 Nov 2020 15:19:51 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id g12so2441803pgm.8;
        Thu, 05 Nov 2020 15:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZvuAaXaGPWts7AqKgFuWP3PSEOzxpeORG8IMIk9DoB4=;
        b=DNq2H1i/lxy9ZD2eMAVfw4Xj39DpfmFWATXoOkIXtji9N26TyXOIq0nX+I90QL05hU
         cimKK43s5ZZ0JpBX2WK6mD/g3wRbeikjopOuqBuKFziydVgUdlaAZTqCCR7r1QiQjpHr
         0FKmbI7BeBqg1cA8RF9AFr34Dbrq/U/TeYd3rDi0HAhBqkEeA2gqQ6sUbVJ0zXxNqxfc
         o+UGaNoPGBigPsruErZg6CUTDp3w9345Oc7PPC6bZMK18fnz/FwU35R02hfDYtNQiowe
         jdzXXMYwVRjMFB1DDH7MK7zM0x+8BqkSXltH7QTf5TKijODRViKh/Czidm47pVZAn9pP
         ob9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZvuAaXaGPWts7AqKgFuWP3PSEOzxpeORG8IMIk9DoB4=;
        b=ChUuYWY3fWp8IWqaRCkLDxNP6PmaS4+FYi3AN/7QhR+QEb/QFEHImElyJRSes68LIt
         kQKgmn3WwiHLTraAjwPeS76DnvyUqNBXudiImgKUDhbdi0nDtT3y/hTEvxLVeWY1XLwn
         lJvsGoptrPv+FCQdX/i6YbZOivlxsXXcIVbElJD78E81/t/psln9YkuJCKhNVGS/XpHO
         +eOvK8ujw+16FvLLb6BbbhIeLjP87KwmkFNpCFEW8St63oOoA69YyZHvsehyzEfipYXV
         k/9nBFkDPuHzi0OHcUv2ZPZ2Zr73kR4rHseYKInSPa6lyOEbJjO9ECTE6R7CnoyRXpFF
         I/Hg==
X-Gm-Message-State: AOAM531WX0DL0f8V60YsPqfWNLSS32BUnpvJt19EqBYVF4uPmPsyPNHR
        u56JcqDTB31g8ndwBRf8qtk=
X-Google-Smtp-Source: ABdhPJxC7s0KyUzzjTN44KHWc9Kartycy+HPFUodJA47ebCdebAduo6jo7PF91e8O+OdzZpG+ED+0g==
X-Received: by 2002:a63:500c:: with SMTP id e12mr4473230pgb.346.1604618390958;
        Thu, 05 Nov 2020 15:19:50 -0800 (PST)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id y141sm3691695pfb.17.2020.11.05.15.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 15:19:50 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-gpio@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 4/4] pinctrl: amd: remove debounce filter setting in IRQ type setting
Date:   Fri,  6 Nov 2020 07:19:12 +0800
Message-Id: <20201105231912.69527-5-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201105231912.69527-1-coiby.xu@gmail.com>
References: <20201105231912.69527-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Debounce filter setting should be independent from IRQ type setting
because according to the ACPI specs, there are separate arguments for
specifying debounce timeout and IRQ type in GpioIo() and GpioInt().

This will fix broken touchpads for laptops whose BIOS set the debounce
timeout to a relatively large value. For example, the BIOS of Lenovo
Legion-5 AMD gaming laptops including 15ARH05 (R7000) and R7000P set
the debounce timeout to 124.8ms. This led to the kernel receiving only
~7 HID reports per second from the Synaptics touchpad
(MSFT0001:00 06CB:7F28). Existing touchpads like [1][2] are not troubled
by this bug because the debounce timeout has been set to 0 by the BIOS
before enabling the debounce filter in setting IRQ type.

[1] https://github.com/Syniurge/i2c-amd-mp2/issues/11#issuecomment-721331582
[2] https://forum.manjaro.org/t/random-short-touchpad-freezes/30832/28

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190
Link: https://lore.kernel.org/linux-gpio/CAHp75VcwiGREBUJ0A06EEw-SyabqYsp%2Bdqs2DpSrhaY-2GVdAA%40mail.gmail.com/
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/pinctrl/pinctrl-amd.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index e9b761c2b77a..2d4acf21117c 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -468,7 +468,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
-		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 
@@ -476,7 +475,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
-		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 
@@ -484,7 +482,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= BOTH_EADGE << ACTIVE_LEVEL_OFF;
-		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 
@@ -492,8 +489,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
-		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
-		pin_reg |= DB_TYPE_PRESERVE_LOW_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_level_irq);
 		break;
 
@@ -501,8 +496,6 @@ static int amd_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
-		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
-		pin_reg |= DB_TYPE_PRESERVE_HIGH_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_level_irq);
 		break;
 
-- 
2.28.0

