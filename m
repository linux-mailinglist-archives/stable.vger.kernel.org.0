Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57298205C5A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387587AbgFWUBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387579AbgFWUBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:01:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C8120706;
        Tue, 23 Jun 2020 20:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942470;
        bh=gyxZKGmYpcSubDwX2gLuJPlr8ZhheA/wFX1fIONie/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNYFKFc6TsJJH83sWrgNj/cbkzxepig39qU3LKBL/vpwpG12IrnpNCylgjt9c2WEC
         CBJNeKiH7Ggeg5RD6QcjguRMIgBF45ZBwtLr5baAYIbmbxGtYobeNsiP9y74mfiVHn
         hFGopZgYDn7eo701mbitmMTfyBYQOg+V2nou76V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 012/477] ASoC: fsl_esai: Disable exception interrupt before scheduling tasklet
Date:   Tue, 23 Jun 2020 21:50:09 +0200
Message-Id: <20200623195408.177073818@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 1fecbb71fe0e46b886f84e3b6decca6643c3af6d ]

Disable exception interrupt before scheduling tasklet, otherwise if
the tasklet isn't handled immediately, there will be endless xrun
interrupt.

Fixes: 7ccafa2b3879 ("ASoC: fsl_esai: recover the channel swap after xrun")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/a8f2ad955aac9e52587beedc1133b3efbe746895.1587968824.git.shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_esai.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index c7a49d03463a7..84290be778f0e 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -87,6 +87,10 @@ static irqreturn_t esai_isr(int irq, void *devid)
 	if ((saisr & (ESAI_SAISR_TUE | ESAI_SAISR_ROE)) &&
 	    esai_priv->reset_at_xrun) {
 		dev_dbg(&pdev->dev, "reset module for xrun\n");
+		regmap_update_bits(esai_priv->regmap, REG_ESAI_TCR,
+				   ESAI_xCR_xEIE_MASK, 0);
+		regmap_update_bits(esai_priv->regmap, REG_ESAI_RCR,
+				   ESAI_xCR_xEIE_MASK, 0);
 		tasklet_schedule(&esai_priv->task);
 	}
 
-- 
2.25.1



