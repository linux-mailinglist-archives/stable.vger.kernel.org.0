Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35778450BCC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbhKOR3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:29:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237857AbhKOR0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:26:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D8A661C15;
        Mon, 15 Nov 2021 17:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996622;
        bh=Ge91bb0a2WU0ipHhN6WwcgHpKc34PGod3OcIfK2khT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9W0+5v+9quWdnHAMVTHVBFQpNaNv1NqZ2sF55Je6AqnuGpObzTVyyDDbumqxRZxU
         VCvGDKduAuxZTi84QwVJcBTqtw03sqzJ2rRgn23QrmyoqLTjQb8WFZLSdrIRQwZQPq
         SLz0S50DVJOZVPaGbx4xfNUMGd8FQnDhy4um7m4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/355] spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()
Date:   Mon, 15 Nov 2021 18:01:38 +0100
Message-Id: <20211115165319.415575294@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 8a4be34bccfd2..8a1176efa4c85 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1300,7 +1300,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 					       &qspi->dev_ids[val]);
 			if (ret < 0) {
 				dev_err(&pdev->dev, "IRQ %s not found\n", name);
-				goto qspi_probe_err;
+				goto qspi_unprepare_err;
 			}
 
 			qspi->dev_ids[val].dev = qspi;
@@ -1315,7 +1315,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 	if (!num_ints) {
 		dev_err(&pdev->dev, "no IRQs registered, cannot init driver\n");
 		ret = -EINVAL;
-		goto qspi_probe_err;
+		goto qspi_unprepare_err;
 	}
 
 	/*
@@ -1359,6 +1359,7 @@ int bcm_qspi_probe(struct platform_device *pdev,
 
 qspi_reg_err:
 	bcm_qspi_hw_uninit(qspi);
+qspi_unprepare_err:
 	clk_disable_unprepare(qspi->clk);
 qspi_probe_err:
 	kfree(qspi->dev_ids);
-- 
2.33.0



