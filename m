Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97AD3167722
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731796AbgBUIiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:38:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731422AbgBUIDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:03:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 202D22465D;
        Fri, 21 Feb 2020 08:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272190;
        bh=Ptu6GMFRDrGb22Ao6q2UrifXKbK8uk5mZ/S7nJG3Xkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fc9LmMvIqzEblBPCWzDmioZZW3pjd/EH33sCadqm9t/Jlv1zTNc9ohPzQFmZdYL/3
         KFOZlBjdKW6swvcwpQRQs6ijCIi3dtsISPpCXBsuEdrwRAynzClAMS9N66anB7n1XJ
         Uq35souBC5JWalbDBiGFqbcVUecRiNOW8YpA3L1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/344] pinctrl: baytrail: Do not clear IRQ flags on direct-irq enabled pins
Date:   Fri, 21 Feb 2020 08:37:28 +0100
Message-Id: <20200221072353.537145973@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7d658e6627e7a..606fe216f902a 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -752,7 +752,13 @@ static void byt_gpio_clear_triggering(struct byt_gpio *vg, unsigned int offset)
 
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



