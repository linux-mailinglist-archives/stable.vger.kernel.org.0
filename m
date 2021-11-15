Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBB545243B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351802AbhKPBgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242480AbhKOSoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:44:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7B3C63382;
        Mon, 15 Nov 2021 18:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999594;
        bh=n47Xb32McseLpQ5TatbdgQivdwwg3oUf8mfuo8lljBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ead3on8j/W7/1mZsYZjX5XB6kJALdCt91+iHKC214Xhky8Y0m9b3gn8QDyzWjqqvv
         qa2vDfVHrIG9Hr5MmewugCh9ldVq/hTLKvJKhs6eLi9RLhmuRiZLb++TSybOI7KeeG
         nB+DiuphnkrNF5zH430+cX/Ws4ofRdPPPEP9qXPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 321/849] spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()
Date:   Mon, 15 Nov 2021 17:56:44 +0100
Message-Id: <20211115165431.099330594@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 3043677ba2226..ea1865c08fc22 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1460,7 +1460,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 					       &qspi->dev_ids[val]);
 			if (ret < 0) {
 				dev_err(&pdev->dev, "IRQ %s not found\n", name);
-				goto qspi_probe_err;
+				goto qspi_unprepare_err;
 			}
 
 			qspi->dev_ids[val].dev = qspi;
@@ -1475,7 +1475,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	if (!num_ints) {
 		dev_err(&pdev->dev, "no IRQs registered, cannot init driver\n");
 		ret = -EINVAL;
-		goto qspi_probe_err;
+		goto qspi_unprepare_err;
 	}
 
 	bcm_qspi_hw_init(qspi);
@@ -1499,6 +1499,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 qspi_reg_err:
 	bcm_qspi_hw_uninit(qspi);
+qspi_unprepare_err:
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-- 
2.33.0



