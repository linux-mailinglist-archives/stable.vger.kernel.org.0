Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CABE59362D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243806AbiHOSrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243937AbiHOSqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:46:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB663F309;
        Mon, 15 Aug 2022 11:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71C96CE125F;
        Mon, 15 Aug 2022 18:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692C4C433D6;
        Mon, 15 Aug 2022 18:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588068;
        bh=Km42Bxm6yHHfHS41fGN5FwzM/bDyy4QOKUQuJLMLkqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHmw0ZR0xQhy6jIhAjMQrHdvr+ufhIVvTw9brsk54BwrtQYKO1cLr4EijQycQ9C0n
         1dAloPRwEKGVyLDE2uyZ9/YoWnPmnaKHmvYjy5LjxIby4bluGivzqkieE502GZizVN
         5USc7gZYrvqBZ0Bf+/1xYd8ylEE9CBrztmP3fUzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Borneo <antonio.borneo@foss.st.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/779] drm: adv7511: override i2c address of cec before accessing it
Date:   Mon, 15 Aug 2022 19:58:22 +0200
Message-Id: <20220815180348.375452011@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 8c2025584f1b..1aadc6e94fde 100644
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



