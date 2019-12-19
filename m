Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E652126CBF
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbfLSSpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbfLSSpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:45:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02DB524680;
        Thu, 19 Dec 2019 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781104;
        bh=3VNEd7+Cg52QHZ9FW9lyN5zK3Oxm3jwhX5bKLK8++pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbPv2MstKl8nW+xYVEyOQB58Yv7E2nLE8eRMFV58sbSfCfKQtaJxaxlzFyI38AR2q
         l0TnB3tgZERTFwTTRgd2F7V1VFw8bn3wvyNysDY4PYjVWg5NkvyqWCDm2DVbx9Tx2M
         ZcTsxUX8ITBwHmWEDOiJAhIVz853rborjmT8iAbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 045/199] i2c: imx: dont print error message on probe defer
Date:   Thu, 19 Dec 2019 19:32:07 +0100
Message-Id: <20191219183217.438890671@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit fece4978510e43f09c8cd386fee15210e8c68493 ]

Probe deferral is a normal operating condition in the probe function,
so don't spam the log with an error in this case.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index c4188308cefae..9c1be9378dfde 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1088,7 +1088,8 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	/* Get I2C clock */
 	i2c_imx->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(i2c_imx->clk)) {
-		dev_err(&pdev->dev, "can't get I2C clock\n");
+		if (PTR_ERR(i2c_imx->clk) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "can't get I2C clock\n");
 		return PTR_ERR(i2c_imx->clk);
 	}
 
-- 
2.20.1



