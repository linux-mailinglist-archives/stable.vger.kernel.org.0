Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213D1137FE8
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbgAKKYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:24:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730643AbgAKKYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:24:06 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27337205F4;
        Sat, 11 Jan 2020 10:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738246;
        bh=YsvyNulDze0pM9EOznZ/h1F/BfCyg96OFeBPGK5KHc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9K2NnpcQCWHjAOy5JsV3eCvFBB2tU/ICyP8cd8YkJFHEbP0s7YL6ABKUAip54diM
         xIDyyxqh5EWGCg7W2hJrK2uMSTY4PLrCjfICgLCF18BL6BhsnGoUkZkPZpuarvuZpR
         iP+nonpjk4g18kUuxSGXvDc86u3ai/aNYWwiZKJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dannenberg <dannenberg@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/165] spi: spi-ti-qspi: Fix a bug when accessing non default CS
Date:   Sat, 11 Jan 2020 10:49:37 +0100
Message-Id: <20200111094926.071778933@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
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



