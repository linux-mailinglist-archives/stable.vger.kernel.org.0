Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F6A59DB40
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242831AbiHWLSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357459AbiHWLRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:17:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D400789805;
        Tue, 23 Aug 2022 02:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EF1FB81C63;
        Tue, 23 Aug 2022 09:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2278C433D7;
        Tue, 23 Aug 2022 09:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246455;
        bh=rtyC8TSFqyWOCi2oMAoUTVzznfmn4eslyFZqWLXOZ9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Tx0PTdHjmRjBLwtkPeOGvNw5HzGSqy/J4aR+MmwZxyRLudQpH9q1gJOPQuxvQes+
         4a5zI6Qn2IE4p5/lcb2TgYhSwiAQIPTwJKDO1mKBGTIuP6tH5NWYzL+ArVEaBc0Mj6
         LhdTYx4hsV2OVAkAzYvTAPm2snQWAoKsyb+Zf8U8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Ranquet <granquet@baylibre.com>,
        Bo-Chen Chen <rex-bc.chen@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/389] drm/mediatek: dpi: Only enable dpi after the bridge is enabled
Date:   Tue, 23 Aug 2022 10:23:13 +0200
Message-Id: <20220823080120.426632009@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Guillaume Ranquet <granquet@baylibre.com>

[ Upstream commit aed61ef6beb911cc043af0f2f291167663995065 ]

Enabling the dpi too early causes glitches on screen.

Move the call to mtk_dpi_enable() at the end of the bridge_enable
callback to ensure everything is setup properly before enabling dpi.

Fixes: 9e629c17aa8d ("drm/mediatek: Add DPI sub driver")
Signed-off-by: Guillaume Ranquet <granquet@baylibre.com>
Signed-off-by: Bo-Chen Chen <rex-bc.chen@mediatek.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20220701035845.16458-16-rex-bc.chen@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index 8f4a9f245a9a..4a64d8aed9da 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -394,7 +394,6 @@ static int mtk_dpi_power_on(struct mtk_dpi *dpi)
 	if (dpi->pinctrl && dpi->pins_dpi)
 		pinctrl_select_state(dpi->pinctrl, dpi->pins_dpi);
 
-	mtk_dpi_enable(dpi);
 	return 0;
 
 err_pixel:
@@ -538,6 +537,7 @@ static void mtk_dpi_encoder_enable(struct drm_encoder *encoder)
 
 	mtk_dpi_power_on(dpi);
 	mtk_dpi_set_display_mode(dpi, &dpi->mode);
+	mtk_dpi_enable(dpi);
 }
 
 static int mtk_dpi_atomic_check(struct drm_encoder *encoder,
-- 
2.35.1



