Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1179A14E16F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgA3SoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730811AbgA3SoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEE552465B;
        Thu, 30 Jan 2020 18:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409864;
        bh=xwn2pakitxhWYFtw+8wAFTZXzu/ntQeMjykG2ynSlZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpzY7zRH8QD3ge6cenk6nfMIE3QKbUkW1WhmsOixsm31eYQfaAQCefm8SgctWM0JE
         ooTnJtCJwBztlMl7DamjBrE4nj09Ich0+I9YsVxYTjmkDDJVaTZbdxBnss8qKd5BFN
         UWKgk87k4kdLgsm7oH/JVGGDIeeibXYEkObbyFUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/110] can: tcan4x5x: tcan4x5x_parse_config(): reset device before register access
Date:   Thu, 30 Jan 2020 19:38:40 +0100
Message-Id: <20200130183622.387523067@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit c3083124e6a1c0d6cd4fe3b3f627b488bd3b10c4 ]

It's a good idea to reset a ip-block/spi device before using it, this
patch will reset the device.

And a generic reset function if needed elsewhere.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index d797912e665a5..b233756345f83 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -164,6 +164,28 @@ static void tcan4x5x_check_wake(struct tcan4x5x_priv *priv)
 	}
 }
 
+static int tcan4x5x_reset(struct tcan4x5x_priv *priv)
+{
+	int ret = 0;
+
+	if (priv->reset_gpio) {
+		gpiod_set_value(priv->reset_gpio, 1);
+
+		/* tpulse_width minimum 30us */
+		usleep_range(30, 100);
+		gpiod_set_value(priv->reset_gpio, 0);
+	} else {
+		ret = regmap_write(priv->regmap, TCAN4X5X_CONFIG,
+				   TCAN4X5X_SW_RESET);
+		if (ret)
+			return ret;
+	}
+
+	usleep_range(700, 1000);
+
+	return ret;
+}
+
 static int regmap_spi_gather_write(void *context, const void *reg,
 				   size_t reg_len, const void *val,
 				   size_t val_len)
@@ -341,6 +363,7 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
 {
 	struct tcan4x5x_priv *tcan4x5x = cdev->device_data;
+	int ret;
 
 	tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
 						    GPIOD_OUT_HIGH);
@@ -354,7 +377,9 @@ static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
 	if (IS_ERR(tcan4x5x->reset_gpio))
 		tcan4x5x->reset_gpio = NULL;
 
-	usleep_range(700, 1000);
+	ret = tcan4x5x_reset(tcan4x5x);
+	if (ret)
+		return ret;
 
 	tcan4x5x->device_state_gpio = devm_gpiod_get_optional(cdev->dev,
 							      "device-state",
-- 
2.20.1



