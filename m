Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CE91D42F4
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 03:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgEOB3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 21:29:03 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:56474 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbgEOB3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 21:29:03 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 04F1SjvH023296; Fri, 15 May 2020 10:28:45 +0900
X-Iguazu-Qid: 34ts1iCWKmbS6Vv0ba
X-Iguazu-QSIG: v=2; s=0; t=1589506124; q=34ts1iCWKmbS6Vv0ba; m=chjwo5BKAJN0yfaj8dQea3Edj3RZ5NTZdR5aGxFWEkc=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1511) id 04F1ShGo031210;
        Fri, 15 May 2020 10:28:44 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 04F1ShZY027002;
        Fri, 15 May 2020 10:28:43 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id 04F1ShSL009604;
        Fri, 15 May 2020 10:28:43 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Ben Hutchings <ben@decadent.org.uk>,
        "wuxu.wu" <wuxu.wu@huawei.com>, Mark Brown <broonie@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [RFC/PATCH for 3.16] spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls
Date:   Fri, 15 May 2020 10:28:29 +0900
X-TSB-HOP: ON
Message-Id: <20200515012829.1070159-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "wuxu.wu" <wuxu.wu@huawei.com>

commit 19b61392c5a852b4e8a0bf35aecb969983c5932d upstream.

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
[iwamatsu: Backported to 3.16: adjut context]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/spi/spi-dw.c | 14 ++++++++++++--
 drivers/spi/spi-dw.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 66e9e5196c8c5..b3e697d5b5966 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -182,9 +182,11 @@ static inline u32 rx_max(struct dw_spi *dws)
 
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
@@ -196,13 +198,16 @@ static void dw_writer(struct dw_spi *dws)
 		dw_writew(dws, DW_SPI_DR, txw);
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
 		rxw = dw_readw(dws, DW_SPI_DR);
 		/* Care rx only if the transfer's original "rx" is not null */
@@ -214,6 +219,7 @@ static void dw_reader(struct dw_spi *dws)
 		}
 		dws->rx += dws->n_bytes;
 	}
+	spin_unlock(&dws->buf_lock);
 }
 
 static void *next_transfer(struct dw_spi *dws)
@@ -368,6 +374,7 @@ static void pump_transfers(unsigned long data)
 	struct spi_transfer *previous = NULL;
 	struct spi_device *spi = NULL;
 	struct chip_data *chip = NULL;
+	unsigned long flags;
 	u8 bits = 0;
 	u8 imask = 0;
 	u8 cs_change = 0;
@@ -406,6 +413,7 @@ static void pump_transfers(unsigned long data)
 	dws->dma_width = chip->dma_width;
 	dws->cs_control = chip->cs_control;
 
+	spin_lock_irqsave(&dws->buf_lock, flags);
 	dws->rx_dma = transfer->rx_dma;
 	dws->tx_dma = transfer->tx_dma;
 	dws->tx = (void *)transfer->tx_buf;
@@ -415,6 +423,7 @@ static void pump_transfers(unsigned long data)
 	dws->len = dws->cur_transfer->len;
 	if (chip != dws->prev_chip)
 		cs_change = 1;
+	spin_unlock_irqrestore(&dws->buf_lock, flags);
 
 	cr0 = chip->cr0;
 
@@ -651,6 +660,7 @@ int dw_spi_add_host(struct device *dev, struct dw_spi *dws)
 	dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
 	snprintf(dws->name, sizeof(dws->name), "dw_spi%d",
 			dws->bus_num);
+	spin_lock_init(&dws->buf_lock);
 
 	ret = request_irq(dws->irq, dw_spi_irq, IRQF_SHARED, dws->name, dws);
 	if (ret < 0) {
diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 6d2acad34f64f..be4119a2159bf 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -116,6 +116,7 @@ struct dw_spi {
 	size_t			len;
 	void			*tx;
 	void			*tx_end;
+	spinlock_t		buf_lock;
 	void			*rx;
 	void			*rx_end;
 	int			dma_mapped;
-- 
2.26.0

