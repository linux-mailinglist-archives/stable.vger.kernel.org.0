Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04701268C58
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 15:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgINNi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 09:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgINNhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 09:37:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422FEC061351;
        Mon, 14 Sep 2020 06:37:52 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c18so18757936wrm.9;
        Mon, 14 Sep 2020 06:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=07LfpwukpmTeG70upPXM1ceHmoutqYVR0coB+0ggDoI=;
        b=MGzE+KCln2rDlWU1eor1MDlnrGu6r4T9HJnQcZfGGdYlBsSLzOuOKiZmi/RtTeCWsh
         PMFpPh35W8yjk3tKQsF4ZvlYO3/Ozbc26pqBrCXTqP6QTscaqsPQ+jor9OAiqd3P8T21
         3pMl9gPdP7rXbspX1NNpdGWMDUlsC//0sGdmtcPgEsYf/GpbHoPbDDHikmh9BZAEU4ki
         EoIZlp6JLAQfC0+ueN8Xv6qnLS5WFOJYj1wzSyzPHkGdN7WPIPDhg2GcW2jttgGr2Xfh
         3vaFf8L1Js5VoKx0WLJoIQ7f1OyOwm2JNPU8wcJcIJNLmo/y5ui4b8HSGEuRc6XZopIk
         w2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=07LfpwukpmTeG70upPXM1ceHmoutqYVR0coB+0ggDoI=;
        b=forROESNbABpZQBdRKnXP97WJU0T6KeQ6pi10CSLjYRXluwyoI0/lKhrE8nv+qU3vH
         jJZ+xMps5GT9slUeDkPSfeH+yNxV0aZLWp8H4QfdahXbNSdiy2hQ0mow+l5160CZJ+Or
         33SugaN4qR1KiIp3/QAJhfWpEiZudJyZkZ4NLbbJHxmGxbL1Mr4Qz4HUIYyca6hbmicq
         mTV9ADhME1w/HReYlRBTXXs1u6YACzBOYbsf4s3kAD6v6XTcJZFAs1xyEWDb6/+Qc9eT
         zkqSE98lQAOuiPIPxcqMFOj4QruLjpsQuiAHgMRj8S8JkAJVNRrSyIxjjk7bzT3NWI+d
         qEpw==
X-Gm-Message-State: AOAM533JiGlO09n75PK8B1wUtnXqEe/Et/48K1B2s/5RZJeEsvs3U/mo
        Z4KyUxBYTh3rHM2hMAdTVoA=
X-Google-Smtp-Source: ABdhPJwOX30ps/KDJqJPmeNlxoDcQHCf41blysDKip2XcAupmMDfIO/EoCW16fLZhFmxwma2jVaUNw==
X-Received: by 2002:adf:8b1d:: with SMTP id n29mr15420779wra.383.1600090671007;
        Mon, 14 Sep 2020 06:37:51 -0700 (PDT)
Received: from arrakis.kwizart.net (lfbn-nic-1-212-171.w2-15.abo.wanadoo.fr. [2.15.59.171])
        by smtp.gmail.com with ESMTPSA id a11sm18532488wmm.18.2020.09.14.06.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 06:37:50 -0700 (PDT)
From:   Nicolas Chauvet <kwizart@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>
Cc:     linux-tegra@vger.kernel.org, Nicolas Chauvet <kwizart@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] ARM: tegra: Avoid setting edp_irq when not relevant
Date:   Mon, 14 Sep 2020 15:37:39 +0200
Message-Id: <20200914133739.60020-5-kwizart@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200914133739.60020-1-kwizart@gmail.com>
References: <20200914133739.60020-1-kwizart@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the binding, the edp_irq is not available on tegra124/132

This commit moves the initialization of tegra->edp_irq after the
introduced SoCs condition. This will have the following effects:
 - soctherm_interrupts_init will not return prematurely with unfinished
thermal_irq initialization on tegra124 and tegra132
 - edp_irq initialization will be bypassed when not relevant

As a result, this will clear the following error when loading the driver:
  kernel: tegra_soctherm 700e2000.thermal-sensor: IRQ index 1 not found

Fixes: 4a04beb1bf2e (thermal: tegra: add support for EDP IRQ)
Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Chauvet <kwizart@gmail.com>
---
 drivers/thermal/tegra/soctherm.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/tegra/soctherm.c b/drivers/thermal/tegra/soctherm.c
index 66e0639da4bf..0a7dc988f25f 100644
--- a/drivers/thermal/tegra/soctherm.c
+++ b/drivers/thermal/tegra/soctherm.c
@@ -2025,12 +2025,6 @@ static int soctherm_interrupts_init(struct platform_device *pdev,
 		return 0;
 	}
 
-	tegra->edp_irq = platform_get_irq(pdev, 1);
-	if (tegra->edp_irq < 0) {
-		dev_dbg(&pdev->dev, "get 'edp_irq' failed.\n");
-		return 0;
-	}
-
 	ret = devm_request_threaded_irq(&pdev->dev,
 					tegra->thermal_irq,
 					soctherm_thermal_isr,
@@ -2043,6 +2037,17 @@ static int soctherm_interrupts_init(struct platform_device *pdev,
 		return ret;
 	}
 
+	/* None of the tegra124 and tegra132 SoCs have edp_irq */
+	if (of_machine_is_compatible("nvidia,tegra124") ||
+		of_machine_is_compatible("nvidia,tegra132"))
+			return 0;
+
+	tegra->edp_irq = platform_get_irq(pdev, 1);
+	if (tegra->edp_irq < 0) {
+		dev_dbg(&pdev->dev, "get 'edp_irq' failed.\n");
+		return 0;
+	}
+
 	ret = devm_request_threaded_irq(&pdev->dev,
 					tegra->edp_irq,
 					soctherm_edp_isr,
-- 
2.25.4

