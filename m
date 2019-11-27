Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF05010BDF0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbfK0Uwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730622AbfK0Uwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C20C21850;
        Wed, 27 Nov 2019 20:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887954;
        bh=ICBpKs12ZejgGbxnsIPoiqox3+96tRhrr5TqFqHAmGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nt9c/rwTjVuFTX+9oxg4Hwl+Fg95ozaVcBzbz21wUeAM2LhxFgn4KOoyilzuQOoqZ
         hRWW+qgJsTYiXE58EPnC7Vk+rArqC8Qv+UCs8+VdDkxIeAIkhUog+PKDGlgDU9wjQO
         xT9bcoAeAMDs1qd5/kXUkJBerzDQMtQbFd0xdWDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Lechner <david@lechnology.com>,
        Vignesh R <vigneshr@ti.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 159/211] spi: omap2-mcspi: Fix DMA and FIFO event trigger size mismatch
Date:   Wed, 27 Nov 2019 21:31:32 +0100
Message-Id: <20191127203108.968974329@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh R <vigneshr@ti.com>

[ Upstream commit baf8b9f8d260c55a86405f70a384c29cda888476 ]

Commit b682cffa3ac6 ("spi: omap2-mcspi: Set FIFO DMA trigger level to word length")
broke SPI transfers where bits_per_word != 8. This is because of
mimsatch between McSPI FIFO level event trigger size (SPI word length) and
DMA request size(word length * maxburst). This leads to data
corruption, lockup and errors like:

	spi1.0: EOW timed out

Fix this by setting DMA maxburst size to 1 so that
McSPI FIFO level event trigger size matches DMA request size.

Fixes: b682cffa3ac6 ("spi: omap2-mcspi: Set FIFO DMA trigger level to word length")
Cc: stable@vger.kernel.org
Reported-by: David Lechner <david@lechnology.com>
Tested-by: David Lechner <david@lechnology.com>
Signed-off-by: Vignesh R <vigneshr@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 517d0ade586bd..1db4d3c1d2bfa 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -625,8 +625,8 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 	cfg.dst_addr = cs->phys + OMAP2_MCSPI_TX0;
 	cfg.src_addr_width = width;
 	cfg.dst_addr_width = width;
-	cfg.src_maxburst = es;
-	cfg.dst_maxburst = es;
+	cfg.src_maxburst = 1;
+	cfg.dst_maxburst = 1;
 
 	rx = xfer->rx_buf;
 	tx = xfer->tx_buf;
-- 
2.20.1



