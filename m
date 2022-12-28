Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BE46581B6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiL1QbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbiL1QbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA571CB1D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0817B81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F2AC433D2;
        Wed, 28 Dec 2022 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244822;
        bh=2T2LJ59ayqgeEhm+nqeNL0q+bbd5bJDVPllt0w3at18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLslj6yKnhwQGM/CYnHsVuhKG2ToRV2G3K3uROnxRPDmNfyt03ZesWP3sT4NT3ETv
         TG2j6fE5NKo0ke9OS16/EW3rIVYoc4ZqUMxgIzP4+6lQzdST4C4zaqbIMAiPD46gdN
         8aue98htuofRvz2CMXy0HioJwjqBFM3ICwn++ezI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0753/1073] power: supply: bq25890: Ensure pump_express_work is cancelled on remove
Date:   Wed, 28 Dec 2022 15:39:01 +0100
Message-Id: <20221228144348.472698098@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index b4c8481ea17b..92fab662a51d 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -1189,6 +1189,13 @@ static int bq25890_fw_probe(struct bq25890_device *bq)
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
@@ -1244,6 +1251,14 @@ static int bq25890_probe(struct i2c_client *client)
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



