Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE8B2C0710
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbgKWMhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:37:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731883AbgKWMhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:37:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 069C32065E;
        Mon, 23 Nov 2020 12:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135028;
        bh=wDQ+6gq8lu/THGFYd719e9zdFYhFd8OvRz97iK/S3hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmJPvBfJyeL6wPZvw9Ub7W0m/3o7TkLp3lQO0ItNoKVDNX9pRPYJ3z2s3T03dwhVq
         TUq25pSFQ5UEg7QHLaUAfxOYmxN//9ytfa8JcJmf7MCVaqOWlKwXlIee4eN5WqbgcE
         0T7sVViHGqZpXSu6qv2oYttI94lCgS5ELzT9nVFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/158] can: ti_hecc: Fix memleak in ti_hecc_probe
Date:   Mon, 23 Nov 2020 13:21:46 +0100
Message-Id: <20201123121823.701897783@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 7968c7c79d3be8987feb8021f0c46e6866831408 ]

In the error handling, we should goto the probe_exit_candev
to free ndev to prevent memory leak.

Fixes: dabf54dd1c63 ("can: ti_hecc: Convert TI HECC driver to DT only driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201114111708.3465543-1-zhangqilong3@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/ti_hecc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index d3a7631eecaf2..d0a05fc5cc32f 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -873,7 +873,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->base)) {
 		dev_err(&pdev->dev, "hecc ioremap failed\n");
-		return PTR_ERR(priv->base);
+		err = PTR_ERR(priv->base);
+		goto probe_exit_candev;
 	}
 
 	/* handle hecc-ram memory */
@@ -886,7 +887,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->hecc_ram = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->hecc_ram)) {
 		dev_err(&pdev->dev, "hecc-ram ioremap failed\n");
-		return PTR_ERR(priv->hecc_ram);
+		err = PTR_ERR(priv->hecc_ram);
+		goto probe_exit_candev;
 	}
 
 	/* handle mbx memory */
@@ -899,13 +901,14 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->mbx = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->mbx)) {
 		dev_err(&pdev->dev, "mbx ioremap failed\n");
-		return PTR_ERR(priv->mbx);
+		err = PTR_ERR(priv->mbx);
+		goto probe_exit_candev;
 	}
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq) {
 		dev_err(&pdev->dev, "No irq resource\n");
-		goto probe_exit;
+		goto probe_exit_candev;
 	}
 
 	priv->ndev = ndev;
@@ -969,7 +972,7 @@ probe_exit_release_clk:
 	clk_put(priv->clk);
 probe_exit_candev:
 	free_candev(ndev);
-probe_exit:
+
 	return err;
 }
 
-- 
2.27.0



