Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779CC590017
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiHKPgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiHKPfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:35:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DD59C8EF;
        Thu, 11 Aug 2022 08:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B99326163B;
        Thu, 11 Aug 2022 15:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AECC433D6;
        Thu, 11 Aug 2022 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231980;
        bh=Ob3k6zGV4eWNH8S7mZX7RHuUHllbUnxwd+j4it+VYlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4yY7uJxA9bFNn6yZCdnZe7372Z/Todwp1NSCS3INBiFx+D1RLUBH+K/pinfKDXDS
         PcUW/0lCdAk3iwmMPCt9DKQonBd7UsJE+c4EsPRJvPQiPWO4iLXrKYrtJTpOFNK6FR
         TmsT9KwoBTW378X37dE0Pwm485IJ7q+6kLdNHKvFTedosURO9YzX7zPv47wHIz+vHz
         xoaEi22lXf1/9H0dOPsu3m0aOB8Fs/CW0hBWIHaTKsngupa9zBhiWIKSkgVc9HD/q+
         f1o03s8JF1OvkNqsotx/WJZOjR0VR/JZQfYmnvQPJjoUskIAzS5U5y9QjtDLH6MovF
         MvO9iIh+twsPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Vanek <jirivanek1@gmail.com>,
        Vinay Simha BN <simhavcs@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andrzej.hajda@intel.com,
        narmstrong@baylibre.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 038/105] drm/bridge/tc358775: Fix DSI clock division for vsync delay calculation
Date:   Thu, 11 Aug 2022 11:27:22 -0400
Message-Id: <20220811152851.1520029-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Vanek <jirivanek1@gmail.com>

[ Upstream commit 993a87917c2af59efb0ee1ce43c878ca8790ba1c ]

Use the same PCLK divide option (divide DSI clock to generate pixel clock)
which is set to LVDS Configuration Register (LVCFG) also for a VSync delay
calculation. Without this change an auxiliary variable could underflow
during the calculation for some dual-link LVDS panels and then calculated
VSync delay is wrong. This leads to a shifted picture on a panel.

Tested-by: Jiri Vanek <jirivanek1@gmail.com>
Signed-off-by: Jiri Vanek <jirivanek1@gmail.com>
Reviewed-by: Vinay Simha BN <simhavcs@gmail.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220615222221.1501-3-jirivanek1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358775.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358775.c b/drivers/gpu/drm/bridge/tc358775.c
index 62a7ef352daa..dd18be95207b 100644
--- a/drivers/gpu/drm/bridge/tc358775.c
+++ b/drivers/gpu/drm/bridge/tc358775.c
@@ -429,7 +429,7 @@ static void tc_bridge_enable(struct drm_bridge *bridge)
 		val = TC358775_VPCTRL_MSF(1);
 
 	dsiclk = mode->crtc_clock * 3 * tc->bpc / tc->num_dsi_lanes / 1000;
-	clkdiv = dsiclk / DIVIDE_BY_3 * tc->lvds_link;
+	clkdiv = dsiclk / (tc->lvds_link == DUAL_LINK ? DIVIDE_BY_6 : DIVIDE_BY_3);
 	byteclk = dsiclk / 4;
 	t1 = hactive * (tc->bpc * 3 / 8) / tc->num_dsi_lanes;
 	t2 = ((100000 / clkdiv)) * (hactive + hback_porch + hsync_len + hfront_porch) / 1000;
-- 
2.35.1

