Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FFE657BE8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbiL1P07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiL1P0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E53BB73
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D39EB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15062C433EF;
        Wed, 28 Dec 2022 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241199;
        bh=K3Tx9dtdTTz4UNH41utkRBHMBa5qQJD4JlT8Zb95Bew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJx9y9cVwUrGQzuuPF0Op1EUGT3mVmCMm4tes5TEvmKGO1/b+1c+1VvjrSQf3sAND
         u+xIfwHwStTLpaR1gSy/kgRTmgXb5a99Sj3F/fNtu0+ne2Ko6bQHQtQrv4laTQP/h1
         tW0QJtIJv0MBkym48fee0eZh2YE/1+Zk0p+O+Z9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yassine Oudjana <y.oudjana@protonmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 452/731] extcon: usbc-tusb320: Add support for TUSB320L
Date:   Wed, 28 Dec 2022 15:39:19 +0100
Message-Id: <20221228144309.656698419@linuxfoundation.org>
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

[ Upstream commit ce0320bd3872038569be360870e2d5251b975692 ]

TUSB320L is a newer chip with additional features, and it has additional steps
in its mode changing sequence:
 - Disable CC state machine,
 - Write to mode register,
 - Wait for 5 ms,
 - Re-enable CC state machine.
It also has an additional register that a revision number can be read from.

Add support for the mode changing sequence, and read the revision number during
probe and print it as info.

Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Stable-dep-of: 581c848b610d ("extcon: usbc-tusb320: Update state on probe even if no IRQ pending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-usbc-tusb320.c | 82 +++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index 1ed1dfe54206..6ba3d89b106d 100644
--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -21,10 +21,13 @@
 #define TUSB320_REG9_INTERRUPT_STATUS		BIT(4)
 
 #define TUSB320_REGA				0xa
+#define TUSB320L_REGA_DISABLE_TERM		BIT(0)
 #define TUSB320_REGA_I2C_SOFT_RESET		BIT(3)
 #define TUSB320_REGA_MODE_SELECT_SHIFT		4
 #define TUSB320_REGA_MODE_SELECT_MASK		0x3
 
+#define TUSB320L_REGA0_REVISION			0xa0
+
 enum tusb320_attached_state {
 	TUSB320_ATTACHED_STATE_NONE,
 	TUSB320_ATTACHED_STATE_DFP,
@@ -39,11 +42,18 @@ enum tusb320_mode {
 	TUSB320_MODE_DRP,
 };
 
+struct tusb320_priv;
+
+struct tusb320_ops {
+	int (*set_mode)(struct tusb320_priv *priv, enum tusb320_mode mode);
+	int (*get_revision)(struct tusb320_priv *priv, unsigned int *revision);
+};
+
 struct tusb320_priv {
 	struct device *dev;
 	struct regmap *regmap;
 	struct extcon_dev *edev;
-
+	struct tusb320_ops *ops;
 	enum tusb320_attached_state state;
 };
 
@@ -99,12 +109,46 @@ static int tusb320_set_mode(struct tusb320_priv *priv, enum tusb320_mode mode)
 	return 0;
 }
 
+static int tusb320l_set_mode(struct tusb320_priv *priv, enum tusb320_mode mode)
+{
+	int ret;
+
+	/* Disable CC state machine */
+	ret = regmap_write_bits(priv->regmap, TUSB320_REGA,
+		TUSB320L_REGA_DISABLE_TERM, 1);
+	if (ret) {
+		dev_err(priv->dev,
+			"failed to disable CC state machine: %d\n", ret);
+		return ret;
+	}
+
+	/* Write mode */
+	ret = regmap_write_bits(priv->regmap, TUSB320_REGA,
+		TUSB320_REGA_MODE_SELECT_MASK << TUSB320_REGA_MODE_SELECT_SHIFT,
+		mode << TUSB320_REGA_MODE_SELECT_SHIFT);
+	if (ret) {
+		dev_err(priv->dev, "failed to write mode: %d\n", ret);
+		goto err;
+	}
+
+	msleep(5);
+err:
+	/* Re-enable CC state machine */
+	ret = regmap_write_bits(priv->regmap, TUSB320_REGA,
+		TUSB320L_REGA_DISABLE_TERM, 0);
+	if (ret)
+		dev_err(priv->dev,
+			"failed to re-enable CC state machine: %d\n", ret);
+
+	return ret;
+}
+
 static int tusb320_reset(struct tusb320_priv *priv)
 {
 	int ret;
 
 	/* Set mode to default (follow PORT pin) */
-	ret = tusb320_set_mode(priv, TUSB320_MODE_PORT);
+	ret = priv->ops->set_mode(priv, TUSB320_MODE_PORT);
 	if (ret && ret != -EBUSY) {
 		dev_err(priv->dev,
 			"failed to set mode to PORT: %d\n", ret);
@@ -126,6 +170,20 @@ static int tusb320_reset(struct tusb320_priv *priv)
 	return 0;
 }
 
+static int tusb320l_get_revision(struct tusb320_priv *priv, unsigned int *revision)
+{
+	return regmap_read(priv->regmap, TUSB320L_REGA0_REVISION, revision);
+}
+
+static struct tusb320_ops tusb320_ops = {
+	.set_mode = tusb320_set_mode,
+};
+
+static struct tusb320_ops tusb320l_ops = {
+	.set_mode = tusb320l_set_mode,
+	.get_revision = tusb320l_get_revision,
+};
+
 static irqreturn_t tusb320_irq_handler(int irq, void *dev_id)
 {
 	struct tusb320_priv *priv = dev_id;
@@ -176,6 +234,8 @@ static int tusb320_extcon_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
 	struct tusb320_priv *priv;
+	const void *match_data;
+	unsigned int revision;
 	int ret;
 
 	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
@@ -191,12 +251,27 @@ static int tusb320_extcon_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 
+	match_data = device_get_match_data(&client->dev);
+	if (!match_data)
+		return -EINVAL;
+
+	priv->ops = (struct tusb320_ops*)match_data;
+
 	priv->edev = devm_extcon_dev_allocate(priv->dev, tusb320_extcon_cable);
 	if (IS_ERR(priv->edev)) {
 		dev_err(priv->dev, "failed to allocate extcon device\n");
 		return PTR_ERR(priv->edev);
 	}
 
+	if (priv->ops->get_revision) {
+		ret = priv->ops->get_revision(priv, &revision);
+		if (ret)
+			dev_warn(priv->dev,
+				"failed to read revision register: %d\n", ret);
+		else
+			dev_info(priv->dev, "chip revision %d\n", revision);
+	}
+
 	ret = devm_extcon_dev_register(priv->dev, priv->edev);
 	if (ret < 0) {
 		dev_err(priv->dev, "failed to register extcon device\n");
@@ -231,7 +306,8 @@ static int tusb320_extcon_probe(struct i2c_client *client,
 }
 
 static const struct of_device_id tusb320_extcon_dt_match[] = {
-	{ .compatible = "ti,tusb320", },
+	{ .compatible = "ti,tusb320", .data = &tusb320_ops, },
+	{ .compatible = "ti,tusb320l", .data = &tusb320l_ops, },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, tusb320_extcon_dt_match);
-- 
2.35.1



