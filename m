Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B837BF7C7D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730027AbfKKSqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:46:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730025AbfKKSqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:46:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4608D20674;
        Mon, 11 Nov 2019 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498003;
        bh=joAlmJwFdGMLIvio/Y3ktCQ43gYYcMvWGpbSsVHlXnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnCn+ff9guOI3j0ctRgSFEFjbCBYPzHwHtdM/VtqwlpGlGqdFouLvrK5XXR7Wo/cJ
         QAboxzVBiC6XNrrYgV3rMVNOZv/Uhl8PniERwqLeN+bzXpEPl802tZXRMijI1vL0PL
         +7YRd+B5tDuuHzjPH1SPQXqlbVN01zhmP2BczHsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, fei.yang@intel.com,
        Oliver Barta <oliver.barta@aptiv.com>,
        Malin Jonsson <malin.jonsson@ericsson.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/125] pinctrl: intel: Avoid potential glitches if pin is in GPIO mode
Date:   Mon, 11 Nov 2019 19:29:17 +0100
Message-Id: <20191111181455.539752769@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 29c2c6aa32405dfee4a29911a51ba133edcedb0f ]

When consumer requests a pin, in order to be on the safest side,
we switch it first to GPIO mode followed by immediate transition
to the input state. Due to posted writes it's luckily to be a single
I/O transaction.

However, if firmware or boot loader already configures the pin
to the GPIO mode, user expects no glitches for the requested pin.
We may check if the pin is pre-configured and leave it as is
till the actual consumer toggles its state to avoid glitches.

Fixes: 7981c0015af2 ("pinctrl: intel: Add Intel Sunrisepoint pin controller and GPIO support")
Depends-on: f5a26acf0162 ("pinctrl: intel: Initialize GPIO properly when used through irqchip")
Cc: stable@vger.kernel.org
Cc: fei.yang@intel.com
Reported-by: Oliver Barta <oliver.barta@aptiv.com>
Reported-by: Malin Jonsson <malin.jonsson@ericsson.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 1ea3438ea67e9..89ff2795a8b55 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -49,6 +49,7 @@
 #define PADCFG0_GPIROUTNMI		BIT(17)
 #define PADCFG0_PMODE_SHIFT		10
 #define PADCFG0_PMODE_MASK		(0xf << PADCFG0_PMODE_SHIFT)
+#define PADCFG0_PMODE_GPIO		0
 #define PADCFG0_GPIORXDIS		BIT(9)
 #define PADCFG0_GPIOTXDIS		BIT(8)
 #define PADCFG0_GPIORXSTATE		BIT(1)
@@ -301,7 +302,7 @@ static void intel_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 	cfg1 = readl(intel_get_padcfg(pctrl, pin, PADCFG1));
 
 	mode = (cfg0 & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
-	if (!mode)
+	if (mode == PADCFG0_PMODE_GPIO)
 		seq_puts(s, "GPIO ");
 	else
 		seq_printf(s, "mode %d ", mode);
@@ -422,6 +423,11 @@ static void __intel_gpio_set_direction(void __iomem *padcfg0, bool input)
 	writel(value, padcfg0);
 }
 
+static int intel_gpio_get_gpio_mode(void __iomem *padcfg0)
+{
+	return (readl(padcfg0) & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+}
+
 static void intel_gpio_set_gpio_mode(void __iomem *padcfg0)
 {
 	u32 value;
@@ -450,7 +456,20 @@ static int intel_gpio_request_enable(struct pinctrl_dev *pctldev,
 	}
 
 	padcfg0 = intel_get_padcfg(pctrl, pin, PADCFG0);
+
+	/*
+	 * If pin is already configured in GPIO mode, we assume that
+	 * firmware provides correct settings. In such case we avoid
+	 * potential glitches on the pin. Otherwise, for the pin in
+	 * alternative mode, consumer has to supply respective flags.
+	 */
+	if (intel_gpio_get_gpio_mode(padcfg0) == PADCFG0_PMODE_GPIO) {
+		raw_spin_unlock_irqrestore(&pctrl->lock, flags);
+		return 0;
+	}
+
 	intel_gpio_set_gpio_mode(padcfg0);
+
 	/* Disable TX buffer and enable RX (this will be input) */
 	__intel_gpio_set_direction(padcfg0, true);
 
-- 
2.20.1



