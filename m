Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF96499950
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453983AbiAXVbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450889AbiAXVVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9809BC0604E1;
        Mon, 24 Jan 2022 12:16:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35A4C611CD;
        Mon, 24 Jan 2022 20:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DBCC340E5;
        Mon, 24 Jan 2022 20:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055383;
        bh=Gj/ZBJfXwO4Vq/uUWw7uOBpKsabtffRUsI+FbzQkHyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYL3eOyhzNXhwQc6rpHK39Tjeq0jyLZ0mg15AECcrLlvHRIdXjYPIN+jErH4iWlty
         kOPtUpEDyYhx6fh0SyNwvND9YUS2vAb3L/j+5Q5MMnWMWrdqkTHc1gyDP58quzx3rq
         TSZCTHwHXhQbaPDpHLcMbzrYSUykd0pvYyayKLtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/846] drm/dp: Dont read back backlight mode in drm_edp_backlight_enable()
Date:   Mon, 24 Jan 2022 19:34:10 +0100
Message-Id: <20220124184105.572031601@linuxfoundation.org>
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
index 6d0f2c447f3b9..7bb24523a7493 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -3214,27 +3214,13 @@ int drm_edp_backlight_enable(struct drm_dp_aux *aux, const struct drm_edp_backli
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
@@ -3244,16 +3230,14 @@ int drm_edp_backlight_enable(struct drm_dp_aux *aux, const struct drm_edp_backli
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



