Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 032BC14E263
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgA3Soa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730828AbgA3So1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D2A1214DB;
        Thu, 30 Jan 2020 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409866;
        bh=+4JoOjg9YkisXPPRKAgUTSvATW03i/cdPH6O5FS/hEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkSTwpb5JCxTxVY+DKO2nuZ15sRfe1ize0FgnEUsfEH35S2ZlGqh/BVdGyWxtNS0G
         MiM7++pCa/YbgdlAOQuimYxY0tcjgPWlAeHI2owTC/QYtQSpfHnY7Z8XkObFA/j04/
         ZAEN0+QvxnKxJwbqHA1kYOpRCuPKNR3B200Zowyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "wuxu.wu" <wuxu.wu@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/110] spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls
Date:   Thu, 30 Jan 2020 19:38:41 +0100
Message-Id: <20200130183622.456789217@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wuxu.wu <wuxu.wu@huawei.com>

[ Upstream commit 19b61392c5a852b4e8a0bf35aecb969983c5932d ]

dw_spi_irq() and dw_spi_transfer_one concurrent calls.

I find a panic in dw_writer(): txw = *(u8 *)(dws->tx), when dw->tx==null,
dw->len==4, and dw->tx_end==1.

When tpm driver's message overtime dw_spi_irq() and dw_spi_transfer_one
may concurrent visit dw_spi, so I think dw_spi structure lack of protection.

Otherwise dw_spi_transfer_one set dw rx/tx buffer and then open irq,
store dw rx/tx instructions and other cores handle irq load dw rx/tx
instructions may out of order.

	[ 1025.321302] Call trace:
	...
	[ 1025.321319]  __crash_kexec+0x98/0x148
	[ 1025.321323]  panic+0x17c/0x314
	[ 1025.321329]  die+0x29c/0x2e8
	[ 1025.321334]  die_kernel_fault+0x68/0x78
	[ 1025.321337]  __do_kernel_fault+0x90/0xb0
	[ 1025.321346]  do_page_fault+0x88/0x500
	[ 1025.321347]  do_translation_fault+0xa8/0xb8
	[ 1025.321349]  do_mem_abort+0x68/0x118
	[ 1025.321351]  el1_da+0x20/0x8c
	[ 1025.321362]  dw_writer+0xc8/0xd0
	[ 1025.321364]  interrupt_transfer+0x60/0x110
	[ 1025.321365]  dw_spi_irq+0x48/0x70
	...

Signed-off-by: wuxu.wu <wuxu.wu@huawei.com>
Link: https://lore.kernel.org/r/1577849981-31489-1-git-send-email-wuxu.wu@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.c | 15 ++++++++++++---
 drivers/spi/spi-dw.h |  1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 45972056ed8c8..11cac7e106635 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -172,9 +172,11 @@ static inline u32 rx_max(struct dw_spi *dws)
 
 static void dw_writer(struct dw_spi *dws)
 {
-	u32 max = tx_max(dws);
+	u32 max;
 	u16 txw = 0;
 
+	spin_lock(&dws->buf_lock);
+	max = tx_max(dws);
 	while (max--) {
 		/* Set the tx word if the transfer's original "tx" is not null */
 		if (dws->tx_end - dws->len) {
@@ -186,13 +188,16 @@ static void dw_writer(struct dw_spi *dws)
 		dw_write_io_reg(dws, DW_SPI_DR, txw);
 		dws->tx += dws->n_bytes;
 	}
+	spin_unlock(&dws->buf_lock);
 }
 
 static void dw_reader(struct dw_spi *dws)
 {
-	u32 max = rx_max(dws);
+	u32 max;
 	u16 rxw;
 
+	spin_lock(&dws->buf_lock);
+	max = rx_max(dws);
 	while (max--) {
 		rxw = dw_read_io_reg(dws, DW_SPI_DR);
 		/* Care rx only if the transfer's original "rx" is not null */
@@ -204,6 +209,7 @@ static void dw_reader(struct dw_spi *dws)
 		}
 		dws->rx += dws->n_bytes;
 	}
+	spin_unlock(&dws->buf_lock);
 }
 
 static void int_error_stop(struct dw_spi *dws, const char *msg)
@@ -276,18 +282,20 @@ static int dw_spi_transfer_one(struct spi_controller *master,
 {
 	struct dw_spi *dws = spi_controller_get_devdata(master);
 	struct chip_data *chip = spi_get_ctldata(spi);
+	unsigned long flags;
 	u8 imask = 0;
 	u16 txlevel = 0;
 	u32 cr0;
 	int ret;
 
 	dws->dma_mapped = 0;
-
+	spin_lock_irqsave(&dws->buf_lock, flags);
 	dws->tx = (void *)transfer->tx_buf;
 	dws->tx_end = dws->tx + transfer->len;
 	dws->rx = transfer->rx_buf;
 	dws->rx_end = dws->rx + transfer->len;
 	dws->len = transfer->len;
+	spin_unlock_irqrestore(&dws->buf_lock, flags);
 
 	spi_enable_chip(dws, 0);
 
@@ -471,6 +479,7 @@ int dw_spi_add_host(struct device *dev, struct dw_spi *dws)
 	dws->type = SSI_MOTO_SPI;
 	dws->dma_inited = 0;
 	dws->dma_addr = (dma_addr_t)(dws->paddr + DW_SPI_DR);
+	spin_lock_init(&dws->buf_lock);
 
 	spi_controller_set_devdata(master, dws);
 
diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index c9c15881e9824..f3a2f157a2b17 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -120,6 +120,7 @@ struct dw_spi {
 	size_t			len;
 	void			*tx;
 	void			*tx_end;
+	spinlock_t		buf_lock;
 	void			*rx;
 	void			*rx_end;
 	int			dma_mapped;
-- 
2.20.1



