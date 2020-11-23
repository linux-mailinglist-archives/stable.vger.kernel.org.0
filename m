Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7E82C0BC7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbgKWNa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:30:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730329AbgKWM1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:27:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E91D208C3;
        Mon, 23 Nov 2020 12:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134470;
        bh=B0HIVhOOFgPqMRT5qB5gRrANqaf0nGkWUCvrnaJBgVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhTRcmy7YhB5mAPmz0d+jFwpCTImZvbsZQ9rb0IkMGGCgpfdsQ3gGVJdh0shNYnGl
         pyQ1qa6KUAJzcY7QBtgXFcTlH8ZbumLc4KMVjAM9PoboOvjcBw4hS8linx/FB1WNro
         ETVAdNkwpIlm3U01TmYCiPggGAXe4JnUqkFxEl24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/60] can: ti_hecc: Fix memleak in ti_hecc_probe
Date:   Mon, 23 Nov 2020 13:22:14 +0100
Message-Id: <20201123121806.591554330@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
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
index db6ea936dc3fc..81a3fdd5e0103 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -903,7 +903,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->base)) {
 		dev_err(&pdev->dev, "hecc ioremap failed\n");
-		return PTR_ERR(priv->base);
+		err = PTR_ERR(priv->base);
+		goto probe_exit_candev;
 	}
 
 	/* handle hecc-ram memory */
@@ -916,7 +917,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->hecc_ram = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->hecc_ram)) {
 		dev_err(&pdev->dev, "hecc-ram ioremap failed\n");
-		return PTR_ERR(priv->hecc_ram);
+		err = PTR_ERR(priv->hecc_ram);
+		goto probe_exit_candev;
 	}
 
 	/* handle mbx memory */
@@ -929,13 +931,14 @@ static int ti_hecc_probe(struct platform_device *pdev)
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
@@ -988,7 +991,7 @@ probe_exit_clk:
 	clk_put(priv->clk);
 probe_exit_candev:
 	free_candev(ndev);
-probe_exit:
+
 	return err;
 }
 
-- 
2.27.0



