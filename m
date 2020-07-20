Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF8322645D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbgGTPo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730385AbgGTPo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:44:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BD7C22CB3;
        Mon, 20 Jul 2020 15:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259866;
        bh=CkMZrcI/01t0Lt8pc/TKDR1bKE2fZRxd58+lX9RTrBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+eGuWAMGO3t+D1vVXKiHepikf/rD6u+vTrtjghd6JuYNMOebSwHHeaRuodpZxwAq
         U/atkyjaaFa93LBevjmI9YsixOpyNDKm90jFoT60EiU1N/2mBRmCbkjtH7+1OT5LEK
         nsR0m1rwZU+H92F8lnOfUt4Tk0nWKxI/ZeDYGqiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanhua Han <chuanhua.han@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 004/125] spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ
Date:   Mon, 20 Jul 2020 17:35:43 +0200
Message-Id: <20200720152803.146031768@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuanhua Han <chuanhua.han@nxp.com>

[ Upstream commit 13aed23927414137a017ac2f7d567001f714293f ]

Some SoC share one irq number between DSPI controllers.
For example, on the LX2160 board, DSPI0 and DSPI1 share one irq number.
In this case, only one DSPI controller can register successfully,
and others will fail.

Signed-off-by: Chuanhua Han <chuanhua.han@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index baf5274485004..4402e531b1bfd 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1027,8 +1027,8 @@ static int dspi_probe(struct platform_device *pdev)
 		goto out_clk_put;
 	}
 
-	ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt, 0,
-			pdev->name, dspi);
+	ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
+			       IRQF_SHARED, pdev->name, dspi);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to attach DSPI interrupt\n");
 		goto out_clk_put;
-- 
2.25.1



