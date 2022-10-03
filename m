Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071E15F297A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiJCHUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJCHSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:18:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FA810548;
        Mon,  3 Oct 2022 00:14:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63579B80E6E;
        Mon,  3 Oct 2022 07:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FDFC433D6;
        Mon,  3 Oct 2022 07:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781278;
        bh=bk2Tc2mP+BAlCfMSQovB6aEbXeo1uiMDHMwvfhvanAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgu/tV0Rg54zubojGsou+inayjuc2bRxBTRBjGgcqSQWrHh6i4XBYkMRwYYk1QZiU
         shpp9qUCe+Gszv6g4xa1iR8GsqPzjH43uBYsLC7AMiEf3uYzN8FNOtSi3svBb8w4tc
         W2Rxvp2Mz/SyA87v7K4uITCDd3Tun7UNBGKuMBsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 063/101] drm/bridge: lt8912b: add vsync hsync
Date:   Mon,  3 Oct 2022 09:10:59 +0200
Message-Id: <20221003070726.035240170@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Philippe Schenker <philippe.schenker@toradex.com>

[ Upstream commit da73a94fa282f78d485bd0aab36c8ac15b6f792c ]

Currently the bridge driver does not take care whether or not the display
needs positive/negative vertical/horizontal syncs. Pass these two flags
to the bridge from the EDID that was read out from the display.

Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
Acked-by: Adrien Grassein <adrien.grassein@gmail.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220922124306.34729-2-dev@pschenker.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index c642d1e02b2f..e011a2763621 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -266,7 +266,7 @@ static int lt8912_video_setup(struct lt8912 *lt)
 	u32 hactive, h_total, hpw, hfp, hbp;
 	u32 vactive, v_total, vpw, vfp, vbp;
 	u8 settle = 0x08;
-	int ret;
+	int ret, hsync_activehigh, vsync_activehigh;
 
 	if (!lt)
 		return -EINVAL;
@@ -276,12 +276,14 @@ static int lt8912_video_setup(struct lt8912 *lt)
 	hpw = lt->mode.hsync_len;
 	hbp = lt->mode.hback_porch;
 	h_total = hactive + hfp + hpw + hbp;
+	hsync_activehigh = lt->mode.flags & DISPLAY_FLAGS_HSYNC_HIGH;
 
 	vactive = lt->mode.vactive;
 	vfp = lt->mode.vfront_porch;
 	vpw = lt->mode.vsync_len;
 	vbp = lt->mode.vback_porch;
 	v_total = vactive + vfp + vpw + vbp;
+	vsync_activehigh = lt->mode.flags & DISPLAY_FLAGS_VSYNC_HIGH;
 
 	if (vactive <= 600)
 		settle = 0x04;
@@ -315,6 +317,11 @@ static int lt8912_video_setup(struct lt8912 *lt)
 	ret |= regmap_write(lt->regmap[I2C_CEC_DSI], 0x3e, hfp & 0xff);
 	ret |= regmap_write(lt->regmap[I2C_CEC_DSI], 0x3f, hfp >> 8);
 
+	ret |= regmap_update_bits(lt->regmap[I2C_MAIN], 0xab, BIT(0),
+				  vsync_activehigh ? BIT(0) : 0);
+	ret |= regmap_update_bits(lt->regmap[I2C_MAIN], 0xab, BIT(1),
+				  hsync_activehigh ? BIT(1) : 0);
+
 	return ret;
 }
 
-- 
2.35.1



