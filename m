Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBB159DFBF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357436AbiHWLSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357957AbiHWLRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:17:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D31895F0;
        Tue, 23 Aug 2022 02:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E76776098A;
        Tue, 23 Aug 2022 09:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED15EC433C1;
        Tue, 23 Aug 2022 09:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246452;
        bh=H6VhL8qotYmtJ91VYskkXpMtTV64KmzIgEHD48+wouM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3BXLm1I/RIaL7P6nzrBxopPqlNWemRhH2XV1QLLh8EymB6G0DDy8UVTu7HHtGVc4
         3t+Y1bXyJzivYN3jMajxCO/VrmtN4abaAWwFX86APw45yiyT5b1mnr4aC3L9SGQKoC
         BtOeermyIEy5yQf0waYnU8JzSQu6xn+892CvhTbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bo-Chen Chen <rex-bc.chen@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/389] drm/mediatek: dpi: Remove output format of YUV
Date:   Tue, 23 Aug 2022 10:23:12 +0200
Message-Id: <20220823080120.385445508@linuxfoundation.org>
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
index 48de07e9059e..8f4a9f245a9a 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -50,13 +50,7 @@ enum mtk_dpi_out_channel_swap {
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
@@ -355,24 +349,11 @@ static void mtk_dpi_config_disable_edge(struct mtk_dpi *dpi)
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
 
 static void mtk_dpi_power_off(struct mtk_dpi *dpi)
-- 
2.35.1



