Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F7837C8BA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhELQMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239010AbhELQHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9C5A61D09;
        Wed, 12 May 2021 15:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833742;
        bh=TffKJI8KAmcyDmLPVib2/8wDzsgHdlux5bMi96Gdqn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcGa80EJwwHqKfX2Oo1EdgtxvkvQLdH3euDXdfvYuzNyGLmU6nrMg9vDmflBFrKRe
         0nWKsDn+naPSSh9/QvjSHVjHTqhpiOqea52WS7xR7LLEqyfawikLLDQmJqB4RzqaPN
         c2jOX4MSMX9OMIbtfSGXZh7Ovn6lIODrW19CsBuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 271/601] spi: spi-zynqmp-gqspi: fix incorrect operating mode in zynqmp_qspi_read_op
Date:   Wed, 12 May 2021 16:45:48 +0200
Message-Id: <20210512144836.740401251@linuxfoundation.org>
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

[ Upstream commit 41d310930084502433fcb3c4baf219e7424b7734 ]

When starting a read operation, we should call zynqmp_qspi_setuprxdma
first to set xqspi->mode according to xqspi->bytes_to_receive and
to calculate correct xqspi->dma_rx_bytes. Then in the function
zynqmp_qspi_fillgenfifo, generate the appropriate command with
operating mode and bytes to transfer, and fill the GENFIFO with
the command to perform the read operation.

Calling zynqmp_qspi_fillgenfifo before zynqmp_qspi_setuprxdma will
result in incorrect transfer length and operating mode. So change
the calling order to fix this issue.

Fixes: 1c26372e5aa9 ("spi: spi-zynqmp-gqspi: Update driver to use spi-mem framework")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Reviewed-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Link: https://lore.kernel.org/r/20210408040223.23134-5-quanyang.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index cf73a069b759..036d8ae41c06 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -827,8 +827,8 @@ static void zynqmp_qspi_write_op(struct zynqmp_qspi *xqspi, u8 tx_nbits,
 static void zynqmp_qspi_read_op(struct zynqmp_qspi *xqspi, u8 rx_nbits,
 				u32 genfifoentry)
 {
-	zynqmp_qspi_fillgenfifo(xqspi, rx_nbits, genfifoentry);
 	zynqmp_qspi_setuprxdma(xqspi);
+	zynqmp_qspi_fillgenfifo(xqspi, rx_nbits, genfifoentry);
 }
 
 /**
-- 
2.30.2



