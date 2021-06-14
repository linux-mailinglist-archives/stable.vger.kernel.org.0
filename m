Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A704D3A6265
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhFNLAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234470AbhFNK5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F7AE61606;
        Mon, 14 Jun 2021 10:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667286;
        bh=WOLd7ah1qgxPQgGi8mtCBc+GE/1Vg1PbV/3cQNmYmbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXz7bMtP7PjGIaW/wMg2RR5rEvoxtJBhTBedvmaGvKJPFaDbeBjYOO0DcVSWJu689
         S6ijKq1584K6wF3x1W1DYwzAOoGMHkIsLEzMTHAXSoeXlffwI2Dwjm1OskwxNk37q1
         P57pv0ARtwUtoDlP6GvkGoM1lqiSbuYu39gZ1DOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Karen Dombroski <karen.dombroski@marsbioimaging.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/131] spi: spi-zynq-qspi: Fix stack violation bug
Date:   Mon, 14 Jun 2021 12:26:06 +0200
Message-Id: <20210614102653.155326989@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karen Dombroski <karen.dombroski@marsbioimaging.com>

[ Upstream commit 6d5ff8e632a4f2389c331e5554cd1c2a9a28c7aa ]

When the number of bytes for the op is greater than one, the read could
run off the end of the function stack and cause a crash.

This patch restores the behaviour of safely reading out of the original
opcode location.

Signed-off-by: Karen Dombroski <karen.dombroski@marsbioimaging.com>
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Link: https://lore.kernel.org/r/20210429053802.17650-3-amit.kumar-mahapatra@xilinx.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynq-qspi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index 5d8a5ee62fa2..2765289028fa 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -528,18 +528,17 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 	struct zynq_qspi *xqspi = spi_controller_get_devdata(mem->spi->master);
 	int err = 0, i;
 	u8 *tmpbuf;
-	u8 opcode = op->cmd.opcode;
 
 	dev_dbg(xqspi->dev, "cmd:%#x mode:%d.%d.%d.%d\n",
-		opcode, op->cmd.buswidth, op->addr.buswidth,
+		op->cmd.opcode, op->cmd.buswidth, op->addr.buswidth,
 		op->dummy.buswidth, op->data.buswidth);
 
 	zynq_qspi_chipselect(mem->spi, true);
 	zynq_qspi_config_op(xqspi, mem->spi);
 
-	if (op->cmd.nbytes) {
+	if (op->cmd.opcode) {
 		reinit_completion(&xqspi->data_completion);
-		xqspi->txbuf = &opcode;
+		xqspi->txbuf = (u8 *)&op->cmd.opcode;
 		xqspi->rxbuf = NULL;
 		xqspi->tx_bytes = op->cmd.nbytes;
 		xqspi->rx_bytes = op->cmd.nbytes;
-- 
2.30.2



