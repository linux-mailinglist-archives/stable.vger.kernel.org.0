Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4730A605455
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 02:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJTAEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 20:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiJTAEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 20:04:33 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962D75F4A
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 17:04:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p14so18752697pfq.5
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 17:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sTMXfwPxByKhRbLMaBxfNCc3mPRoF7RiiHgqUtdhFi8=;
        b=NzPUtom58NR34m2Vw7sS73ERU30rhe3RyOvvFRL8c790qf5KuZz3KvN69al/nH052u
         65SRaYt/WHp0PKjIXDaLYCni7KlNbgouTs8KNf5Fy7byqei7PQ3KRgBHVXjhzqsdhzY0
         or9yFqOg4L7gMu66IIQ9eWmxSPJ7xk7vRk2RQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sTMXfwPxByKhRbLMaBxfNCc3mPRoF7RiiHgqUtdhFi8=;
        b=hzlmuNxQfJS13wk6FFyP6tUlhgn2RDl0KgcZKLv6bXhx9GfHimLfy8mR9KbOJTPIFm
         a2D6RfyCOpFBHeqquIsxdgd7fbdbtLSBGvyVCvlmy3fjh4rBAKo+8QcB7FazlmLdpCFk
         uBqd/tlV+ujahpJnbwfH8mzOQ/uMuhacTUm9cWd8NYCUwusCeI57AwrT6XIOddxkuaZV
         3amqdU19ZcRMLclwgSmwAD4HMVEMvQfihRh88uIszN3fPja4DMQ9Wo0eaBXOtXrmgBit
         sllN7sV5Qt1PKUzBSLX01jZXqqci8uZpPpsDV05bVlZ45UB1mJZlrYr3X/AzlMxIVP4a
         GtDA==
X-Gm-Message-State: ACrzQf2Wm/zYkz/Uy4ZhOSMUMNEw0r/d6CF8791k4f8o7BUyk9+SfJNl
        NzxYtXMYOqqF9sH1T2KiRYiEJw==
X-Google-Smtp-Source: AMsMyM664xBzQRRznQW+wpuvkN2DiM8TEUvDJZUSO7BbmhIQUEq/kvX65aGrSxbs3usLThugxlDXJA==
X-Received: by 2002:a63:4283:0:b0:457:dced:8ba3 with SMTP id p125-20020a634283000000b00457dced8ba3mr9328251pga.220.1666224261493;
        Wed, 19 Oct 2022 17:04:21 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:57b7:1f0e:44d1:f252])
        by smtp.gmail.com with UTF8SMTPSA id lb13-20020a17090b4a4d00b0020a825fc912sm459119pjb.45.2022.10.19.17.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 17:04:21 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>
Cc:     dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>,
        Helen Koike <helen.koike@collabora.com>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/rockchip: dsi: Clean up 'usage_mode' when failing to attach
Date:   Wed, 19 Oct 2022 17:03:48 -0700
Message-Id: <20221019170255.1.Ia68dfb27b835d31d22bfe23812baf366ee1c6eac@changeid>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we fail to attach the first time (especially: EPROBE_DEFER), we fail
to clean up 'usage_mode', and thus will fail to attach on any subsequent
attempts, with "dsi controller already in use".

Re-set to DW_DSI_USAGE_IDLE on attach failure.

This is especially common to hit when enabling asynchronous probe on a
duel-DSI system (such as RK3399 Gru/Scarlet), such that we're more
likely to fail dw_mipi_dsi_rockchip_find_second() the first time.

Fixes: 71f68fe7f121 ("drm/rockchip: dsi: add ability to work as a phy instead of full dsi")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---

 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
index bf6948125b84..d222c6811207 100644
--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -1051,23 +1051,31 @@ static int dw_mipi_dsi_rockchip_host_attach(void *priv_data,
 	if (ret) {
 		DRM_DEV_ERROR(dsi->dev, "Failed to register component: %d\n",
 					ret);
-		return ret;
+		goto out;
 	}
 
 	second = dw_mipi_dsi_rockchip_find_second(dsi);
-	if (IS_ERR(second))
-		return PTR_ERR(second);
+	if (IS_ERR(second)) {
+		ret = PTR_ERR(second);
+		goto out;
+	}
 	if (second) {
 		ret = component_add(second, &dw_mipi_dsi_rockchip_ops);
 		if (ret) {
 			DRM_DEV_ERROR(second,
 				      "Failed to register component: %d\n",
 				      ret);
-			return ret;
+			goto out;
 		}
 	}
 
 	return 0;
+
+out:
+	mutex_lock(&dsi->usage_mutex);
+	dsi->usage_mode = DW_DSI_USAGE_IDLE;
+	mutex_unlock(&dsi->usage_mutex);
+	return ret;
 }
 
 static int dw_mipi_dsi_rockchip_host_detach(void *priv_data,
-- 
2.38.0.413.g74048e4d9e-goog

