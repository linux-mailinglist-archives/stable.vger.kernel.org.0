Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4DA163169
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgBRUAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:00:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727462AbgBRUAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2469020659;
        Tue, 18 Feb 2020 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056007;
        bh=5KXVAfBd63CuEldh5+IuIGkdm8p6ZP7WJF61mIXofL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ocfsxao2LaRPAmN/Alpj9Ppyq97gc4wlqL0eHtf8FGGv/JZTpPPl7/ocF7uutzo5W
         W63dD3YCHY6K1cKoIB0OkFn5usjHa6rK0HUZuFBPDFx16VPae3TPL+iOH84kXimjSc
         03zvSXnXA5XXP6pJ6DrJX0AC/zLcqoCuSRpeu8/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 66/66] mmc: core: Rework wp-gpio handling
Date:   Tue, 18 Feb 2020 20:55:33 +0100
Message-Id: <20200218190434.454828706@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit 9073d10b098973519044f5fcdc25586810b435da ]

Use MMC_CAP2_RO_ACTIVE_HIGH flag as indicator if GPIO line is to be
inverted compared to DT/platform-specified polarity. The flag is not used
after init in GPIO mode anyway. No functional changes intended.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/a60f563f11bbff821da2fa2949ca82922b144860.1576031637.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c          |  4 ----
 drivers/mmc/core/host.c            | 11 ++++-------
 drivers/mmc/core/slot-gpio.c       |  3 +++
 drivers/mmc/host/pxamci.c          |  8 ++++----
 drivers/mmc/host/sdhci-esdhc-imx.c |  3 ++-
 5 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 7ee5b7f53aebe..3ece59185d372 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -146,10 +146,6 @@ static void of_gpio_flags_quirks(struct device_node *np,
 			if (of_property_read_bool(np, "cd-inverted"))
 				*flags ^= OF_GPIO_ACTIVE_LOW;
 		}
-		if (!strcmp(propname, "wp-gpios")) {
-			if (of_property_read_bool(np, "wp-inverted"))
-				*flags ^= OF_GPIO_ACTIVE_LOW;
-		}
 	}
 	/*
 	 * Some GPIO fixed regulator quirks.
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 105b7a7c02513..b3484def0a8b0 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -176,7 +176,6 @@ int mmc_of_parse(struct mmc_host *host)
 	u32 bus_width, drv_type, cd_debounce_delay_ms;
 	int ret;
 	bool cd_cap_invert, cd_gpio_invert = false;
-	bool ro_cap_invert, ro_gpio_invert = false;
 
 	if (!dev || !dev_fwnode(dev))
 		return 0;
@@ -255,9 +254,11 @@ int mmc_of_parse(struct mmc_host *host)
 	}
 
 	/* Parse Write Protection */
-	ro_cap_invert = device_property_read_bool(dev, "wp-inverted");
 
-	ret = mmc_gpiod_request_ro(host, "wp", 0, 0, &ro_gpio_invert);
+	if (device_property_read_bool(dev, "wp-inverted"))
+		host->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
+
+	ret = mmc_gpiod_request_ro(host, "wp", 0, 0, NULL);
 	if (!ret)
 		dev_info(host->parent, "Got WP GPIO\n");
 	else if (ret != -ENOENT && ret != -ENOSYS)
@@ -266,10 +267,6 @@ int mmc_of_parse(struct mmc_host *host)
 	if (device_property_read_bool(dev, "disable-wp"))
 		host->caps2 |= MMC_CAP2_NO_WRITE_PROTECT;
 
-	/* See the comment on CD inversion above */
-	if (ro_cap_invert ^ ro_gpio_invert)
-		host->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
-
 	if (device_property_read_bool(dev, "cap-sd-highspeed"))
 		host->caps |= MMC_CAP_SD_HIGHSPEED;
 	if (device_property_read_bool(dev, "cap-mmc-highspeed"))
diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
index da2596c5fa28d..582ec3d720f64 100644
--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -241,6 +241,9 @@ int mmc_gpiod_request_ro(struct mmc_host *host, const char *con_id,
 			return ret;
 	}
 
+	if (host->caps2 & MMC_CAP2_RO_ACTIVE_HIGH)
+		gpiod_toggle_active_low(desc);
+
 	if (gpio_invert)
 		*gpio_invert = !gpiod_is_active_low(desc);
 
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 024acc1b0a2ea..b2bbcb09a49e6 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -740,16 +740,16 @@ static int pxamci_probe(struct platform_device *pdev)
 			goto out;
 		}
 
+		if (!host->pdata->gpio_card_ro_invert)
+			mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
+
 		ret = mmc_gpiod_request_ro(mmc, "wp", 0, 0, NULL);
 		if (ret && ret != -ENOENT) {
 			dev_err(dev, "Failed requesting gpio_ro\n");
 			goto out;
 		}
-		if (!ret) {
+		if (!ret)
 			host->use_ro_gpio = true;
-			mmc->caps2 |= host->pdata->gpio_card_ro_invert ?
-				0 : MMC_CAP2_RO_ACTIVE_HIGH;
-		}
 
 		if (host->pdata->init)
 			host->pdata->init(dev, pxamci_detect_irq, mmc);
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 1c988d6a24330..dccb4df465126 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1381,13 +1381,14 @@ static int sdhci_esdhc_imx_probe_nondt(struct platform_device *pdev,
 				host->mmc->parent->platform_data);
 	/* write_protect */
 	if (boarddata->wp_type == ESDHC_WP_GPIO) {
+		host->mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
+
 		err = mmc_gpiod_request_ro(host->mmc, "wp", 0, 0, NULL);
 		if (err) {
 			dev_err(mmc_dev(host->mmc),
 				"failed to request write-protect gpio!\n");
 			return err;
 		}
-		host->mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
 	}
 
 	/* card_detect */
-- 
2.20.1



