Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15565498FA1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344417AbiAXTxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47408 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350884AbiAXTud (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:50:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D563660B43;
        Mon, 24 Jan 2022 19:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6D9C340E5;
        Mon, 24 Jan 2022 19:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053830;
        bh=02qCKii77kOqjfN+HoEomacGxd5qMKcREHO1H1Kj6rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDF+wsI9vd8kd/qcU4Wm/GCMcnNEHe0RmR+eo0F8Dp58SKneoPcVmiAE35hkWJspx
         OtFvdg6ERWlz1OT99DmeepVHhQr7rNoWlqEpu7tSEOrvSbx2gkj57ucjxDKBJ9FNLn
         YMepiXtiYpHCqtQHoENVxsRPLsHrNjEHv6hty1S8=
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
Subject: [PATCH 5.10 191/563] backlight: qcom-wled: Fix off-by-one maximum with default num_strings
Date:   Mon, 24 Jan 2022 19:39:16 +0100
Message-Id: <20220124184031.029770158@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 5ada78b26f935f8751852dffa24f6b545b1d2517 ]

When not specifying num-strings in the DT the default is used, but +1 is
added to it which turns WLED3 into 4 and WLED4/5 into 5 strings instead
of 3 and 4 respectively, causing out-of-bounds reads and register
read/writes.  This +1 exists for a deficiency in the DT parsing code,
and is simply omitted entirely - solving this oob issue - by parsing the
property separately much like qcom,enabled-strings.

This also enables more stringent checks on the maximum value when
qcom,enabled-strings is provided in the DT, by parsing num-strings after
enabled-strings to allow it to check against (and in a subsequent patch
override) the length of enabled-strings: it is invalid to set
num-strings higher than that.
The DT currently utilizes it to get around an incorrect fixed read of
four elements from that array (has been addressed in a prior patch) by
setting a lower num-strings where desired.

Fixes: 93c64f1ea1e8 ("leds: add Qualcomm PM8941 WLED driver")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-By: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211115203459.1634079-5-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 48 ++++++++++-------------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 92df5a9f6ae51..9e09165984b48 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1256,21 +1256,6 @@ static const struct wled_var_cfg wled5_ovp_cfg = {
 	.size = 16,
 };
 
-static u32 wled3_num_strings_values_fn(u32 idx)
-{
-	return idx + 1;
-}
-
-static const struct wled_var_cfg wled3_num_strings_cfg = {
-	.fn = wled3_num_strings_values_fn,
-	.size = 3,
-};
-
-static const struct wled_var_cfg wled4_num_strings_cfg = {
-	.fn = wled3_num_strings_values_fn,
-	.size = 4,
-};
-
 static u32 wled3_switch_freq_values_fn(u32 idx)
 {
 	return 19200 / (2 * (1 + idx));
@@ -1344,11 +1329,6 @@ static int wled_configure(struct wled *wled)
 			.val_ptr = &cfg->switch_freq,
 			.cfg = &wled3_switch_freq_cfg,
 		},
-		{
-			.name = "qcom,num-strings",
-			.val_ptr = &cfg->num_strings,
-			.cfg = &wled3_num_strings_cfg,
-		},
 	};
 
 	const struct wled_u32_opts wled4_opts[] = {
@@ -1372,11 +1352,6 @@ static int wled_configure(struct wled *wled)
 			.val_ptr = &cfg->switch_freq,
 			.cfg = &wled3_switch_freq_cfg,
 		},
-		{
-			.name = "qcom,num-strings",
-			.val_ptr = &cfg->num_strings,
-			.cfg = &wled4_num_strings_cfg,
-		},
 	};
 
 	const struct wled_u32_opts wled5_opts[] = {
@@ -1400,11 +1375,6 @@ static int wled_configure(struct wled *wled)
 			.val_ptr = &cfg->switch_freq,
 			.cfg = &wled3_switch_freq_cfg,
 		},
-		{
-			.name = "qcom,num-strings",
-			.val_ptr = &cfg->num_strings,
-			.cfg = &wled4_num_strings_cfg,
-		},
 		{
 			.name = "qcom,modulator-sel",
 			.val_ptr = &cfg->mod_sel,
@@ -1523,8 +1493,6 @@ static int wled_configure(struct wled *wled)
 			*bool_opts[i].val_ptr = true;
 	}
 
-	cfg->num_strings = cfg->num_strings + 1;
-
 	string_len = of_property_count_elems_of_size(dev->of_node,
 						     "qcom,enabled-strings",
 						     sizeof(u32));
@@ -1555,6 +1523,22 @@ static int wled_configure(struct wled *wled)
 		}
 	}
 
+	rc = of_property_read_u32(dev->of_node, "qcom,num-strings", &val);
+	if (!rc) {
+		if (val < 1 || val > wled->max_string_count) {
+			dev_err(dev, "qcom,num-strings must be between 1 and %d\n",
+				wled->max_string_count);
+			return -EINVAL;
+		}
+
+		if (string_len > 0 && val > string_len) {
+			dev_err(dev, "qcom,num-strings exceeds qcom,enabled-strings\n");
+			return -EINVAL;
+		}
+
+		cfg->num_strings = val;
+	}
+
 	return 0;
 }
 
-- 
2.34.1



