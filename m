Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1146D47FE9D
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhL0Pai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:30:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34510 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237760AbhL0P3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:29:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A31EB810A2;
        Mon, 27 Dec 2021 15:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927CDC36AEA;
        Mon, 27 Dec 2021 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618957;
        bh=JJ0n9CvCx/rc8BUqP3+f0ITBFp3o4iRM1ExUIUmsoHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ds9R4/woa/LKuh9tmMiiF1ORpJ7APQK4y/c1jJuk/+uFmgGtXHKLGpEaWQTVaADi9
         vguyEbkRe1itfJW6uF4KzmobhaUtHTMz/EHDWrJlcKbcC/1K4uGqZlmN4MZiCyYqv1
         AiTwczAT8c+SmHSKsae70MAJ7s4p/HN8KcUcUx7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/29] spi: change clk_disable_unprepare to clk_unprepare
Date:   Mon, 27 Dec 2021 16:27:14 +0100
Message-Id: <20211227151318.618635062@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
References: <20211227151318.475251079@linuxfoundation.org>
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
index 4903f15177cfd..8fedf83585d41 100644
--- a/drivers/spi/spi-armada-3700.c
+++ b/drivers/spi/spi-armada-3700.c
@@ -852,7 +852,7 @@ static int a3700_spi_probe(struct platform_device *pdev)
 	return 0;
 
 error_clk:
-	clk_disable_unprepare(spi->clk);
+	clk_unprepare(spi->clk);
 error:
 	spi_master_put(master);
 out:
-- 
2.34.1



