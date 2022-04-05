Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6804F2770
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiDEIGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236436AbiDEICP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F914C7BD;
        Tue,  5 Apr 2022 01:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4450DB81B14;
        Tue,  5 Apr 2022 08:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2780C34117;
        Tue,  5 Apr 2022 08:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145615;
        bh=/t/IVCH4HyVLdbcbyqgv9M9GgE6INsqR2BeJWrEF/7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ylw/OFMYgwEavP+4TALTqAEHC8CuOcbazLYa91ZfAo3zQ3TW1/u41ATyeQMDciFHG
         X314xSouXe2rGOGrj+SxkYdU8gpFM111VFbFtWcIGNHd+hc7A2g+ThWmxXm1HTkNtT
         og0Y9z9t7ImryuXLWedcZqv2ee8jQVw9Yc6TIyxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagan Teki <jagan@amarulasolutions.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0428/1126] drm: bridge: adv7511: Fix ADV7535 HPD enablement
Date:   Tue,  5 Apr 2022 09:19:35 +0200
Message-Id: <20220405070420.188115442@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jagan Teki <jagan@amarulasolutions.com>

[ Upstream commit 3dbc84a595d17f64f14fcea00120d31e33e98880 ]

Existing HPD enablement logic is not compatible with ADV7535
bridge, thus any runtime plug-in of HDMI cable is not working
on these bridge designs.

Unlike other ADV7511 family of bridges, the ADV7535 require
HPD_OVERRIDE bit to set and reset for proper handling of HPD
functionality.

Fix it.

Fixes: 8501fe4b14a3 ("drm: bridge: adv7511: Add support for ADV7535")
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220109172949.168167-1-jagan@amarulasolutions.com
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511.h     |  1 +
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 29 +++++++++++++++-----
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
index 592ecfcf00ca..6a882891d91c 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
@@ -169,6 +169,7 @@
 #define ADV7511_PACKET_ENABLE_SPARE2		BIT(1)
 #define ADV7511_PACKET_ENABLE_SPARE1		BIT(0)
 
+#define ADV7535_REG_POWER2_HPD_OVERRIDE		BIT(6)
 #define ADV7511_REG_POWER2_HPD_SRC_MASK		0xc0
 #define ADV7511_REG_POWER2_HPD_SRC_BOTH		0x00
 #define ADV7511_REG_POWER2_HPD_SRC_HPD		0x40
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index f8e5da148599..77118c3395bf 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -351,11 +351,17 @@ static void __adv7511_power_on(struct adv7511 *adv7511)
 	 * from standby or are enabled. When the HPD goes low the adv7511 is
 	 * reset and the outputs are disabled which might cause the monitor to
 	 * go to standby again. To avoid this we ignore the HPD pin for the
-	 * first few seconds after enabling the output.
+	 * first few seconds after enabling the output. On the other hand
+	 * adv7535 require to enable HPD Override bit for proper HPD.
 	 */
-	regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER2,
-			   ADV7511_REG_POWER2_HPD_SRC_MASK,
-			   ADV7511_REG_POWER2_HPD_SRC_NONE);
+	if (adv7511->type == ADV7535)
+		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER2,
+				   ADV7535_REG_POWER2_HPD_OVERRIDE,
+				   ADV7535_REG_POWER2_HPD_OVERRIDE);
+	else
+		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER2,
+				   ADV7511_REG_POWER2_HPD_SRC_MASK,
+				   ADV7511_REG_POWER2_HPD_SRC_NONE);
 }
 
 static void adv7511_power_on(struct adv7511 *adv7511)
@@ -375,6 +381,10 @@ static void adv7511_power_on(struct adv7511 *adv7511)
 static void __adv7511_power_off(struct adv7511 *adv7511)
 {
 	/* TODO: setup additional power down modes */
+	if (adv7511->type == ADV7535)
+		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER2,
+				   ADV7535_REG_POWER2_HPD_OVERRIDE, 0);
+
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER,
 			   ADV7511_POWER_POWER_DOWN,
 			   ADV7511_POWER_POWER_DOWN);
@@ -672,9 +682,14 @@ adv7511_detect(struct adv7511 *adv7511, struct drm_connector *connector)
 			status = connector_status_disconnected;
 	} else {
 		/* Renable HPD sensing */
-		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER2,
-				   ADV7511_REG_POWER2_HPD_SRC_MASK,
-				   ADV7511_REG_POWER2_HPD_SRC_BOTH);
+		if (adv7511->type == ADV7535)
+			regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER2,
+					   ADV7535_REG_POWER2_HPD_OVERRIDE,
+					   ADV7535_REG_POWER2_HPD_OVERRIDE);
+		else
+			regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER2,
+					   ADV7511_REG_POWER2_HPD_SRC_MASK,
+					   ADV7511_REG_POWER2_HPD_SRC_BOTH);
 	}
 
 	adv7511->status = status;
-- 
2.34.1



