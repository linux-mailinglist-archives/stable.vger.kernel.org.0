Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA821FBDC
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbgGNSz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730223AbgGNSzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C346B222B9;
        Tue, 14 Jul 2020 18:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752924;
        bh=kFlVpf3xsjPd5uBp1qmNbTQ/O1AJA5LuZSfT32sZWqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/nIzGaW1hnAueh9v7Fp/dvKiW0wkldy9pM6iJaf8rQL+KVMRgdLEXo5YDFMSLcoJ
         AkGIMu7JhewlsU6cnzJmCdm1JedsEmifgGswLz2Hz2YWlNbHt8nmcg+RMA0amqPknL
         veHTq+QGdUJ8kHGbnpdQTvvpnx3nVew0VsKGDqRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 052/166] ASoC: fsl_mqs: Fix unchecked return value for clk_prepare_enable
Date:   Tue, 14 Jul 2020 20:43:37 +0200
Message-Id: <20200714184118.368907272@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 15217d170a4461c1d4c1ea7c497e1fc1122e42a9 ]

Fix unchecked return value for clk_prepare_enable, add error
handler in fsl_mqs_runtime_resume.

Fixes: 9e28f6532c61 ("ASoC: fsl_mqs: Add MQS component driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/5edd68d03def367d96268f1a9a00bd528ea5aaf2.1592888591.git.shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_mqs.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_mqs.c b/sound/soc/fsl/fsl_mqs.c
index b44b134390a39..69aeb0e71844d 100644
--- a/sound/soc/fsl/fsl_mqs.c
+++ b/sound/soc/fsl/fsl_mqs.c
@@ -265,10 +265,20 @@ static int fsl_mqs_remove(struct platform_device *pdev)
 static int fsl_mqs_runtime_resume(struct device *dev)
 {
 	struct fsl_mqs *mqs_priv = dev_get_drvdata(dev);
+	int ret;
 
-	clk_prepare_enable(mqs_priv->ipg);
+	ret = clk_prepare_enable(mqs_priv->ipg);
+	if (ret) {
+		dev_err(dev, "failed to enable ipg clock\n");
+		return ret;
+	}
 
-	clk_prepare_enable(mqs_priv->mclk);
+	ret = clk_prepare_enable(mqs_priv->mclk);
+	if (ret) {
+		dev_err(dev, "failed to enable mclk clock\n");
+		clk_disable_unprepare(mqs_priv->ipg);
+		return ret;
+	}
 
 	if (mqs_priv->use_gpr)
 		regmap_write(mqs_priv->regmap, IOMUXC_GPR2,
-- 
2.25.1



