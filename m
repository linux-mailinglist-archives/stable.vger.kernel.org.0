Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAE259A1D0
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351065AbiHSQDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351636AbiHSQCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:02:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB99D4199;
        Fri, 19 Aug 2022 08:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F162B8280C;
        Fri, 19 Aug 2022 15:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165EEC433D6;
        Fri, 19 Aug 2022 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924445;
        bh=vlLaho7aPIYCSWSRoTd5tegJqakUGZ2amDCR2GU2kVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GerEcomtk5ahfTCQbdD9S1WgZLLlvRjPcHimKePh0CdJSP9fZPXwTxaVjAyOwDofg
         vVNbfEqfC7tEbT+x4a6ZMovowjgftP1NBcWFYZpvfnKuIaVxBh5yh2yTYd4nXm9Y3t
         7PVFFF2P8+BcHbZR3002P1om5/5vXUrSPrdh3zcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Borneo <antonio.borneo@foss.st.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/545] drm: adv7511: override i2c address of cec before accessing it
Date:   Fri, 19 Aug 2022 17:39:02 +0200
Message-Id: <20220819153837.055998390@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit 9cc4853e4781bf0dd0f35355dc92d97c9da02f5d ]

Commit 680532c50bca ("drm: adv7511: Add support for
i2c_new_secondary_device") allows a device tree node to override
the default addresses of the secondary i2c devices. This is useful
for solving address conflicts on the i2c bus.

In adv7511_init_cec_regmap() the new i2c address of cec device is
read from device tree and immediately accessed, well before it is
written in the proper register to override the default address.
This can cause an i2c error during probe and a consequent probe
failure.

Once the new i2c address is read from the device tree, override
the default address before any attempt to access the cec.

Tested with adv7533 and stm32mp157f.

Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Fixes: 680532c50bca ("drm: adv7511: Add support for i2c_new_secondary_device")
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220607213144.427177-1-antonio.borneo@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index aca2f14f04c2..8bac392cab79 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1063,6 +1063,10 @@ static int adv7511_init_cec_regmap(struct adv7511 *adv)
 						ADV7511_CEC_I2C_ADDR_DEFAULT);
 	if (IS_ERR(adv->i2c_cec))
 		return PTR_ERR(adv->i2c_cec);
+
+	regmap_write(adv->regmap, ADV7511_REG_CEC_I2C_ADDR,
+		     adv->i2c_cec->addr << 1);
+
 	i2c_set_clientdata(adv->i2c_cec, adv);
 
 	adv->regmap_cec = devm_regmap_init_i2c(adv->i2c_cec,
@@ -1267,9 +1271,6 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	if (ret)
 		goto err_i2c_unregister_packet;
 
-	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
-		     adv7511->i2c_cec->addr << 1);
-
 	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
 
 	if (i2c->irq) {
-- 
2.35.1



