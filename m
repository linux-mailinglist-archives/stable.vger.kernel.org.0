Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96D91BFD59
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgD3NvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgD3NvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE44120873;
        Thu, 30 Apr 2020 13:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254664;
        bh=j7EesqpJdFMIiohM4Zu86JeArWKo8byoEHxcvBmIFJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRBWvn2SU5htasFxi1UM7LtEFOkn8Wa2dca9nph9ekjzsLKnACh/JSgog1kP2qsAO
         DPN0tXGA8wNV5OZ6bs5ZJTs+ky59j5YrizkZdENcviIjidXbyvhb3cuAZXoD8tlC74
         6yFsxExFP0oX0+mxx+EZqXRn1aOKagxTsDd5MTsY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 17/79] ASoC: samsung: s3c24xx-i2s: Fix build after removal of DAI suspend/resume
Date:   Thu, 30 Apr 2020 09:49:41 -0400
Message-Id: <20200430135043.19851-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit ec21bdc6dd16d74b3674ef1fd12ae8e4e7418603 ]

Commit 450312b640f9 ("ASoC: soc-core: remove DAI suspend/resume")
removed the DAI side suspend/resume hooks and switched entirely to
component suspend/resume.  However the Samsung SoC s3c-i2s-v2 driver was
not updated.

Move the suspend/resume hooks from s3c-i2s-v2.c to s3c2412-i2s.c while
changing dai to component which allows to keep the struct
snd_soc_component_driver const.

This fixes build errors:

    sound/soc/samsung/s3c-i2s-v2.c: In function ‘s3c_i2sv2_register_component’:
    sound/soc/samsung/s3c-i2s-v2.c:730:9: error: ‘struct snd_soc_dai_driver’ has no member named ‘suspend’
      dai_drv->suspend = s3c2412_i2s_suspend;

Reported-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 450312b640f9 ("ASoC: soc-core: remove DAI suspend/resume")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Link: https://lore.kernel.org/r/20200413124548.28197-1-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/s3c-i2s-v2.c  | 57 ---------------------------------
 sound/soc/samsung/s3c2412-i2s.c | 56 ++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/sound/soc/samsung/s3c-i2s-v2.c b/sound/soc/samsung/s3c-i2s-v2.c
index 593be1b668d64..b3e12d6a78a19 100644
--- a/sound/soc/samsung/s3c-i2s-v2.c
+++ b/sound/soc/samsung/s3c-i2s-v2.c
@@ -656,60 +656,6 @@ void s3c_i2sv2_cleanup(struct snd_soc_dai *dai,
 }
 EXPORT_SYMBOL_GPL(s3c_i2sv2_cleanup);
 
-#ifdef CONFIG_PM
-static int s3c2412_i2s_suspend(struct snd_soc_dai *dai)
-{
-	struct s3c_i2sv2_info *i2s = to_info(dai);
-	u32 iismod;
-
-	if (dai->active) {
-		i2s->suspend_iismod = readl(i2s->regs + S3C2412_IISMOD);
-		i2s->suspend_iiscon = readl(i2s->regs + S3C2412_IISCON);
-		i2s->suspend_iispsr = readl(i2s->regs + S3C2412_IISPSR);
-
-		/* some basic suspend checks */
-
-		iismod = readl(i2s->regs + S3C2412_IISMOD);
-
-		if (iismod & S3C2412_IISCON_RXDMA_ACTIVE)
-			pr_warn("%s: RXDMA active?\n", __func__);
-
-		if (iismod & S3C2412_IISCON_TXDMA_ACTIVE)
-			pr_warn("%s: TXDMA active?\n", __func__);
-
-		if (iismod & S3C2412_IISCON_IIS_ACTIVE)
-			pr_warn("%s: IIS active\n", __func__);
-	}
-
-	return 0;
-}
-
-static int s3c2412_i2s_resume(struct snd_soc_dai *dai)
-{
-	struct s3c_i2sv2_info *i2s = to_info(dai);
-
-	pr_info("dai_active %d, IISMOD %08x, IISCON %08x\n",
-		dai->active, i2s->suspend_iismod, i2s->suspend_iiscon);
-
-	if (dai->active) {
-		writel(i2s->suspend_iiscon, i2s->regs + S3C2412_IISCON);
-		writel(i2s->suspend_iismod, i2s->regs + S3C2412_IISMOD);
-		writel(i2s->suspend_iispsr, i2s->regs + S3C2412_IISPSR);
-
-		writel(S3C2412_IISFIC_RXFLUSH | S3C2412_IISFIC_TXFLUSH,
-		       i2s->regs + S3C2412_IISFIC);
-
-		ndelay(250);
-		writel(0x0, i2s->regs + S3C2412_IISFIC);
-	}
-
-	return 0;
-}
-#else
-#define s3c2412_i2s_suspend NULL
-#define s3c2412_i2s_resume  NULL
-#endif
-
 int s3c_i2sv2_register_component(struct device *dev, int id,
 			   const struct snd_soc_component_driver *cmp_drv,
 			   struct snd_soc_dai_driver *dai_drv)
@@ -727,9 +673,6 @@ int s3c_i2sv2_register_component(struct device *dev, int id,
 	if (!ops->delay)
 		ops->delay = s3c2412_i2s_delay;
 
-	dai_drv->suspend = s3c2412_i2s_suspend;
-	dai_drv->resume = s3c2412_i2s_resume;
-
 	return devm_snd_soc_register_component(dev, cmp_drv, dai_drv, 1);
 }
 EXPORT_SYMBOL_GPL(s3c_i2sv2_register_component);
diff --git a/sound/soc/samsung/s3c2412-i2s.c b/sound/soc/samsung/s3c2412-i2s.c
index 787a3f6e9f242..b35d828c1cfe9 100644
--- a/sound/soc/samsung/s3c2412-i2s.c
+++ b/sound/soc/samsung/s3c2412-i2s.c
@@ -117,6 +117,60 @@ static int s3c2412_i2s_hw_params(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int s3c2412_i2s_suspend(struct snd_soc_component *component)
+{
+	struct s3c_i2sv2_info *i2s = snd_soc_component_get_drvdata(component);
+	u32 iismod;
+
+	if (component->active) {
+		i2s->suspend_iismod = readl(i2s->regs + S3C2412_IISMOD);
+		i2s->suspend_iiscon = readl(i2s->regs + S3C2412_IISCON);
+		i2s->suspend_iispsr = readl(i2s->regs + S3C2412_IISPSR);
+
+		/* some basic suspend checks */
+
+		iismod = readl(i2s->regs + S3C2412_IISMOD);
+
+		if (iismod & S3C2412_IISCON_RXDMA_ACTIVE)
+			pr_warn("%s: RXDMA active?\n", __func__);
+
+		if (iismod & S3C2412_IISCON_TXDMA_ACTIVE)
+			pr_warn("%s: TXDMA active?\n", __func__);
+
+		if (iismod & S3C2412_IISCON_IIS_ACTIVE)
+			pr_warn("%s: IIS active\n", __func__);
+	}
+
+	return 0;
+}
+
+static int s3c2412_i2s_resume(struct snd_soc_component *component)
+{
+	struct s3c_i2sv2_info *i2s = snd_soc_component_get_drvdata(component);
+
+	pr_info("component_active %d, IISMOD %08x, IISCON %08x\n",
+		component->active, i2s->suspend_iismod, i2s->suspend_iiscon);
+
+	if (component->active) {
+		writel(i2s->suspend_iiscon, i2s->regs + S3C2412_IISCON);
+		writel(i2s->suspend_iismod, i2s->regs + S3C2412_IISMOD);
+		writel(i2s->suspend_iispsr, i2s->regs + S3C2412_IISPSR);
+
+		writel(S3C2412_IISFIC_RXFLUSH | S3C2412_IISFIC_TXFLUSH,
+		       i2s->regs + S3C2412_IISFIC);
+
+		ndelay(250);
+		writel(0x0, i2s->regs + S3C2412_IISFIC);
+	}
+
+	return 0;
+}
+#else
+#define s3c2412_i2s_suspend NULL
+#define s3c2412_i2s_resume  NULL
+#endif
+
 #define S3C2412_I2S_RATES \
 	(SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 | SNDRV_PCM_RATE_16000 | \
 	SNDRV_PCM_RATE_22050 | SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 | \
@@ -146,6 +200,8 @@ static struct snd_soc_dai_driver s3c2412_i2s_dai = {
 
 static const struct snd_soc_component_driver s3c2412_i2s_component = {
 	.name		= "s3c2412-i2s",
+	.suspend	= s3c2412_i2s_suspend,
+	.resume		= s3c2412_i2s_resume,
 };
 
 static int s3c2412_iis_dev_probe(struct platform_device *pdev)
-- 
2.20.1

