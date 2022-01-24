Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF6F49936D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345894AbiAXUdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:33:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382208AbiAXUZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:25:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0890B8122C;
        Mon, 24 Jan 2022 20:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9BFC340E8;
        Mon, 24 Jan 2022 20:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055915;
        bh=C2yRUz42DqSxD6SVZ6vEK2YQtCMvqicsfk/FQJFLEfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxMdtwUydBNN46lQ+7UMAN+T5M8sftX2pM1ecrdXIhoPjpiOhK2pbTBb0TDjMhsCI
         iEOX4bIeBB6n5cqjyM49OOjBOc6+mQkd/FK98KHmRlH7r1G6fPnvVqFMiItAjEgedl
         uJqVa+N5YktjxLVx3WJnSvQwsu35afcCdOWKIaas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 291/846] backlight: qcom-wled: Respect enabled-strings in set_brightness
Date:   Mon, 24 Jan 2022 19:36:48 +0100
Message-Id: <20220124184110.972393777@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit ec961cf3241153e0f27d850f1bf0f172e7d27a21 ]

The hardware is capable of controlling any non-contiguous sequence of
LEDs specified in the DT using qcom,enabled-strings as u32
array, and this also follows from the DT-bindings documentation.  The
numbers specified in this array represent indices of the LED strings
that are to be enabled and disabled.

Its value is appropriately used to setup and enable string modules, but
completely disregarded in the set_brightness paths which only iterate
over the number of strings linearly.
Take an example where only string 2 is enabled with
qcom,enabled_strings=<2>: this string is appropriately enabled but
subsequent brightness changes would have only touched the zero'th
brightness register because num_strings is 1 here.  This is simply
addressed by looking up the string for this index in the enabled_strings
array just like the other codepaths that iterate over num_strings.

Likewise enabled_strings is now also used in the autodetection path for
consistent behaviour: when a list of strings is specified in DT only
those strings will be probed for autodetection, analogous to how the
number of strings that need to be probed is already bound by
qcom,num-strings.  After all autodetection uses the set_brightness
helpers to set an initial value, which could otherwise end up changing
brightness on a different set of strings.

Fixes: 775d2ffb4af6 ("backlight: qcom-wled: Restructure the driver for WLED3")
Fixes: 03b2b5e86986 ("backlight: qcom-wled: Add support for WLED4 peripheral")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211115203459.1634079-10-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 5306b06044b4f..f12c76d6e61de 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -237,7 +237,7 @@ static int wled3_set_brightness(struct wled *wled, u16 brightness)
 
 	for (i = 0;  i < wled->cfg.num_strings; ++i) {
 		rc = regmap_bulk_write(wled->regmap, wled->ctrl_addr +
-				       WLED3_SINK_REG_BRIGHT(i),
+				       WLED3_SINK_REG_BRIGHT(wled->cfg.enabled_strings[i]),
 				       &v, sizeof(v));
 		if (rc < 0)
 			return rc;
@@ -260,7 +260,7 @@ static int wled4_set_brightness(struct wled *wled, u16 brightness)
 
 	for (i = 0;  i < wled->cfg.num_strings; ++i) {
 		rc = regmap_bulk_write(wled->regmap, wled->sink_addr +
-				       WLED4_SINK_REG_BRIGHT(i),
+				       WLED4_SINK_REG_BRIGHT(wled->cfg.enabled_strings[i]),
 				       &v, sizeof(v));
 		if (rc < 0)
 			return rc;
@@ -571,7 +571,7 @@ unlock_mutex:
 
 static void wled_auto_string_detection(struct wled *wled)
 {
-	int rc = 0, i, delay_time_us;
+	int rc = 0, i, j, delay_time_us;
 	u32 sink_config = 0;
 	u8 sink_test = 0, sink_valid = 0, val;
 	bool fault_set;
@@ -618,14 +618,15 @@ static void wled_auto_string_detection(struct wled *wled)
 
 	/* Iterate through the strings one by one */
 	for (i = 0; i < wled->cfg.num_strings; i++) {
-		sink_test = BIT((WLED4_SINK_REG_CURR_SINK_SHFT + i));
+		j = wled->cfg.enabled_strings[i];
+		sink_test = BIT((WLED4_SINK_REG_CURR_SINK_SHFT + j));
 
 		/* Enable feedback control */
 		rc = regmap_write(wled->regmap, wled->ctrl_addr +
-				  WLED3_CTRL_REG_FEEDBACK_CONTROL, i + 1);
+				  WLED3_CTRL_REG_FEEDBACK_CONTROL, j + 1);
 		if (rc < 0) {
 			dev_err(wled->dev, "Failed to enable feedback for SINK %d rc = %d\n",
-				i + 1, rc);
+				j + 1, rc);
 			goto failed_detect;
 		}
 
@@ -634,7 +635,7 @@ static void wled_auto_string_detection(struct wled *wled)
 				  WLED4_SINK_REG_CURR_SINK, sink_test);
 		if (rc < 0) {
 			dev_err(wled->dev, "Failed to configure SINK %d rc=%d\n",
-				i + 1, rc);
+				j + 1, rc);
 			goto failed_detect;
 		}
 
@@ -661,7 +662,7 @@ static void wled_auto_string_detection(struct wled *wled)
 
 		if (fault_set)
 			dev_dbg(wled->dev, "WLED OVP fault detected with SINK %d\n",
-				i + 1);
+				j + 1);
 		else
 			sink_valid |= sink_test;
 
@@ -701,15 +702,16 @@ static void wled_auto_string_detection(struct wled *wled)
 	/* Enable valid sinks */
 	if (wled->version == 4) {
 		for (i = 0; i < wled->cfg.num_strings; i++) {
+			j = wled->cfg.enabled_strings[i];
 			if (sink_config &
-			    BIT(WLED4_SINK_REG_CURR_SINK_SHFT + i))
+			    BIT(WLED4_SINK_REG_CURR_SINK_SHFT + j))
 				val = WLED4_SINK_REG_STR_MOD_MASK;
 			else
 				/* Disable modulator_en for unused sink */
 				val = 0;
 
 			rc = regmap_write(wled->regmap, wled->sink_addr +
-					  WLED4_SINK_REG_STR_MOD_EN(i), val);
+					  WLED4_SINK_REG_STR_MOD_EN(j), val);
 			if (rc < 0) {
 				dev_err(wled->dev, "Failed to configure MODULATOR_EN rc=%d\n",
 					rc);
-- 
2.34.1



