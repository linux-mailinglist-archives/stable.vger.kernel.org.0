Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A08119613
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfLJVYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:24:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:32830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbfLJVKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5AC324697;
        Tue, 10 Dec 2019 21:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012248;
        bh=WvEFyyi/O+WRj6bp4PbOSJv1s0e0tDsQyd8Jf5h5W+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fp0Cif0+NghVk0j7oUceQblI5x8D5PtUkMAbeRgUCKujqBWKqA8MrmekmNSQy03Rc
         GSN2bxJ9tcBwv9QKquSW63BoLHSChdj0+BJ3Nr+b6gWeZfuop0Y4Gid9SZ8Kl/knUd
         qttN/RIORF9g3T+4OdPGf6cL7jiuvju/PEDtG//g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 196/350] spi: sifive: disable clk when probe fails and remove
Date:   Tue, 10 Dec 2019 16:05:01 -0500
Message-Id: <20191210210735.9077-157-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 35254bdc42c48..f7c1e20432e07 100644
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

