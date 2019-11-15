Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57506FE7DE
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfKOWeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:12 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46101 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbfKOWeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:11 -0500
Received: by mail-pl1-f196.google.com with SMTP id l4so5611586plt.13
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f67vg1P6cp56FC+gFomHmc7P3PWgRttseTI8GzuDMDw=;
        b=xA6/rKgNfSpMNx7U2CIf58R0lskOLg3y9hYciTIt8ZD92F0abPfnJuNWvlOArEOELy
         Eg1q0mG7cr3zITCHPC3sYPPWPZpvKqTpZpqj0CiwzgBAHOv+44QxulLsvWlnsWu4gd8H
         iEOqm1GqavhvEBS16eTYSVDgdfFhUlNs4E2uzERBdCZlfSInyLMACfvujQG9qO/qlK0o
         Uxl2r/sRt1TU1QCCi/KATL4JehE2IfKdKDi6Uc6qegftMBClBcB7jv9K0QwVPVRGR5/u
         9OJPcNqlrci4gxNVVvGbQUOYbTYXj8dLUk0yvBsQPmQBCW0m6Up7CMw0HPCnXfY/E4wQ
         KWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f67vg1P6cp56FC+gFomHmc7P3PWgRttseTI8GzuDMDw=;
        b=AQlTSmir2mMTOws0Y6rKUgT4CXUBeHHQXKEW+JLjoL/CPQTQukxTXCIRaGRlylbS18
         wANk52u23NGdEYPyv3Frw9XCDqtOtA551tzzRfgLuZetS+2j8ZRoWcd1NuG4nbp9XTV4
         36eI8f5rGmtKY50SejekRVq5hznFUDYNKNnq39qdBiGSNtsHQHOXjq5tP+oN9BJua8HQ
         hJDeYLEEFMKQFwpKbVLpjDZDwdvVNwdLUHUcnpZaFV+TTfW7gin2omILX8dMb1Yx7Azr
         SCtmFWwpR69zOdLVIfDweL7PnYskud4T6hXQZ3BUTW7002RzAdNu1mGnqGVesW6y8eAD
         9fTQ==
X-Gm-Message-State: APjAAAUg/Xy3QqpuGdQTkelVmgcyNPxha0AgdoIaCLKjverNtBAbDXgy
        LsGTdpJaWuDBACJsBOf3ZYWOXqPAuVQ=
X-Google-Smtp-Source: APXvYqy5gmuKV2XPYe0CJ9Tar06N04Tv6DzHZfUu5lOREsiiyK0PNj9Ybul3RHjzrkIoJm7yH+3w2A==
X-Received: by 2002:a17:902:ff14:: with SMTP id f20mr17167605plj.225.1573857250463;
        Fri, 15 Nov 2019 14:34:10 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:09 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 15/20] ASoC: stm32: i2s: fix dma configuration
Date:   Fri, 15 Nov 2019 15:33:51 -0700
Message-Id: <20191115223356.27675-15-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit 1ac2bd16448997d9ec01922423486e1e85535eda upstream

DMA configuration is not balanced on start/stop.
Move DMA configuration to trigger callback.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 sound/soc/stm/stm32_i2s.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 6d0bf78d114d..449bb7049a28 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -488,7 +488,7 @@ static int stm32_i2s_configure(struct snd_soc_dai *cpu_dai,
 {
 	struct stm32_i2s_data *i2s = snd_soc_dai_get_drvdata(cpu_dai);
 	int format = params_width(params);
-	u32 cfgr, cfgr_mask, cfg1, cfg1_mask;
+	u32 cfgr, cfgr_mask, cfg1;
 	unsigned int fthlv;
 	int ret;
 
@@ -529,15 +529,11 @@ static int stm32_i2s_configure(struct snd_soc_dai *cpu_dai,
 	if (ret < 0)
 		return ret;
 
-	cfg1 = I2S_CFG1_RXDMAEN | I2S_CFG1_TXDMAEN;
-	cfg1_mask = cfg1;
-
 	fthlv = STM32_I2S_FIFO_SIZE * I2S_FIFO_TH_ONE_QUARTER / 4;
-	cfg1 |= I2S_CFG1_FTHVL_SET(fthlv - 1);
-	cfg1_mask |= I2S_CFG1_FTHVL_MASK;
+	cfg1 = I2S_CFG1_FTHVL_SET(fthlv - 1);
 
 	return regmap_update_bits(i2s->regmap, STM32_I2S_CFG1_REG,
-				  cfg1_mask, cfg1);
+				  I2S_CFG1_FTHVL_MASK, cfg1);
 }
 
 static int stm32_i2s_startup(struct snd_pcm_substream *substream,
@@ -589,6 +585,10 @@ static int stm32_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
 		/* Enable i2s */
 		dev_dbg(cpu_dai->dev, "start I2S\n");
 
+		cfg1_mask = I2S_CFG1_RXDMAEN | I2S_CFG1_TXDMAEN;
+		regmap_update_bits(i2s->regmap, STM32_I2S_CFG1_REG,
+				   cfg1_mask, cfg1_mask);
+
 		ret = regmap_update_bits(i2s->regmap, STM32_I2S_CR1_REG,
 					 I2S_CR1_SPE, I2S_CR1_SPE);
 		if (ret < 0) {
-- 
2.17.1

