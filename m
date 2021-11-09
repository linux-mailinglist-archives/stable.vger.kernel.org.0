Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A295444A35C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242896AbhKIB0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243604AbhKIBX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:23:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13746613B3;
        Tue,  9 Nov 2021 01:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420150;
        bh=i0jV/KhtSx0BQq0o+enM7ZIbvtFGSUk3n/q7u2joUbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGjsop9NB6eEPWtLiFocHvewQqN08fkxVmNCWNEObDAsVtqwOTQadccPSNr/GeVFd
         jJriKbaY9N4Rul3c793dLceqUe+b8FNGEY2w+ElJ0j7FDJUGUt5me/tSwacVWc7o3e
         zficRV+w1Jkg4dj9B5NID5ZJ0MBM7GJnBkvr+MaMwsPsR4Fhq/dRKta6+qBAidGeCG
         dtMXRDx8zFJ5dHM38X1hAx04q2EIPwRAPL/gzKouS3e5rdvXZgc0Yj2WoVj0DTwGwg
         JkxRSgQ0kqaP+vkdQF+ZcYhAbtkU9pmYDVkTJJX4r/qz6pcLxRdSf+bOD7FPOJBef2
         98j8G99Gg98YA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, kdasu.kdev@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 31/33] spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()
Date:   Mon,  8 Nov 2021 20:08:05 -0500
Message-Id: <20211109010807.1191567-31-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ca9b8f56ec089d3a436050afefd17b7237301f47 ]

Fix the missing clk_disable_unprepare() before return
from bcm_qspi_probe() in the error handling case.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211018073413.2029081-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index 5453910d8abc3..d521adf6ac245 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1266,7 +1266,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 					       &qspi->dev_ids[val]);
 			if (ret < 0) {
 				dev_err(&pdev->dev, "IRQ %s not found\n", name);
-				goto qspi_probe_err;
+				goto qspi_unprepare_err;
 			}
 
 			qspi->dev_ids[val].dev = qspi;
@@ -1281,7 +1281,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	if (!num_ints) {
 		dev_err(&pdev->dev, "no IRQs registered, cannot init driver\n");
 		ret = -EINVAL;
-		goto qspi_probe_err;
+		goto qspi_unprepare_err;
 	}
 
 	/*
@@ -1332,6 +1332,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 qspi_reg_err:
 	bcm_qspi_hw_uninit(qspi);
+qspi_unprepare_err:
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-- 
2.33.0

