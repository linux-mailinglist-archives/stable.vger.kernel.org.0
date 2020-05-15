Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E621D4235
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 02:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgEOAl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 20:41:27 -0400
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:59022 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgEOAl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 20:41:27 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 04F0fHYr007603; Fri, 15 May 2020 09:41:17 +0900
X-Iguazu-Qid: 2wHHmtTgm5EShJ2HOj
X-Iguazu-QSIG: v=2; s=0; t=1589503277; q=2wHHmtTgm5EShJ2HOj; m=F5IG6JWbQw0m8zDfmjMiZ9lVpsadh0g5Suh1sgtNL2c=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1110) id 04F0fG3B025780;
        Fri, 15 May 2020 09:41:16 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 04F0fG0P000648;
        Fri, 15 May 2020 09:41:16 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id 04F0fGbU028114;
        Fri, 15 May 2020 09:41:16 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, "wuxu.wu" <wuxu.wu@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Nobuhiro Iwamatsu <npbuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4, 4.9] spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls
Date:   Fri, 15 May 2020 09:40:56 +0900
X-TSB-HOP: ON
Message-Id: <20200515004056.1069809-1-nobuhiro1.iwamatsu@toshiba.co.jp>
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
Signed-off-by: Nobuhiro Iwamatsu (CIP) <npbuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/spi/spi-dw.c | 15 ++++++++++++---
 drivers/spi/spi-dw.h |  1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 87a0e47eeae64..4edd38d03b939 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -180,9 +180,11 @@ static inline u32 rx_max(struct dw_spi *dws)
 
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
@@ -194,13 +196,16 @@ static void dw_writer(struct dw_spi *dws)
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
@@ -212,6 +217,7 @@ static void dw_reader(struct dw_spi *dws)
 		}
 		dws->rx += dws->n_bytes;
 	}
+	spin_unlock(&dws->buf_lock);
 }
 
 static void int_error_stop(struct dw_spi *dws, const char *msg)
@@ -284,6 +290,7 @@ static int dw_spi_transfer_one(struct spi_master *master,
 {
 	struct dw_spi *dws = spi_master_get_devdata(master);
 	struct chip_data *chip = spi_get_ctldata(spi);
+	unsigned long flags;
 	u8 imask = 0;
 	u16 txlevel = 0;
 	u16 clk_div;
@@ -291,12 +298,13 @@ static int dw_spi_transfer_one(struct spi_master *master,
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
 
@@ -488,6 +496,7 @@ int dw_spi_add_host(struct device *dev, struct dw_spi *dws)
 	dws->dma_inited = 0;
 	dws->dma_addr = (dma_addr_t)(dws->paddr + DW_SPI_DR);
 	snprintf(dws->name, sizeof(dws->name), "dw_spi%d", dws->bus_num);
+	spin_lock_init(&dws->buf_lock);
 
 	ret = request_irq(dws->irq, dw_spi_irq, IRQF_SHARED, dws->name, master);
 	if (ret < 0) {
diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 35589a270468d..d05b216ea3f87 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -117,6 +117,7 @@ struct dw_spi {
 	size_t			len;
 	void			*tx;
 	void			*tx_end;
+	spinlock_t		buf_lock;
 	void			*rx;
 	void			*rx_end;
 	int			dma_mapped;
-- 
2.26.0

