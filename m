Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3558C12C808
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbfL2RuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731524AbfL2RuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 070AA206A4;
        Sun, 29 Dec 2019 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641816;
        bh=FmcKULmvubKzpyFssXEJhR9jlH3zBABRcOFRVNTB0lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WF8G199Urc3Uqj2yduQ8IXPdifqwE8eQ9FrcpZiV/7RIuCRR7/CgD2i9QJ31Et68O
         tG4Y2+f6ZMYm0wFxLK3Zf8EovC9SA0LPEdMctV9IN7foxaCgMbpOawQRcetMirShfj
         2qAPSH4J53uf6EC068qtkPRDYvv9orkzevqN1sPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 222/434] spi: sifive: disable clk when probe fails and remove
Date:   Sun, 29 Dec 2019 18:24:35 +0100
Message-Id: <20191229172716.592655591@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit a725272bda77e61c1b4de85c7b0c875b2ea639b6 ]

The driver forgets to disable and unprepare clk when probe fails and
remove.
Add the calls to fix the problem.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Palmer Dabbelt <palmer@dabbelt.com>
Link: https://lore.kernel.org/r/20191101121745.13413-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sifive.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-sifive.c b/drivers/spi/spi-sifive.c
index 35254bdc42c4..f7c1e20432e0 100644
--- a/drivers/spi/spi-sifive.c
+++ b/drivers/spi/spi-sifive.c
@@ -357,14 +357,14 @@ static int sifive_spi_probe(struct platform_device *pdev)
 	if (!cs_bits) {
 		dev_err(&pdev->dev, "Could not auto probe CS lines\n");
 		ret = -EINVAL;
-		goto put_master;
+		goto disable_clk;
 	}
 
 	num_cs = ilog2(cs_bits) + 1;
 	if (num_cs > SIFIVE_SPI_MAX_CS) {
 		dev_err(&pdev->dev, "Invalid number of spi slaves\n");
 		ret = -EINVAL;
-		goto put_master;
+		goto disable_clk;
 	}
 
 	/* Define our master */
@@ -393,7 +393,7 @@ static int sifive_spi_probe(struct platform_device *pdev)
 			       dev_name(&pdev->dev), spi);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to bind to interrupt\n");
-		goto put_master;
+		goto disable_clk;
 	}
 
 	dev_info(&pdev->dev, "mapped; irq=%d, cs=%d\n",
@@ -402,11 +402,13 @@ static int sifive_spi_probe(struct platform_device *pdev)
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "spi_register_master failed\n");
-		goto put_master;
+		goto disable_clk;
 	}
 
 	return 0;
 
+disable_clk:
+	clk_disable_unprepare(spi->clk);
 put_master:
 	spi_master_put(master);
 
@@ -420,6 +422,7 @@ static int sifive_spi_remove(struct platform_device *pdev)
 
 	/* Disable all the interrupts just in case */
 	sifive_spi_write(spi, SIFIVE_SPI_REG_IE, 0);
+	clk_disable_unprepare(spi->clk);
 
 	return 0;
 }
-- 
2.20.1



