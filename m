Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40DDD10CD33
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfK1Qu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:50:57 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36600 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfK1QuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:50:11 -0500
Received: by mail-pf1-f194.google.com with SMTP id b19so13393125pfd.3
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 08:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6rU2ZvHsnSzYwMs7Z05xUbhf11jabY6wDKJCR5AZiJ8=;
        b=xLaNPUaUIKXCW9bn1eGbhGpqCq44pw7uvqUvbHWA4HXNCC3j8wDWHuHJOglsgXtqSk
         WHKtLL/F++cUfpC9UOFnfKeZYczymLgalUAVwkbj2XQewDTZaY49MRx4nJHwuX2LQ22g
         hZCd2n+Fs45bxCw09A83bpNdll58/D85vKQUfLvPhdLeJGezwl2ddQlfKf/glagBUdp8
         1m8c/kJuqMChbyaZPNkYaMtKvkiReM3ynaPvfVHGYkjtbrEIXiSF6jmuEjWy5hUisEd3
         Mo7glQ+8H5q3aaptBsBgrOKcyZoZ596KJiz3lV9SYRpWfxNey2AXYAhCR4YSM6ExV8xq
         OwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6rU2ZvHsnSzYwMs7Z05xUbhf11jabY6wDKJCR5AZiJ8=;
        b=tHWW7zhUH6E6dNuTlto1Lg7Mzg68QgFndYh+w9HHiopnFvFOc476SRQKC+bNZvTuoh
         cmfCGf11JnriWKRLHamEy6elFPnUrkGLU0j7Boket4PxwTqNZkxgXQmT9N5cpR9oi5Ig
         cR0/wCjvju2mSGpOIcPb6bY+yuPj9W5yZx1/tmJdxbihG1woWFDPvp92Y39+EnYBG/Kb
         IduQQMq820cCrDpT/EGvvdWo83Q0CETTRdL+hAu7EBD398D1bkwmgI37GU+qi+xz4jyO
         Cj8r6e8cb9AX+cGA8QHKhJu9CLL02/vLDVc0URb0sm7/nMQliaaMIVuUWfvbwd/y+hRt
         gm1A==
X-Gm-Message-State: APjAAAUHaZxr1y3tdp8VIIl5sDD0qT2Y5fcbBf+y+UIRakaVOW/FCSC1
        G4pnWqYN8LbJAHSMh33rCCLlw5WuNzM=
X-Google-Smtp-Source: APXvYqwwS5sB68lbDlyVrgeTCJ16HYifOS/3Hk6LpNS+0KYfnvpq3hykK4GUDY5gN7r2/bWGXWlThQ==
X-Received: by 2002:a63:4547:: with SMTP id u7mr12360882pgk.423.1574959809102;
        Thu, 28 Nov 2019 08:50:09 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id a15sm2450343pfh.169.2019.11.28.08.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 08:50:08 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 05/17] hwrng: stm32 - fix unbalanced pm_runtime_enable
Date:   Thu, 28 Nov 2019 09:49:50 -0700
Message-Id: <20191128165002.6234-6-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128165002.6234-1-mathieu.poirier@linaro.org>
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lionel Debieve <lionel.debieve@st.com>

commit af0d4442dd6813de6e77309063beb064fa8e89ae upstream

No remove function implemented yet in the driver.
Without remove function, the pm_runtime implementation
complains when removing and probing again the driver.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/char/hw_random/stm32-rng.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 042860d97b15..37b338a76ba4 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -169,6 +169,13 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 	return devm_hwrng_register(dev, &priv->rng);
 }
 
+static int stm32_rng_remove(struct platform_device *ofdev)
+{
+	pm_runtime_disable(&ofdev->dev);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int stm32_rng_runtime_suspend(struct device *dev)
 {
@@ -210,6 +217,7 @@ static struct platform_driver stm32_rng_driver = {
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
+	.remove = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);
-- 
2.17.1

