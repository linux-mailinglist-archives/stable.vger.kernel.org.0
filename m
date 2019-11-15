Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 607DEFE7FE
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfKOWfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:35:01 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37233 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfKOWeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:05 -0500
Received: by mail-pg1-f196.google.com with SMTP id z24so6639382pgu.4
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I8DYLlgbe7crhAhNbwNPqGy2McaZWO3AECdzJYJCCco=;
        b=uq0Rvs0KPR5i9HtlAfbqJ09ftst7366sxovqlgQSCdSMlx7zsOEFlsXzxIZ/RFJepW
         +xNmN50KWjZEmZ4ahwYGYncO2oNSlvlk9+bSZ0uJj5KwnzYGnYwwpJh3Z0U0CVVPUgeF
         WBek2r2DnpcVe5urx/INF76BoO8wqFwuN86lGWJuCvpErfOgoUCoWWPI37s5pI2Uuw9X
         OEj1WNleT7NOb7K1+oFm34vXUlCdixUaNsyhZrrKKyzZ34tRHBi5jpoqITPilNH4uc3A
         cG9Aay+Ra1kWvl+WOeF5ifVv++jVQtvf2AnAcuQ92MtUnevyPsRG5Pf0brxRmVhP9TbT
         u6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I8DYLlgbe7crhAhNbwNPqGy2McaZWO3AECdzJYJCCco=;
        b=WV7WXdgGSCrXxlIw41GvWGuyB4u36P41J4TkeAStFlPupksrSIiyHoVtcvLSS5cSLm
         jjwtvCR+RdJolabUdw0n9yEvovd6sH+GcBrZSsl/e4cubv6ZaUDAds/Mm+g2Prf3FrLv
         4lFlb8WS0zK28HlLiQBG1P6dhbFqylSYQSOrHps0Abz1M7BH8DQh/E3cmHb99zPcRHMF
         iPkUqEs6SB1NqI1ZQ1YQ8jWYJ340UVC918pUu4/R7HzPGZq/URkg5EeAVDTxraBbkLmk
         4HyeMPDcseu/B6dg6BkvBTbZXTncgkvK+7lyGHsxtJVXLW0vmi11UK9FEj15d13SAN18
         VBrg==
X-Gm-Message-State: APjAAAUuSSwC/e40nkFXALMAs9qv/Oq9pHK20rP4roPdVbn7tdeWOde9
        TYPufPWZ+vGYTXIN5dZHLVHlnX2niE8=
X-Google-Smtp-Source: APXvYqytHqdgYw+McewKp6L1IK0RR+uPnytQnNFy3RGnQfrkQ+RNzORO54L3aq41JZ6v3SKIJheJ4A==
X-Received: by 2002:a63:2e01:: with SMTP id u1mr19770443pgu.25.1573857243342;
        Fri, 15 Nov 2019 14:34:03 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:02 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 07/20] hwrng: stm32 - fix unbalanced pm_runtime_enable
Date:   Fri, 15 Nov 2019 15:33:43 -0700
Message-Id: <20191115223356.27675-7-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
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
Cc: stable <stable@vger.kernel.org> # 4.19+
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

