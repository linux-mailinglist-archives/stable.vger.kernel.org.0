Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3958E408E5E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241821AbhIMNdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239851AbhIMNbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:31:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AA1E61360;
        Mon, 13 Sep 2021 13:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539523;
        bh=HSHrTQXN2KzLKUEw5TjHr0WGyk7B6dL5F3It8eBIkxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MupvYSzTDXGGkeyVjKNtBg+GIfMtOsOqeSFDfjCJh9Wuhtj7AeL0kjCRGq9In0Pzr
         JgQL57k4rtA/lf/jsDHCBy7//OhSnfJ4CUbZj656OLGRw3JrQcTUFvcGUz0DR5CwTt
         yYJByCrH/X83zWf74QQf8if0mJqWTbU1NMm8Tqog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/236] spi: coldfire-qspi: Use clk_disable_unprepare in the remove function
Date:   Mon, 13 Sep 2021 15:12:41 +0200
Message-Id: <20210913131102.260572744@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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



