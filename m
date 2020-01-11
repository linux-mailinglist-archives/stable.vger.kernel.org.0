Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F258D137F17
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbgAKKQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgAKKQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:16:36 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F16CD20842;
        Sat, 11 Jan 2020 10:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737796;
        bh=q9+pkmMYIVZ7m7UdmQKG+i2JhtZ0O5hS5J0M6XTuC2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8cpOIvb4ghqZquGFjQP3+0YugDgN1iMsuH21ATcf0bZr7Meffz+T03lwFE+8mMbv
         wtAdAEm1SEcbEVVeq9TOWUwyydXaAkRgDuKY2VxeV01lZDaYzKGbIzxI2mkz9pcx75
         ycwwy5BwP7zKI2Rol7mddyqFVmSa9ST/qTrYQ0n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dannenberg <dannenberg@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/84] spi: spi-ti-qspi: Fix a bug when accessing non default CS
Date:   Sat, 11 Jan 2020 10:50:06 +0100
Message-Id: <20200111094856.956468763@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit c52c91bb9aa6bd8c38dbf9776158e33038aedd43 ]

When switching ChipSelect from default CS0 to any other CS, driver fails
to update the bits in system control module register that control which
CS is mapped for MMIO access. This causes reads to fail when driver
tries to access QSPI flash on CS1/2/3.

Fix this by updating appropriate bits whenever active CS changes.

Reported-by: Andreas Dannenberg <dannenberg@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20191211155216.30212-1-vigneshr@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ti-qspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index b9fb6493cd6b..95c28abaa027 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -69,6 +69,7 @@ struct ti_qspi {
 	u32 dc;
 
 	bool mmap_enabled;
+	int current_cs;
 };
 
 #define QSPI_PID			(0x0)
@@ -494,6 +495,7 @@ static void ti_qspi_enable_memory_map(struct spi_device *spi)
 				   MEM_CS_EN(spi->chip_select));
 	}
 	qspi->mmap_enabled = true;
+	qspi->current_cs = spi->chip_select;
 }
 
 static void ti_qspi_disable_memory_map(struct spi_device *spi)
@@ -505,6 +507,7 @@ static void ti_qspi_disable_memory_map(struct spi_device *spi)
 		regmap_update_bits(qspi->ctrl_base, qspi->ctrl_reg,
 				   MEM_CS_MASK, 0);
 	qspi->mmap_enabled = false;
+	qspi->current_cs = -1;
 }
 
 static void ti_qspi_setup_mmap_read(struct spi_device *spi, u8 opcode,
@@ -550,7 +553,7 @@ static int ti_qspi_exec_mem_op(struct spi_mem *mem,
 
 	mutex_lock(&qspi->list_lock);
 
-	if (!qspi->mmap_enabled)
+	if (!qspi->mmap_enabled || qspi->current_cs != mem->spi->chip_select)
 		ti_qspi_enable_memory_map(mem->spi);
 	ti_qspi_setup_mmap_read(mem->spi, op->cmd.opcode, op->data.buswidth,
 				op->addr.nbytes, op->dummy.nbytes);
@@ -807,6 +810,7 @@ static int ti_qspi_probe(struct platform_device *pdev)
 		}
 	}
 	qspi->mmap_enabled = false;
+	qspi->current_cs = -1;
 
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (!ret)
-- 
2.20.1



