Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634A5664945
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbjAJSUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239139AbjAJSTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:19:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF2F921D8
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:17:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACCCDB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08718C433D2;
        Tue, 10 Jan 2023 18:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374629;
        bh=aF9XGd847OBV9ASn/3QWJID57AOLr6pHJv2XGS0Veog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbgJsR0PoVQzhxALvxoHS8TqSjPJ5R/aO1g2mJQgBgooBuVPr8ljqjtQdJHx0JbMY
         jgFGB6OH2Xcfiy1pYwx082XU+i91lphm365maujeYQ1X9ELeV6lmhBsLKdgldnUm7G
         9fgqaicNukWfTkaKM1ZDUIYlt5/GoPvED397YJHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Carlo Caione <ccaione@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/159] drm/meson: Reduce the FIFO lines held when AFBC is not used
Date:   Tue, 10 Jan 2023 19:03:48 +0100
Message-Id: <20230110180020.859872586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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



