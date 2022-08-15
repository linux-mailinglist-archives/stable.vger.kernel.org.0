Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A04B5947C7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354712AbiHOXzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354695AbiHOXtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:49:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514A68FD70;
        Mon, 15 Aug 2022 13:15:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CF9E60F0E;
        Mon, 15 Aug 2022 20:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1B6C433D6;
        Mon, 15 Aug 2022 20:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594545;
        bh=2uyKtmGglGH0iXko6R1xrbjLGUfoGmJ7bj7j9NKT1Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AguIDfoD77bQYkLrUCG6fywHAdkWA54+pxnwBQX8iT3134dx7DPk2OEcElT6vopbd
         wcYwujjs1TEGDutawyOCKMupwcWaxdDvJ5EFftYDodZAGoa+uApiPmw58SVmxvF/5j
         iN8IV3sb+a3meEsD5VO90pyYz4V6b1kbqAeNoDMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Xin Ji <xji@analogixsemi.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0447/1157] drm/bridge: anx7625: Fix NULL pointer crash when using edp-panel
Date:   Mon, 15 Aug 2022 19:56:43 +0200
Message-Id: <20220815180457.473914286@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit dfb02eb6bdf84697dbadd69a7df12db612ce4ed0 ]

Move devm_of_dp_aux_populate_ep_devices() after pm runtime and i2c setup
to avoid NULL pointer crash.

edp-panel probe (generic_edp_panel_probe) calls pm_runtime_get_sync() to
read EDID. At this time, bridge should have pm runtime enabled and i2c
clients ready.

Fixes: adca62ec370c ("drm/bridge: anx7625: Support reading edid through aux channel")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Xin Ji <xji@analogixsemi.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220706125254.2474095-4-hsinyi@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 0117fd8c62ae..183bd065c494 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2656,14 +2656,6 @@ static int anx7625_i2c_probe(struct i2c_client *client,
 	platform->aux.dev = dev;
 	platform->aux.transfer = anx7625_aux_transfer;
 	drm_dp_aux_init(&platform->aux);
-	devm_of_dp_aux_populate_ep_devices(&platform->aux);
-
-	ret = anx7625_parse_dt(dev, pdata);
-	if (ret) {
-		if (ret != -EPROBE_DEFER)
-			DRM_DEV_ERROR(dev, "fail to parse DT : %d\n", ret);
-		goto free_wq;
-	}
 
 	if (anx7625_register_i2c_dummy_clients(platform, client) != 0) {
 		ret = -ENOMEM;
@@ -2679,6 +2671,15 @@ static int anx7625_i2c_probe(struct i2c_client *client,
 	if (ret)
 		goto free_wq;
 
+	devm_of_dp_aux_populate_ep_devices(&platform->aux);
+
+	ret = anx7625_parse_dt(dev, pdata);
+	if (ret) {
+		if (ret != -EPROBE_DEFER)
+			DRM_DEV_ERROR(dev, "fail to parse DT : %d\n", ret);
+		goto free_wq;
+	}
+
 	if (!platform->pdata.low_power_mode) {
 		anx7625_disable_pd_protocol(platform);
 		pm_runtime_get_sync(dev);
-- 
2.35.1



