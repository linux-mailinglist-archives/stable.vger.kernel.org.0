Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EE629C29B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820741AbgJ0Rht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760585AbgJ0OfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:35:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78A9622202;
        Tue, 27 Oct 2020 14:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809318;
        bh=hadelxIbODUlJfTnBBpblC19rz6RmRwvvnUY11Qrtss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0s0hrH5jK7w8Cj4oLTSH9o3UH9KYh150h25vUKZMC5s3U/c2PW9mvPgk0+a43Nvn
         c3Vrk7TYscpdUy1GUAGRROMDtyLfoPikmLylG1nm+0H7dk0Xwh6MD1SV5sRqvM+Rk6
         YRzkMrPS9FJqjgi9hgk6Vsf7vYsiCQxxn3lHoaJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit kumar <rohitkr@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/408] ASoC: qcom: lpass-cpu: fix concurrency issue
Date:   Tue, 27 Oct 2020 14:50:51 +0100
Message-Id: <20201027135500.344992671@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohit kumar <rohitkr@codeaurora.org>

[ Upstream commit 753a6e17942f6f425ca622e1610625998312ad89 ]

i2sctl register value is set to 0 during hw_free(). This
impacts any ongoing concurrent session on the same i2s
port. As trigger() stop already resets enable bit to 0,
there is no need of explicit hw_free. Removing it to
fix the issue.

Fixes: 80beab8e1d86 ("ASoC: qcom: Add LPASS CPU DAI driver")
Signed-off-by: Rohit kumar <rohitkr@codeaurora.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/1597402388-14112-7-git-send-email-rohitkr@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index dbce7e92baf3c..c5d6952a4a33f 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -174,21 +174,6 @@ static int lpass_cpu_daiops_hw_params(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static int lpass_cpu_daiops_hw_free(struct snd_pcm_substream *substream,
-		struct snd_soc_dai *dai)
-{
-	struct lpass_data *drvdata = snd_soc_dai_get_drvdata(dai);
-	int ret;
-
-	ret = regmap_write(drvdata->lpaif_map,
-			   LPAIF_I2SCTL_REG(drvdata->variant, dai->driver->id),
-			   0);
-	if (ret)
-		dev_err(dai->dev, "error writing to i2sctl reg: %d\n", ret);
-
-	return ret;
-}
-
 static int lpass_cpu_daiops_prepare(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *dai)
 {
@@ -269,7 +254,6 @@ const struct snd_soc_dai_ops asoc_qcom_lpass_cpu_dai_ops = {
 	.startup	= lpass_cpu_daiops_startup,
 	.shutdown	= lpass_cpu_daiops_shutdown,
 	.hw_params	= lpass_cpu_daiops_hw_params,
-	.hw_free	= lpass_cpu_daiops_hw_free,
 	.prepare	= lpass_cpu_daiops_prepare,
 	.trigger	= lpass_cpu_daiops_trigger,
 };
-- 
2.25.1



