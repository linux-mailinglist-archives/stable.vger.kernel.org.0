Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6090629C4A0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757425AbgJ0OT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757420AbgJ0OT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:19:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60694206D4;
        Tue, 27 Oct 2020 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808367;
        bh=ewlaxnRaadBePgHr+xb/RrbkFOIArvJHc4Jxdh9EBn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7ejmDnkM/V31UWwyQ7jW3PzeeMCwYswO2Nqiep18kNHChMe4EqfODAA3L/XEJsud
         JAkaLJeMufn7vu0D/zSV5gaI3T61NcbkolPjl90VPAt7UT0dALBWa+h7BGVrKNK1nE
         aTsHvI5lEpeogXjCHM4PoXIicBTQ6HikBmdfRIis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/264] spi: spi-s3c64xx: swap s3c64xx_spi_set_cs() and s3c64xx_enable_datapath()
Date:   Tue, 27 Oct 2020 14:52:02 +0100
Message-Id: <20201027135433.683971910@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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



