Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363DE12B75D
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfL0Rs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbfL0Rog (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D40C206F4;
        Fri, 27 Dec 2019 17:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468675;
        bh=q9+pkmMYIVZ7m7UdmQKG+i2JhtZ0O5hS5J0M6XTuC2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VftRpNVvzogBP5quPPYkUbEseNV7GwTDygaXstca+I7Z7S+VYhXhqLE/g6cFvtITq
         Ezuevm607V0CgWUTiwcyWz7Mhw6hRMNvrIzw7tMk9hUc96lmYpyYm43UdjTe0AveDm
         etZzwgiA7s2fLR5figb17O4g6pimaHiX67MZ8kCI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Andreas Dannenberg <dannenberg@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 35/84] spi: spi-ti-qspi: Fix a bug when accessing non default CS
Date:   Fri, 27 Dec 2019 12:43:03 -0500
Message-Id: <20191227174352.6264-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

