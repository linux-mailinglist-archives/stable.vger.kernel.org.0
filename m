Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89DF29C2C3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902354AbgJ0Ocv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902347AbgJ0Oct (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 558F0206DC;
        Tue, 27 Oct 2020 14:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809168;
        bh=ewlaxnRaadBePgHr+xb/RrbkFOIArvJHc4Jxdh9EBn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMR+rvnbd6egkpJjxp98383vBpcQC4He8FUffPPQ/rkkb5Qm/fAd9K9r7o5V7r4X7
         7y3zXfyV6HVqZRNGsoHUJt/2H4cze/kmlwqbIRm1fZI1+4GjRVsnJMWMUt96wj23/v
         erPiFDtoT/WM/txw5hQb29ayPFRWE380jM0O+83M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/408] spi: spi-s3c64xx: swap s3c64xx_spi_set_cs() and s3c64xx_enable_datapath()
Date:   Tue, 27 Oct 2020 14:50:38 +0100
Message-Id: <20201027135459.731814913@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Stelmach <l.stelmach@samsung.com>

[ Upstream commit 581e2b41977dfc2d4c26c8e976f89c43bb92f9bf ]

Fix issues with DMA transfers bigger than 512 bytes on Exynos3250. Without
the patches such transfers fail to complete. This solution to the problem
is found in the vendor kernel for ARTIK5 boards based on Exynos3250.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Link: https://lore.kernel.org/r/20201002122243.26849-2-l.stelmach@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 7b7151ec14c8a..322f75f89c713 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -678,11 +678,11 @@ static int s3c64xx_spi_transfer_one(struct spi_master *master,
 		sdd->state &= ~RXBUSY;
 		sdd->state &= ~TXBUSY;
 
-		s3c64xx_enable_datapath(sdd, xfer, use_dma);
-
 		/* Start the signals */
 		s3c64xx_spi_set_cs(spi, true);
 
+		s3c64xx_enable_datapath(sdd, xfer, use_dma);
+
 		spin_unlock_irqrestore(&sdd->lock, flags);
 
 		if (use_dma)
-- 
2.25.1



