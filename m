Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F29657C05
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiL1P2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiL1P16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:27:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D89140C1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:27:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09F82B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD98C433D2;
        Wed, 28 Dec 2022 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241274;
        bh=hRsLGpEwKoT96N31pQ5jkxbGhInLr9PJ9L+6/tiqJQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCy5ub77FTcYzYOX8nC3vbIK3qU6izEtmDUwEuYmHCG+DU2tGJ8xS+hHAsxrmZcfg
         S3ao6Jjn81tYXSaNCORpEXr4R9TAzYpDhXUdM2lcpVZpTswC8OrTO94Hand9mmPWcE
         CfgMIZWcCGDDioyCGD0IfHidElpKLajEa6JPitqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pin-yen Lin <treapking@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0227/1146] drm/bridge: it6505: Initialize AUX channel in it6505_i2c_probe
Date:   Wed, 28 Dec 2022 15:29:26 +0100
Message-Id: <20221228144336.308197639@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit e577d4b13064c337b83fe7edecb3f34e87144821 ]

During device boot, the HPD interrupt could be triggered before the DRM
subsystem registers it6505 as a DRM bridge. In such cases, the driver
tries to access AUX channel and causes NULL pointer dereference.
Initializing the AUX channel earlier to prevent such error.

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221013110411.1674359-2-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index dfe4351c9bdd..99123eec4551 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2860,10 +2860,7 @@ static int it6505_bridge_attach(struct drm_bridge *bridge,
 	}
 
 	/* Register aux channel */
-	it6505->aux.name = "DP-AUX";
-	it6505->aux.dev = dev;
 	it6505->aux.drm_dev = bridge->dev;
-	it6505->aux.transfer = it6505_aux_transfer;
 
 	ret = drm_dp_aux_register(&it6505->aux);
 
@@ -3316,6 +3313,11 @@ static int it6505_i2c_probe(struct i2c_client *client,
 	DRM_DEV_DEBUG_DRIVER(dev, "it6505 device name: %s", dev_name(dev));
 	debugfs_init(it6505);
 
+	it6505->aux.name = "DP-AUX";
+	it6505->aux.dev = dev;
+	it6505->aux.transfer = it6505_aux_transfer;
+	drm_dp_aux_init(&it6505->aux);
+
 	it6505->bridge.funcs = &it6505_bridge_funcs;
 	it6505->bridge.type = DRM_MODE_CONNECTOR_DisplayPort;
 	it6505->bridge.ops = DRM_BRIDGE_OP_DETECT | DRM_BRIDGE_OP_EDID |
-- 
2.35.1



