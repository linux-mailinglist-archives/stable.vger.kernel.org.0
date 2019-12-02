Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC5110E7D4
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfLBJmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:42:14 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35237 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbfLBJmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:42:13 -0500
Received: by mail-wm1-f68.google.com with SMTP id u8so6828113wmu.0
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=f8o2MHBmdU+g1TqYQB240FVyZ62ANhRFiNEs2ZZzTMU=;
        b=G+Tq1wpfbHC/arJWlfODhCe4Zc41PwwncqoRzWtAHlOmQPVtXpNIomtzxJb0kVqvrB
         FX+5ppYCSCDsVqn5TZUA1uL2rZieiZuXjmG0Iv2WTqMKzrYsQ+8eoaygjFo1cV9X+bik
         vFx1eO0IP0OmWRv+kOZmEPHY4lXr/wSRs4Of8NvKCSji8az0ZSWr76xx/I8s/p5Ezy4j
         BvzuIrhBF8ysEyjGzjqJucV7rygni4RXRTqev+NFCD2dBypIIiMyxePTXgKoHbLJSYCn
         MPu09Yp5bDu8ZgCTDzrXTPXte0xoqH/Hx62OfGgKeF+gh24czJGvCc6VY9UtFRhFIvm6
         1GhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f8o2MHBmdU+g1TqYQB240FVyZ62ANhRFiNEs2ZZzTMU=;
        b=GwrJIYjJD0fCz4VUeKOQLL3l/P/UGAHPKMUsLeYi9LUwW/0ocuTLpcLdXugfwBiH/c
         QI9dGS0uBEX4afBIZsyLL4VUynMKPOYIShWNpYnX2BcsNK8shM5MG2Tpf+XqrAUqCoO9
         32uTzpcy0/rHGfQGvBzHQCf6KyoFwT5oNymRxgydosC7lvEmS1IZUSjzeY9MCriV1l1R
         CkvlMXL7BUtCn0xUmYbAfMfc3F4DfjUizuvEoN0heM5ASB1xbuXYR5GdY4DR+4iqdRQB
         kCMqsNNeyyTCznQ+snAcEHhKJjzeixEuD8So8tSEhvWPGDPabaL3G6/dgVd4kUs6F3+/
         mlkg==
X-Gm-Message-State: APjAAAWmebnUVRbGqmnaq+H8D+SalISy2oSK+azwkaUbQ4aIW/xT//W2
        gtc1OsJzG0GcoK/PTKtCt2feOgycANc=
X-Google-Smtp-Source: APXvYqxBpEbno7nYnFRpb4HGtmJCdqjJhH8Nq60Gon5xt5EExKeYhNK22G0oGOI6FQhmzYRCBZkWnQ==
X-Received: by 2002:a7b:c1d3:: with SMTP id a19mr28354783wmj.127.1575279731645;
        Mon, 02 Dec 2019 01:42:11 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id w8sm990381wmm.0.2019.12.02.01.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:42:11 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 3/4] net: macb: fix error format in dev_err()
Date:   Mon,  2 Dec 2019 09:41:49 +0000
Message-Id: <20191202094150.32485-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202094150.32485-1-lee.jones@linaro.org>
References: <20191202094150.32485-1-lee.jones@linaro.org>
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
 drivers/net/ethernet/cadence/macb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 085f77f273ba..75bdb6aad352 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -2275,14 +2275,14 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
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
 
@@ -2292,19 +2292,19 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 
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
 
@@ -2704,7 +2704,7 @@ static int at91ether_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 
-- 
2.24.0

