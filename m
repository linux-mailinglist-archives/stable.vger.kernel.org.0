Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0521310E824
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfLBKD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:03:57 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36511 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfLBKD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:03:57 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so16574727wma.1
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RnwQaiFvjaJUW7N8MIQ/aT+fPISiZ2Sp2ScaNBJ2Tqo=;
        b=bL8aPSA+M/AVA12BBW2lbM8XWy1X5A95g2a7PtFm/e4BsqRYjl87jqaCfsJXBz28U7
         V7Bq7dpfwzKLTJoz/3RLo2SPsq3W952BssHgm00JbSwfPPhjLIrKSUeokmUo6ieqXz6F
         gOXyvtujdbr4QUAdXD1BPE3oXLIBQl2t7UyQSC8mFscGrUcz+evOIN6o0BWdBy1SkJbW
         p78/3z1bwEfwtxQriA487GpppDpo2i82va73vAP61ubCLe1TXwrwYvGKUnTk4K6tHgSO
         5nqB6dcp+voAX276wv4mzBIVBSAgw+2nftBApHxq/63qKMN35NPN6ri3yvq93X1bhcwl
         Jy7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RnwQaiFvjaJUW7N8MIQ/aT+fPISiZ2Sp2ScaNBJ2Tqo=;
        b=MALA84wcpcUgdH2JxsM7bwEfJjTB54SINS5cXClOOsuU55lGHBfAhQgPoQTGE4VMH5
         tShJ9ZlETvgKNm5vd4vm9g1HqKqX5ucJtNtrblT7hAb0xxzjW9Pbg3DAwmrITrEBZZf7
         qO0xzZmfEmf/r4DYI5F/Pml3HC2l3dBE5kD2hxGkq1729Xy0tMK31JqhE6IY7btpLMO1
         pkjLKg7EPQCzPsyRC32t+5T/QRFbqhWx0BNwGJO48awYGvhLFpVwhjm/YMClwiTJtRjy
         3RpsCTeIQgbET07S1looEY2tVUVL43sGEhQ/rOQiJK/LukML9GPcuw4ZHWhtJQPVjeEm
         6dlg==
X-Gm-Message-State: APjAAAVRsouyNk2VVILn25uQPDU0MtSZoLfse/xdajzHm0nWPY+sk/hB
        eyk1rTIlaxqhgtUyOYapotWX1fsGwzs=
X-Google-Smtp-Source: APXvYqwHfsNCHVzWAHT2s8PC0050ZPUrqeLpIoeW26E3t8bkEKywYJN/gdXxoQc1OUhqjPwoNX7uVQ==
X-Received: by 2002:a1c:61d7:: with SMTP id v206mr27475897wmb.13.1575281033837;
        Mon, 02 Dec 2019 02:03:53 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:53 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 06/14] net: macb: fix error format in dev_err()
Date:   Mon,  2 Dec 2019 10:03:04 +0000
Message-Id: <20191202100312.1397-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
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
index 2287749de087..bc9ab227d055 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2822,7 +2822,7 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		if (!err)
 			err = -ENODEV;
 
-		dev_err(&pdev->dev, "failed to get macb_clk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get macb_clk (%d)\n", err);
 		return err;
 	}
 
@@ -2831,7 +2831,7 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 		if (!err)
 			err = -ENODEV;
 
-		dev_err(&pdev->dev, "failed to get hclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to get hclk (%d)\n", err);
 		return err;
 	}
 
@@ -2845,25 +2845,25 @@ static int macb_clk_init(struct platform_device *pdev, struct clk **pclk,
 
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
 
@@ -3298,7 +3298,7 @@ static int at91ether_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 
-- 
2.24.0

