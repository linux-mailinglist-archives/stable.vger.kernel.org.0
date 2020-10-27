Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2B529B2E3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764409AbgJ0Oqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764397AbgJ0Oqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:46:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BDE12222C;
        Tue, 27 Oct 2020 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810007;
        bh=WLnf6TZZfMo2UufkeOxaHmltYlQFMUdzlIPoCuCQyGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C04xEmoDHb0sQQSHNvZz29rDvBoIDWPs/RqqGyVUI3ic7O9WIm6rw5GFRKvuFdFig
         3WUSyIDB9vOlKRZDVtEmHIyJ29WghfNq/UJ9Vrujl+IbgFGQ5SAMVx0+M1K4hh0e69
         jv+TqllqRfs5fTuCCd7C0SMUCowR3dYVwDGMdsgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 397/408] dmaengine: dw: Add DMA-channels mask cell support
Date:   Tue, 27 Oct 2020 14:55:35 +0100
Message-Id: <20201027135513.413483027@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit e8ee6c8cb61b676f1a2d6b942329e98224bd8ee9 ]

DW DMA IP-core provides a way to synthesize the DMA controller with
channels having different parameters like maximum burst-length,
multi-block support, maximum data width, etc. Those parameters both
explicitly and implicitly affect the channels performance. Since DMA slave
devices might be very demanding to the DMA performance, let's provide a
functionality for the slaves to be assigned with DW DMA channels, which
performance according to the platform engineer fulfill their requirements.
After this patch is applied it can be done by passing the mask of suitable
DMA-channels either directly in the dw_dma_slave structure instance or as
a fifth cell of the DMA DT-property. If mask is zero or not provided, then
there is no limitation on the channels allocation.

For instance Baikal-T1 SoC is equipped with a DW DMAC engine, which first
two channels are synthesized with max burst length of 16, while the rest
of the channels have been created with max-burst-len=4. It would seem that
the first two channels must be faster than the others and should be more
preferable for the time-critical DMA slave devices. In practice it turned
out that the situation is quite the opposite. The channels with
max-burst-len=4 demonstrated a better performance than the channels with
max-burst-len=16 even when they both had been initialized with the same
settings. The performance drop of the first two DMA-channels made them
unsuitable for the DW APB SSI slave device. No matter what settings they
are configured with, full-duplex SPI transfers occasionally experience the
Rx FIFO overflow. It means that the DMA-engine doesn't keep up with
incoming data pace even though the SPI-bus is enabled with speed of 25MHz
while the DW DMA controller is clocked with 50MHz signal. There is no such
problem has been noticed for the channels synthesized with
max-burst-len=4.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20200731200826.9292-6-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/core.c                | 4 ++++
 drivers/dma/dw/of.c                  | 7 +++++--
 include/linux/platform_data/dma-dw.h | 2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index a1b56f52db2f2..5e7fdc0b6e3db 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -772,6 +772,10 @@ bool dw_dma_filter(struct dma_chan *chan, void *param)
 	if (dws->dma_dev != chan->device->dev)
 		return false;
 
+	/* permit channels in accordance with the channels mask */
+	if (dws->channels && !(dws->channels & dwc->mask))
+		return false;
+
 	/* We have to copy data since dws can be temporary storage */
 	memcpy(&dwc->dws, dws, sizeof(struct dw_dma_slave));
 
diff --git a/drivers/dma/dw/of.c b/drivers/dma/dw/of.c
index 9e27831dee324..43e975fb67142 100644
--- a/drivers/dma/dw/of.c
+++ b/drivers/dma/dw/of.c
@@ -22,18 +22,21 @@ static struct dma_chan *dw_dma_of_xlate(struct of_phandle_args *dma_spec,
 	};
 	dma_cap_mask_t cap;
 
-	if (dma_spec->args_count != 3)
+	if (dma_spec->args_count < 3 || dma_spec->args_count > 4)
 		return NULL;
 
 	slave.src_id = dma_spec->args[0];
 	slave.dst_id = dma_spec->args[0];
 	slave.m_master = dma_spec->args[1];
 	slave.p_master = dma_spec->args[2];
+	if (dma_spec->args_count >= 4)
+		slave.channels = dma_spec->args[3];
 
 	if (WARN_ON(slave.src_id >= DW_DMA_MAX_NR_REQUESTS ||
 		    slave.dst_id >= DW_DMA_MAX_NR_REQUESTS ||
 		    slave.m_master >= dw->pdata->nr_masters ||
-		    slave.p_master >= dw->pdata->nr_masters))
+		    slave.p_master >= dw->pdata->nr_masters ||
+		    slave.channels >= BIT(dw->pdata->nr_channels)))
 		return NULL;
 
 	dma_cap_zero(cap);
diff --git a/include/linux/platform_data/dma-dw.h b/include/linux/platform_data/dma-dw.h
index f3eaf9ec00a1b..70078be166e3c 100644
--- a/include/linux/platform_data/dma-dw.h
+++ b/include/linux/platform_data/dma-dw.h
@@ -21,6 +21,7 @@
  * @dst_id:	dst request line
  * @m_master:	memory master for transfers on allocated channel
  * @p_master:	peripheral master for transfers on allocated channel
+ * @channels:	mask of the channels permitted for allocation (zero value means any)
  * @hs_polarity:set active low polarity of handshake interface
  */
 struct dw_dma_slave {
@@ -29,6 +30,7 @@ struct dw_dma_slave {
 	u8			dst_id;
 	u8			m_master;
 	u8			p_master;
+	u8			channels;
 	bool			hs_polarity;
 };
 
-- 
2.25.1



