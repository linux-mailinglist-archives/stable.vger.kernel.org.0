Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD0044A303
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242297AbhKIBZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240602AbhKIBPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 426AD61A40;
        Tue,  9 Nov 2021 01:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419996;
        bh=dLuPjWBz/m5H5FwyUvB6OyIPGZxR95Ap2K4I5sWT250=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1GEuptiVTa0OE7X2phGGmWqBQz00fnN27DSKaNokYBIsAKxOncdhNgv6MWN4DG7r
         vG3YsHs67P5s/tJm4H7einOBEXMVqsBwnLZgJYQOO/FxsQnahW1FJnu/xlYz1/16ES
         Wxaxmx/o+8qTeG6hUljxj3iR+FZOXMFGcka1/K6nKvhhkgULP5uzE5q2eele3+O22x
         GYZjCfAnMHMiZOwtu1FaGJ6Khx1DQhQrFXofcp38OUEFWWBA8qHB5+cFDbe06oBcqn
         jF1wxNziewUdmMbrul+5c9VGNXt4rGlUToE3faWYwoPHY5HVtkcKbERsibnCY2s+JL
         UINQInQKEcoZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, kdasu.kdev@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 42/47] spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()
Date:   Mon,  8 Nov 2021 12:50:26 -0500
Message-Id: <20211108175031.1190422-42-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
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
index 4ee92f7ca20bd..b2fd7a3691964 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1305,7 +1305,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 					       &qspi->dev_ids[val]);
 			if (ret < 0) {
 				dev_err(&pdev->dev, "IRQ %s not found\n", name);
-				goto qspi_probe_err;
+				goto qspi_unprepare_err;
 			}
 
 			qspi->dev_ids[val].dev = qspi;
@@ -1320,7 +1320,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	if (!num_ints) {
 		dev_err(&pdev->dev, "no IRQs registered, cannot init driver\n");
 		ret = -EINVAL;
-		goto qspi_probe_err;
+		goto qspi_unprepare_err;
 	}
 
 	/*
@@ -1371,6 +1371,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 qspi_reg_err:
 	bcm_qspi_hw_uninit(qspi);
+qspi_unprepare_err:
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-- 
2.33.0

