Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE917EA021
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfJ3Pxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727637AbfJ3Pxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:45 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0243A20656;
        Wed, 30 Oct 2019 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450825;
        bh=ytG4s/RVaKqNw7NHfre3fwqfCriOCM4ASbq+qC1JFtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVAPbhPfjGF1DGodfbpfOeIei4+bucBiov0kJTn16Q59oLpghC+3A4i7Asa3s9sve
         BUbXRr2RBnc6oES8QdZmdQt74PGfrC3ywBGTNzMc19QOhEXBl+N2yweWmxsyOdrutb
         cav8Y4JPCkLJN2zZCodqDq+c58UM/jm4e1HZ506I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 59/81] ASoC: Intel: sof-rt5682: add a check for devm_clk_get
Date:   Wed, 30 Oct 2019 11:49:05 -0400
Message-Id: <20191030154928.9432-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit e5f0d490fb718254a884453e47fcd48493cd67ea ]

sof_audio_probe misses a check for devm_clk_get and may cause problems.
Add a check for it to fix the bug.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191017025044.31474-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 239eef128c2b7..9e59586e03bac 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -573,6 +573,15 @@ static int sof_audio_probe(struct platform_device *pdev)
 	/* need to get main clock from pmc */
 	if (sof_rt5682_quirk & SOF_RT5682_MCLK_BYTCHT_EN) {
 		ctx->mclk = devm_clk_get(&pdev->dev, "pmc_plt_clk_3");
+		if (IS_ERR(ctx->mclk)) {
+			ret = PTR_ERR(ctx->mclk);
+
+			dev_err(&pdev->dev,
+				"Failed to get MCLK from pmc_plt_clk_3: %d\n",
+				ret);
+			return ret;
+		}
+
 		ret = clk_prepare_enable(ctx->mclk);
 		if (ret < 0) {
 			dev_err(&pdev->dev,
-- 
2.20.1

