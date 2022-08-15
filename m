Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA6F5948B6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354233AbiHOXoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354428AbiHOXmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:42:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8BC32EC0;
        Mon, 15 Aug 2022 13:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A5E4B80EA8;
        Mon, 15 Aug 2022 20:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF14FC433D6;
        Mon, 15 Aug 2022 20:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594406;
        bh=ZCTlZ6oiSDxVQ1XvejSCzZ84C+U5CBdJqQG1WcctKyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvOFvV7ORMeu7XMQpriZhya4GjiKuHWRiQC/ij3Yu2H7vvpnW3gbOCwLthkgohmXQ
         DRL1sP03V+qs1E4hXXLdGHtynf/P6svT9v72FTy6Vvi5H+SU1CriBUUl7tJXl+BZjK
         Xv/SwKjbUfgg7POrO7t0ec8ORefXyVPoZd1NI6Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Ranquet <granquet@baylibre.com>,
        Bo-Chen Chen <rex-bc.chen@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0435/1157] drm/mediatek: dpi: Only enable dpi after the bridge is enabled
Date:   Mon, 15 Aug 2022 19:56:31 +0200
Message-Id: <20220815180457.049435147@linuxfoundation.org>
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
index 675e2e4072df..41c783349321 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -417,7 +417,6 @@ static int mtk_dpi_power_on(struct mtk_dpi *dpi)
 	if (dpi->pinctrl && dpi->pins_dpi)
 		pinctrl_select_state(dpi->pinctrl, dpi->pins_dpi);
 
-	mtk_dpi_enable(dpi);
 	return 0;
 
 err_pixel:
@@ -639,6 +638,7 @@ static void mtk_dpi_bridge_enable(struct drm_bridge *bridge)
 
 	mtk_dpi_power_on(dpi);
 	mtk_dpi_set_display_mode(dpi, &dpi->mode);
+	mtk_dpi_enable(dpi);
 }
 
 static enum drm_mode_status
-- 
2.35.1



