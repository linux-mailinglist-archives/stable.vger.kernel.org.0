Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D090710E8E5
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfLBKbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54521 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLBKbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so21128594wmj.4
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CdaQIaHNfuGDVRU1iZt8C3kZ2l5NffXqnrKltL5Qaa8=;
        b=vYKuB40L99AVLE9Btij+3E6z7rjYJ1EM1VyOZbaxWdz+nUm1h/wGsQrglsDxXFfexb
         brOuMceoFyVHXwve4Ldm7imcheAq75h5DD7zIjZSMkUWTik0U4ig7HexLpQnWi+GKALO
         CMoJuTXZN+GEJZ2Ofbtrzevh6ciX5i+AL7Vf7BbbxVe9DhdYNE2Op3LE4pbUQ2acgfIO
         QM0hMIr42Hp+hl+QNzakGRp5g0Hm211SaOoL/wF6dX9VVorHyb4XrlHNtk+kHQ97v8Ai
         qP3VLsCeKnri+LvQRCMWNcR3xvkZzDdyZSjh9LuINfJAfCeNPLYhkyNi+YSVWYoYeOHZ
         WDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CdaQIaHNfuGDVRU1iZt8C3kZ2l5NffXqnrKltL5Qaa8=;
        b=SHlopr2kvGcPw9Z8s3G8eLUV6rzPUuwBNb89+D+HiUcaav/M/9Y1pZ6hwo1m9cYkv9
         +KJnGpRHPEs9bZvxHI6VLQqp8VDoe1l6FSlHc6QQi51IKrGhb29+M9XGFw2z/P8IDH7O
         cdxwJynwHFqCzn/SUium8Yt+JX9NyAKFAOF6IbtG5J3MGX/Edzc1PNrsouiF9bfcYxOS
         ap88b8qbNafBdN3lewWsRLXucavYWgu7Jkke3xjtz/8Dt2PDmC3Bs7edxJDhJ/LB4HNr
         65GAJrc5X1/K1CrL1C/wRufal3OP/cwTEnffTLd/7tBu26q9cL0CJZfZsaKa3ccsz3+E
         qocQ==
X-Gm-Message-State: APjAAAWzwfHO/NvzXO6ss2HONRWSuWm1uLUsu3cge1aNOFWpVu3b99c0
        +cH5sf7nS0MxMTs0RlOQ6ENMbRHhk10=
X-Google-Smtp-Source: APXvYqzxcMtxlLrYJIdT6qEnU8WvGRTgcg9CoecNdhx2moSJEXZZ+em01qf5m4t48mA0EQYWv1+avg==
X-Received: by 2002:a1c:e90b:: with SMTP id q11mr27103651wmc.125.1575282672746;
        Mon, 02 Dec 2019 02:31:12 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:12 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 07/15] net: macb: fix error format in dev_err()
Date:   Mon,  2 Dec 2019 10:30:42 +0000
Message-Id: <20191202103050.2668-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Ceresoli <luca@lucaceresoli.net>

[ Upstream commit f413cbb332a0b5251a790f396d0eb4ebcade5dec ]

Errors are negative numbers. Using %u shows them as very large positive
numbers such as 4294967277 that don't make sense. Use the %d format
instead, and get a much nicer -19.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Fixes: b48e0bab142f ("net: macb: Migrate to devm clock interface")
Fixes: 93b31f48b3ba ("net/macb: unify clock management")
Fixes: 421d9df0628b ("net/macb: merge at91_ether driver into macb driver")
Fixes: aead88bd0e99 ("net: ethernet: macb: Add support for rx_clk")
Fixes: f5473d1d44e4 ("net: macb: Support clock management for tsu_clk")
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index f175b20ac510..d98077ab306b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3328,7 +3328,7 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		if (!err)
 			err = -ENODEV;
 
-		dev_err(&pdev->dev, "failed to get macb_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get macb_clk (%d)\n", err);
 		return err;
 	}
 
@@ -3337,7 +3337,7 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		if (!err)
 			err = -ENODEV;
 
-		dev_err(&pdev->dev, "failed to get hclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get hclk (%d)\n", err);
 		return err;
 	}
 
@@ -3351,25 +3351,25 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 
 	err = clk_prepare_enable(*hclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable hclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable hclk (%d)\n", err);
 		goto err_disable_pclk;
 	}
 
 	err = clk_prepare_enable(*tx_clk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable tx_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable tx_clk (%d)\n", err);
 		goto err_disable_hclk;
 	}
 
 	err = clk_prepare_enable(*rx_clk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable rx_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable rx_clk (%d)\n", err);
 		goto err_disable_txclk;
 	}
 
@@ -3839,7 +3839,7 @@ static int at91ether_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 
-- 
2.24.0

