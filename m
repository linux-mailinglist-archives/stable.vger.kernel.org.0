Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839EB6677F7
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbjALOvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239902AbjALOuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:50:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818ED12ACF
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:37:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ADECB81E70
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702D5C433F2;
        Thu, 12 Jan 2023 14:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534243;
        bh=aF9XGd847OBV9ASn/3QWJID57AOLr6pHJv2XGS0Veog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSK1U6JBnOk1VIXcJPfdfw8dUVc1ak3YbnH22TTKX/RraC40JQvYRdtbnheDnNLCZ
         4M1yoosbEOzRdMk3krHXgKNlbk15mm306aJ3oitD+/6tPEt3oRLGoTUI5ODCgoGZOq
         xrQa9sCFg5ZA0Xm39IRR6yaNAcufM1VfqDebWW3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Carlo Caione <ccaione@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 744/783] drm/meson: Reduce the FIFO lines held when AFBC is not used
Date:   Thu, 12 Jan 2023 14:57:40 +0100
Message-Id: <20230112135558.854318662@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Carlo Caione <ccaione@baylibre.com>

[ Upstream commit 3b754ed6d1cd90017e66e5cc16f3923e4a952ffc ]

Having a bigger number of FIFO lines held after vsync is only useful to
SoCs using AFBC to give time to the AFBC decoder to be reset, configured
and enabled again.

For SoCs not using AFBC this, on the contrary, is causing on some
displays issues and a few pixels vertical offset in the displayed image.

Conditionally increase the number of lines held after vsync only for
SoCs using AFBC, leaving the default value for all the others.

Fixes: 24e0d4058eff ("drm/meson: hold 32 lines after vsync to give time for AFBC start")
Signed-off-by: Carlo Caione <ccaione@baylibre.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
[narmstrong: added fixes tag]
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221216-afbc_s905x-v1-0-033bebf780d9@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_viu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_viu.c b/drivers/gpu/drm/meson/meson_viu.c
index d4b907889a21..cd399b0b7181 100644
--- a/drivers/gpu/drm/meson/meson_viu.c
+++ b/drivers/gpu/drm/meson/meson_viu.c
@@ -436,15 +436,14 @@ void meson_viu_init(struct meson_drm *priv)
 
 	/* Initialize OSD1 fifo control register */
 	reg = VIU_OSD_DDR_PRIORITY_URGENT |
-		VIU_OSD_HOLD_FIFO_LINES(31) |
 		VIU_OSD_FIFO_DEPTH_VAL(32) | /* fifo_depth_val: 32*8=256 */
 		VIU_OSD_WORDS_PER_BURST(4) | /* 4 words in 1 burst */
 		VIU_OSD_FIFO_LIMITS(2);      /* fifo_lim: 2*16=32 */
 
 	if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
-		reg |= VIU_OSD_BURST_LENGTH_32;
+		reg |= (VIU_OSD_BURST_LENGTH_32 | VIU_OSD_HOLD_FIFO_LINES(31));
 	else
-		reg |= VIU_OSD_BURST_LENGTH_64;
+		reg |= (VIU_OSD_BURST_LENGTH_64 | VIU_OSD_HOLD_FIFO_LINES(4));
 
 	writel_relaxed(reg, priv->io_base + _REG(VIU_OSD1_FIFO_CTRL_STAT));
 	writel_relaxed(reg, priv->io_base + _REG(VIU_OSD2_FIFO_CTRL_STAT));
-- 
2.35.1



