Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501DC499FB2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842040AbiAXXAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835941AbiAXWhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805E1C0E9BB2;
        Mon, 24 Jan 2022 13:00:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22488611DA;
        Mon, 24 Jan 2022 21:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C52C340E5;
        Mon, 24 Jan 2022 20:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057999;
        bh=bLax4OLcXZabgWm10AYP5WuGHuGUFlNoXdOHjo1yZi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mnl6gY1HB/WV1k7Hq198i1TEB5/TxIE3t8KMT4OIdWEUpb+TEJetk+gpjQ7P6upNK
         rCH7d8IcdI1yyoyp2oUb6Ix7eSf/ufk9hlJmtsdfUwr+TKIW/gDRUhsfwirOa/1Y23
         5qXPNQMyzqY7XR1sx62/nbDSmeh/cM5ArYvKlRFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0148/1039] drm/dp: Dont read back backlight mode in drm_edp_backlight_enable()
Date:   Mon, 24 Jan 2022 19:32:17 +0100
Message-Id: <20220124184130.141392342@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 646596485e1ed2182adf293dfd5aec4a96c46330 ]

As it turns out, apparently some machines will actually leave additional
backlight functionality like dynamic backlight control on before the OS
loads. Currently we don't take care to disable unsupported features when
writing back the backlight mode, which can lead to some rather strange
looking behavior when adjusting the backlight.

So, let's fix this by just not reading back the current backlight mode on
initial enable. I don't think there should really be any downsides to this,
and this will ensure we don't leave any unsupported functionality enabled.

This should fix at least one (but not all) of the issues seen with DPCD
backlight support on fi-bdw-samus

v5:
* Just avoid reading back DPCD register - Doug Anderson

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 867cf9cd73c3 ("drm/dp: Extract i915's eDP backlight code into DRM helpers")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211105183342.130810-4-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_helper.c | 40 ++++++++++-----------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index 4d0d1e8e51fa7..db7db839e42d1 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -3246,27 +3246,13 @@ int drm_edp_backlight_enable(struct drm_dp_aux *aux, const struct drm_edp_backli
 			     const u16 level)
 {
 	int ret;
-	u8 dpcd_buf, new_dpcd_buf;
+	u8 dpcd_buf = DP_EDP_BACKLIGHT_CONTROL_MODE_DPCD;
 
-	ret = drm_dp_dpcd_readb(aux, DP_EDP_BACKLIGHT_MODE_SET_REGISTER, &dpcd_buf);
-	if (ret != 1) {
-		drm_dbg_kms(aux->drm_dev,
-			    "%s: Failed to read backlight mode: %d\n", aux->name, ret);
-		return ret < 0 ? ret : -EIO;
-	}
-
-	new_dpcd_buf = dpcd_buf;
-
-	if ((dpcd_buf & DP_EDP_BACKLIGHT_CONTROL_MODE_MASK) != DP_EDP_BACKLIGHT_CONTROL_MODE_DPCD) {
-		new_dpcd_buf &= ~DP_EDP_BACKLIGHT_CONTROL_MODE_MASK;
-		new_dpcd_buf |= DP_EDP_BACKLIGHT_CONTROL_MODE_DPCD;
-
-		if (bl->pwmgen_bit_count) {
-			ret = drm_dp_dpcd_writeb(aux, DP_EDP_PWMGEN_BIT_COUNT, bl->pwmgen_bit_count);
-			if (ret != 1)
-				drm_dbg_kms(aux->drm_dev, "%s: Failed to write aux pwmgen bit count: %d\n",
-					    aux->name, ret);
-		}
+	if (bl->pwmgen_bit_count) {
+		ret = drm_dp_dpcd_writeb(aux, DP_EDP_PWMGEN_BIT_COUNT, bl->pwmgen_bit_count);
+		if (ret != 1)
+			drm_dbg_kms(aux->drm_dev, "%s: Failed to write aux pwmgen bit count: %d\n",
+				    aux->name, ret);
 	}
 
 	if (bl->pwm_freq_pre_divider) {
@@ -3276,16 +3262,14 @@ int drm_edp_backlight_enable(struct drm_dp_aux *aux, const struct drm_edp_backli
 				    "%s: Failed to write aux backlight frequency: %d\n",
 				    aux->name, ret);
 		else
-			new_dpcd_buf |= DP_EDP_BACKLIGHT_FREQ_AUX_SET_ENABLE;
+			dpcd_buf |= DP_EDP_BACKLIGHT_FREQ_AUX_SET_ENABLE;
 	}
 
-	if (new_dpcd_buf != dpcd_buf) {
-		ret = drm_dp_dpcd_writeb(aux, DP_EDP_BACKLIGHT_MODE_SET_REGISTER, new_dpcd_buf);
-		if (ret != 1) {
-			drm_dbg_kms(aux->drm_dev, "%s: Failed to write aux backlight mode: %d\n",
-				    aux->name, ret);
-			return ret < 0 ? ret : -EIO;
-		}
+	ret = drm_dp_dpcd_writeb(aux, DP_EDP_BACKLIGHT_MODE_SET_REGISTER, dpcd_buf);
+	if (ret != 1) {
+		drm_dbg_kms(aux->drm_dev, "%s: Failed to write aux backlight mode: %d\n",
+			    aux->name, ret);
+		return ret < 0 ? ret : -EIO;
 	}
 
 	ret = drm_edp_backlight_set_level(aux, bl, level);
-- 
2.34.1



