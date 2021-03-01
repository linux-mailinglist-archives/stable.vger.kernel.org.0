Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D63D328BA7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240265AbhCASiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239935AbhCASbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:31:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC08C64ED0;
        Mon,  1 Mar 2021 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618781;
        bh=3iIJNzO6x3OdNw8BEJ8RqIZMa45rJQd9ITWVvn2rOHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ssq6ObaBE+s5fwIPZrDty1N+zvOjatfkw/S26JtsYoQdLO8/e44qZ9d39MgyTPqXd
         h/bId19/+eg/oAG0OaS2iyK3ie46pMvgTnxSujVbfLJInEexow1qt7WXXb1slsH51P
         yZF04MtFVsTJr221w7Rw8+TkfmRYasX9HBAZ6Tyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/663] ASoC: qcom: Fix typo error in HDMI regmap config callbacks
Date:   Mon,  1 Mar 2021 17:07:42 +0100
Message-Id: <20210301161152.378011315@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>

[ Upstream commit e681b1a6d706b4e54c3847bb822531b4660234f3 ]

Had a typo in lpass platform driver that resulted in crash
during suspend/resume with an HDMI dongle connected.

The regmap read/write/volatile regesters validation callbacks in lpass-cpu
were using MI2S rdma_channels count instead of hdmi_rdma_channels.

This typo error causing to read registers from the regmap beyond the length
of the mapping created by ioremap().

This fix avoids the need for reducing number hdmi_rdma_channels,
which is done in
commit 7dfe20ee92f6 ("ASoC: qcom: Fix number of HDMI RDMA channels on sc7180").
So reverting the same.

Fixes: 7cb37b7bd0d3c ("ASoC: qcom: Add support for lpass hdmi driver")
Signed-off-by: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Link: https://lore.kernel.org/r/20210202062727.22469-1-srivasam@codeaurora.org
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 6815f32b67b40..a33dbd6de8a06 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -594,7 +594,7 @@ static bool lpass_hdmi_regmap_writeable(struct device *dev, unsigned int reg)
 			return true;
 	}
 
-	for (i = 0; i < v->rdma_channels; ++i) {
+	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACTL_REG(v, i))
 			return true;
 		if (reg == LPAIF_HDMI_RDMABASE_REG(v, i))
@@ -640,7 +640,7 @@ static bool lpass_hdmi_regmap_readable(struct device *dev, unsigned int reg)
 	if (reg == LPASS_HDMITX_APP_IRQSTAT_REG(v))
 		return true;
 
-	for (i = 0; i < v->rdma_channels; ++i) {
+	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACTL_REG(v, i))
 			return true;
 		if (reg == LPAIF_HDMI_RDMABASE_REG(v, i))
@@ -667,7 +667,7 @@ static bool lpass_hdmi_regmap_volatile(struct device *dev, unsigned int reg)
 	if (reg == LPASS_HDMI_TX_LEGACY_ADDR(v))
 		return true;
 
-	for (i = 0; i < v->rdma_channels; ++i) {
+	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACURR_REG(v, i))
 			return true;
 	}
@@ -817,7 +817,7 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
 		}
 
 		lpass_hdmi_regmap_config.max_register = LPAIF_HDMI_RDMAPER_REG(variant,
-					variant->hdmi_rdma_channels);
+					variant->hdmi_rdma_channels - 1);
 		drvdata->hdmiif_map = devm_regmap_init_mmio(dev, drvdata->hdmiif,
 					&lpass_hdmi_regmap_config);
 		if (IS_ERR(drvdata->hdmiif_map)) {
-- 
2.27.0



