Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCBD29B7E2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368782AbgJ0P1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798137AbgJ0PZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:25:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD0B20728;
        Tue, 27 Oct 2020 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812344;
        bh=/MpkjtwbIeJqfHde6uoQ+qIVHoHiphfOXqQaZX7nSp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRxSrRqxhGBaJmpDC58Yo6SJwV+kFW4sHbxCtjpuAqFQvCswERqeDczjInAffykNa
         DmIwRepoMcofN+YuFiG57Jp1txtBTdnKEQ+yZGF8pcUB9hBJrH4GWjt3dFq+I6dbnr
         aKF69691i5j4Bpb3UqIfU9uat7YL4IpizQuYqlAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brad Bishop <bradleyb@fuzziesquirrel.com>,
        Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 146/757] spi: fsi: Fix use of the bneq+ sequencer instruction
Date:   Tue, 27 Oct 2020 14:46:36 +0100
Message-Id: <20201027135457.451054336@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brad Bishop <bradleyb@fuzziesquirrel.com>

[ Upstream commit 7909eebb2bea7fdbb2de0aa794cf29843761ed5b ]

All of the switches in N2_count_control in the counter configuration are
required to make the branch if not equal and increment command work.
Set them when using bneq+.

A side effect of this mode requires a dummy write to TDR when both
transmitting and receiving otherwise the controller won't start shifting
receive data.

It is likely not possible to avoid TDR underrun errors in this mode and
they are harmless, so do not check for them.

Fixes: bbb6b2f9865b ("spi: Add FSI-attached SPI controller driver")
Signed-off-by: Brad Bishop <bradleyb@fuzziesquirrel.com>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20200909222857.28653-4-eajames@linux.ibm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsi.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index 8f64af0140e09..bb18b407cdcf3 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -29,6 +29,10 @@
 #define SPI_FSI_ERROR			0x0
 #define SPI_FSI_COUNTER_CFG		0x1
 #define  SPI_FSI_COUNTER_CFG_LOOPS(x)	 (((u64)(x) & 0xffULL) << 32)
+#define  SPI_FSI_COUNTER_CFG_N2_RX	 BIT_ULL(8)
+#define  SPI_FSI_COUNTER_CFG_N2_TX	 BIT_ULL(9)
+#define  SPI_FSI_COUNTER_CFG_N2_IMPLICIT BIT_ULL(10)
+#define  SPI_FSI_COUNTER_CFG_N2_RELOAD	 BIT_ULL(11)
 #define SPI_FSI_CFG1			0x2
 #define SPI_FSI_CLOCK_CFG		0x3
 #define  SPI_FSI_CLOCK_CFG_MM_ENABLE	 BIT_ULL(32)
@@ -61,7 +65,7 @@
 #define  SPI_FSI_STATUS_RDR_OVERRUN	 BIT_ULL(62)
 #define  SPI_FSI_STATUS_RDR_FULL	 BIT_ULL(63)
 #define  SPI_FSI_STATUS_ANY_ERROR	 \
-	(SPI_FSI_STATUS_ERROR | SPI_FSI_STATUS_TDR_UNDERRUN | \
+	(SPI_FSI_STATUS_ERROR | \
 	 SPI_FSI_STATUS_TDR_OVERRUN | SPI_FSI_STATUS_RDR_UNDERRUN | \
 	 SPI_FSI_STATUS_RDR_OVERRUN)
 #define SPI_FSI_PORT_CTRL		0x9
@@ -238,6 +242,7 @@ static int fsi_spi_sequence_transfer(struct fsi_spi *ctx,
 	int rc;
 	u8 len = min(transfer->len, 8U);
 	u8 rem = transfer->len % len;
+	u64 cfg = 0ULL;
 
 	loops = transfer->len / len;
 
@@ -258,8 +263,14 @@ static int fsi_spi_sequence_transfer(struct fsi_spi *ctx,
 	if (loops > 1) {
 		fsi_spi_sequence_add(seq, SPI_FSI_SEQUENCE_BRANCH(idx));
 
-		rc = fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG,
-				       SPI_FSI_COUNTER_CFG_LOOPS(loops - 1));
+		cfg = SPI_FSI_COUNTER_CFG_LOOPS(loops - 1);
+		if (transfer->rx_buf)
+			cfg |= SPI_FSI_COUNTER_CFG_N2_RX |
+				SPI_FSI_COUNTER_CFG_N2_TX |
+				SPI_FSI_COUNTER_CFG_N2_IMPLICIT |
+				SPI_FSI_COUNTER_CFG_N2_RELOAD;
+
+		rc = fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG, cfg);
 		if (rc)
 			return rc;
 	}
@@ -275,6 +286,7 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 {
 	int rc = 0;
 	u64 status = 0ULL;
+	u64 cfg = 0ULL;
 
 	if (transfer->tx_buf) {
 		int nb;
@@ -312,6 +324,16 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 		u64 in = 0ULL;
 		u8 *rx = transfer->rx_buf;
 
+		rc = fsi_spi_read_reg(ctx, SPI_FSI_COUNTER_CFG, &cfg);
+		if (rc)
+			return rc;
+
+		if (cfg & SPI_FSI_COUNTER_CFG_N2_IMPLICIT) {
+			rc = fsi_spi_write_reg(ctx, SPI_FSI_DATA_TX, 0);
+			if (rc)
+				return rc;
+		}
+
 		while (transfer->len > recv) {
 			do {
 				rc = fsi_spi_read_reg(ctx, SPI_FSI_STATUS,
-- 
2.25.1



