Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926A540943C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244808AbhIMO3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345449AbhIMO0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:26:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C023961B4F;
        Mon, 13 Sep 2021 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540946;
        bh=HSHrTQXN2KzLKUEw5TjHr0WGyk7B6dL5F3It8eBIkxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jh93yKQ4CYL5qss8B0ZG3vwRBIEDqtSW/Y78IxWEXjG9zL1swhIQ5tmu88gF4j521
         8LICIJaU9QR202zLKQVm20sTByXerAuOWvciRpE2q4CCws0Z+3nt7cvVGtfXyiYlgX
         7IdoYfFLd5IyMAvYCXlaSdH+Hxk1+uLFPHO3919Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 067/334] spi: coldfire-qspi: Use clk_disable_unprepare in the remove function
Date:   Mon, 13 Sep 2021 15:12:01 +0200
Message-Id: <20210913131115.674983002@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d68f4c73d729245a47e70eb216fa24bc174ed2e2 ]

'clk_prepare_enable()' is used in the probe, so 'clk_disable_unprepare()'
should be used in the remove function to be consistent.

Fixes: 499de01c5c0b ("spi: coldfire-qspi: Use clk_prepare_enable and clk_disable_unprepare")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/ee91792ddba61342b0d3284cd4558a2b0016c4e7.1629319838.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-coldfire-qspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index 8996115ce736..263ce9047327 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -444,7 +444,7 @@ static int mcfqspi_remove(struct platform_device *pdev)
 	mcfqspi_wr_qmr(mcfqspi, MCFQSPI_QMR_MSTR);
 
 	mcfqspi_cs_teardown(mcfqspi);
-	clk_disable(mcfqspi->clk);
+	clk_disable_unprepare(mcfqspi->clk);
 
 	return 0;
 }
-- 
2.30.2



