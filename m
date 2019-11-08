Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA02FF5622
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391374AbfKHTGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391367AbfKHTGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:06:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2D36222C6;
        Fri,  8 Nov 2019 19:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240014;
        bh=ytG4s/RVaKqNw7NHfre3fwqfCriOCM4ASbq+qC1JFtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeCmeZhSKe9APeRCf/ahUITumyqBAgGGDyL/ZqelL0ksBRafPYuMSSU8eq4hbWErH
         dzmJZt+/M+orGteWAinWsH0ixMNnnJwCKjMnH0Hej0dxVCm5+SJuWLYsypG8SP6QVx
         IfC+w+bilFDbDRYJLkB0QQb2my6qVXCdWd32HIWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 058/140] ASoC: Intel: sof-rt5682: add a check for devm_clk_get
Date:   Fri,  8 Nov 2019 19:49:46 +0100
Message-Id: <20191108174908.945016734@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



