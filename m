Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B0215E80A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394361AbgBNQ5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404551AbgBNQRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2BBF24688;
        Fri, 14 Feb 2020 16:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697065;
        bh=SpY9AsGdg7XlSt1I/aCb8556rHUzr0sSJiiICFBDHVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrTeVNZgSOBEAJmgrX2MTa+P3DQ0Nn28YjxJ16N4IN5o3/mLFQfEkf+1svQfJrffO
         vBYdrcFI3MhawB2kVIdWJcKsocSg0AGnBzrMLJccaaYV9esaZ0qMb/LgSM1yjPzXOi
         QtGWKWkynK0PQl5fMB3Y2SAE1v/yrzlB8RhyS0jQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 022/186] pinctrl: baytrail: Do not clear IRQ flags on direct-irq enabled pins
Date:   Fri, 14 Feb 2020 11:14:31 -0500
Message-Id: <20200214161715.18113-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a23680594da7a9e2696dbcf4f023e9273e2fa40b ]

Suspending Goodix touchscreens requires changing the interrupt pin to
output before sending them a power-down command. Followed by wiggling
the interrupt pin to wake the device up, after which it is put back
in input mode.

On Bay Trail devices with a Goodix touchscreen direct-irq mode is used
in combination with listing the pin as a normal GpioIo resource.

This works fine, until the goodix driver gets rmmod-ed and then insmod-ed
again. In this case byt_gpio_disable_free() calls
byt_gpio_clear_triggering() which clears the IRQ flags and after that the
(direct) IRQ no longer triggers.

This commit fixes this by adding a check for the BYT_DIRECT_IRQ_EN flag
to byt_gpio_clear_triggering().

Note that byt_gpio_clear_triggering() only gets called from
byt_gpio_disable_free() for direct-irq enabled pins, as these are excluded
from the irq_valid mask by byt_init_irq_valid_mask().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 9df5d29d708da..4fb3e44f91331 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -958,7 +958,13 @@ static void byt_gpio_clear_triggering(struct byt_gpio *vg, unsigned int offset)
 
 	raw_spin_lock_irqsave(&byt_lock, flags);
 	value = readl(reg);
-	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
+
+	/* Do not clear direct-irq enabled IRQs (from gpio_disable_free) */
+	if (value & BYT_DIRECT_IRQ_EN)
+		/* nothing to do */ ;
+	else
+		value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
+
 	writel(value, reg);
 	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
-- 
2.20.1

