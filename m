Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAFB3962AE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhEaPAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234283AbhEaO5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF0761448;
        Mon, 31 May 2021 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469634;
        bh=v8L/5MiTcVd5VZJDeFZ8tx+G2LIK7lyE+6GAJMxxvhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPF/Ku7kXhGFHvCrSkBItH4/ihZKCVDTPTmf6OpHNkXhHTrtO35oAC7Tt+22Xdpgd
         JSHCxsnzdChrhtVoXKphAmVxd/ktg2zYchVdA7XCnvVcFNKudR6pHQCnjRAPU/S1o2
         VGFUQ5EfAJ/JKWKKuHdt2ouZWQblNyp4EQiW2KME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 272/296] ASoC: qcom: lpass-cpu: Use optional clk APIs
Date:   Mon, 31 May 2021 15:15:27 +0200
Message-Id: <20210531130712.891046118@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit af2702549d68519ac78228e915d9b2c199056787 ]

This driver spits out a warning for me at boot:

 sc7180-lpass-cpu 62f00000.lpass: asoc_qcom_lpass_cpu_platform_probe() error getting optional null: -2

but it looks like it is all an optional clk. Use the optional clk APIs
here so that we don't see this message and everything else is the same.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Banajit Goswami <bgoswami@codeaurora.org>
Fixes: 3e53ac8230c1 ("ASoC: qcom: make osr clock optional")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210520014807.3749797-1-swboyd@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index be360a402b67..936384a94f25 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -835,18 +835,8 @@ int asoc_qcom_lpass_cpu_platform_probe(struct platform_device *pdev)
 		if (dai_id == LPASS_DP_RX)
 			continue;
 
-		drvdata->mi2s_osr_clk[dai_id] = devm_clk_get(dev,
+		drvdata->mi2s_osr_clk[dai_id] = devm_clk_get_optional(dev,
 					     variant->dai_osr_clk_names[i]);
-		if (IS_ERR(drvdata->mi2s_osr_clk[dai_id])) {
-			dev_warn(dev,
-				"%s() error getting optional %s: %ld\n",
-				__func__,
-				variant->dai_osr_clk_names[i],
-				PTR_ERR(drvdata->mi2s_osr_clk[dai_id]));
-
-			drvdata->mi2s_osr_clk[dai_id] = NULL;
-		}
-
 		drvdata->mi2s_bit_clk[dai_id] = devm_clk_get(dev,
 						variant->dai_bit_clk_names[i]);
 		if (IS_ERR(drvdata->mi2s_bit_clk[dai_id])) {
-- 
2.30.2



