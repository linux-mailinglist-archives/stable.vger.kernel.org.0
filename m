Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364E2FE7E0
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfKOWeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:15 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40386 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfKOWeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:14 -0500
Received: by mail-pf1-f196.google.com with SMTP id r4so7330267pfl.7
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K6EZMz28tei+A3Fv/t1+BOEFoAHrbvWtLCwNz1ul25g=;
        b=K+EFQOwvuF5Ea8JFTFkHmNjxaOLY3h/RqojbKXq9i/HQlhlztvlHNcN78FEt9TXC6o
         gSUamhTirK9XvaurkQpqxAGX9vGVxHMdQiaEQWdY4pU3qEj4HzoubKBVTea2SyfoaOJK
         BPCTKzxPUfEL6BWFoVxIfRmwHA4tUCwpDJ2n4SjysulPcZeL7QSTvBqV9U6sa5+BoRxN
         ByG3lYAWlD6MNyS7zATy/bbUyGMR05gPdPv2GsQzG7CJCDbPYpfG/4kCkSVGAS68F2K6
         gbCm66gHeb8hSy4KH2drGGvctHA7MuK4Ym++2SmPIVbJl9j9cJZ4kkEEVL0bmc7yyJmw
         rdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K6EZMz28tei+A3Fv/t1+BOEFoAHrbvWtLCwNz1ul25g=;
        b=MScaxir+eN1s66nMwFPntzVyhDjFWdkfiPi5da3iPPZp1f0BToF6pBa8EeoI00eg8F
         KeuqAgFyaJCMSlV6hWcTpP/o3jUvVNgAzYDVNIezyWyqYOM2tLPMnWhumJxR1BReVoYB
         i0F0zZFFjFvyyn0Vpay6u28xCtuezOAAavYIFLuhmjypmEbamYV07WwLtfcjmsR+R60R
         OvjNzrs89BahR/pSTXa7sJAZPTtVCgkec7slM/nAymbBJh6g7BUvgm2uOpS8fRVMgoDA
         i3hWy207SQpDw7ZRYzFWIHK+DIK5fJWLYlMcIKxzlwFMCxIOkX5CR7iND+iJQQ3rWypj
         PM+Q==
X-Gm-Message-State: APjAAAX6su7YzWaCq0VOhZ1UFJLw4dSLP5W70En30+1dh0A0i7fpbYIN
        D2s3Y8HDGE6J1EAV2cqX3NIeAtjbmpM=
X-Google-Smtp-Source: APXvYqwwG/XpWrw8NucKWEIVOJTEWpsvZTO9ZLZ6W3FY/qZdC0OPiY33DETIGgqjWtA92DNeccpTNQ==
X-Received: by 2002:a62:447:: with SMTP id 68mr20154481pfe.70.1573857252596;
        Fri, 15 Nov 2019 14:34:12 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:11 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 17/20] ASoC: stm32: i2s: fix IRQ clearing
Date:   Fri, 15 Nov 2019 15:33:53 -0700
Message-Id: <20191115223356.27675-17-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit 8ba3c5215d69c09f5c39783ff3b78347769822ad upstream

Because of regmap cache, interrupts may not be cleared
as expected.
Declare IFCR register as write only and make writings
to IFCR register unconditional.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 sound/soc/stm/stm32_i2s.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 004d83091505..aa2b1196171a 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -246,8 +246,8 @@ static irqreturn_t stm32_i2s_isr(int irq, void *devid)
 		return IRQ_NONE;
 	}
 
-	regmap_update_bits(i2s->regmap, STM32_I2S_IFCR_REG,
-			   I2S_IFCR_MASK, flags);
+	regmap_write_bits(i2s->regmap, STM32_I2S_IFCR_REG,
+			  I2S_IFCR_MASK, flags);
 
 	if (flags & I2S_SR_OVR) {
 		dev_dbg(&pdev->dev, "Overrun\n");
@@ -276,7 +276,6 @@ static bool stm32_i2s_readable_reg(struct device *dev, unsigned int reg)
 	case STM32_I2S_CFG2_REG:
 	case STM32_I2S_IER_REG:
 	case STM32_I2S_SR_REG:
-	case STM32_I2S_IFCR_REG:
 	case STM32_I2S_TXDR_REG:
 	case STM32_I2S_RXDR_REG:
 	case STM32_I2S_CGFR_REG:
@@ -547,8 +546,8 @@ static int stm32_i2s_startup(struct snd_pcm_substream *substream,
 	i2s->refcount++;
 	spin_unlock(&i2s->lock_fd);
 
-	return regmap_update_bits(i2s->regmap, STM32_I2S_IFCR_REG,
-				  I2S_IFCR_MASK, I2S_IFCR_MASK);
+	return regmap_write_bits(i2s->regmap, STM32_I2S_IFCR_REG,
+				 I2S_IFCR_MASK, I2S_IFCR_MASK);
 }
 
 static int stm32_i2s_hw_params(struct snd_pcm_substream *substream,
@@ -603,8 +602,8 @@ static int stm32_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
 			return ret;
 		}
 
-		regmap_update_bits(i2s->regmap, STM32_I2S_IFCR_REG,
-				   I2S_IFCR_MASK, I2S_IFCR_MASK);
+		regmap_write_bits(i2s->regmap, STM32_I2S_IFCR_REG,
+				  I2S_IFCR_MASK, I2S_IFCR_MASK);
 
 		if (playback_flg) {
 			ier = I2S_IER_UDRIE;
-- 
2.17.1

