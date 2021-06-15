Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63913A84BA
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhFOPvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232105AbhFOPv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 922F16148E;
        Tue, 15 Jun 2021 15:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772162;
        bh=R2z5GIrmCya7sg7LqFVvlexetXRp+JisOWiVMnKGpXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R37UBIH/NmonYakUCO1inhDcL6FUTs6hQGt2XHXzpE85VHUaDEaL9mwAF8Q1qaq6J
         C6kEpeOZ2U1gi/zmw3whDY7YZvuelfEBO53RPE+0/cDrKf+fSC4uci/ZuZxoXiyShp
         qO3VF0b7b45Y2LROivcRpgJ7yhgIBU5R6adxksFnsMTJMkwFYOHAcOSQTAVYPav9dt
         vtRdyiGQOhPf4q2URlUETOeXULJYQCxf3Stqt+tyAWCl8x1X8mntfzUFvUeokf/Nl3
         TS1MwnqxegMveENF8+Lo8oCWSkPKF41ZC+j6XlW/AKWJuFTWhnRCov/KaPAMY+GxUF
         pUsprxIX8gfHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zpershuai <zpershuai@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 11/30] spi: spi-zynq-qspi: Fix some wrong goto jumps & missing error code
Date:   Tue, 15 Jun 2021 11:48:48 -0400
Message-Id: <20210615154908.62388-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zpershuai <zpershuai@gmail.com>

[ Upstream commit f131767eefc47de2f8afb7950cdea78397997d66 ]

In zynq_qspi_probe function, when enable the device clock is done,
the return of all the functions should goto the clk_dis_all label.

If num_cs is not right then this should return a negative error
code but currently it returns success.

Signed-off-by: zpershuai <zpershuai@gmail.com>
Link: https://lore.kernel.org/r/1622110857-21812-1-git-send-email-zpershuai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynq-qspi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index 5d8a5ee62fa2..79863c889e18 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -679,14 +679,14 @@ static int zynq_qspi_probe(struct platform_device *pdev)
 	xqspi->irq = platform_get_irq(pdev, 0);
 	if (xqspi->irq <= 0) {
 		ret = -ENXIO;
-		goto remove_master;
+		goto clk_dis_all;
 	}
 	ret = devm_request_irq(&pdev->dev, xqspi->irq, zynq_qspi_irq,
 			       0, pdev->name, xqspi);
 	if (ret != 0) {
 		ret = -ENXIO;
 		dev_err(&pdev->dev, "request_irq failed\n");
-		goto remove_master;
+		goto clk_dis_all;
 	}
 
 	ret = of_property_read_u32(np, "num-cs",
@@ -694,8 +694,9 @@ static int zynq_qspi_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		ctlr->num_chipselect = 1;
 	} else if (num_cs > ZYNQ_QSPI_MAX_NUM_CS) {
+		ret = -EINVAL;
 		dev_err(&pdev->dev, "only 2 chip selects are available\n");
-		goto remove_master;
+		goto clk_dis_all;
 	} else {
 		ctlr->num_chipselect = num_cs;
 	}
-- 
2.30.2

