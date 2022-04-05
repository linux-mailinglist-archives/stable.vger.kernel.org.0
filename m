Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7242C4F3BCC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245020AbiDEMCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358002AbiDEK1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CEFD7634;
        Tue,  5 Apr 2022 03:12:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 257F8B81B7A;
        Tue,  5 Apr 2022 10:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2F4C385A0;
        Tue,  5 Apr 2022 10:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153556;
        bh=fWnZGTaax7ux6XIJiRunoR+0ZtZCkTRhX4NvNDGGMFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WM5no34pE0flo1xzRUHSgzbNbzfXJ0/56O+Jgpzwd0uqKHNHiDmsbNBuFM9+GIFK6
         /DdehqDVjKbzGfU9CYDhlxpAdCWeKHciPDDxINyK1292PHwpfQbHBcvbVcKOwhT5C0
         tF6yOIeL5q5eqVhRmIehDDk2sUL+TqQC4HNmcops=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagan Teki <jagan@amarulasolutions.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 264/599] drm: bridge: adv7511: Fix ADV7535 HPD enablement
Date:   Tue,  5 Apr 2022 09:29:18 +0200
Message-Id: <20220405070306.694905921@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index a9bb734366ae..a0f6ee15c248 100644
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
index a0d392c338da..c6f059be4b89 100644
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



