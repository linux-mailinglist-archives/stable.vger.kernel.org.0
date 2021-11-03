Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8844449CA
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhKCUyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 16:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKCUys (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 16:54:48 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A4AC061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 13:52:11 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t21so3587968plr.6
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 13:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yqAQai0AVtWoyKf+XOKjzNiTg8raLXgXEunM3lTJxUk=;
        b=U/kJOM2CP4eT2Oubzvy2haWJkQ0vdvYS46QTEv5zRGXrYepI/mZAtVxkqg7Iily9DJ
         yagFW1lzXxduJErfpPbiZ4K7NTFtR04zBbQWb+isi1JdaZqf/Il9fjEeeU9GNBAe5qro
         QcuKa6J8Ex2UZrb4YsP7s10g3ut6Sd/ACaFAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yqAQai0AVtWoyKf+XOKjzNiTg8raLXgXEunM3lTJxUk=;
        b=njXpOytE6Arqf/Dm2WjX0I4vDvlKEEPKd+1mk95WKjj99OQLWbe1ElzTychwHWDbw8
         Fl9y+ycClBpuPkJbdYUTkn2y2Lxqzqd6wxQmDqmp3+ueRcJBlETJtiavEnfR/hOwWNe1
         pwOmjn/YYfmegtoAhPuaQQrKOJrCkg4HBoYCSyNsudhjBrb7okldH91WH/1PPZrcgvR5
         oazBThIJL/tgaXfsr214JHGEIJdeSdyYAmyVxhesBK5EddwkxEP+4G6aUPnhG694/dXD
         MXoobxdPm+v/yqjqOzq9JRzpQ9T4dZsb+AagF4OXy/trKuY9TQplZD1ifnSbsHvpDbjU
         zdsg==
X-Gm-Message-State: AOAM533cG7pDS2egjF3j7gLpRtIVJT5mkWlWJz5lz8OcIaCn29ilw2RZ
        JxXuI5PbWZVLCJJRUFTHWo38cg==
X-Google-Smtp-Source: ABdhPJxdt5m7HOjsZyqgaU14acNru/rI3Appso2MBN3PM/6nyfFVhgSaBY1PZ7XjJl0RbDFc7/NRjw==
X-Received: by 2002:a17:902:b7cb:b0:141:b33a:9589 with SMTP id v11-20020a170902b7cb00b00141b33a9589mr33428633plz.9.1635972731305;
        Wed, 03 Nov 2021 13:52:11 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:c80d:e9d8:d115:daf])
        by smtp.gmail.com with UTF8SMTPSA id h11sm3595674pfc.131.2021.11.03.13.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 13:52:10 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>
Cc:     Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sean Paul <sean@poorly.run>, Jonas Karlman <jonas@kwiboo.se>,
        dri-devel@lists.freedesktop.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Zain Wang <wzz@rock-chips.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>
Subject: [PATCH v3] drm/bridge: analogix_dp: Make PSR-exit block less
Date:   Wed,  3 Nov 2021 13:52:00 -0700
Message-Id: <20211103135112.v3.1.I67612ea073c3306c71b46a87be894f79707082df@changeid>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prior to commit 6c836d965bad ("drm/rockchip: Use the helpers for PSR"),
"PSR exit" used non-blocking analogix_dp_send_psr_spd(). The refactor
started using the blocking variant, for a variety of reasons -- quoting
Sean Paul's potentially-faulty memory:

"""
 - To avoid racing a subsequent PSR entry (if exit takes a long time)
 - To avoid racing disable/modeset
 - We're not displaying new content while exiting PSR anyways, so there
   is minimal utility in allowing frames to be submitted
 - We're lying to userspace telling them frames are on the screen when
   we're just dropping them on the floor
"""

However, I'm finding that this blocking transition is causing upwards of
60+ ms of unneeded latency on PSR-exit, to the point that initial cursor
movements when leaving PSR are unbearably jumpy.

It turns out that we need to meet in the middle somewhere: Sean is right
that we were "lying to userspace" with a non-blocking PSR-exit, but the
new blocking behavior is also waiting too long:

According to the eDP specification, the sink device must support PSR
entry transitions from both state 4 (ACTIVE_RESYNC) and state 0
(INACTIVE). It also states that in ACTIVE_RESYNC, "the Sink device must
display the incoming active frames from the Source device with no
visible glitches and/or artifacts."

Thus, for our purposes, we only need to wait for ACTIVE_RESYNC before
moving on; we are ready to display video, and subsequent PSR-entry is
safe.

Tested on a Samsung Chromebook Plus (i.e., Rockchip RK3399 Gru Kevin),
where this saves about 60ms of latency, for PSR-exit that used to
take about 80ms.

Fixes: 6c836d965bad ("drm/rockchip: Use the helpers for PSR")
Cc: <stable@vger.kernel.org>
Cc: Zain Wang <wzz@rock-chips.com>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
---
CC list is partially constructed from the commit message of the Fixed
commit

Changes in v3:
 - Fix the exiting/entering comment (a reviewer noticed off-mailing-list
   that I got it backwards)
 - Add Reviewed-by

Changes in v2:
 - retitled subject (previous: "drm/bridge: analogix_dp: Make
   PSR-disable non-blocking")
 - instead of completely non-blocking, make this "less"-blocking
 - more background (thanks Sean!)
 - more specification details

 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
index cab6c8b92efd..6a4f20fccf84 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
@@ -998,11 +998,21 @@ int analogix_dp_send_psr_spd(struct analogix_dp_device *dp,
 	if (!blocking)
 		return 0;
 
+	/*
+	 * db[1]!=0: entering PSR, wait for fully active remote frame buffer.
+	 * db[1]==0: exiting PSR, wait for either
+	 *  (a) ACTIVE_RESYNC - the sink "must display the
+	 *      incoming active frames from the Source device with no visible
+	 *      glitches and/or artifacts", even though timings may still be
+	 *      re-synchronizing; or
+	 *  (b) INACTIVE - the transition is fully complete.
+	 */
 	ret = readx_poll_timeout(analogix_dp_get_psr_status, dp, psr_status,
 		psr_status >= 0 &&
 		((vsc->db[1] && psr_status == DP_PSR_SINK_ACTIVE_RFB) ||
-		(!vsc->db[1] && psr_status == DP_PSR_SINK_INACTIVE)), 1500,
-		DP_TIMEOUT_PSR_LOOP_MS * 1000);
+		(!vsc->db[1] && (psr_status == DP_PSR_SINK_ACTIVE_RESYNC ||
+				 psr_status == DP_PSR_SINK_INACTIVE))),
+		1500, DP_TIMEOUT_PSR_LOOP_MS * 1000);
 	if (ret) {
 		dev_warn(dp->dev, "Failed to apply PSR %d\n", ret);
 		return ret;
-- 
2.34.0.rc0.344.g81b53c2807-goog

