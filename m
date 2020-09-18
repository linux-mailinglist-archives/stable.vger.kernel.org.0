Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6612226EFFF
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgIRCjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbgIRCLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB74208E4;
        Fri, 18 Sep 2020 02:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395111;
        bh=/iP9Ag19GgBHLvoiSq8lhc67xp8mDrrl8ZQW/1k9LsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2r5w3JBt1m/iQ32nKbrzswZWsp2vfR9nxkYyHda6nsE2WaSTeSWz+DeMC1uFkbkP
         9TtGZ/6f45eTKCsIpvlbl91uupNQuex4TA070BocLIR9yPeP1kDY6E1MoTlgWydblH
         oI/RkzEN1Vjc5A4Ykz9m00/WAKG/m5htCUyhsp10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 185/206] ASoC: img-i2s-out: Fix runtime PM imbalance on error
Date:   Thu, 17 Sep 2020 22:07:41 -0400
Message-Id: <20200918020802.2065198-185-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 65bd91dd6957390c42a0491b9622cf31a2cdb140 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20200529012230.5863-1-dinghao.liu@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/img/img-i2s-out.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/img/img-i2s-out.c b/sound/soc/img/img-i2s-out.c
index fc2d1dac63339..798ab579564cb 100644
--- a/sound/soc/img/img-i2s-out.c
+++ b/sound/soc/img/img-i2s-out.c
@@ -350,8 +350,10 @@ static int img_i2s_out_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	chan_control_mask = IMG_I2S_OUT_CHAN_CTL_CLKT_MASK;
 
 	ret = pm_runtime_get_sync(i2s->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(i2s->dev);
 		return ret;
+	}
 
 	img_i2s_out_disable(i2s);
 
@@ -491,8 +493,10 @@ static int img_i2s_out_probe(struct platform_device *pdev)
 			goto err_pm_disable;
 	}
 	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(&pdev->dev);
 		goto err_suspend;
+	}
 
 	reg = IMG_I2S_OUT_CTL_FRM_SIZE_MASK;
 	img_i2s_out_writel(i2s, reg, IMG_I2S_OUT_CTL);
-- 
2.25.1

