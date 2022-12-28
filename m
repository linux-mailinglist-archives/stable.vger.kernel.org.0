Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838FB657BF7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiL1P1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiL1P1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:27:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E068140E4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:27:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F01DDB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41560C433D2;
        Wed, 28 Dec 2022 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241237;
        bh=ggYCZCSu+o++irCI2zbzpAGM7+IKkejY1SenxfhOwMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIGgNN5cKDP2aNF4ZzDUEGzgSyLAXk/+sAc+uexVpi3iWf4wvZcnyuBjgKkNRaF/6
         sy0H4Yo4RWfcS0eWkw5jCLThLhQfpCnouAn4uL43+s6o2laAV0R4p414evVfeVqD4x
         2HPglNO9vG8gH0s6ds3pkeiI2Hc+LU4ojMs1xTu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 456/731] extcon: usbc-tusb320: Update state on probe even if no IRQ pending
Date:   Wed, 28 Dec 2022 15:39:23 +0100
Message-Id: <20221228144309.770876879@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 581c848b610dbf3fe1ed4d85fd53d0743c61faba ]

Currently this driver triggers extcon and typec state update in its
probe function, to read out current state reported by the chip and
report the correct state to upper layers. This synchronization is
performed correctly, but only in case the chip indicates a pending
interrupt in reg09 register.

This fails to cover the situation where all interrupts reported by
the chip were already handled by Linux before reboot, then the system
rebooted, and then Linux starts again. In this case, the TUSB320 no
longer reports any interrupts in reg09, and the state update does not
perform any update as it depends on that interrupt indication.

Fix this by turning tusb320_irq_handler() into a thin wrapper around
tusb320_state_update_handler(), where the later now contains the bulk
of the code of tusb320_irq_handler(), but adds new function parameter
"force_update". The "force_update" parameter can be used by the probe
function to assure that the state synchronization is always performed,
independent of the interrupt indicated in reg09. The interrupt handler
tusb320_irq_handler() callback uses force_update=false to avoid state
updates on potential spurious interrupts and retain current behavior.

Fixes: 06bc4ca115cdd ("extcon: Add driver for TI TUSB320")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221120141509.81012-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-usbc-tusb320.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index edb8c3f997c9..b0f6e16ab0a9 100644
--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -313,9 +313,9 @@ static void tusb320_typec_irq_handler(struct tusb320_priv *priv, u8 reg9)
 		typec_set_pwr_opmode(port, TYPEC_PWR_MODE_USB);
 }
 
-static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
+static irqreturn_t tusb320_state_update_handler(struct tusb320_priv *priv,
+						bool force_update)
 {
-	struct tusb320_priv *priv = dev_id;
 	unsigned int reg;
 
 	if (regmap_read(priv->regmap, TUSB320_REG9, &reg)) {
@@ -323,7 +323,7 @@ static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 
-	if (!(reg & TUSB320_REG9_INTERRUPT_STATUS))
+	if (!force_update && !(reg & TUSB320_REG9_INTERRUPT_STATUS))
 		return IRQ_NONE;
 
 	tusb320_extcon_irq_handler(priv, reg);
@@ -334,6 +334,13 @@ static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
+{
+	struct tusb320_priv *priv = dev_id;
+
+	return tusb320_state_update_handler(priv, false);
+}
+
 static const struct regmap_config tusb320_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -460,7 +467,7 @@ static int tusb320_probe(struct i2c_client *client,
 		return ret;
 
 	/* update initial state */
-	tusb320_irq_handler(client->irq, priv);
+	tusb320_state_update_handler(priv, true);
 
 	/* Reset chip to its default state */
 	ret = tusb320_reset(priv);
@@ -471,7 +478,7 @@ static int tusb320_probe(struct i2c_client *client,
 		 * State and polarity might change after a reset, so update
 		 * them again and make sure the interrupt status bit is cleared.
 		 */
-		tusb320_irq_handler(client->irq, priv);
+		tusb320_state_update_handler(priv, true);
 
 	ret = devm_request_threaded_irq(priv->dev, client->irq, NULL,
 					tusb320_irq_handler,
-- 
2.35.1



