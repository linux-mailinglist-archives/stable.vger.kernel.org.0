Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D67420F12
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbhJDNah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237612AbhJDN2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C64F630EF;
        Mon,  4 Oct 2021 13:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353184;
        bh=ol1Ud4I99kMsTCv+cnLrcTXo/MlSDVsH/d8koUErul0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGVhcvDPbRNFIuGfPnRRsOiAqcW6EsYrrkgANedelGZMzHZVys0FeDOed0llvCQhr
         ynM6JeW7RdPRhLg4huPyAZaqASpddbERAdrJdCBuCI2UpUORogD/drZkOIBHMDQhk/
         H0tEecm1UxM6OSgI7UOAITZxyDwGb7jwjnj83xtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 008/172] ASoC: fsl_xcvr: register platform component before registering cpu dai
Date:   Mon,  4 Oct 2021 14:50:58 +0200
Message-Id: <20211004125045.234068794@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit c590fa80b39287a91abeb487829f3190e7ae775f ]

There is no defer probe when adding platform component to
snd_soc_pcm_runtime(rtd), the code is in snd_soc_add_pcm_runtime()

snd_soc_register_card()
  -> snd_soc_bind_card()
    -> snd_soc_add_pcm_runtime()
      -> adding cpu dai
      -> adding codec dai
      -> adding platform component.

So if the platform component is not ready at that time, then the
sound card still registered successfully, but platform component
is empty, the sound card can't be used.

As there is defer probe checking for cpu dai component, then register
platform component before cpu dai to avoid such issue.

Fixes: 28564486866f ("ASoC: fsl_xcvr: Add XCVR ASoC CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1630665006-31437-6-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index fb7c29fc39d7..477d16713e72 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1217,18 +1217,23 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	regcache_cache_only(xcvr->regmap, true);
 
+	/*
+	 * Register platform component before registering cpu dai for there
+	 * is not defer probe for platform component in snd_soc_add_pcm_runtime().
+	 */
+	ret = devm_snd_dmaengine_pcm_register(dev, NULL, 0);
+	if (ret) {
+		dev_err(dev, "failed to pcm register\n");
+		return ret;
+	}
+
 	ret = devm_snd_soc_register_component(dev, &fsl_xcvr_comp,
 					      &fsl_xcvr_dai, 1);
 	if (ret) {
 		dev_err(dev, "failed to register component %s\n",
 			fsl_xcvr_comp.name);
-		return ret;
 	}
 
-	ret = devm_snd_dmaengine_pcm_register(dev, NULL, 0);
-	if (ret)
-		dev_err(dev, "failed to pcm register\n");
-
 	return ret;
 }
 
-- 
2.33.0



