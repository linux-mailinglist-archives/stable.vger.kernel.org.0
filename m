Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DA037C8EC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbhELQNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239382AbhELQH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DBF961C75;
        Wed, 12 May 2021 15:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833870;
        bh=s0g5S8odRju7kFcdBL7xfjSpY3t0m+/AzXi0YNquHg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3/DbpeTwKqX1Tz7UEbnp6/Ix5lWLEzCDGhXWawmxygxi0RV6CaBdstgu7DEQ2z0N
         uYRX7V05UzmyR1fM1V34C7XpHQLKLoB+2DKu753O6Gt7r2O2jZiya0ADmpXOeZLG5B
         M6eBAWdTxVwWZaM3R6kumnYALZXZ4xE2vReTnQ8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 294/601] spi: spi-zynqmp-gqspi: fix use-after-free in zynqmp_qspi_exec_op
Date:   Wed, 12 May 2021 16:46:11 +0200
Message-Id: <20210512144837.497693832@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit a2c5bedb2d55dd27c642c7b9fb6886d7ad7bdb58 ]

When handling op->addr, it is using the buffer "tmpbuf" which has been
freed. This will trigger a use-after-free KASAN warning. Let's use
temporary variables to store op->addr.val and op->cmd.opcode to fix
this issue.

Fixes: 1c26372e5aa9 ("spi: spi-zynqmp-gqspi: Update driver to use spi-mem framework")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Link: https://lore.kernel.org/r/20210416004652.2975446-5-quanyang.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index d6ac8fe145a1..2a0be16b2eb0 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -926,8 +926,9 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 	struct zynqmp_qspi *xqspi = spi_controller_get_devdata
 				    (mem->spi->master);
 	int err = 0, i;
-	u8 *tmpbuf;
 	u32 genfifoentry = 0;
+	u16 opcode = op->cmd.opcode;
+	u64 opaddr;
 
 	dev_dbg(xqspi->dev, "cmd:%#x mode:%d.%d.%d.%d\n",
 		op->cmd.opcode, op->cmd.buswidth, op->addr.buswidth,
@@ -940,14 +941,8 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 	genfifoentry |= xqspi->genfifobus;
 
 	if (op->cmd.opcode) {
-		tmpbuf = kzalloc(op->cmd.nbytes, GFP_KERNEL | GFP_DMA);
-		if (!tmpbuf) {
-			mutex_unlock(&xqspi->op_lock);
-			return -ENOMEM;
-		}
-		tmpbuf[0] = op->cmd.opcode;
 		reinit_completion(&xqspi->data_completion);
-		xqspi->txbuf = tmpbuf;
+		xqspi->txbuf = &opcode;
 		xqspi->rxbuf = NULL;
 		xqspi->bytes_to_transfer = op->cmd.nbytes;
 		xqspi->bytes_to_receive = 0;
@@ -961,13 +956,12 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 		if (!wait_for_completion_timeout
 		    (&xqspi->data_completion, msecs_to_jiffies(1000))) {
 			err = -ETIMEDOUT;
-			kfree(tmpbuf);
 			goto return_err;
 		}
-		kfree(tmpbuf);
 	}
 
 	if (op->addr.nbytes) {
+		xqspi->txbuf = &opaddr;
 		for (i = 0; i < op->addr.nbytes; i++) {
 			*(((u8 *)xqspi->txbuf) + i) = op->addr.val >>
 					(8 * (op->addr.nbytes - i - 1));
-- 
2.30.2



