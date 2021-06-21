Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65CC3AF04F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhFUQsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234037AbhFUQqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:46:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 735A4613B1;
        Mon, 21 Jun 2021 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293187;
        bh=nGOf27RMGsJa6chr7glk2gXKh75BH+v6kU7jTmObYQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0o0bigu5dRQc5gUplb4MtOo9M8eqp4n9eMDy2V7OXPw4wDSShiesSbCU5KGKhv6X
         ct8I+S1a/3a+WF1ZmySxkeXhyphaW+ldpkD226l30skXr6a5EmGs5xIh2K45iFpi/v
         35q4pZjE8c8NCnOIBVCM48Qrg/HBUJElzRqfGPpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zpershuai <zpershuai@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 097/178] spi: spi-zynq-qspi: Fix some wrong goto jumps & missing error code
Date:   Mon, 21 Jun 2021 18:15:11 +0200
Message-Id: <20210621154926.058249344@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2765289028fa..68193db8b2e3 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -678,14 +678,14 @@ static int zynq_qspi_probe(struct platform_device *pdev)
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
@@ -693,8 +693,9 @@ static int zynq_qspi_probe(struct platform_device *pdev)
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



