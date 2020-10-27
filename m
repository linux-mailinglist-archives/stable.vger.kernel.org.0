Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8366329B934
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802260AbgJ0PqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368753AbgJ0P1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:27:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71C2D22202;
        Tue, 27 Oct 2020 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812441;
        bh=Sz1MxoIX2bhhHXpza6QKvGLQfuaUSo/wFg+bSWNNUsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8YiEV1L3fZV7rSXMeffb+2sVQ2n4tXEru7N3TuFDC0jUs4hDUjNJUsz+bR1OI1UT
         neARdUG1sPY0mFuwinWNzNepPPcj/k/C4AKrrQ1i37ROBeb+HUxSYAQ8dlgCvqddzs
         9zyOSXhtfJJ6LipCl6byV6uC+X2sVLWev3YKquSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Robin Gong <b38343@freescale.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 180/757] spi: imx: Fix freeing of DMA channels if spi_bitbang_start() fails
Date:   Tue, 27 Oct 2020 14:47:10 +0100
Message-Id: <20201027135459.032020313@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 45f0bbdafd26d6d772172563b30bff561cec9133 ]

If the SPI controller has has_dmamode = true and spi_bitbang_start() fails
in spi_imx_probe(), then the driver must release the DMA channels acquired
in spi_imx_sdma_init() by calling spi_imx_sdma_exit() in the fail path.

Fixes: f62caccd12c1 ("spi: spi-imx: add DMA support")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Robin Gong <b38343@freescale.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Link: https://lore.kernel.org/r/20201005132229.513119-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 38a5f1304cec4..e38e5ad3c7068 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1707,7 +1707,7 @@ static int spi_imx_probe(struct platform_device *pdev)
 	ret = spi_bitbang_start(&spi_imx->bitbang);
 	if (ret) {
 		dev_err(&pdev->dev, "bitbang start failed with %d\n", ret);
-		goto out_runtime_pm_put;
+		goto out_bitbang_start;
 	}
 
 	dev_info(&pdev->dev, "probed\n");
@@ -1717,6 +1717,9 @@ static int spi_imx_probe(struct platform_device *pdev)
 
 	return ret;
 
+out_bitbang_start:
+	if (spi_imx->devtype_data->has_dmamode)
+		spi_imx_sdma_exit(spi_imx);
 out_runtime_pm_put:
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
 	pm_runtime_put_sync(spi_imx->dev);
-- 
2.25.1



