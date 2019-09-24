Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDF2BD01C
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391351AbfIXQlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391096AbfIXQlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:41:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C04FA20872;
        Tue, 24 Sep 2019 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343312;
        bh=l7SVIHAjohUAHLLjL6LFbSWx39cHsD0Jnyhm3JkmAAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vYyTM2XrJnTRHz/sqISb5SJJif0Lg9XUwNbZ6e4peWURx1BkZxRCx9kd44lGdFPE
         aHgsb90g8VAQTmBsTwujMoW1UZYEGbKKCWKCyD0bsrGjOqrlXfp4U5DrGfAD/z1xC5
         AbSYYaDvaRDDUDE6QmQVRjG9yO59/3sqCyMSL958=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Redfearn <matt.redfearn@thinci.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 04/87] drm/bridge: adv7511: Attach to DSI host at probe time
Date:   Tue, 24 Sep 2019 12:40:20 -0400
Message-Id: <20190924164144.25591-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Redfearn <matt.redfearn@thinci.com>

[ Upstream commit 83f35bc3a852f1c3892c7474998c5cec707c7ba3 ]

In contrast to all of the DSI panel drivers in drivers/gpu/drm/panel
which attach to the DSI host via mipi_dsi_attach() at probe time, the
ADV7533 bridge device does not. Instead it defers this to the point that
the upstream device connects to its bridge via drm_bridge_attach().
The generic Synopsys MIPI DSI host driver does not register it's own
drm_bridge until the MIPI DSI has attached. But it does not call
drm_bridge_attach() on the downstream device until the upstream device
has attached. This leads to a chicken and the egg failure and the DRM
pipeline does not complete.
Since all other mipi_dsi_device drivers call mipi_dsi_attach() in
probe(), make the adv7533 mipi_dsi_device do the same. This ensures that
the Synopsys MIPI DSI host registers it's bridge such that it is
available for the upstream device to connect to.

Signed-off-by: Matt Redfearn <matt.redfearn@thinci.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190627151740.2277-1-matt.redfearn@thinci.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index f6d2681f69273..98bccace8c1c0 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -874,9 +874,6 @@ static int adv7511_bridge_attach(struct drm_bridge *bridge)
 				 &adv7511_connector_helper_funcs);
 	drm_connector_attach_encoder(&adv->connector, bridge->encoder);
 
-	if (adv->type == ADV7533)
-		ret = adv7533_attach_dsi(adv);
-
 	if (adv->i2c_main->irq)
 		regmap_write(adv->regmap, ADV7511_REG_INT_ENABLE(0),
 			     ADV7511_INT0_HPD);
@@ -1222,8 +1219,17 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	drm_bridge_add(&adv7511->bridge);
 
 	adv7511_audio_init(dev, adv7511);
+
+	if (adv7511->type == ADV7533) {
+		ret = adv7533_attach_dsi(adv7511);
+		if (ret)
+			goto err_remove_bridge;
+	}
+
 	return 0;
 
+err_remove_bridge:
+	drm_bridge_remove(&adv7511->bridge);
 err_unregister_cec:
 	i2c_unregister_device(adv7511->i2c_cec);
 	if (adv7511->cec_clk)
-- 
2.20.1

