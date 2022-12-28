Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CA46578D4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbiL1Oyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiL1Oyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:54:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24073245
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B400161544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6425C433EF;
        Wed, 28 Dec 2022 14:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239274;
        bh=eXsXy9qOBsh/TFjeFq2rx1xWGDx4hQ5gd6AbdSjzzQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+kuueCdE6HcgijR1Ufxt+h9wA7/jw43VcELkd00s9jE9IXQNbyaUgwuwpV9HnAWe
         psM8CBOS578VY65CiSAMpIKD6jYdrOtHNZnk2un+dKZabQvop/Il43osu2HMu0OhDG
         i9BVAaW9lKamwL3TXgrS7xx2gzY8CtZzI9NpFJ7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xinlei Lee <xinlei.lee@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/731] drm/mediatek: Modify dpi power on/off sequence.
Date:   Wed, 28 Dec 2022 15:35:01 +0100
Message-Id: <20221228144302.180307715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Xinlei Lee <xinlei.lee@mediatek.com>

[ Upstream commit ff446c0f6290185cefafe3b376bb86063a3a9f6a ]

Modify dpi power on/off sequence so that the first gpio operation will
take effect.

Fixes: 6bd4763fd532 ("drm/mediatek: set dpi pin mode to gpio low to avoid leakage current")
Signed-off-by: Xinlei Lee <xinlei.lee@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index 41c783349321..94c6bd3b0082 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -387,9 +387,6 @@ static void mtk_dpi_power_off(struct mtk_dpi *dpi)
 	if (--dpi->refcount != 0)
 		return;
 
-	if (dpi->pinctrl && dpi->pins_gpio)
-		pinctrl_select_state(dpi->pinctrl, dpi->pins_gpio);
-
 	mtk_dpi_disable(dpi);
 	clk_disable_unprepare(dpi->pixel_clk);
 	clk_disable_unprepare(dpi->engine_clk);
@@ -414,9 +411,6 @@ static int mtk_dpi_power_on(struct mtk_dpi *dpi)
 		goto err_pixel;
 	}
 
-	if (dpi->pinctrl && dpi->pins_dpi)
-		pinctrl_select_state(dpi->pinctrl, dpi->pins_dpi);
-
 	return 0;
 
 err_pixel:
@@ -630,12 +624,18 @@ static void mtk_dpi_bridge_disable(struct drm_bridge *bridge)
 	struct mtk_dpi *dpi = bridge_to_dpi(bridge);
 
 	mtk_dpi_power_off(dpi);
+
+	if (dpi->pinctrl && dpi->pins_gpio)
+		pinctrl_select_state(dpi->pinctrl, dpi->pins_gpio);
 }
 
 static void mtk_dpi_bridge_enable(struct drm_bridge *bridge)
 {
 	struct mtk_dpi *dpi = bridge_to_dpi(bridge);
 
+	if (dpi->pinctrl && dpi->pins_dpi)
+		pinctrl_select_state(dpi->pinctrl, dpi->pins_dpi);
+
 	mtk_dpi_power_on(dpi);
 	mtk_dpi_set_display_mode(dpi, &dpi->mode);
 	mtk_dpi_enable(dpi);
-- 
2.35.1



