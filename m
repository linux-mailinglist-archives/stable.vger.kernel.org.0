Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663FA37CE40
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239130AbhELREO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233880AbhELQm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D264561D4B;
        Wed, 12 May 2021 16:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835967;
        bh=BMMnwKIKArOQuJDpMbJFy5/8JvHpyrHqrwgsEE8FpDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPYonEKDkvXRavSQdTfbeJM9e62zqj3gpEBzaWfKGjCAPL4OsapttmISP2/pjfmWe
         d15mvsHC29Nfkmp6ETRmNY/a80HMcZYpQCWBGMIqeJANes/deHcCmH0XHGpt+iQw67
         w1e0O8UBPDwGuHQi3x4hrc8tV15sMwxoi4sLjBY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 555/677] pinctrl: at91-pio4: Fix slew rate disablement
Date:   Wed, 12 May 2021 16:50:01 +0200
Message-Id: <20210512144855.825233710@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit cbde6c823bfaa553fb162257a5926ba15ebaaa43 ]

The slew rate was enabled by default for each configuration of the
pin. In case the pin had more than one configuration, even if
we set the slew rate as disabled in the device tree, the next pin
configuration would set again the slew rate enabled by default,
overwriting the slew rate disablement.
Instead of enabling the slew rate by default for each pin configuration,
enable the slew rate by default just once per pin, regardless of the
number of configurations. This way the slew rate disablement will also
work for cases where pins have multiple configurations.

Fixes: c709135e576b ("pinctrl: at91-pio4: add support for slew-rate")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Link: https://lore.kernel.org/r/20210409082522.625168-1-tudor.ambarus@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91-pio4.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index e71ebccc479c..03c32b2c5d30 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -801,6 +801,10 @@ static int atmel_conf_pin_config_group_set(struct pinctrl_dev *pctldev,
 
 	conf = atmel_pin_config_read(pctldev, pin_id);
 
+	/* Keep slew rate enabled by default. */
+	if (atmel_pioctrl->slew_rate_support)
+		conf |= ATMEL_PIO_SR_MASK;
+
 	for (i = 0; i < num_configs; i++) {
 		unsigned int param = pinconf_to_config_param(configs[i]);
 		unsigned int arg = pinconf_to_config_argument(configs[i]);
@@ -808,10 +812,6 @@ static int atmel_conf_pin_config_group_set(struct pinctrl_dev *pctldev,
 		dev_dbg(pctldev->dev, "%s: pin=%u, config=0x%lx\n",
 			__func__, pin_id, configs[i]);
 
-		/* Keep slew rate enabled by default. */
-		if (atmel_pioctrl->slew_rate_support)
-			conf |= ATMEL_PIO_SR_MASK;
-
 		switch (param) {
 		case PIN_CONFIG_BIAS_DISABLE:
 			conf &= (~ATMEL_PIO_PUEN_MASK);
-- 
2.30.2



