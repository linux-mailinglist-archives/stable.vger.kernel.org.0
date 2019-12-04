Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA111318E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbfLDSA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729348AbfLDSA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:00:27 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 954C820881;
        Wed,  4 Dec 2019 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482426;
        bh=7u8/GhN6bT6ZtAxp590wsbZd5QQK+pGhbZCcuSqFDc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMMwlj9X+Htgkj9hb3iCByxdK/k8Nj/Dp0PEFFDJG8K0kQQ4ISgMRRqxffGzlY3yD
         HNNbLgFYX1QNz63jhS8OmOwrcXyayCqtbbIKmM36MFgmTdjR1I7T0K1Nstgi2jzA0l
         ijEekTMWm+BR8TrUdR+grp5elhWxxv5cJcuofw3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Ceresoli <luca@lucaceresoli.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 81/92] net: macb: fix error format in dev_err()
Date:   Wed,  4 Dec 2019 18:50:21 +0100
Message-Id: <20191204174335.083362358@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Ceresoli <luca@lucaceresoli.net>

commit f413cbb332a0b5251a790f396d0eb4ebcade5dec upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/cadence/macb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -2275,14 +2275,14 @@ static int macb_clk_init(struct platform
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
 
@@ -2292,19 +2292,19 @@ static int macb_clk_init(struct platform
 
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
 
@@ -2704,7 +2704,7 @@ static int at91ether_clk_init(struct pla
 
 	err = clk_prepare_enable(*pclk);
 	if (err) {
-		dev_err(&pdev->dev, "failed to enable pclk (%u)\n", err);
+		dev_err(&pdev->dev, "failed to enable pclk (%d)\n", err);
 		return err;
 	}
 


