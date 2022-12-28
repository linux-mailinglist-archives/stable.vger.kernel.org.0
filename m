Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1E9657DF2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbiL1Psj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbiL1PsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:48:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F7E17E18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:48:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 368AE61572
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D244C433EF;
        Wed, 28 Dec 2022 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242501;
        bh=aY37VRJGVWapcHGzUuJcRsc53vUmD/yFtF5zhR7ZWiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9bVXKSgXTe5/99sPLR5zxGduJJUbwd88jngsAear6cA5hg10Ratl3B0GXQqaQeQI
         gpVE0kSvm97H1A3iKMzYR2tAJWDJk6E+bac1LDDXnWatFHs+KPAeQ3XPMrRtOPXpwG
         wvkigfkGJRye3+bDrXPxcW67/HmG5Q/+gaeJnQQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "zhichao.liu" <zhichao.liu@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0417/1073] spi: mt65xx: Add dma max segment size declaration
Date:   Wed, 28 Dec 2022 15:33:25 +0100
Message-Id: <20221228144339.349078816@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: zhichao.liu <zhichao.liu@mediatek.com>

[ Upstream commit 309e98548c2b144512d0a212f2d786ae9694f5e4 ]

Add spi dma max segment size declaration according to spi
hardware capability, instead of 64KB by system default
setting, to improve bus bandwidth for mass data transmission.

Signed-off-by: zhichao.liu <zhichao.liu@mediatek.com>
Link: https://lore.kernel.org/r/20220927083248.25404-1-zhichao.liu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c6f7874687f7 ("spi: mediatek: Enable irq when pdata is ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index a7cc96aeb590..d6aff909fc36 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1187,6 +1187,11 @@ static int mtk_spi_probe(struct platform_device *pdev)
 	if (!dev->dma_mask)
 		dev->dma_mask = &dev->coherent_dma_mask;
 
+	if (mdata->dev_comp->ipm_design)
+		dma_set_max_seg_size(dev, SZ_16M);
+	else
+		dma_set_max_seg_size(dev, SZ_256K);
+
 	ret = devm_request_irq(dev, irq, mtk_spi_interrupt,
 			       IRQF_TRIGGER_NONE, dev_name(dev), master);
 	if (ret)
-- 
2.35.1



