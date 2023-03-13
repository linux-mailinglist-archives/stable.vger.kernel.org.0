Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C6B6B784B
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 14:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCMNBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 09:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjCMNBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 09:01:36 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0E424CA4
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 06:01:16 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id fd5so14487930edb.7
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 06:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google; t=1678712475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4Q/DogsgORqXACnXI/E1XL6lwcLWumClKlVZk2SIujI=;
        b=Zy7mqeiIhq9wgKd37Y2pJOId901fubrqJ9e/TkoouPGsGgZClMJB1DbeocGQ6U+HeW
         AQICMW/GoJB6GtAg48EH/iXQkZtNm0CQyZMVBbntOU4Ou/+Ht0Rk8O02/cLB40yC2djV
         MNVG0IfYFCshwqepZwx9X0eDdKEoq3OdmQ3Bg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678712475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Q/DogsgORqXACnXI/E1XL6lwcLWumClKlVZk2SIujI=;
        b=uvTvrzo5rjuoLDxK/QTw2LiZH4vGYBfq09hLak/mR3HLed05YVH8R0GN94lJU5sBm3
         pk7GbhzWe+WttlxvT6QLgfW8nstyrYf3yVATOBeBBSEnd3I/4a7hZkDVY2sirEgBouZR
         fmJlv6GKzS2zVoCm4YJwYFf4CnqA/mu7Calnk1k/m5Dgu+p0CBu73M/q+oeBB+Kjw2IA
         A0r/QtLcvo76IuJcV26U5AbJySFUDDypm4xKzLzi59ZDbtpRX+X3OU4uvREIZ4r7Uyxr
         k8gxsWvanvULmyO+wlSKscZY5ZTX10Pn0BQEH9SJWNGQIMcPZNqcM9qq+EixvNeyF1AB
         XQog==
X-Gm-Message-State: AO0yUKXm5LRJrdZuSUPayh3/JubNp1xcla3PA51hOKp7dcUsDK/DA5FP
        mJGP4S6kPlkwGKo3FK/e5pzkvw==
X-Google-Smtp-Source: AK7set/91glySBtTl8d3atKkP/ij+i3KLc3CbDn/Gxd1o/lQfMOHiSXXClvluRraMPz5cyD6LdhQsA==
X-Received: by 2002:a17:907:d090:b0:92b:5c67:c660 with SMTP id vc16-20020a170907d09000b0092b5c67c660mr1648091ejc.69.1678712475078;
        Mon, 13 Mar 2023 06:01:15 -0700 (PDT)
Received: from localhost.localdomain ([193.89.194.60])
        by smtp.gmail.com with ESMTPSA id u25-20020a50a419000000b004fc01b0aa55sm1407535edb.4.2023.03.13.06.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 06:01:14 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] extcon: usbc-tusb320: unregister typec port on driver removal
Date:   Mon, 13 Mar 2023 14:01:05 +0100
Message-Id: <20230313130105.4183296-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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
 drivers/extcon/extcon-usbc-tusb320.c | 42 ++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index b408ce989c22..03125c53329d 100644
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
+	priv->connector_fwnode;
 
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

