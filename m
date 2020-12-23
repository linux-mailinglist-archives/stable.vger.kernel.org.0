Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E342E11C7
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725300AbgLWCRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgLWCRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:17:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 970222222A;
        Wed, 23 Dec 2020 02:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689791;
        bh=ZSA41/q39HXg0SItUW1TBhjquHbuv7/iDv3p9HfPKpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCYfxuhc70scrJX79WjWacYJQIr8egDKknyQ5sx1zbaj2BpuQ4PmCcDGgu7YA7rHB
         PHBZhwr00Prpuw1tfV6KxIYR2Ifgx++WSWwN8sVVhUIiVPaDWOEWEd7CrRXBr+2Xyw
         U2E11VEkQpbPO0iLtpMH6gPkPcG4qlQjHjjsQkt4zszovkhZ0BtE4lvn4O2G59ZdK2
         7Dt6EvwGjSUErcEkkMeyGZei+w6W5VM+XaH2AcLRIqaIPO/xMHMPz4rKmy4GS7kZN2
         675d74DnlXeiFcRFGYaImIfRBaHQOsampW9g4OO/9UzbslbQhLqNRsjoVLAchoInJU
         w3AJMm5vdw4uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Steev Klimaszewski <steev@kali.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 003/217] drm/bridge: ti-sn65dsi86: Add retries for link training
Date:   Tue, 22 Dec 2020 21:12:52 -0500
Message-Id: <20201223021626.2790791-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 137655d1ed353806b8591855b569efd090d84135 ]

On some panels hooked up to the ti-sn65dsi86 bridge chip we found that
link training was failing.  Specifically, we'd see:

  ti_sn65dsi86 2-002d: [drm:ti_sn_bridge_enable] *ERROR* Link training failed, link is off (-5)

The panel was hooked up to a logic analyzer and it was found that, as
part of link training, the bridge chip was writing a 0x1 to DPCD
address 00600h and the panel responded NACK.  As can be seen in header
files, the write of 0x1 to DPCD address 0x600h means we were trying to
write the value DP_SET_POWER_D0 to the register DP_SET_POWER.  The
panel vendor says that a NACK in this case is not unexpected and means
"not ready, try again".

In testing, we found that this panel would respond with a NACK in
about 1/25 times.  Adding the retry logic worked fine and the most
number of tries needed was 3.  Just to be safe, we'll add 10 tries
here and we'll add a little blurb to the logs if we ever need more
than 5.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Tested-By: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201002135920.1.I2adbc90b2db127763e2444bd5a4e5bf30e1db8e5@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 40 +++++++++++++++++++--------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index ecdf9b01340f5..c9ab9d8296940 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -106,6 +106,8 @@
 #define SN_NUM_GPIOS			4
 #define SN_GPIO_PHYSICAL_OFFSET		1
 
+#define SN_LINK_TRAINING_TRIES		10
+
 /**
  * struct ti_sn_bridge - Platform data for ti-sn65dsi86 driver.
  * @dev:          Pointer to our device.
@@ -673,6 +675,7 @@ static int ti_sn_link_training(struct ti_sn_bridge *pdata, int dp_rate_idx,
 {
 	unsigned int val;
 	int ret;
+	int i;
 
 	/* set dp clk frequency value */
 	regmap_update_bits(pdata->regmap, SN_DATARATE_CONFIG_REG,
@@ -689,19 +692,34 @@ static int ti_sn_link_training(struct ti_sn_bridge *pdata, int dp_rate_idx,
 		goto exit;
 	}
 
-	/* Semi auto link training mode */
-	regmap_write(pdata->regmap, SN_ML_TX_MODE_REG, 0x0A);
-	ret = regmap_read_poll_timeout(pdata->regmap, SN_ML_TX_MODE_REG, val,
-				       val == ML_TX_MAIN_LINK_OFF ||
-				       val == ML_TX_NORMAL_MODE, 1000,
-				       500 * 1000);
-	if (ret) {
-		*last_err_str = "Training complete polling failed";
-	} else if (val == ML_TX_MAIN_LINK_OFF) {
-		*last_err_str = "Link training failed, link is off";
-		ret = -EIO;
+	/*
+	 * We'll try to link train several times.  As part of link training
+	 * the bridge chip will write DP_SET_POWER_D0 to DP_SET_POWER.  If
+	 * the panel isn't ready quite it might respond NAK here which means
+	 * we need to try again.
+	 */
+	for (i = 0; i < SN_LINK_TRAINING_TRIES; i++) {
+		/* Semi auto link training mode */
+		regmap_write(pdata->regmap, SN_ML_TX_MODE_REG, 0x0A);
+		ret = regmap_read_poll_timeout(pdata->regmap, SN_ML_TX_MODE_REG, val,
+					       val == ML_TX_MAIN_LINK_OFF ||
+					       val == ML_TX_NORMAL_MODE, 1000,
+					       500 * 1000);
+		if (ret) {
+			*last_err_str = "Training complete polling failed";
+		} else if (val == ML_TX_MAIN_LINK_OFF) {
+			*last_err_str = "Link training failed, link is off";
+			ret = -EIO;
+			continue;
+		}
+
+		break;
 	}
 
+	/* If we saw quite a few retries, add a note about it */
+	if (!ret && i > SN_LINK_TRAINING_TRIES / 2)
+		DRM_DEV_INFO(pdata->dev, "Link training needed %d retries\n", i);
+
 exit:
 	/* Disable the PLL if we failed */
 	if (ret)
-- 
2.27.0

