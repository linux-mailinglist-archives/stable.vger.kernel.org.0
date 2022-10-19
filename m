Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9A9603DA0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiJSJFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiJSJEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F190B03E6;
        Wed, 19 Oct 2022 01:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEFE0617E4;
        Wed, 19 Oct 2022 08:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3E7C433D6;
        Wed, 19 Oct 2022 08:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169795;
        bh=CKtuwDOYPsb0DMnuLbGcnbkAajbl8yEKG+j15wLGQfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcKERcxLYLXpMghenyV6GXX2eaLVYJ91YPcOHTItha1JgdyjFwSUA3upkUWENBvc8
         cHsYg/7QYN+SSzpTg2pKgAB3fAekuJRyIrJsat1LdGi53ggWG/b7XLHMDAxnq193l6
         QD0g43NXPCVAGcdIKZeTym3FwMc9ln+xId5E+X78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pin-yen Lin <treapking@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 379/862] drm/bridge: it6505: Fix the order of DP_SET_POWER commands
Date:   Wed, 19 Oct 2022 10:27:46 +0200
Message-Id: <20221019083306.719583623@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 7c1dceaffd99247bf443606730515b54d6285969 ]

Send DP_SET_POWER_D3 command to the downstream before stopping DP, so the
suspend process will not be interrupted by the HPD interrupt. Also modify
the order in .atomic_enable callback to make the callbacks symmetric.

Fixes: 46ca7da7f1e8 ("drm/bridge: it6505: Send DPCD SET_POWER to downstream")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220830045756.1655954-1-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index e5626035f311..a09d1a39ab0a 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2945,9 +2945,6 @@ static void it6505_bridge_atomic_enable(struct drm_bridge *bridge,
 	if (ret)
 		dev_err(dev, "Failed to setup AVI infoframe: %d", ret);
 
-	it6505_drm_dp_link_set_power(&it6505->aux, &it6505->link,
-				     DP_SET_POWER_D0);
-
 	it6505_update_video_parameter(it6505, mode);
 
 	ret = it6505_send_video_infoframe(it6505, &frame);
@@ -2957,6 +2954,9 @@ static void it6505_bridge_atomic_enable(struct drm_bridge *bridge,
 
 	it6505_int_mask_enable(it6505);
 	it6505_video_reset(it6505);
+
+	it6505_drm_dp_link_set_power(&it6505->aux, &it6505->link,
+				     DP_SET_POWER_D0);
 }
 
 static void it6505_bridge_atomic_disable(struct drm_bridge *bridge,
@@ -2968,9 +2968,9 @@ static void it6505_bridge_atomic_disable(struct drm_bridge *bridge,
 	DRM_DEV_DEBUG_DRIVER(dev, "start");
 
 	if (it6505->powered) {
-		it6505_video_disable(it6505);
 		it6505_drm_dp_link_set_power(&it6505->aux, &it6505->link,
 					     DP_SET_POWER_D3);
+		it6505_video_disable(it6505);
 	}
 }
 
-- 
2.35.1



