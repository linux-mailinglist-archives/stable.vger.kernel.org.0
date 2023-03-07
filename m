Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C2E6AEED5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbjCGSRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbjCGSQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:16:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ECEA6491
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:11:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FF616152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4474FC433D2;
        Tue,  7 Mar 2023 18:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212689;
        bh=fY1d5z9ST2cxWNPFnSWBGoAABv5eJ6UDXALDYPkD3Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/azf7Mt3h/ezmlILrtTyWNRFSCe2uFzsZUzITIlC3WNDfPeS2rUBC8IKnf8r74mU
         Qs0BfCCSX11W/v5kdE9MLk02yFtrMIAGtMPYIN3QWpdOY1SwyX8WAMgqNSFthaorAw
         xmD64ZtPisPfDbdPFUCum9JpkO881yXBvk2Fi/Zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/885] drm/bridge: ti-sn65dsi83: Fix delay after reset deassert to match spec
Date:   Tue,  7 Mar 2023 17:53:19 +0100
Message-Id: <20230307170013.531680369@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 4b03d5e0d3e86ee492d54254927d020dc0fe8acf ]

The datasheet specifies a delay of 10 milliseconds, but the current
driver only waits for 1 ms. Fix this to make sure the initialization
sequence meets the spec.

Fixes: ceb515ba29ba ("drm/bridge: ti-sn65dsi83: Add TI SN65DSI83 and SN65DSI84 driver")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221122081219.20143-1-frieder@fris.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index 7ba9467fff129..047c14ddbbf11 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -346,7 +346,7 @@ static void sn65dsi83_atomic_enable(struct drm_bridge *bridge,
 
 	/* Deassert reset */
 	gpiod_set_value_cansleep(ctx->enable_gpio, 1);
-	usleep_range(1000, 1100);
+	usleep_range(10000, 11000);
 
 	/* Get the LVDS format from the bridge state. */
 	bridge_state = drm_atomic_get_new_bridge_state(state, bridge);
-- 
2.39.2



