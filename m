Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34F630CC69
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240209AbhBBTzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:55:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233092AbhBBNv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A3B64FB6;
        Tue,  2 Feb 2021 13:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273394;
        bh=+jah0nhBlXabwlUZ88a8E80mXWMsLUYOS15udGs0J6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlR2tIKigPgprxJGTo7m+YmhaPfhEZ/JdD8nja78AJz378itkrt7D7LfXpRzlv4xV
         QxvlS6og4CWxDKpunbKFNf/b+RAqt78vMhZBTkmpKxCjwBH/nIWaf1egaV2rUPn4ul
         GDABSQ4L2fkZHtBlUDeIlcNlgHNqP43DhB3k51+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Nie <jun.nie@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Srinivasa Rao <srivasam@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/142] ASoC: qcom: Fix broken support to MI2S TERTIARY and QUATERNARY
Date:   Tue,  2 Feb 2021 14:37:34 +0100
Message-Id: <20210202133001.463398840@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit cd3484f7f1386071b1af159023917ed12c182d39 ]

lpass hdmi support patch totally removed support for MI2S TERTIARY
and QUATERNARY.

One of the major issue was spotted with the design of having
separate SoC specific header files for the common lpass driver.
This design is prone to break as an when new SoC header is added
as the common DAI ids of other SoCs will be overwritten by the
new ones.

Having a common header qcom,lpass.h should fix the issue and any new
DAI ids should be added to the common header.

With this change lpass also needs a new of_xlate function to resolve
dai name.

Fixes: 7cb37b7bd0d3 ("ASoC: qcom: Add support for lpass hdmi driver")
Reported-by: Jun Nie <jun.nie@linaro.org>
Reported-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Srinivasa Rao <srivasam@codeaurora.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20210119171527.32145-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c      | 22 ++++++++++++++++++++++
 sound/soc/qcom/lpass-platform.c | 12 ++++++++++++
 sound/soc/qcom/lpass-sc7180.c   |  9 +++------
 sound/soc/qcom/lpass.h          |  2 +-
 4 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 97b920ab50685..46bb24afeacf0 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -344,8 +344,30 @@ int asoc_qcom_lpass_cpu_dai_probe(struct snd_soc_dai *dai)
 }
 EXPORT_SYMBOL_GPL(asoc_qcom_lpass_cpu_dai_probe);
 
+static int asoc_qcom_of_xlate_dai_name(struct snd_soc_component *component,
+				   struct of_phandle_args *args,
+				   const char **dai_name)
+{
+	struct lpass_data *drvdata = snd_soc_component_get_drvdata(component);
+	struct lpass_variant *variant = drvdata->variant;
+	int id = args->args[0];
+	int ret = -EINVAL;
+	int i;
+
+	for (i = 0; i  < variant->num_dai; i++) {
+		if (variant->dai_driver[i].id == id) {
+			*dai_name = variant->dai_driver[i].name;
+			ret = 0;
+			break;
+		}
+	}
+
+	return ret;
+}
+
 static const struct snd_soc_component_driver lpass_cpu_comp_driver = {
 	.name = "lpass-cpu",
+	.of_xlate_dai_name = asoc_qcom_of_xlate_dai_name,
 };
 
 static bool lpass_cpu_regmap_writeable(struct device *dev, unsigned int reg)
diff --git a/sound/soc/qcom/lpass-platform.c b/sound/soc/qcom/lpass-platform.c
index 232deee6fde56..71122e9eb2305 100644
--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -257,6 +257,9 @@ static int lpass_platform_pcmops_hw_params(struct snd_soc_component *component,
 		break;
 	case MI2S_PRIMARY:
 	case MI2S_SECONDARY:
+	case MI2S_TERTIARY:
+	case MI2S_QUATERNARY:
+	case MI2S_QUINARY:
 		ret = regmap_fields_write(dmactl->intf, id,
 						LPAIF_DMACTL_AUDINTF(dma_port));
 		if (ret) {
@@ -507,6 +510,9 @@ static int lpass_platform_pcmops_trigger(struct snd_soc_component *component,
 			break;
 		case MI2S_PRIMARY:
 		case MI2S_SECONDARY:
+		case MI2S_TERTIARY:
+		case MI2S_QUATERNARY:
+		case MI2S_QUINARY:
 			reg_irqclr = LPAIF_IRQCLEAR_REG(v, LPAIF_IRQ_PORT_HOST);
 			val_irqclr = LPAIF_IRQ_ALL(ch);
 
@@ -559,6 +565,9 @@ static int lpass_platform_pcmops_trigger(struct snd_soc_component *component,
 			break;
 		case MI2S_PRIMARY:
 		case MI2S_SECONDARY:
+		case MI2S_TERTIARY:
+		case MI2S_QUATERNARY:
+		case MI2S_QUINARY:
 			reg_irqen = LPAIF_IRQEN_REG(v, LPAIF_IRQ_PORT_HOST);
 			val_mask = LPAIF_IRQ_ALL(ch);
 			val_irqen = 0;
@@ -655,6 +664,9 @@ static irqreturn_t lpass_dma_interrupt_handler(
 	break;
 	case MI2S_PRIMARY:
 	case MI2S_SECONDARY:
+	case MI2S_TERTIARY:
+	case MI2S_QUATERNARY:
+	case MI2S_QUINARY:
 		map = drvdata->lpaif_map;
 		reg = LPAIF_IRQCLEAR_REG(v, LPAIF_IRQ_PORT_HOST);
 		val = 0;
diff --git a/sound/soc/qcom/lpass-sc7180.c b/sound/soc/qcom/lpass-sc7180.c
index bc998d5016000..c647e627897a2 100644
--- a/sound/soc/qcom/lpass-sc7180.c
+++ b/sound/soc/qcom/lpass-sc7180.c
@@ -20,7 +20,7 @@
 #include "lpass.h"
 
 static struct snd_soc_dai_driver sc7180_lpass_cpu_dai_driver[] = {
-	[MI2S_PRIMARY] = {
+	{
 		.id = MI2S_PRIMARY,
 		.name = "Primary MI2S",
 		.playback = {
@@ -43,9 +43,7 @@ static struct snd_soc_dai_driver sc7180_lpass_cpu_dai_driver[] = {
 		},
 		.probe	= &asoc_qcom_lpass_cpu_dai_probe,
 		.ops    = &asoc_qcom_lpass_cpu_dai_ops,
-	},
-
-	[MI2S_SECONDARY] = {
+	}, {
 		.id = MI2S_SECONDARY,
 		.name = "Secondary MI2S",
 		.playback = {
@@ -59,8 +57,7 @@ static struct snd_soc_dai_driver sc7180_lpass_cpu_dai_driver[] = {
 		},
 		.probe	= &asoc_qcom_lpass_cpu_dai_probe,
 		.ops    = &asoc_qcom_lpass_cpu_dai_ops,
-	},
-	[LPASS_DP_RX] = {
+	}, {
 		.id = LPASS_DP_RX,
 		.name = "Hdmi",
 		.playback = {
diff --git a/sound/soc/qcom/lpass.h b/sound/soc/qcom/lpass.h
index bccd1a05d771e..868c1c8dbd455 100644
--- a/sound/soc/qcom/lpass.h
+++ b/sound/soc/qcom/lpass.h
@@ -12,7 +12,7 @@
 #include <linux/compiler.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
-#include <dt-bindings/sound/sc7180-lpass.h>
+#include <dt-bindings/sound/qcom,lpass.h>
 #include "lpass-hdmi.h"
 
 #define LPASS_AHBIX_CLOCK_FREQUENCY		131072000
-- 
2.27.0



