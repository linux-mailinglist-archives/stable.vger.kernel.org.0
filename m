Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDB0594764
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354225AbiHOXn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354416AbiHOXmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:42:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32BA32D81;
        Mon, 15 Aug 2022 13:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74B27B81154;
        Mon, 15 Aug 2022 20:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63F6C433C1;
        Mon, 15 Aug 2022 20:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594403;
        bh=NDaqN0HN4Lw9xKA+GYcUn8lKUCBj57SDn6sS5RzJY98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixlHPoFMHxpuRkyfz0g/spNvYQQ6pLdZUoxpHweVbEpXg4rhXdhsg2GGPLcV9+J+X
         rbBM4HAaOMC2RfxppnHmuPqrsgPRnDXge1BYBKdIoAgbGl3UqdQex9uJPslzBibOzu
         y6j5SDG61DdIJLOFCcEZk6UZNzW9tS1JmubowKqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bo-Chen Chen <rex-bc.chen@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0434/1157] drm/mediatek: dpi: Remove output format of YUV
Date:   Mon, 15 Aug 2022 19:56:30 +0200
Message-Id: <20220815180457.012405557@linuxfoundation.org>
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

From: Bo-Chen Chen <rex-bc.chen@mediatek.com>

[ Upstream commit c9ed0713b3c35fc45677707ba47f432cad95da56 ]

DPI is not support output format as YUV, but there is the setting of
configuring output YUV. Therefore, remove them in this patch.

Fixes: 9e629c17aa8d ("drm/mediatek: Add DPI sub driver")
Signed-off-by: Bo-Chen Chen <rex-bc.chen@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20220701035845.16458-5-rex-bc.chen@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 31 ++++++------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index e61cd67b978f..675e2e4072df 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -54,13 +54,7 @@ enum mtk_dpi_out_channel_swap {
 };
 
 enum mtk_dpi_out_color_format {
-	MTK_DPI_COLOR_FORMAT_RGB,
-	MTK_DPI_COLOR_FORMAT_RGB_FULL,
-	MTK_DPI_COLOR_FORMAT_YCBCR_444,
-	MTK_DPI_COLOR_FORMAT_YCBCR_422,
-	MTK_DPI_COLOR_FORMAT_XV_YCC,
-	MTK_DPI_COLOR_FORMAT_YCBCR_444_FULL,
-	MTK_DPI_COLOR_FORMAT_YCBCR_422_FULL
+	MTK_DPI_COLOR_FORMAT_RGB
 };
 
 struct mtk_dpi {
@@ -364,24 +358,11 @@ static void mtk_dpi_config_disable_edge(struct mtk_dpi *dpi)
 static void mtk_dpi_config_color_format(struct mtk_dpi *dpi,
 					enum mtk_dpi_out_color_format format)
 {
-	if ((format == MTK_DPI_COLOR_FORMAT_YCBCR_444) ||
-	    (format == MTK_DPI_COLOR_FORMAT_YCBCR_444_FULL)) {
-		mtk_dpi_config_yuv422_enable(dpi, false);
-		mtk_dpi_config_csc_enable(dpi, true);
-		mtk_dpi_config_swap_input(dpi, false);
-		mtk_dpi_config_channel_swap(dpi, MTK_DPI_OUT_CHANNEL_SWAP_BGR);
-	} else if ((format == MTK_DPI_COLOR_FORMAT_YCBCR_422) ||
-		   (format == MTK_DPI_COLOR_FORMAT_YCBCR_422_FULL)) {
-		mtk_dpi_config_yuv422_enable(dpi, true);
-		mtk_dpi_config_csc_enable(dpi, true);
-		mtk_dpi_config_swap_input(dpi, true);
-		mtk_dpi_config_channel_swap(dpi, MTK_DPI_OUT_CHANNEL_SWAP_RGB);
-	} else {
-		mtk_dpi_config_yuv422_enable(dpi, false);
-		mtk_dpi_config_csc_enable(dpi, false);
-		mtk_dpi_config_swap_input(dpi, false);
-		mtk_dpi_config_channel_swap(dpi, MTK_DPI_OUT_CHANNEL_SWAP_RGB);
-	}
+	/* only support RGB888 */
+	mtk_dpi_config_yuv422_enable(dpi, false);
+	mtk_dpi_config_csc_enable(dpi, false);
+	mtk_dpi_config_swap_input(dpi, false);
+	mtk_dpi_config_channel_swap(dpi, MTK_DPI_OUT_CHANNEL_SWAP_RGB);
 }
 
 static void mtk_dpi_dual_edge(struct mtk_dpi *dpi)
-- 
2.35.1



