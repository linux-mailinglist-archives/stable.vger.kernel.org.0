Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0692C0621
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgKWM2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:28:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730392AbgKWM2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:28:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF6A420888;
        Mon, 23 Nov 2020 12:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134482;
        bh=B/eNGlAHvi5dC+mgfYnFNNUWf9A5JS+agK/HNgpTLEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHz+jdt1Ea5vs3VLpuGeXUln8AobG6fTfQwY8O/6RUd+sVCPFOkd5Fuf2O1uCbErc
         RemL5sK55vfwncDD7/o6Sn6S8dOFeNsGsSUoNzQS4UY6aX6DJ/CNkTVToaTMbJ/Jd/
         coflTngms9Mr6vwUwhhnEe49Zobct9vXGJVJRJTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        V Sujith Kumar Reddy <vsujithk@codeaurora.org>,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/60] ASoC: qcom: lpass-platform: Fix memory leak
Date:   Mon, 23 Nov 2020 13:22:18 +0100
Message-Id: <20201123121806.793993057@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>

[ Upstream commit bd6327fda2f3ded85b69b3c3125c99aaa51c7881 ]

lpass_pcm_data is not freed in error paths. Free it in
error paths to avoid memory leak.

Fixes: 022d00ee0b55 ("ASoC: lpass-platform: Fix broken pcm data usage")
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: V Sujith Kumar Reddy <vsujithk@codeaurora.org>
Signed-off-by: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Link: https://lore.kernel.org/r/1605416210-14530-1-git-send-email-srivasam@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-platform.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass-platform.c b/sound/soc/qcom/lpass-platform.c
index b8f8cb906d805..35c49fc9602b6 100644
--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -80,8 +80,10 @@ static int lpass_platform_pcmops_open(struct snd_pcm_substream *substream)
 	else
 		dma_ch = 0;
 
-	if (dma_ch < 0)
+	if (dma_ch < 0) {
+		kfree(data);
 		return dma_ch;
+	}
 
 	drvdata->substream[dma_ch] = substream;
 
@@ -102,6 +104,7 @@ static int lpass_platform_pcmops_open(struct snd_pcm_substream *substream)
 	ret = snd_pcm_hw_constraint_integer(runtime,
 			SNDRV_PCM_HW_PARAM_PERIODS);
 	if (ret < 0) {
+		kfree(data);
 		dev_err(soc_runtime->dev, "setting constraints failed: %d\n",
 			ret);
 		return -EINVAL;
-- 
2.27.0



