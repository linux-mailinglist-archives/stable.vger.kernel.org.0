Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1C939A72D
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhFCRKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhFCRKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 992A361403;
        Thu,  3 Jun 2021 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740115;
        bh=WOLd7ah1qgxPQgGi8mtCBc+GE/1Vg1PbV/3cQNmYmbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfcOTgKlmndVxQ2rrnjsDXuPlyv82APoaNEn7ZkRwH91eCF8KBnZn6P6ohaxmMZMN
         4A3p7+m7qmZeOoWBLZ5RD/eIFelTyNNCWlcSqG1aMJ2TgpXzXtkmbjcKY5iudJq7+b
         Id+8DkMjdJjV6ghhImgoUR0LoksHFNxdP5vcRjGFZNGmePjY5kYZ2MFa7OmazN/rgk
         1menhVBXrqBdlvuSLtftV4VZ8gIRFzT+4iLAwu1Zfmvs2aX5sO8wEFf5lFnnlOXqbt
         KH3flm+YAsPVz4jUF1gGNqfZXEOH4jTo8LfC1VLCheSEtSWu46HFb9bzIwNu4HMMAI
         gAveHeewu6wfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karen Dombroski <karen.dombroski@marsbioimaging.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 04/39] spi: spi-zynq-qspi: Fix stack violation bug
Date:   Thu,  3 Jun 2021 13:07:54 -0400
Message-Id: <20210603170829.3168708-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

