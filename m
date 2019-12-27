Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7514112B666
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfL0Rma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:42:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbfL0Rm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66772222C3;
        Fri, 27 Dec 2019 17:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468549;
        bh=YsvyNulDze0pM9EOznZ/h1F/BfCyg96OFeBPGK5KHc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VK4HTcaPQP9gze904siS/AzkWtQpdEZKOM2J+6pKxeqs2qz9dcdFC3pQu/GPQzLeM
         dKRrW6qt4k0oDNK5H8LT1v8VegmAW4gKISzRKNZW/t8qQJvUiEj+fSCRNqIB6bbfCz
         RpeUY2bKHE83qm7x2BqbBjMm1fYnUwQQf/FHNmT8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Andreas Dannenberg <dannenberg@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 076/187] spi: spi-ti-qspi: Fix a bug when accessing non default CS
Date:   Fri, 27 Dec 2019 12:39:04 -0500
Message-Id: <20191227174055.4923-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
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
index 3cb65371ae3b..66dcb6128539 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -62,6 +62,7 @@ struct ti_qspi {
 	u32 dc;
 
 	bool mmap_enabled;
+	int current_cs;
 };
 
 #define QSPI_PID			(0x0)
@@ -487,6 +488,7 @@ static void ti_qspi_enable_memory_map(struct spi_device *spi)
 				   MEM_CS_EN(spi->chip_select));
 	}
 	qspi->mmap_enabled = true;
+	qspi->current_cs = spi->chip_select;
 }
 
 static void ti_qspi_disable_memory_map(struct spi_device *spi)
@@ -498,6 +500,7 @@ static void ti_qspi_disable_memory_map(struct spi_device *spi)
 		regmap_update_bits(qspi->ctrl_base, qspi->ctrl_reg,
 				   MEM_CS_MASK, 0);
 	qspi->mmap_enabled = false;
+	qspi->current_cs = -1;
 }
 
 static void ti_qspi_setup_mmap_read(struct spi_device *spi, u8 opcode,
@@ -543,7 +546,7 @@ static int ti_qspi_exec_mem_op(struct spi_mem *mem,
 
 	mutex_lock(&qspi->list_lock);
 
-	if (!qspi->mmap_enabled)
+	if (!qspi->mmap_enabled || qspi->current_cs != mem->spi->chip_select)
 		ti_qspi_enable_memory_map(mem->spi);
 	ti_qspi_setup_mmap_read(mem->spi, op->cmd.opcode, op->data.buswidth,
 				op->addr.nbytes, op->dummy.nbytes);
@@ -799,6 +802,7 @@ static int ti_qspi_probe(struct platform_device *pdev)
 		}
 	}
 	qspi->mmap_enabled = false;
+	qspi->current_cs = -1;
 
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (!ret)
-- 
2.20.1

