Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA158541A44
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351628AbiFGVcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380051AbiFGV2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:28:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3767228F79;
        Tue,  7 Jun 2022 12:02:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38135617C8;
        Tue,  7 Jun 2022 19:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DB2C34115;
        Tue,  7 Jun 2022 19:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628539;
        bh=KMr9qbwkA8fYAqb2hOPdq0teI7fY3uvBUGHNV7CPuCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEY8+NXQDpBTqGYLbYNUnn7iabMqspvxE+ytSzBQkgZhpfK2VSFH2KHnDfyREGKRF
         c08vB1o2DZsw3WLD85nGNAHZpLyjfSQJoRu9eHlObKdFfVPXhMl3kEALyXIiuvAMck
         XcQrqqmpNcxIxs3AhnD/JcylU+DCz5VHGaz1C7AQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 329/879] drm/mediatek: dpi: Use mt8183 output formats for mt8192
Date:   Tue,  7 Jun 2022 18:57:27 +0200
Message-Id: <20220607165012.404036044@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 7112e0b0a58be8575547eba6596c42710922674f ]

The configuration for mt8192 was incorrectly using the output formats
from mt8173. Since the output formats for mt8192 are instead the same
ones as for mt8183, which require two bus samples per pixel, the
pixelclock and DDR edge setting were misconfigured. This made external
displays unable to show the image.

Fix the issue by correcting the output format for mt8192 to be the same
as for mt8183, fixing the usage of external displays for mt8192.

Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20220408013950.674477-1-nfraprado@collabora.com/
Fixes: be63f6e8601f ("drm/mediatek: dpi: Add output bus formats to driver data")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index 4554e2de1430..e61cd67b978f 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -819,8 +819,8 @@ static const struct mtk_dpi_conf mt8192_conf = {
 	.cal_factor = mt8183_calculate_factor,
 	.reg_h_fre_con = 0xe0,
 	.max_clock_khz = 150000,
-	.output_fmts = mt8173_output_fmts,
-	.num_output_fmts = ARRAY_SIZE(mt8173_output_fmts),
+	.output_fmts = mt8183_output_fmts,
+	.num_output_fmts = ARRAY_SIZE(mt8183_output_fmts),
 };
 
 static int mtk_dpi_probe(struct platform_device *pdev)
-- 
2.35.1



