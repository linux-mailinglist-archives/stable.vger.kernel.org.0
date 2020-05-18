Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F35C1D806D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgERRjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbgERRjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:39:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 466B12083E;
        Mon, 18 May 2020 17:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823585;
        bh=qAHCWrioLNufzVaxB4pLOJpa7VgRqthNqvTyV3ytbwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnyZYwde1onS47vTtiF1jnKlOqne4l1xrnt82XkDxM4K03sObQep9GStU1UXkdeXg
         cTvp//tss+3K6dpmToRw74QsZaLA8mLL8h0WKPOpITMUrNqw/Jpt/MhIWRQr8k0KwH
         qy2v+FuomkIhIc6pp/cRHZUVP1GTsleA1QYwZbGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "wuxu.wu" <wuxu.wu@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 40/86] spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls
Date:   Mon, 18 May 2020 19:36:11 +0200
Message-Id: <20200518173458.510093508@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wuxu.wu <wuxu.wu@huawei.com>

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
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-dw.c |   15 ++++++++++++---
 drivers/spi/spi-dw.h |    1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -180,9 +180,11 @@ static inline u32 rx_max(struct dw_spi *
 
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
@@ -194,13 +196,16 @@ static void dw_writer(struct dw_spi *dws
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
@@ -212,6 +217,7 @@ static void dw_reader(struct dw_spi *dws
 		}
 		dws->rx += dws->n_bytes;
 	}
+	spin_unlock(&dws->buf_lock);
 }
 
 static void int_error_stop(struct dw_spi *dws, const char *msg)
@@ -284,6 +290,7 @@ static int dw_spi_transfer_one(struct sp
 {
 	struct dw_spi *dws = spi_master_get_devdata(master);
 	struct chip_data *chip = spi_get_ctldata(spi);
+	unsigned long flags;
 	u8 imask = 0;
 	u16 txlevel = 0;
 	u16 clk_div;
@@ -291,12 +298,13 @@ static int dw_spi_transfer_one(struct sp
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
 
@@ -488,6 +496,7 @@ int dw_spi_add_host(struct device *dev,
 	dws->dma_inited = 0;
 	dws->dma_addr = (dma_addr_t)(dws->paddr + DW_SPI_DR);
 	snprintf(dws->name, sizeof(dws->name), "dw_spi%d", dws->bus_num);
+	spin_lock_init(&dws->buf_lock);
 
 	ret = request_irq(dws->irq, dw_spi_irq, IRQF_SHARED, dws->name, master);
 	if (ret < 0) {
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


