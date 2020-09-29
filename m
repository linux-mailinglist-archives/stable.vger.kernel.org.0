Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22A127C744
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgI2Lws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730529AbgI2Lra (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8945206E5;
        Tue, 29 Sep 2020 11:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380049;
        bh=gzA5Q1xNRnCQ78o9B5dq6SBk+kOlPvH/FvVASyWJQxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2PEPtm9Sjh/r4VR2ZOxAfBGFaYb/DMmAZYuk09kyKhDmM2A3+fFEfnHTSqZwKspJ
         tGeWbBVJVVUb6welOZcWeZwIZlv+/h72CNnmVfteWnd4Q7W43dd3q3SKHjXLsbIze3
         kuCu/Tw3RVFa5thRL+SAWKQeSswMdoaMrLoJXhLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiang Zhao <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 44/99] spi: spi-fsl-dspi: use XSPI mode instead of DMA for DPAA2 SoCs
Date:   Tue, 29 Sep 2020 13:01:27 +0200
Message-Id: <20200929105931.895912207@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 505623a2be48b36de533951ced130876a76a2d55 ]

The arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi device tree lacks DMA
channels for DSPI, so naturally, the driver fails to probe:

[ 2.945302] fsl-dspi 2100000.spi: rx dma channel not available
[ 2.951134] fsl-dspi 2100000.spi: can't get dma channels

In retrospect, this should have been obvious, because LS2080A, LS2085A
LS2088A and LX2160A don't appear to have an eDMA module at all. Looking
again at their datasheets, the CTARE register (which is specific to XSPI
functionality) seems to be documented, so switch them to XSPI mode
instead.

Fixes: 0feaf8f5afe0 ("spi: spi-fsl-dspi: Convert the instantiations that support it to DMA")
Reported-by: Qiang Zhao <qiang.zhao@nxp.com>
Tested-by: Qiang Zhao <qiang.zhao@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20200910121532.1138596-1-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 91c6affe139c9..283f2468a2f46 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -174,17 +174,17 @@ static const struct fsl_dspi_devtype_data devtype_data[] = {
 		.fifo_size		= 16,
 	},
 	[LS2080A] = {
-		.trans_mode		= DSPI_DMA_MODE,
+		.trans_mode		= DSPI_XSPI_MODE,
 		.max_clock_factor	= 8,
 		.fifo_size		= 4,
 	},
 	[LS2085A] = {
-		.trans_mode		= DSPI_DMA_MODE,
+		.trans_mode		= DSPI_XSPI_MODE,
 		.max_clock_factor	= 8,
 		.fifo_size		= 4,
 	},
 	[LX2160A] = {
-		.trans_mode		= DSPI_DMA_MODE,
+		.trans_mode		= DSPI_XSPI_MODE,
 		.max_clock_factor	= 8,
 		.fifo_size		= 4,
 	},
-- 
2.25.1



