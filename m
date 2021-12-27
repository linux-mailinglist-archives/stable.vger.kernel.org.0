Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1016E47FFAE
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhL0Pkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:40:45 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41408 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239018AbhL0PiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:38:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27B03CE10D4;
        Mon, 27 Dec 2021 15:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163A5C36AEB;
        Mon, 27 Dec 2021 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619491;
        bh=2o90BmwRkuNE+o7uki4KS2CtdBoVd+SEuqt9qvk1KeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEyti3ZVix6Zf8o7MvrjM7KVAQZ3L/MuRAQ2cZhmG2FAjob32gTH82YE+Db8+YMqK
         PcvViMNKUfgGm2w/ghRsHNUXBG1V9o+fb5jRfWeAmrwysW2zzsWpsNJG71htaehVJ4
         Gau0RrojExMA8vdBFM2TZdU78fJfMuBssVB+aQ8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/76] spi: change clk_disable_unprepare to clk_unprepare
Date:   Mon, 27 Dec 2021 16:30:25 +0100
Message-Id: <20211227151325.061681799@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit db6689b643d8653092f5853751ea2cdbc299f8d3 ]

The corresponding API for clk_prepare is clk_unprepare, other than
clk_disable_unprepare.

Fix this by changing clk_disable_unprepare to clk_unprepare.

Fixes: 5762ab71eb24 ("spi: Add support for Armada 3700 SPI Controller")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Link: https://lore.kernel.org/r/20211206101931.2816597-1-mudongliangabcd@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-armada-3700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-armada-3700.c b/drivers/spi/spi-armada-3700.c
index 46feafe4e201c..d8cc4b270644a 100644
--- a/drivers/spi/spi-armada-3700.c
+++ b/drivers/spi/spi-armada-3700.c
@@ -901,7 +901,7 @@ static int a3700_spi_probe(struct platform_device *pdev)
 	return 0;
 
 error_clk:
-	clk_disable_unprepare(spi->clk);
+	clk_unprepare(spi->clk);
 error:
 	spi_master_put(master);
 out:
-- 
2.34.1



