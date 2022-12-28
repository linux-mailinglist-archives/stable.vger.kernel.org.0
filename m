Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B5E65822B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbiL1Qdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbiL1QdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:33:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A9F1B1CA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:30:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39401B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA34C433D2;
        Wed, 28 Dec 2022 16:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245031;
        bh=QpTKAsx72ADvHR3HjIkM4tgMilHaT3NZwCapRsf8+po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5a2Dh6Cn8n4ge6SntlenPeMQ09fA10juXeItI7x2PEx425ftX72SSOwHbZMMNwa4
         Fr7suZFGIMTKuZEH0PsVGSfEfv+VByN4MVe+2qU4WtHCpNBVhQd2jIwFqTY6j5RMUY
         3XxUFxF2+OxrOJE1y8ulB+gjdLymnVJMkKZoMR5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0781/1146] power: supply: bq25890: Ensure pump_express_work is cancelled on remove
Date:   Wed, 28 Dec 2022 15:38:40 +0100
Message-Id: <20221228144351.360715573@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a7aaa80098d5b7608b2dc1e883e3c3f929415243 ]

The pump_express_work which gets queued from an external_power_changed
callback might be pending / running on remove() (or on probe failure).

Add a devm action cancelling the work, to ensure that it is cancelled.

Note the devm action is added before devm_power_supply_register(), making
it run after devm unregisters the power_supply, so that the work cannot
be queued anymore (this is also why a devm action is used for this).

Fixes: 48f45b094dbb ("power: supply: bq25890: Support higher charging voltages through Pump Express+ protocol")
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq25890_charger.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index f212fc7cbb6d..0e15302b8df2 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -1219,6 +1219,13 @@ static int bq25890_fw_probe(struct bq25890_device *bq)
 	return 0;
 }
 
+static void bq25890_non_devm_cleanup(void *data)
+{
+	struct bq25890_device *bq = data;
+
+	cancel_delayed_work_sync(&bq->pump_express_work);
+}
+
 static int bq25890_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -1274,6 +1281,14 @@ static int bq25890_probe(struct i2c_client *client)
 	/* OTG reporting */
 	bq->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
 
+	/*
+	 * This must be before bq25890_power_supply_init(), so that it runs
+	 * after devm unregisters the power_supply.
+	 */
+	ret = devm_add_action_or_reset(dev, bq25890_non_devm_cleanup, bq);
+	if (ret)
+		return ret;
+
 	ret = bq25890_register_regulator(bq);
 	if (ret)
 		return ret;
-- 
2.35.1



