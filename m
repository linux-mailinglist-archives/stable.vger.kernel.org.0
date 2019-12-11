Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66B711B516
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732492AbfLKPVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731843AbfLKPVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0189322527;
        Wed, 11 Dec 2019 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077700;
        bh=UV2G6q/DXBthsE3ae57WamEql2zCNb2Q2GjMnMRBGkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVtOquf2oudfARqi89sn3/KsjQWYysEwZDWuXJ0m58z4Ma4JA/pzs8g/4gleSf+aL
         PoKGktQ5kHpTbpK2d57QCM4Ql7yirxLMeQoLeAhuTibWRt4/w0pJdLilsGFa9KrfGa
         iEVXNYCBkLO8JSwk5RBVkW335ePwd9fMuX2njb8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 137/243] gpio: OF: Parse MMC-specific CD and WP properties
Date:   Wed, 11 Dec 2019 16:04:59 +0100
Message-Id: <20191211150348.405211936@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 81c85ec15a1946f2e347ec0bf66936121eb97ce7 ]

When retrieveing CD (card detect) and WP (write protect)
GPIO handles from the device tree, make sure to assign
them active low by default unless the "cd-inverted" or
"wp-inverted" properties are set. These properties mean
that respective signal is active HIGH since the SDHCI
specification stipulates that this kind of signals
should be treated as active LOW.

If the twocell GPIO flag is also specified as active
low, well that's nice and we will silently ignore the
tautological specification.

If however the GPIO line is specified as active low
in the GPIO flasg cell and "cd-inverted" or "wp-inverted"
is also specified, the latter takes precedence and we
print a warning.

The current effect on the MMC slot-gpio core are as
follows:

For CD GPIOs: no effect. The current code in
mmc/core/host.c calls mmc_gpiod_request_cd() with
the "override_active_level" argument set to true,
which means that whatever the GPIO descriptor
thinks about active low/high will be ignored, the
core will use the MMC_CAP2_CD_ACTIVE_HIGH to keep
track of this and reads the raw value from the
GPIO descriptor, totally bypassing gpiolibs inversion
semantics. I plan to clean this up at a later point
passing the handling of inversion semantics over
to gpiolib, so this patch prepares the ground for
that.

Fow WP GPIOs: this is probably fixing a bug, because
the code in mmc/core/host.c calls mmc_gpiod_request_ro()
with the "override_active_level" argument set to false,
which means it will respect the inversion semantics of
the gpiolib and ignore the MMC_CAP2_RO_ACTIVE_HIGH
flag for everyone using this through device tree.
However the code in host.c confusingly goes to great
lengths setting up the MMC_CAP2_RO_ACTIVE_HIGH flag
from the GPIO descriptor and by reading the "wp-inverted"
property of the node. As far as I can tell this is all
in vain and the inversion is broken: device trees that
use "wp-inverted" do not work as intended, instead the
only way to actually get inversion on a line is by
setting the second cell flag to GPIO_ACTIVE_HIGH (which
will be the default) or GPIO_ACTIVE_LOW if they want
the proper MMC semantics. Presumably all device trees do
this right but we need to parse and handle this properly.

Cc: linux-mmc@vger.kernel.org
Cc: linux-gpio@vger.kernel.org
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index e0f149bdf98ff..1147ad968fd75 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -60,6 +60,45 @@ static struct gpio_desc *of_xlate_and_get_gpiod_flags(struct gpio_chip *chip,
 static void of_gpio_flags_quirks(struct device_node *np,
 				 enum of_gpio_flags *flags)
 {
+	/*
+	 * Handle MMC "cd-inverted" and "wp-inverted" semantics.
+	 */
+	if (IS_ENABLED(CONFIG_MMC)) {
+		if (of_property_read_bool(np, "cd-gpios")) {
+			if (of_property_read_bool(np, "cd-inverted")) {
+				if (*flags & OF_GPIO_ACTIVE_LOW) {
+					/* "cd-inverted" takes precedence */
+					*flags &= ~OF_GPIO_ACTIVE_LOW;
+					pr_warn("%s GPIO handle specifies CD active low - ignored\n",
+						of_node_full_name(np));
+				}
+			} else {
+				/*
+				 * Active low is the default according to the
+				 * SDHCI specification. If the GPIO handle
+				 * specifies the same thing - good.
+				 */
+				*flags |= OF_GPIO_ACTIVE_LOW;
+			}
+		}
+		if (of_property_read_bool(np, "wp-gpios")) {
+			if (of_property_read_bool(np, "wp-inverted")) {
+				/* "wp-inverted" takes precedence */
+				if (*flags & OF_GPIO_ACTIVE_LOW) {
+					*flags &= ~OF_GPIO_ACTIVE_LOW;
+					pr_warn("%s GPIO handle specifies WP active low - ignored\n",
+						of_node_full_name(np));
+				}
+			} else {
+				/*
+				 * Active low is the default according to the
+				 * SDHCI specification. If the GPIO handle
+				 * specifies the same thing - good.
+				 */
+				*flags |= OF_GPIO_ACTIVE_LOW;
+			}
+		}
+	}
 	/*
 	 * Some GPIO fixed regulator quirks.
 	 * Note that active low is the default.
-- 
2.20.1



