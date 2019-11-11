Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBAB4F6E4F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKKGAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:00:11 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40863 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbfKKGAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:00:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3865220F24;
        Mon, 11 Nov 2019 01:00:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Hxb9gy
        OG3YU60rzLSte04qutIhy7fvxKooK7zkGg2a4=; b=oZXLYj1jJHP2I3t98I9z9j
        6c6Yi8xjLlNL7RK8rrbQoxLXgvNpzz2L67JyXBZXp35/lv8dlUH+Lso7GL4bbgzH
        3hAIlPYg9kycojPUExby4uJsd8APdElSMJUWPHTAhF0+xPEYSVT2w4N2t/0d/gQO
        s8s14VyING/mUYs5p0WeTTLROQ1iHwTvYojwh+fNbGfjfVUKQ+DMUrG6ErusML6c
        P7+GFHoETazqXCogYmDi+/yTkL1RSe2UnkMGRlzoAR1siBmKq6/YnaxyHzCEQ2T6
        Loz+eQQRi8NIoE7qTAj8RBtILIw5qwZFZdreYjDbYlrK7fgTek/XpAfTzFrfK3Bw
        ==
X-ME-Sender: <xms:6vjIXf_GCvtz1XoJFsskMB6ykjarqSFRvhVlgqWNsRMnodmpGTtwLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:6vjIXTSkBX5SUqGGQ8UX1p1WAGxJuIcHI7qUPS4vSwtv5R9vcxyhmg>
    <xmx:6vjIXcqsiEwALJqpKpM0MlocpPsYYLGcl5FEh1vIH55xMvZD5xRQsg>
    <xmx:6vjIXYNtWotW1g9nGGX9s-juOtHsE-TVUxtTwt-IgKd592yWxWYA9w>
    <xmx:6vjIXbKLrLc4_owTm8LGjWkEf66zSgF4j4zVuM1zdeJnPJ0TJqxxTg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABDFA80063;
        Mon, 11 Nov 2019 01:00:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: intel: Avoid potential glitches if pin is in GPIO" failed to apply to 4.9-stable tree
To:     andriy.shevchenko@linux.intel.com, malin.jonsson@ericsson.com,
        mika.westerberg@linux.intel.com, oliver.barta@aptiv.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 06:59:54 +0100
Message-ID: <157345199413487@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 29c2c6aa32405dfee4a29911a51ba133edcedb0f Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 14 Oct 2019 12:51:04 +0300
Subject: [PATCH] pinctrl: intel: Avoid potential glitches if pin is in GPIO
 mode

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

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index bc013599a9a3..83981ad66a71 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -52,6 +52,7 @@
 #define PADCFG0_GPIROUTNMI		BIT(17)
 #define PADCFG0_PMODE_SHIFT		10
 #define PADCFG0_PMODE_MASK		GENMASK(13, 10)
+#define PADCFG0_PMODE_GPIO		0
 #define PADCFG0_GPIORXDIS		BIT(9)
 #define PADCFG0_GPIOTXDIS		BIT(8)
 #define PADCFG0_GPIORXSTATE		BIT(1)
@@ -332,7 +333,7 @@ static void intel_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 	cfg1 = readl(intel_get_padcfg(pctrl, pin, PADCFG1));
 
 	mode = (cfg0 & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
-	if (!mode)
+	if (mode == PADCFG0_PMODE_GPIO)
 		seq_puts(s, "GPIO ");
 	else
 		seq_printf(s, "mode %d ", mode);
@@ -458,6 +459,11 @@ static void __intel_gpio_set_direction(void __iomem *padcfg0, bool input)
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
@@ -491,7 +497,20 @@ static int intel_gpio_request_enable(struct pinctrl_dev *pctldev,
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
 

