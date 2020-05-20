Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506D71DB6F3
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgETO2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:28:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32774 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726857AbgETOWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:23 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-00034w-5Q; Wed, 20 May 2020 15:22:18 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbt-007DO4-OT; Wed, 20 May 2020 15:22:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>,
        "Mark Brown" <broonie@kernel.org>, "wuxu.wu" <wuxu.wu@huawei.com>
Date:   Wed, 20 May 2020 15:13:31 +0100
Message-ID: <lsq.1589984008.211986776@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 03/99] spi: spi-dw: Add lock protect dw_spi rx/tx to
 prevent concurrent calls
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-dw.c | 14 ++++++++++++--
 drivers/spi/spi-dw.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -182,9 +182,11 @@ static inline u32 rx_max(struct dw_spi *
 
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
@@ -196,13 +198,16 @@ static void dw_writer(struct dw_spi *dws
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
@@ -214,6 +219,7 @@ static void dw_reader(struct dw_spi *dws
 		}
 		dws->rx += dws->n_bytes;
 	}
+	spin_unlock(&dws->buf_lock);
 }
 
 static void *next_transfer(struct dw_spi *dws)
@@ -368,6 +374,7 @@ static void pump_transfers(unsigned long
 	struct spi_transfer *previous = NULL;
 	struct spi_device *spi = NULL;
 	struct chip_data *chip = NULL;
+	unsigned long flags;
 	u8 bits = 0;
 	u8 imask = 0;
 	u8 cs_change = 0;
@@ -406,6 +413,7 @@ static void pump_transfers(unsigned long
 	dws->dma_width = chip->dma_width;
 	dws->cs_control = chip->cs_control;
 
+	spin_lock_irqsave(&dws->buf_lock, flags);
 	dws->rx_dma = transfer->rx_dma;
 	dws->tx_dma = transfer->tx_dma;
 	dws->tx = (void *)transfer->tx_buf;
@@ -415,6 +423,7 @@ static void pump_transfers(unsigned long
 	dws->len = dws->cur_transfer->len;
 	if (chip != dws->prev_chip)
 		cs_change = 1;
+	spin_unlock_irqrestore(&dws->buf_lock, flags);
 
 	cr0 = chip->cr0;
 
@@ -651,6 +660,7 @@ int dw_spi_add_host(struct device *dev,
 	dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
 	snprintf(dws->name, sizeof(dws->name), "dw_spi%d",
 			dws->bus_num);
+	spin_lock_init(&dws->buf_lock);
 
 	ret = request_irq(dws->irq, dw_spi_irq, IRQF_SHARED, dws->name, dws);
 	if (ret < 0) {
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

