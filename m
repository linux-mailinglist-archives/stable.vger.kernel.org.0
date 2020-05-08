Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231141CAF21
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgEHNPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbgEHMqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F215208D6;
        Fri,  8 May 2020 12:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941978;
        bh=iaJgSycNveGukZ45uUAhwvuBgSrYC1SKqiUsBBB6haw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiJ5Hlusu6OH1DzwW8WZPRm+o6yhGY51vFD5C3Qx22Ic9kEDQ1KrCpl7OWRtodXK3
         Hl0IWPZ6SQ4IYMD6TNqij4ULeDPN3bUPqMtFDDeEk3mATykfR45nArC1x+mblPHt2u
         MBqxHHq264s5J5YSwfDf4+Kp+VhlN0z2RHgxsRq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Addy ke <addy.ke@rock-chips.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Caesar Wang <wxt@rock-chips.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 4.4 248/312] spi: rockchip: modify DMA max burst to 1
Date:   Fri,  8 May 2020 14:33:59 +0200
Message-Id: <20200508123141.862800005@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Addy Ke <addy.ke@rock-chips.com>

commit 80abf8880cc6e1594c11b7c417f22dde60e25312 upstream.

Generic dma controller on Rockchips' platform cannot support
DMAFLUSHP instruction which make dma to flush the req of non-aligned
or non-multiple of what we need. That will cause an unrecoverable
dma bus error. The saftest way is to set dma max burst to 1.

Signed-off-by: Addy ke <addy.ke@rock-chips.com>
Fixes: 64e36824b32b06 ("spi/rockchip: add driver for Rockchip...")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
cc: Heiko Stuebner <heiko@sntech.de>
cc: Olof Johansson <olof@lixom.net>
cc: Doug Anderson <dianders@chromium.org>
cc: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Caesar Wang <wxt@rock-chips.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>

---
 drivers/spi/spi-rockchip.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -199,6 +199,7 @@ struct rockchip_spi {
 	struct sg_table rx_sg;
 	struct rockchip_spi_dma_data dma_rx;
 	struct rockchip_spi_dma_data dma_tx;
+	struct dma_slave_caps dma_caps;
 };
 
 static inline void spi_enable_chip(struct rockchip_spi *rs, int enable)
@@ -457,7 +458,10 @@ static void rockchip_spi_prepare_dma(str
 		rxconf.direction = rs->dma_rx.direction;
 		rxconf.src_addr = rs->dma_rx.addr;
 		rxconf.src_addr_width = rs->n_bytes;
-		rxconf.src_maxburst = rs->n_bytes;
+		if (rs->dma_caps.max_burst > 4)
+			rxconf.src_maxburst = 4;
+		else
+			rxconf.src_maxburst = 1;
 		dmaengine_slave_config(rs->dma_rx.ch, &rxconf);
 
 		rxdesc = dmaengine_prep_slave_sg(
@@ -474,7 +478,10 @@ static void rockchip_spi_prepare_dma(str
 		txconf.direction = rs->dma_tx.direction;
 		txconf.dst_addr = rs->dma_tx.addr;
 		txconf.dst_addr_width = rs->n_bytes;
-		txconf.dst_maxburst = rs->n_bytes;
+		if (rs->dma_caps.max_burst > 4)
+			txconf.dst_maxburst = 4;
+		else
+			txconf.dst_maxburst = 1;
 		dmaengine_slave_config(rs->dma_tx.ch, &txconf);
 
 		txdesc = dmaengine_prep_slave_sg(
@@ -738,6 +745,7 @@ static int rockchip_spi_probe(struct pla
 	}
 
 	if (rs->dma_tx.ch && rs->dma_rx.ch) {
+		dma_get_slave_caps(rs->dma_rx.ch, &(rs->dma_caps));
 		rs->dma_tx.addr = (dma_addr_t)(mem->start + ROCKCHIP_SPI_TXDR);
 		rs->dma_rx.addr = (dma_addr_t)(mem->start + ROCKCHIP_SPI_RXDR);
 		rs->dma_tx.direction = DMA_MEM_TO_DEV;


