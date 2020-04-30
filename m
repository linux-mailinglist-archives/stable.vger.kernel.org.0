Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07641BFD44
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgD3OLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbgD3NvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 851EF2082E;
        Thu, 30 Apr 2020 13:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254685;
        bh=yVDzDf7BPjN8V3Q1sj6RasbrxByVjWam1uXEnqFNqCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4OHDPD8gFHxVnTbmLEhBYaQIzF0wza76jwZWX9dq28S7y70bfndBx8nq/D0LWHMM
         spnvQoAvAOZqQGWpEem3NqgpJRqU2gso/B8CHMtlUI7q7dRXRbTy9y/HpdTfOFhLC1
         BRmdIBt+nDT8wnVK8XedN+3hp2EePIk61VoILnWU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 36/79] ASoC: stm32: sai: fix sai probe
Date:   Thu, 30 Apr 2020 09:50:00 -0400
Message-Id: <20200430135043.19851-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

[ Upstream commit e2bcb65782f91390952e849e21b82ed7cb05697f ]

pcm config must be set before snd_dmaengine_pcm_register() call.

Fixes: 0d6defc7e0e4 ("ASoC: stm32: sai: manage rebind issue")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Link: https://lore.kernel.org/r/20200417142122.10212-1-olivier.moysan@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index d3259de43712b..7e965848796c3 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -1543,6 +1543,9 @@ static int stm32_sai_sub_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	if (STM_SAI_PROTOCOL_IS_SPDIF(sai))
+		conf = &stm32_sai_pcm_config_spdif;
+
 	ret = snd_dmaengine_pcm_register(&pdev->dev, conf, 0);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not register pcm dma\n");
@@ -1551,15 +1554,10 @@ static int stm32_sai_sub_probe(struct platform_device *pdev)
 
 	ret = snd_soc_register_component(&pdev->dev, &stm32_component,
 					 &sai->cpu_dai_drv, 1);
-	if (ret) {
+	if (ret)
 		snd_dmaengine_pcm_unregister(&pdev->dev);
-		return ret;
-	}
-
-	if (STM_SAI_PROTOCOL_IS_SPDIF(sai))
-		conf = &stm32_sai_pcm_config_spdif;
 
-	return 0;
+	return ret;
 }
 
 static int stm32_sai_sub_remove(struct platform_device *pdev)
-- 
2.20.1

