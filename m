Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A552E37BB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgL1M7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbgL1M7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 958EE22AAA;
        Mon, 28 Dec 2020 12:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160365;
        bh=FwRUHDdPGtpKSW/WBJ6ArrHLmmHoqdAXZgw0/96+PxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nSiA2KcZ2o/QwmISzbJdpIUttQGYgDfIhFynjqmUbo+e8Tmzc6kFtaHIspzxLdZ0
         FHgEskAAVfHUDoiEsChRcM2mhLIp8tviZ2z2Wkt6Wm5IN97AB5KM3u+GdHQ1ciQRIP
         W0844zV8Qw/2HlNueygOWDZivZR9qzsogaOZDm3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coiby Xu <coiby.xu@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.9 009/175] pinctrl: amd: remove debounce filter setting in IRQ type setting
Date:   Mon, 28 Dec 2020 13:47:42 +0100
Message-Id: <20201228124853.700206948@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coiby Xu <coiby.xu@gmail.com>

commit 47a0001436352c9853d72bf2071e85b316d688a2 upstream.

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
    8dcb7a15a585 ("gpiolib: acpi: Take into account debounce settings")
[2] https://github.com/Syniurge/i2c-amd-mp2/issues/11#issuecomment-721331582
[3] https://forum.manjaro.org/t/random-short-touchpad-freezes/30832/28

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-gpio/CAHp75VcwiGREBUJ0A06EEw-SyabqYsp%2Bdqs2DpSrhaY-2GVdAA%40mail.gmail.com/
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190
Link: https://lore.kernel.org/r/20201125130320.311059-1-coiby.xu@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-amd.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -404,7 +404,6 @@ static int amd_gpio_irq_set_type(struct
 		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
-		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 
@@ -412,7 +411,6 @@ static int amd_gpio_irq_set_type(struct
 		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
-		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 
@@ -420,7 +418,6 @@ static int amd_gpio_irq_set_type(struct
 		pin_reg &= ~BIT(LEVEL_TRIG_OFF);
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= BOTH_EADGE << ACTIVE_LEVEL_OFF;
-		pin_reg |= DB_TYPE_REMOVE_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_edge_irq);
 		break;
 
@@ -428,8 +425,6 @@ static int amd_gpio_irq_set_type(struct
 		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_HIGH << ACTIVE_LEVEL_OFF;
-		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
-		pin_reg |= DB_TYPE_PRESERVE_LOW_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_level_irq);
 		break;
 
@@ -437,8 +432,6 @@ static int amd_gpio_irq_set_type(struct
 		pin_reg |= LEVEL_TRIGGER << LEVEL_TRIG_OFF;
 		pin_reg &= ~(ACTIVE_LEVEL_MASK << ACTIVE_LEVEL_OFF);
 		pin_reg |= ACTIVE_LOW << ACTIVE_LEVEL_OFF;
-		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
-		pin_reg |= DB_TYPE_PRESERVE_HIGH_GLITCH << DB_CNTRL_OFF;
 		irq_set_handler_locked(d, handle_level_irq);
 		break;
 


