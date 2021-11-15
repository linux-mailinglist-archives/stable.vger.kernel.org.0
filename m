Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EA4451FE8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356198AbhKPApq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343733AbhKOTVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E91A63294;
        Mon, 15 Nov 2021 18:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001920;
        bh=kn6pcuTRLYUc38gZARayQOKqf/nabe3968N8ojS4hE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKpF78xaq1WzxG3ZxX5QU0xODnhFs2GJJ2pDKTQetEGUVkFiWuYE/0OsiyCNzEUn+
         r9XTYb3f+PIRrdGZUVffCwHpPuLpJKs+1bECyO/5c+ptG+OH4sKCV0Ez23WICBoFtK
         qgS65MxNhvqcwBJBERBJemm/OcshrCHmxL4Sl24w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoshitaka Ikeda <ikeda@nskint.co.jp>,
        Pratyush Yadav <p.yadav@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 344/917] spi: Fixed division by zero warning
Date:   Mon, 15 Nov 2021 17:57:19 +0100
Message-Id: <20211115165440.410904383@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshitaka Ikeda <ikeda@nskint.co.jp>

[ Upstream commit 09134c5322df9f105d9ed324051872d5d0e162aa ]

The reason for dividing by zero is because the dummy bus width is zero,
but if the dummy n bytes is zero, it indicates that there is no data transfer,
so there is no need for calculation.

Fixes: 7512eaf54190 ("spi: cadence-quadspi: Fix dummy cycle calculation when buswidth > 1")
Signed-off-by: Yoshitaka Ikeda <ikeda@nskint.co.jp>
Acked-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/OSZPR01MB70049C8F56ED8902852DF97B8BD49@OSZPR01MB7004.jpnprd01.prod.outlook.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c  | 2 +-
 drivers/spi/spi-bcm-qspi.c   | 3 ++-
 drivers/spi/spi-mtk-nor.c    | 2 +-
 drivers/spi/spi-stm32-qspi.c | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 95d4fa32c2995..92d9610df1fd8 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -310,7 +310,7 @@ static int atmel_qspi_set_cfg(struct atmel_qspi *aq,
 		return mode;
 	ifr |= atmel_qspi_modes[mode].config;
 
-	if (op->dummy.buswidth && op->dummy.nbytes)
+	if (op->dummy.nbytes)
 		dummy_cycles = op->dummy.nbytes * 8 / op->dummy.buswidth;
 
 	/*
diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index ea1865c08fc22..151e154284bde 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -395,7 +395,8 @@ static int bcm_qspi_bspi_set_flex_mode(struct bcm_qspi *qspi,
 	if (addrlen == BSPI_ADDRLEN_4BYTES)
 		bpp = BSPI_BPP_ADDR_SELECT_MASK;
 
-	bpp |= (op->dummy.nbytes * 8) / op->dummy.buswidth;
+	if (op->dummy.nbytes)
+		bpp |= (op->dummy.nbytes * 8) / op->dummy.buswidth;
 
 	switch (width) {
 	case SPI_NBITS_SINGLE:
diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index 41e7b341d2616..5c93730615f8d 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -160,7 +160,7 @@ static bool mtk_nor_match_read(const struct spi_mem_op *op)
 {
 	int dummy = 0;
 
-	if (op->dummy.buswidth)
+	if (op->dummy.nbytes)
 		dummy = op->dummy.nbytes * BITS_PER_BYTE / op->dummy.buswidth;
 
 	if ((op->data.buswidth == 2) || (op->data.buswidth == 4)) {
diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
index 27f35aa2d746d..514337c86d2c3 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -397,7 +397,7 @@ static int stm32_qspi_send(struct spi_mem *mem, const struct spi_mem_op *op)
 		ccr |= FIELD_PREP(CCR_ADSIZE_MASK, op->addr.nbytes - 1);
 	}
 
-	if (op->dummy.buswidth && op->dummy.nbytes)
+	if (op->dummy.nbytes)
 		ccr |= FIELD_PREP(CCR_DCYC_MASK,
 				  op->dummy.nbytes * 8 / op->dummy.buswidth);
 
-- 
2.33.0



