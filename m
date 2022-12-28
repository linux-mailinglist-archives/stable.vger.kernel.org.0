Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C46657BE7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiL1P04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiL1P0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A641BF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A33C0B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105D8C433D2;
        Wed, 28 Dec 2022 15:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241191;
        bh=hafTzfsayXdeFYxoNO2rdQVl+0KVRalLJ956sh9huyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1mrS2uCO2pGvZpfP1SRF0EHUAzCeUxeBDcr8XagtUWijSojPNPQuY/gzNkHww+i6
         V2d3fXh4bw25T4VLwJoHlLyx5otoWcrqzr6HnO6xpSEHZAJIQjswzhemc/HKQXMtlp
         edgoaGmTpi3NmRHM809slOT6QGNiNN+I2eG56d6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yassine Oudjana <y.oudjana@protonmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 451/731] extcon: usbc-tusb320: Add support for mode setting and reset
Date:   Wed, 28 Dec 2022 15:39:18 +0100
Message-Id: <20221228144309.627391443@linuxfoundation.org>
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

From: Yassine Oudjana <y.oudjana@protonmail.com>

[ Upstream commit 70c55d6be634e5f9894169340f3fe5c73f53ac2d ]

Reset the chip and set its mode to default (maintain mode set by PORT pin)
during probe to make sure it comes up in the default state.

Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Stable-dep-of: 581c848b610d ("extcon: usbc-tusb320: Update state on probe even if no IRQ pending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-usbc-tusb320.c | 85 ++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index 805af73b4152..1ed1dfe54206 100644
--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -19,15 +19,32 @@
 #define TUSB320_REG9_ATTACHED_STATE_MASK	0x3
 #define TUSB320_REG9_CABLE_DIRECTION		BIT(5)
 #define TUSB320_REG9_INTERRUPT_STATUS		BIT(4)
-#define TUSB320_ATTACHED_STATE_NONE		0x0
-#define TUSB320_ATTACHED_STATE_DFP		0x1
-#define TUSB320_ATTACHED_STATE_UFP		0x2
-#define TUSB320_ATTACHED_STATE_ACC		0x3
+
+#define TUSB320_REGA				0xa
+#define TUSB320_REGA_I2C_SOFT_RESET		BIT(3)
+#define TUSB320_REGA_MODE_SELECT_SHIFT		4
+#define TUSB320_REGA_MODE_SELECT_MASK		0x3
+
+enum tusb320_attached_state {
+	TUSB320_ATTACHED_STATE_NONE,
+	TUSB320_ATTACHED_STATE_DFP,
+	TUSB320_ATTACHED_STATE_UFP,
+	TUSB320_ATTACHED_STATE_ACC,
+};
+
+enum tusb320_mode {
+	TUSB320_MODE_PORT,
+	TUSB320_MODE_UFP,
+	TUSB320_MODE_DFP,
+	TUSB320_MODE_DRP,
+};
 
 struct tusb320_priv {
 	struct device *dev;
 	struct regmap *regmap;
 	struct extcon_dev *edev;
+
+	enum tusb320_attached_state state;
 };
 
 static const char * const tusb_attached_states[] = {
@@ -62,6 +79,53 @@ static int tusb320_check_signature(struct tusb320_priv *priv)
 	return 0;
 }
 
+static int tusb320_set_mode(struct tusb320_priv *priv, enum tusb320_mode mode)
+{
+	int ret;
+
+	/* Mode cannot be changed while cable is attached */
+	if (priv->state != TUSB320_ATTACHED_STATE_NONE)
+		return -EBUSY;
+
+	/* Write mode */
+	ret = regmap_write_bits(priv->regmap, TUSB320_REGA,
+		TUSB320_REGA_MODE_SELECT_MASK << TUSB320_REGA_MODE_SELECT_SHIFT,
+		mode << TUSB320_REGA_MODE_SELECT_SHIFT);
+	if (ret) {
+		dev_err(priv->dev, "failed to write mode: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int tusb320_reset(struct tusb320_priv *priv)
+{
+	int ret;
+
+	/* Set mode to default (follow PORT pin) */
+	ret = tusb320_set_mode(priv, TUSB320_MODE_PORT);
+	if (ret && ret != -EBUSY) {
+		dev_err(priv->dev,
+			"failed to set mode to PORT: %d\n", ret);
+		return ret;
+	}
+
+	/* Perform soft reset */
+	ret = regmap_write_bits(priv->regmap, TUSB320_REGA,
+			TUSB320_REGA_I2C_SOFT_RESET, 1);
+	if (ret) {
+		dev_err(priv->dev,
+			"failed to write soft reset bit: %d\n", ret);
+		return ret;
+	}
+
+	/* Wait for chip to go through reset */
+	msleep(95);
+
+	return 0;
+}
+
 static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
 {
 	struct tusb320_priv *priv = dev_id;
@@ -96,6 +160,8 @@ static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
 	extcon_sync(priv->edev, EXTCON_USB);
 	extcon_sync(priv->edev, EXTCON_USB_HOST);
 
+	priv->state = state;
+
 	regmap_write(priv->regmap, TUSB320_REG9, reg);
 
 	return IRQ_HANDLED;
@@ -145,6 +211,17 @@ static int tusb320_extcon_probe(struct i2c_client *client,
 	/* update initial state */
 	tusb320_irq_handler(client->irq, priv);
 
+	/* Reset chip to its default state */
+	ret = tusb320_reset(priv);
+	if (ret)
+		dev_warn(priv->dev, "failed to reset chip: %d\n", ret);
+	else
+		/*
+		 * State and polarity might change after a reset, so update
+		 * them again and make sure the interrupt status bit is cleared.
+		 */
+		tusb320_irq_handler(client->irq, priv);
+
 	ret = devm_request_threaded_irq(priv->dev, client->irq, NULL,
 					tusb320_irq_handler,
 					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-- 
2.35.1



