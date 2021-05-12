Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0496D37CC7E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbhELQpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243266AbhELQhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 802CD61E22;
        Wed, 12 May 2021 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835317;
        bh=vNw7hPyriTF8vD1Ecj2og92mIOBMCxSbrMbzY/QIXHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vonc+JJ65qQRyWF+BdMUUInc9IgO8d3k+Xb8DVY5dmRMwwQU7040ujzWtiZlw6O+R
         AF4jZ7nQOW2cuouD1ZbY8qFSDCuC6qLImXmQhgoNdCLTOKySC/kJw3DosHzYqdtsuZ
         A4rQhhSt2mr0Gak6MkjodcavU8yb/d1MKZpW6TS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 294/677] spi: spi-zynqmp-gqspi: add mutex locking for exec_op
Date:   Wed, 12 May 2021 16:45:40 +0200
Message-Id: <20210512144846.980133108@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit a0f65be6e880a14d3445b75e7dc03d7d015fc922 ]

The spi-mem framework has no locking to prevent ctlr->mem_ops->exec_op
from concurrency. So add the locking to zynqmp_qspi_exec_op.

Fixes: 1c26372e5aa9 ("spi: spi-zynqmp-gqspi: Update driver to use spi-mem framework")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Reviewed-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Link: https://lore.kernel.org/r/20210408040223.23134-3-quanyang.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index d49ab6575553..3b39461d58b3 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -173,6 +173,7 @@ struct zynqmp_qspi {
 	u32 genfifoentry;
 	enum mode_type mode;
 	struct completion data_completion;
+	struct mutex op_lock;
 };
 
 /**
@@ -951,6 +952,7 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 		op->cmd.opcode, op->cmd.buswidth, op->addr.buswidth,
 		op->dummy.buswidth, op->data.buswidth);
 
+	mutex_lock(&xqspi->op_lock);
 	zynqmp_qspi_config_op(xqspi, mem->spi);
 	zynqmp_qspi_chipselect(mem->spi, false);
 	genfifoentry |= xqspi->genfifocs;
@@ -1084,6 +1086,7 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 return_err:
 
 	zynqmp_qspi_chipselect(mem->spi, true);
+	mutex_unlock(&xqspi->op_lock);
 
 	return err;
 }
@@ -1156,6 +1159,8 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 		goto clk_dis_pclk;
 	}
 
+	mutex_init(&xqspi->op_lock);
+
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_set_active(&pdev->dev);
-- 
2.30.2



