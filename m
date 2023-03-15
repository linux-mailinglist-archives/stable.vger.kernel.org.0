Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A1B6BB5B9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjCOOQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjCOOQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:16:29 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4053934C35
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:16:01 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id y4so46705814edo.2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google; t=1678889759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oFlsa6HtfdlDO+5W0pHOXKXz4uVBrG6uhwA+mTGh/F4=;
        b=UGMpDSGL8X5RFbzk+SEfLtR+9GJKEnTWGNIdPmBJGWII5fmtVJp57KaAbMkCgDbJb+
         +8GCmf9p0z3p6oHvimw007lQGVU/hqtHOT1SAewubK0Ucm6lG0u2Eg+J6aal9KzsMyXv
         Lw6KTdWkHzGq95NRgsqVjI/+4RQWYPFFYUiWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678889759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oFlsa6HtfdlDO+5W0pHOXKXz4uVBrG6uhwA+mTGh/F4=;
        b=OvUSQkcap+j4+etT1ID7TElM4aK55WXuVi9jKK09LwXqmelxhXqNo+tmWb+V2EeFZl
         K9/fl6QYUkFN4xdnn1aTy7zu04YPZ2Ci3mtVsCX/efxGTuto1VQIIXv2gevLeGdgAtIT
         mmupgqrUlS0iVaKPd2E94LQoQP4XKl32KwaUxRlASwJ8Tzl7W8nfTZslk6/hFWhaEVyS
         9ztwjKtjaAzX1f5LK6NqWmSReBF/SB6GqVO+IhkWkbqE+M83kUOGHXBt/RhsgZuNHDqR
         PpdoDWVmaFUT0haD2hN9bTuStQwcso2catlv4SpXqaVfC8HU9Eus6KtF/R2IzZoMagA9
         mVfQ==
X-Gm-Message-State: AO0yUKVfW1A66YF592EnJWx0fCHEaXLfaxvITCwvCInwlYOVQHMsTuB4
        /FZBJi192mlKw4TwFR3A0xJZ8g==
X-Google-Smtp-Source: AK7set8oPIsIHljWEG7Btn7/oqvtoKP54iIoNGcUixTywJ0v44k5S6228+JMg1jI54PO01KBJ+54IA==
X-Received: by 2002:a17:907:a804:b0:92a:edd4:638 with SMTP id vo4-20020a170907a80400b0092aedd40638mr2911718ejc.22.1678889758698;
        Wed, 15 Mar 2023 07:15:58 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b004aef147add6sm2532280edb.47.2023.03.15.07.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 07:15:58 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Marek Vasut <marex@denx.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] extcon: usbc-tusb320: unregister typec port on driver removal
Date:   Wed, 15 Mar 2023 15:15:47 +0100
Message-Id: <20230315141547.825057-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

The driver can register a typec port if suitable firmware properties are
present. But if the driver is removed through sysfs unbind, rmmod or
similar, then it does not clean up after itself and the typec port
device remains registered. This can be seen in sysfs, where stale typec
ports get left over in /sys/class/typec.

In order to fix this we have to add an i2c_driver remove function and
call typec_unregister_port(), which is a no-op in the case where no
typec port is created and the pointer remains NULL.

In the process we should also put the fwnode_handle when the typec port
isn't registered anymore, including if an error occurs during probe. The
typec subsystem does not increase or decrease the reference counter for
us, so we track it in the driver's private data.

Note that the conditional check on TYPEC_PWR_MODE_PD was removed in the
probe path because a call to tusb320_set_adv_pwr_mode() will perform an
even more robust validation immediately after, hence there is no
functional change here.

Fixes: bf7571c00dca ("extcon: usbc-tusb320: Add USB TYPE-C support")
Cc: stable@vger.kernel.org
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v2: properly assign priv->connector_fwnode = connector;
---
 drivers/extcon/extcon-usbc-tusb320.c | 42 ++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index b408ce989c22..10dff1c512c4 100644
--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -78,6 +78,7 @@ struct tusb320_priv {
 	struct typec_capability	cap;
 	enum typec_port_type port_type;
 	enum typec_pwr_opmode pwr_opmode;
+	struct fwnode_handle *connector_fwnode;
 };
 
 static const char * const tusb_attached_states[] = {
@@ -391,27 +392,25 @@ static int tusb320_typec_probe(struct i2c_client *client,
 	/* Type-C connector found. */
 	ret = typec_get_fw_cap(&priv->cap, connector);
 	if (ret)
-		return ret;
+		goto err_put;
 
 	priv->port_type = priv->cap.type;
 
 	/* This goes into register 0x8 field CURRENT_MODE_ADVERTISE */
 	ret = fwnode_property_read_string(connector, "typec-power-opmode", &cap_str);
 	if (ret)
-		return ret;
+		goto err_put;
 
 	ret = typec_find_pwr_opmode(cap_str);
 	if (ret < 0)
-		return ret;
-	if (ret == TYPEC_PWR_MODE_PD)
-		return -EINVAL;
+		goto err_put;
 
 	priv->pwr_opmode = ret;
 
 	/* Initialize the hardware with the devicetree settings. */
 	ret = tusb320_set_adv_pwr_mode(priv);
 	if (ret)
-		return ret;
+		goto err_put;
 
 	priv->cap.revision		= USB_TYPEC_REV_1_1;
 	priv->cap.accessory[0]		= TYPEC_ACCESSORY_AUDIO;
@@ -422,10 +421,25 @@ static int tusb320_typec_probe(struct i2c_client *client,
 	priv->cap.fwnode		= connector;
 
 	priv->port = typec_register_port(&client->dev, &priv->cap);
-	if (IS_ERR(priv->port))
-		return PTR_ERR(priv->port);
+	if (IS_ERR(priv->port)) {
+		ret = PTR_ERR(priv->port);
+		goto err_put;
+	}
+
+	priv->connector_fwnode = connector;
 
 	return 0;
+
+err_put:
+	fwnode_handle_put(connector);
+
+	return ret;
+}
+
+static void tusb320_typec_remove(struct tusb320_priv *priv)
+{
+	typec_unregister_port(priv->port);
+	fwnode_handle_put(priv->connector_fwnode);
 }
 
 static int tusb320_probe(struct i2c_client *client)
@@ -438,7 +452,9 @@ static int tusb320_probe(struct i2c_client *client)
 	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+
 	priv->dev = &client->dev;
+	i2c_set_clientdata(client, priv);
 
 	priv->regmap = devm_regmap_init_i2c(client, &tusb320_regmap_config);
 	if (IS_ERR(priv->regmap))
@@ -489,10 +505,19 @@ static int tusb320_probe(struct i2c_client *client)
 					tusb320_irq_handler,
 					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 					client->name, priv);
+	if (ret)
+		tusb320_typec_remove(priv);
 
 	return ret;
 }
 
+static void tusb320_remove(struct i2c_client *client)
+{
+	struct tusb320_priv *priv = i2c_get_clientdata(client);
+
+	tusb320_typec_remove(priv);
+}
+
 static const struct of_device_id tusb320_extcon_dt_match[] = {
 	{ .compatible = "ti,tusb320", .data = &tusb320_ops, },
 	{ .compatible = "ti,tusb320l", .data = &tusb320l_ops, },
@@ -502,6 +527,7 @@ MODULE_DEVICE_TABLE(of, tusb320_extcon_dt_match);
 
 static struct i2c_driver tusb320_extcon_driver = {
 	.probe_new	= tusb320_probe,
+	.remove		= tusb320_remove,
 	.driver		= {
 		.name	= "extcon-tusb320",
 		.of_match_table = tusb320_extcon_dt_match,
-- 
2.39.2

