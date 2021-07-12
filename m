Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA373C5088
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245645AbhGLHdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343571AbhGLH2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:28:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C820561921;
        Mon, 12 Jul 2021 07:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074645;
        bh=uuDOYGr39R0SKAOdikfpujbED331JVwA4d41fRH3ZSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odAtxMZnkLm3qWLMM/ym7xLYrcBC98daUCBS2u8AOTrvKGMm3inNhIaEg1H3Q/zTc
         KMsaFjwQoGrt5JUADPxfdKK+AvO2CMLvpVW96hW8b33MgDegy5qIhrsKnIgX17EtQu
         yo09rlRMSVMV8sG/VIwKhPYFnenLVwNWez9S5Ixg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 649/700] ASoC: fsl_spdif: Fix unexpected interrupt after suspend
Date:   Mon, 12 Jul 2021 08:12:12 +0200
Message-Id: <20210712061044.913234845@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit a7a0a2feb957e446b2bcf732f245ba04fc8b6314 ]

When system enter suspend, the machine driver suspend callback
function will be called, then the cpu driver trigger callback
(SNDRV_PCM_TRIGGER_SUSPEND) be called, it would disable the
interrupt.

But the machine driver suspend and cpu dai driver suspend order
maybe changed, the cpu dai driver's suspend callback is called before
machine driver's suppend callback, then the interrupt is not cleared
successfully in trigger callback.

So need to clear interrupts in cpu dai driver's suspend callback
to avoid such issue.

Fixes: 9cb2b3796e08 ("ASoC: fsl_spdif: Add pm runtime function")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/1624365084-7934-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_spdif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index e5d366b2a6a4..6d5e9c0acdb4 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -1429,6 +1429,9 @@ static int fsl_spdif_runtime_suspend(struct device *dev)
 	struct fsl_spdif_priv *spdif_priv = dev_get_drvdata(dev);
 	int i;
 
+	/* Disable all the interrupts */
+	regmap_update_bits(spdif_priv->regmap, REG_SPDIF_SIE, 0xffffff, 0);
+
 	regmap_read(spdif_priv->regmap, REG_SPDIF_SRPC,
 			&spdif_priv->regcache_srpc);
 	regcache_cache_only(spdif_priv->regmap, true);
-- 
2.30.2



