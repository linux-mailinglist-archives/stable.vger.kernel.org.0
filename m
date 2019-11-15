Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440B3FE7E1
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfKOWeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:18 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40557 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfKOWeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:18 -0500
Received: by mail-pl1-f196.google.com with SMTP id e3so5627228plt.7
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FlA/WYoLeRABK4x8leOELB1KpW2VXeE/7KRkjFeheIs=;
        b=EuCYF29XK/mB/F3BxjT3sWX6z88YjtNqs+w5TNJQP6w08JiRou935ewYfWNAW/g3Eg
         FYlTO4DtoNdOTwlSxUFfeQtM32HB8UD4XiO9OLyVfO071D1lvVGMwJJWMxV7DW959l9H
         3cEwLuybSJy5RgNBVbsk3HFrKrWbg+s5SFLxWWx6v5gjbraobv8BFodgs84RA1TUiybx
         8wvlY+DBrzz7i+IYZ/fG8vjyNWly48fh5ZQWjCLhzQuBoYMt+ckcnb/GiIKLPGqHmTMR
         H6s2ATHNqRlbPvsQBZJwh0jEIKkumM1yU/gS+DXe538ozDU9zHQll5wun9QYpe4w15+l
         ifVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FlA/WYoLeRABK4x8leOELB1KpW2VXeE/7KRkjFeheIs=;
        b=V6bnBjNb2K0wCHcXhNLmWZL6KaG4NHkwvpVZ+IvveIbefmJCyWfM20/INm6UKSP7/T
         rlKRHthYl8euhK1MgCuF5jJ69nCF7HwsFhhgYo2U4iiYZn3WxCjVm8YNWI92wL12IjZF
         gRW5Dpa18hrhDN+fg0GxIHTM+bT/wZkOnbbajqxc8Ee2d1JQ/1li9fgi7ygv/6ggKNlk
         bVIxdE+PP4d/mA7Dd+5lQXzl5rjWEtgqavWJR8stqmUp6ataDrAmo/3rL3mqO/MXdsbd
         K/je7wEKY9Qgz8KrODhIcb6piAdjoJ/ZSlNRIRYGzi44ubK8cgEB4W/Jjn0mr9SdEbge
         z7Fw==
X-Gm-Message-State: APjAAAWCnTHsQmKCNBBKgyl1ijx0Vsw/32rEn/TVTJ+nOGkQO5R9oEXR
        PDxJjhCd5Ha+woVK6vcEEu45Z7zINbM=
X-Google-Smtp-Source: APXvYqwrPgGdAOCHvG+Dr9yqtqFxSjTdBheEMm1jF9StVEaJaadS7qR9/JmFNyQStGJT1dxmYiuHuQ==
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr22958192pje.117.1573857255728;
        Fri, 15 Nov 2019 14:34:15 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:15 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 20/20] dmaengine: stm32-dma: check whether length is aligned on FIFO threshold
Date:   Fri, 15 Nov 2019 15:33:56 -0700
Message-Id: <20191115223356.27675-20-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>

commit cc832dc8e32785a730ba07c3a357e17c201a5df8 upstream

When a period length is not multiple of FIFO some data may be stuck
within FIFO.

Burst/FIFO Threshold/Period or buffer length check has to be hardened

In any case DMA will grant any request from client but will degraded
any parameters whether awkward.

Signed-off-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/dma/stm32-dma.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index 379e8d534e61..4903a408fc14 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -308,20 +308,12 @@ static bool stm32_dma_fifo_threshold_is_allowed(u32 burst, u32 threshold,
 
 static bool stm32_dma_is_burst_possible(u32 buf_len, u32 threshold)
 {
-	switch (threshold) {
-	case STM32_DMA_FIFO_THRESHOLD_FULL:
-		if (buf_len >= STM32_DMA_MAX_BURST)
-			return true;
-		else
-			return false;
-	case STM32_DMA_FIFO_THRESHOLD_HALFFULL:
-		if (buf_len >= STM32_DMA_MAX_BURST / 2)
-			return true;
-		else
-			return false;
-	default:
-		return false;
-	}
+	/*
+	 * Buffer or period length has to be aligned on FIFO depth.
+	 * Otherwise bytes may be stuck within FIFO at buffer or period
+	 * length.
+	 */
+	return ((buf_len % ((threshold + 1) * 4)) == 0);
 }
 
 static u32 stm32_dma_get_best_burst(u32 buf_len, u32 max_burst, u32 threshold,
-- 
2.17.1

