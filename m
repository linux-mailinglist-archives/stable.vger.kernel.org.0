Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7176210E7F0
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfLBJuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:50:35 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43621 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfLBJuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:50:35 -0500
Received: by mail-wr1-f68.google.com with SMTP id n1so43370918wra.10
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cwSTsKyp+VB/yrtk55Z3QdqURnT8SdzS6bse74wQ6jk=;
        b=L8rGxBrvBN4zhJoD7z3/4BPgF4sx4kYC1FH/wRUev01IT9jPUyxx6WL+MgsE4qOjkR
         F2SxNeRQtZd9oIoIgr5WfRRjLiLlVVgGN1iNO59Y+/VfDJrnZVft1Mv8m0lofkJMIdLn
         679rRZoCSJtIw2fZVWt3HShMKX+PW9xieNwvuapCY/9OyR4b9RDaJ6w6uxXBP7KJyYe8
         efI//8FgZrqLE5X3Bdk5Mkf28i/Q1M3GVIi0xAGxgqvF1PbeW960cIm/LtKRmHGtC7vB
         ZMbqv+A4/LzyahZSYQJ9lmzuIYCd52j1ppa7XFU7fmktnnEY4rGjeqDMyuV/qqf+beFD
         9HSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cwSTsKyp+VB/yrtk55Z3QdqURnT8SdzS6bse74wQ6jk=;
        b=dwP73ILMhTJvD+FyoufHd1INQwAF9CakKQY6bAZEXpnFiPIpjCB1CGtTfBQoimYpqS
         XqnUiPpn92kyUSWE9wXaKK4Qa8KFPq2lrtY8IcYnKB+zIaNumfqxKsBUjHQiUyDSB7oL
         +LJv1v1jhfC6mI/SB9lbFFMS9ZAFRg/aFCvLO8uN9pBBj8um323wun02Vgcj9gGr9iwU
         Nljq5yNplXpBxjnqU2nKwY4Xom0UTbzjpzjXsebrurXzl2GiLDOZG1Mt+N9T7YeKNxGg
         hxTP6kTIuKBtWfSYY21gYFRd+RirKDx8xOAng9FcaBbqHDFtXf55UY4joxVH77qsF2OQ
         pehA==
X-Gm-Message-State: APjAAAUoAAOQXS7fHjxP5ZQVRfiqS7dSNfM4ncenFo3TKT8yimLMpzZj
        5LRfQvSBjAkUueErkKjcycRjQY5jIwY=
X-Google-Smtp-Source: APXvYqzC7EAZDdHpzDedvgekdoUveP0VRedY0ArltIFz0CUqMM6kyBJDzZ8oSzMqGr6JOB/CrDolZA==
X-Received: by 2002:adf:ea4e:: with SMTP id j14mr19775324wrn.101.1575280232603;
        Mon, 02 Dec 2019 01:50:32 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id l3sm4629698wrt.29.2019.12.02.01.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:50:32 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 4/6] net: macb: fix error format in dev_err()
Date:   Mon,  2 Dec 2019 09:50:10 +0000
Message-Id: <20191202095012.559-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202095012.559-1-lee.jones@linaro.org>
References: <20191202095012.559-1-lee.jones@linaro.org>
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
 drivers/net/ethernet/cadence/macb.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index a0d640243df2..30e93041bf83 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -2364,14 +2364,14 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 	*pclk = devm_clk_get(&pdev->dev, "pclk");
 	if (IS_ERR(*pclk)) {
 		err = PTR_ERR(*pclk);
-		dev_err(&pdev->dev, "failed to get macb_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get macb_clk (%d)\n", err);
 		return err;
 	}
 
 	*hclk = devm_clk_get(&pdev->dev, "hclk");
 	if (IS_ERR(*hclk)) {
 		err = PTR_ERR(*hclk);
-		dev_err(&pdev->dev, "failed to get hclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get hclk (%d)\n", err);
 		return err;
 	}
 
@@ -2385,25 +2385,25 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 
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
 
@@ -2823,7 +2823,7 @@ static int at91ether_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 
-- 
2.24.0

