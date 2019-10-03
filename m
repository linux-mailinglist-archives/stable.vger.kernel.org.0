Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7CFCA777
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfJCQxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392392AbfJCQxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:53:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4F0F2070B;
        Thu,  3 Oct 2019 16:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121620;
        bh=i4IspC7AeqYlgm2PcakB4Ki6b9MyRM+zKi5VW6w/aa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tb5NbJoc+1GCkRMJgK4mvPDoCOXl7WWJod4Nefbdly8Cso4Hpz+ht6zI0nM+ZsD1S
         aIAfj+JBAAVkVFiGEN4oVXj2I8axLrCBIEkiixJrs58lG06IzHKSRjKOXHXxqEjRz7
         28tmhFBMS9HDtr3Gi6OIF72zvYJs/84ybK+Wh8S4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.3 299/344] rtw88: pci: Use DMA sync instead of remapping in RX ISR
Date:   Thu,  3 Oct 2019 17:54:24 +0200
Message-Id: <20191003154609.010463031@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

commit 29b68a920f6abb7b5ba21ab4b779f62d536bac9b upstream.

Since each skb in RX ring is reused instead of new allocation, we can
treat the DMA in a more efficient way by DMA synchronization.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtw88/pci.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -206,6 +206,23 @@ static int rtw_pci_reset_rx_desc(struct
 	return 0;
 }
 
+static void rtw_pci_sync_rx_desc_device(struct rtw_dev *rtwdev, dma_addr_t dma,
+					struct rtw_pci_rx_ring *rx_ring,
+					u32 idx, u32 desc_sz)
+{
+	struct device *dev = rtwdev->dev;
+	struct rtw_pci_rx_buffer_desc *buf_desc;
+	int buf_sz = RTK_PCI_RX_BUF_SIZE;
+
+	dma_sync_single_for_device(dev, dma, buf_sz, DMA_FROM_DEVICE);
+
+	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
+						     idx * desc_sz);
+	memset(buf_desc, 0, sizeof(*buf_desc));
+	buf_desc->buf_size = cpu_to_le16(RTK_PCI_RX_BUF_SIZE);
+	buf_desc->dma = cpu_to_le32(dma);
+}
+
 static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 				struct rtw_pci_rx_ring *rx_ring,
 				u8 desc_size, u32 len)
@@ -784,8 +801,8 @@ static void rtw_pci_rx_isr(struct rtw_de
 		rtw_pci_dma_check(rtwdev, ring, cur_rp);
 		skb = ring->buf[cur_rp];
 		dma = *((dma_addr_t *)skb->cb);
-		pci_unmap_single(rtwpci->pdev, dma, RTK_PCI_RX_BUF_SIZE,
-				 PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(rtwdev->dev, dma, RTK_PCI_RX_BUF_SIZE,
+					DMA_FROM_DEVICE);
 		rx_desc = skb->data;
 		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
 
@@ -820,7 +837,8 @@ static void rtw_pci_rx_isr(struct rtw_de
 
 next_rp:
 		/* new skb delivered to mac80211, re-enable original skb DMA */
-		rtw_pci_reset_rx_desc(rtwdev, skb, ring, cur_rp, buf_desc_sz);
+		rtw_pci_sync_rx_desc_device(rtwdev, dma, ring, cur_rp,
+					    buf_desc_sz);
 
 		/* host read next element in ring */
 		if (++cur_rp >= ring->r.len)


