Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B282D5DBE
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390209AbgLJO3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:29:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390201AbgLJO3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:29:12 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/45] pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output
Date:   Thu, 10 Dec 2020 15:26:32 +0100
Message-Id: <20201210142603.266345166@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit e2b74419e5cc7cfc58f3e785849f73f8fa0af5b3 upstream

Suspending Goodix touchscreens requires changing the interrupt pin to
output before sending them a power-down command. Followed by wiggling
the interrupt pin to wake the device up, after which it is put back
in input mode.

On Cherry Trail device the interrupt pin is listed as a GpioInt ACPI
resource so we can do this without problems as long as we release the
IRQ before changing the pin to output mode.

On Bay Trail devices with a Goodix touchscreen direct-irq mode is used
in combination with listing the pin as a normal GpioIo resource. This
works fine, but this triggers the WARN in byt_gpio_set_direction-s output
path because direct-irq support is enabled on the pin.

This commit replaces the WARN call with a dev_info_once call, fixing a
bunch of WARN splats in dmesg on each suspend/resume cycle.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 1e945aa77734b..23b3b3d541675 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -1034,15 +1034,15 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 	value &= ~BYT_DIR_MASK;
 	if (input)
 		value |= BYT_OUTPUT_EN;
-	else
+	else if (readl(conf_reg) & BYT_DIRECT_IRQ_EN)
 		/*
 		 * Before making any direction modifications, do a check if gpio
 		 * is set for direct IRQ.  On baytrail, setting GPIO to output
-		 * does not make sense, so let's at least warn the caller before
+		 * does not make sense, so let's at least inform the caller before
 		 * they shoot themselves in the foot.
 		 */
-		WARN(readl(conf_reg) & BYT_DIRECT_IRQ_EN,
-		     "Potential Error: Setting GPIO with direct_irq_en to output");
+		dev_info_once(vg->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
+
 	writel(value, val_reg);
 
 	raw_spin_unlock_irqrestore(&byt_lock, flags);
-- 
2.27.0



