Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5F837C8B9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhELQMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239004AbhELQHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6311361D05;
        Wed, 12 May 2021 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833734;
        bh=3ko12gNx5sd+b+RuP/0bkyRe5JZE8HzT8Tp0etjgp3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbY+XoQXvPeKAzTjZtF+F7c+41MjlAMt5D/I3w/woOlXy/oKBIqA3oAV18sfI9nOB
         +zdh52FPgURR+ZNuWdpP5s4Vc02+Ic8n3vRKHIlW1neKaRkjjuGnUvd1y5ZI+4RwbX
         jbWlUSX68aBfZRYX32qmGROvrl7aTLdoRsc/KNaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 268/601] spi: spi-zynqmp-gqspi: use wait_for_completion_timeout to make zynqmp_qspi_exec_op not interruptible
Date:   Wed, 12 May 2021 16:45:45 +0200
Message-Id: <20210512144836.639370174@linuxfoundation.org>
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

[ Upstream commit a16bff68b75fd082d36aa0b14b540bd7a3ebebbd ]

When Ctrl+C occurs during the process of zynqmp_qspi_exec_op, the function
wait_for_completion_interruptible_timeout will return a non-zero value
-ERESTARTSYS immediately. This will disrupt the SPI memory operation
because the data transmitting may begin before the command or address
transmitting completes. Use wait_for_completion_timeout to prevent
the process from being interruptible.

This patch fixes the error as below:
root@xilinx-zynqmp:~# flash_erase /dev/mtd3 0 0
Erasing 4 Kibyte @ 3d000 --  4 % complete
    (Press Ctrl+C)
[  169.581911] zynqmp-qspi ff0f0000.spi: Chip select timed out
[  170.585907] zynqmp-qspi ff0f0000.spi: Chip select timed out
[  171.589910] zynqmp-qspi ff0f0000.spi: Chip select timed out
[  172.593910] zynqmp-qspi ff0f0000.spi: Chip select timed out
[  173.597907] zynqmp-qspi ff0f0000.spi: Chip select timed out
[  173.603480] spi-nor spi0.0: Erase operation failed.
[  173.608368] spi-nor spi0.0: Attempted to modify a protected sector.

Fixes: 1c26372e5aa9 ("spi: spi-zynqmp-gqspi: Update driver to use spi-mem framework")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Reviewed-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Link: https://lore.kernel.org/r/20210408040223.23134-2-quanyang.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index c8fa6ee18ae7..d49ab6575553 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -973,7 +973,7 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 		zynqmp_gqspi_write(xqspi, GQSPI_IER_OFST,
 				   GQSPI_IER_GENFIFOEMPTY_MASK |
 				   GQSPI_IER_TXNOT_FULL_MASK);
-		if (!wait_for_completion_interruptible_timeout
+		if (!wait_for_completion_timeout
 		    (&xqspi->data_completion, msecs_to_jiffies(1000))) {
 			err = -ETIMEDOUT;
 			kfree(tmpbuf);
@@ -1001,7 +1001,7 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 				   GQSPI_IER_TXEMPTY_MASK |
 				   GQSPI_IER_GENFIFOEMPTY_MASK |
 				   GQSPI_IER_TXNOT_FULL_MASK);
-		if (!wait_for_completion_interruptible_timeout
+		if (!wait_for_completion_timeout
 		    (&xqspi->data_completion, msecs_to_jiffies(1000))) {
 			err = -ETIMEDOUT;
 			goto return_err;
@@ -1076,7 +1076,7 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 						   GQSPI_IER_RXEMPTY_MASK);
 			}
 		}
-		if (!wait_for_completion_interruptible_timeout
+		if (!wait_for_completion_timeout
 		    (&xqspi->data_completion, msecs_to_jiffies(1000)))
 			err = -ETIMEDOUT;
 	}
-- 
2.30.2



