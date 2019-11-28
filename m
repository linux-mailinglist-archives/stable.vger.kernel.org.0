Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE5710CD18
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfK1QuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:50:23 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36604 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfK1QuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:50:21 -0500
Received: by mail-pl1-f193.google.com with SMTP id d7so11814815pls.3
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 08:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ve1daf/mMGyyV9VtqaD9VZ+drFrdziUeyzqFEa1bEX8=;
        b=QdfKOwx2OJabOfCqE3mEGZgTrv2/gWtfc9aPsAegxShDlcJFxfod9xbR8qUpaUSrKA
         lN+swYwLnlgLgrSviR4JWJihJonMpuhy7wXqHAnmUInK0mv8323jJHcCIE4QGYw2lsZH
         q8oKAydylvf86RpUa4wuc+K76Mk8Yr0z0Bp0mJmTZlYpbNQelJuy2w772CJ365QXJ0hK
         sJQROf9qRH30ngnifsT6wcvVfOsqo0OHmynT5HckidI/ew0Z7ofqawUkSOMQO/qEzAcp
         C1v01meXvQFJRnBwVFxCG2S+pRY6T9NkCdPIOWPZspbfiwTUWLVf5twPkpqtU/z0nBQI
         nIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ve1daf/mMGyyV9VtqaD9VZ+drFrdziUeyzqFEa1bEX8=;
        b=tkdlmQdNTIw6ZQH7ytmRljZVi/da/Ekxap0KCkmsDUjfKeX0UidBKZvQ7wxWFEKruB
         0wWfGzH33V1yNmtJXyxumSwa/pvoMfSGag5nAhbFko2KtnPNpzZ86K/NKqylplNImb10
         jK3q3b4xz2TN2gsBm3CxpNlI42XDJMoX25KC+/V1+xeSZAzuFwYzFONnbBZcnJziYAOE
         pg/1HK7RNH+Zz75DAK1wKnYXqrjjm5MMnzldENe34/PfDjXi8lCaMgAECKyzj9+9+nMb
         NA01Kt6iQzE59GZT/rtj/HLKMX8Lyx+zU635UEPP9z9OGa/obwasdT3+LI0Z22MIrNGb
         7mrA==
X-Gm-Message-State: APjAAAUGrlkPYDWV+0iRxVZAX6nnszdmDlyt+HaQHrPMdkeQ5n2mzwF0
        i5qfjMHhl+CLA3O2OptwtPhdB5Rmw1w=
X-Google-Smtp-Source: APXvYqwF9EpUID9uoRJaTP7XOptfqBdu8zh2mx1l+skezdxU/+nVZEZ0krSH/BIt3st7U3Is4b6ZnQ==
X-Received: by 2002:a17:902:b181:: with SMTP id s1mr10698227plr.62.1574959820186;
        Thu, 28 Nov 2019 08:50:20 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id a15sm2450343pfh.169.2019.11.28.08.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 08:50:19 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 17/17] dmaengine: stm32-dma: check whether length is aligned on FIFO threshold
Date:   Thu, 28 Nov 2019 09:50:02 -0700
Message-Id: <20191128165002.6234-18-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128165002.6234-1-mathieu.poirier@linaro.org>
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
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
Cc: stable <stable@vger.kernel.org> # 4.19
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

