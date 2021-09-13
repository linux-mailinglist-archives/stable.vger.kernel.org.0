Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996A9408EDF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241488AbhIMNhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243280AbhIMNfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:35:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D456E6113B;
        Mon, 13 Sep 2021 13:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539635;
        bh=6/nUNLV6uq2S6wGpXS5nMzjp8J1lMFzCHjONzA59AyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+4owsLUPanEH/1IYwdDpwdDAg+JLsAx0BHqnqw0p1m+ptsCB6BYvINftbKg9JeiS
         Fkbb4B2gg9siBQbMAvxOtaJtpRTOEgSu/1OpqjHLLNqQ0eHaVejfj+BCOx20lMX8D2
         xol4fKe9HeqhPWvg174M0fALz5ic8RMmEFkYQIRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/236] spi: spi-zynq-qspi: use wait_for_completion_timeout to make zynq_qspi_exec_mem_op not interruptible
Date:   Mon, 13 Sep 2021 15:12:52 +0200
Message-Id: <20210913131102.639110781@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 26cfc0dbe43aae60dc03af27077775244f26c167 ]

The function wait_for_completion_interruptible_timeout will return
-ERESTARTSYS immediately when receiving SIGKILL signal which is sent
by "jffs2_gcd_mtd" during umounting jffs2. This will break the SPI memory
operation because the data transmitting may begin before the command or
address transmitting completes. Use wait_for_completion_timeout to prevent
the process from being interruptible.

Fixes: 67dca5e580f1 ("spi: spi-mem: Add support for Zynq QSPI controller")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Link: https://lore.kernel.org/r/20210826005930.20572-1-quanyang.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynq-qspi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index 68193db8b2e3..b635835729d6 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -545,7 +545,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 		zynq_qspi_write_op(xqspi, ZYNQ_QSPI_FIFO_DEPTH, true);
 		zynq_qspi_write(xqspi, ZYNQ_QSPI_IEN_OFFSET,
 				ZYNQ_QSPI_IXR_RXTX_MASK);
-		if (!wait_for_completion_interruptible_timeout(&xqspi->data_completion,
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
 							       msecs_to_jiffies(1000)))
 			err = -ETIMEDOUT;
 	}
@@ -563,7 +563,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 		zynq_qspi_write_op(xqspi, ZYNQ_QSPI_FIFO_DEPTH, true);
 		zynq_qspi_write(xqspi, ZYNQ_QSPI_IEN_OFFSET,
 				ZYNQ_QSPI_IXR_RXTX_MASK);
-		if (!wait_for_completion_interruptible_timeout(&xqspi->data_completion,
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
 							       msecs_to_jiffies(1000)))
 			err = -ETIMEDOUT;
 	}
@@ -579,7 +579,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 		zynq_qspi_write_op(xqspi, ZYNQ_QSPI_FIFO_DEPTH, true);
 		zynq_qspi_write(xqspi, ZYNQ_QSPI_IEN_OFFSET,
 				ZYNQ_QSPI_IXR_RXTX_MASK);
-		if (!wait_for_completion_interruptible_timeout(&xqspi->data_completion,
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
 							       msecs_to_jiffies(1000)))
 			err = -ETIMEDOUT;
 
@@ -603,7 +603,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 		zynq_qspi_write_op(xqspi, ZYNQ_QSPI_FIFO_DEPTH, true);
 		zynq_qspi_write(xqspi, ZYNQ_QSPI_IEN_OFFSET,
 				ZYNQ_QSPI_IXR_RXTX_MASK);
-		if (!wait_for_completion_interruptible_timeout(&xqspi->data_completion,
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
 							       msecs_to_jiffies(1000)))
 			err = -ETIMEDOUT;
 	}
-- 
2.30.2



