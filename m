Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361E045BDCE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345202AbhKXMlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344975AbhKXMjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:39:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B59861391;
        Wed, 24 Nov 2021 12:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756611;
        bh=DBYqDsEuPR5l4aROrVAQvL1/upaFZgZnYxxv5zi1E2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzopr3gdJykMpWmN3vZwvvQDJ26C0fnOZgXCHd/CO5c3Npa9L6MsSyQU9MzqejI6j
         dW2m38zgNoqjN/ZWCI0zWXvoeROrr5e8yJYKS3dtMfTIgy3p0/N9XcP+che8MAQE7O
         pwPvnNEOEtB6QkxEuUq1+B6x4yDj1M15si5s4VYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 102/251] spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()
Date:   Wed, 24 Nov 2021 12:55:44 +0100
Message-Id: <20211124115713.797533034@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 11adc2c13a74c..298b1dd463800 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1301,7 +1301,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 					       &qspi->dev_ids[val]);
 			if (ret < 0) {
 				dev_err(&pdev->dev, "IRQ %s not found\n", name);
-				goto qspi_probe_err;
+				goto qspi_unprepare_err;
 			}
 
 			qspi->dev_ids[val].dev = qspi;
@@ -1316,7 +1316,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	if (!num_ints) {
 		dev_err(&pdev->dev, "no IRQs registered, cannot init driver\n");
 		ret = -EINVAL;
-		goto qspi_probe_err;
+		goto qspi_unprepare_err;
 	}
 
 	/*
@@ -1367,6 +1367,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 qspi_reg_err:
 	bcm_qspi_hw_uninit(qspi);
+qspi_unprepare_err:
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-- 
2.33.0



