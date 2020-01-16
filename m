Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7D913E086
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgAPQoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgAPQoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:44:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE9F22073A;
        Thu, 16 Jan 2020 16:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193040;
        bh=CkOoXPkUnHzrdzJoAg4KfI49I5hOgybxZY2hocS8IEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXfR4ZFPQClasjIkXr8y84NZtzT7zFEDUGrdw/rWaB1cWh0eAf6AeNYZO9w4WfrBd
         E1M+AzI10WXIkwL9h/DapOI38o2I+4wqOSYeSyrIzs4KyFlDYJOMSwA+X7UHBs6w78
         krjPX2N9ftgRroqRMpV52bU0gM4POZlHhlRnPtqY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 012/205] spi: lpspi: fix memory leak in fsl_lpspi_probe
Date:   Thu, 16 Jan 2020 11:39:47 -0500
Message-Id: <20200116164300.6705-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 057b8945f78f76d0b04eeb5c27cd9225e5e7ad86 ]

In fsl_lpspi_probe an SPI controller is allocated either via
spi_alloc_slave or spi_alloc_master. In all but one error cases this
controller is put by going to error handling code. This commit fixes the
case when pm_runtime_get_sync fails and it should go to the error
handling path.

Fixes: 944c01a889d9 ("spi: lpspi: enable runtime pm for lpspi")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20190930034602.1467-1-navid.emamdoost@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index d08e9324140e..3528ed5eea9b 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -938,7 +938,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	ret = pm_runtime_get_sync(fsl_lpspi->dev);
 	if (ret < 0) {
 		dev_err(fsl_lpspi->dev, "failed to enable clock\n");
-		return ret;
+		goto out_controller_put;
 	}
 
 	temp = readl(fsl_lpspi->base + IMX7ULP_PARAM);
-- 
2.20.1

