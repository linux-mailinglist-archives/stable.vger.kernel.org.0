Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045082C0845
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732805AbgKWMrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732721AbgKWMrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8FD72100A;
        Mon, 23 Nov 2020 12:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135615;
        bh=96Ig/gGRerfzv0ZjBacyI+loKSft5qgvRfL/yMC9LqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqyIXE8g6t8Y2VSBkbGZcAYiVw4C5Fa9hJDga2fAaa3SQbwvyvJOoBhcPf6RSbbMu
         nJuTI8dNqPwMW4gupEkmziY5QYmDfbQYzjPSH7J8iElYobxftpJ1x4HB17f8IrdJ4/
         DkG6M9+72DqfDam7nOB5YHxSclOWWxLYRHbJjX8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 132/252] can: ti_hecc: Fix memleak in ti_hecc_probe
Date:   Mon, 23 Nov 2020 13:21:22 +0100
Message-Id: <20201123121841.966798321@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
index 228ecd45ca6c1..0e8b5df7e9830 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -887,7 +887,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->base)) {
 		dev_err(&pdev->dev, "hecc ioremap failed\n");
-		return PTR_ERR(priv->base);
+		err = PTR_ERR(priv->base);
+		goto probe_exit_candev;
 	}
 
 	/* handle hecc-ram memory */
@@ -900,7 +901,8 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv->hecc_ram = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->hecc_ram)) {
 		dev_err(&pdev->dev, "hecc-ram ioremap failed\n");
-		return PTR_ERR(priv->hecc_ram);
+		err = PTR_ERR(priv->hecc_ram);
+		goto probe_exit_candev;
 	}
 
 	/* handle mbx memory */
@@ -913,13 +915,14 @@ static int ti_hecc_probe(struct platform_device *pdev)
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
@@ -983,7 +986,7 @@ probe_exit_release_clk:
 	clk_put(priv->clk);
 probe_exit_candev:
 	free_candev(ndev);
-probe_exit:
+
 	return err;
 }
 
-- 
2.27.0



