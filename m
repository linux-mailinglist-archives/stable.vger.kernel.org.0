Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BC54C9B07
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 03:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbiCBCMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 21:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbiCBCMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 21:12:33 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3531A6507
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 18:11:50 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso3509927pjk.1
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 18:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F209WZI5vXfOkAuKwi/GeBW/6ePfEyIdvCWtsBXsuzo=;
        b=iu79tfZfv3syKE43Jc12ubc5bbfcm39Ba+iZqiH3YF6xx2VPj3Kue+5S3kBvepBO5q
         kdqhPnMePsk0a9w8OIsw9SA9VZIf2pxacttjWVOEkepKtTZDlhYIL9v+fhG0XVWGlEwh
         Se8dU2iquV0Zmid8y13HZf9VaAMALn+8EStJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F209WZI5vXfOkAuKwi/GeBW/6ePfEyIdvCWtsBXsuzo=;
        b=RIeMVARO4DI40RMqbqfiyClVbqMBwRcQ6Sv/yYt4GiTDuXNH87ad5LYL4HbSQutHBb
         6d/oEdtlS6cUXB9WX66tOHn5k9ECnhsK/9+OcQWw45cGe2ojMn3yCgrThBlf/vl42r+i
         LEtfU2ICX2sfzaLuF4/NsiWGg8GgZXtQVu4cg0h0/aRJ8P2Z/d+IDXnpaLBAsCTHZBBl
         IMDvALJHym7KviKuOrBcby0el4v7QHqAalgceoJ5HE00bh32/zEroRyz55sqQAWAGh4y
         pnK4g0hErwR/nqvmdCtS+em3oqUMPSjAznpCCM6uLsnpikcIOCo9vS1vmEFrL4wL5Jxj
         qRqA==
X-Gm-Message-State: AOAM533K1U9AHfWRetXctvC8vLUFTQd1jhLAmzGko1PB6Yn8rOEzaQIe
        ZAlXmT7wYgiu9ICLXADSFHvLrA==
X-Google-Smtp-Source: ABdhPJwkV2kz8kBnK1WvzDVCNJRbzW5x17kwBoiaU5GguV6QDiHBp0jHTeZkBJ3WlYzD/yEyKxFkhQ==
X-Received: by 2002:a17:90a:4609:b0:1bc:f41e:5390 with SMTP id w9-20020a17090a460900b001bcf41e5390mr23827824pjg.27.1646187110276;
        Tue, 01 Mar 2022 18:11:50 -0800 (PST)
Received: from localhost ([2620:15c:202:201:ddf3:7c12:38c:3c61])
        by smtp.gmail.com with UTF8SMTPSA id f15-20020a056a0022cf00b004f3b99a6c43sm18651207pfj.219.2022.03.01.18.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 18:11:49 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Cc:     Jonas Karlman <jonas@kwiboo.se>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v4 1/2] drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX
Date:   Tue,  1 Mar 2022 18:11:38 -0800
Message-Id: <20220301181107.v4.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the display is not enable()d, then we aren't holding a runtime PM
reference here. Thus, it's easy to accidentally cause a hang, if user
space is poking around at /dev/drm_dp_aux0 at the "wrong" time.

Let's get a runtime PM reference, and check that we "see" the panel.
Don't force any panel power-up, etc., because that can be intrusive, and
that's not what other drivers do (see
drivers/gpu/drm/bridge/ti-sn65dsi86.c and
drivers/gpu/drm/bridge/parade-ps8640.c.)

Fixes: 0d97ad03f422 ("drm/bridge: analogix_dp: Remove duplicated code")
Cc: <stable@vger.kernel.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
---

Changes in v4:
- Add Doug's Reviewed-by

Changes in v3:
- Avoid panel power-up; just check for HPD state, and let the rest
  happen "as-is" (e.g., time out, if the caller hasn't prepared things
  properly)

Changes in v2:
- Fix spelling in Subject
- DRM_DEV_ERROR() -> drm_err()
- Propagate errors from un-analogix_dp_prepare_panel()

 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index b7d2e4449cfa..16be279aed2c 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1632,8 +1632,19 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
 				       struct drm_dp_aux_msg *msg)
 {
 	struct analogix_dp_device *dp = to_dp(aux);
+	int ret;
+
+	pm_runtime_get_sync(dp->dev);
+
+	ret = analogix_dp_detect_hpd(dp);
+	if (ret)
+		goto out;
 
-	return analogix_dp_transfer(dp, msg);
+	ret = analogix_dp_transfer(dp, msg);
+out:
+	pm_runtime_put(dp->dev);
+
+	return ret;
 }
 
 struct analogix_dp_device *
-- 
2.35.1.574.g5d30c73bfb-goog

