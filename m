Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057E51482E9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404232AbgAXLbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:31:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404365AbgAXLbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:31:51 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74803206D4;
        Fri, 24 Jan 2020 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865510;
        bh=e2hI6TDdl6NlCXYKgFLpcZeyOdP5byPgHqaf2nDS708=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqbYKtr5cnwSjfoP01IyhJLlUI2cliCqslBbplgkds0IQT8snasFj4rfSaaPr1np8
         iryrRVuvPl7s29P6DIl/ZvHR9sa3SDvDjbTohy2JbcDudetC8IX2deJ58gEGHKtLiR
         +cJS4bkQHeTp9cP8kIGbxWsW8+gJfvb0MSLUcVu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Firo Yang <firo.yang@suse.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 557/639] ixgbe: sync the first fragment unconditionally
Date:   Fri, 24 Jan 2020 10:32:07 +0100
Message-Id: <20200124093159.070242339@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Firo Yang <firo.yang@suse.com>

[ Upstream commit e7ba676c6188d394a0133fc4b9bcd7ee50d54b7f ]

In Xen environment, if Xen-swiotlb is enabled, ixgbe driver
could possibly allocate a page, DMA memory buffer, for the first
fragment which is not suitable for Xen-swiotlb to do DMA operations.
Xen-swiotlb have to internally allocate another page for doing DMA
operations. This mechanism requires syncing the data from the internal
page to the page which ixgbe sends to upper network stack. However,
since commit f3213d932173 ("ixgbe: Update driver to make use of DMA
attributes in Rx path"), the unmap operation is performed with
DMA_ATTR_SKIP_CPU_SYNC. As a result, the sync is not performed.
Since the sync isn't performed, the upper network stack could receive
a incomplete network packet. By incomplete, it means the linear data
on the first fragment(between skb->head and skb->end) is invalid. So
we have to copy the data from the internal xen-swiotlb page to the page
which ixgbe sends to upper network stack through the sync operation.

More details from Alexander Duyck:
Specifically since we are mapping the frame with
DMA_ATTR_SKIP_CPU_SYNC we have to unmap with that as well. As a result
a sync is not performed on an unmap and must be done manually as we
skipped it for the first frag. As such we need to always sync before
possibly performing a page unmap operation.

Fixes: f3213d932173 ("ixgbe: Update driver to make use of DMA attributes in Rx path")
Signed-off-by: Firo Yang <firo.yang@suse.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index de65ca1e65580..51cd58fbab695 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1822,13 +1822,7 @@ static void ixgbe_pull_tail(struct ixgbe_ring *rx_ring,
 static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 				struct sk_buff *skb)
 {
-	/* if the page was released unmap it, else just sync our portion */
-	if (unlikely(IXGBE_CB(skb)->page_released)) {
-		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
-				     ixgbe_rx_pg_size(rx_ring),
-				     DMA_FROM_DEVICE,
-				     IXGBE_RX_DMA_ATTR);
-	} else if (ring_uses_build_skb(rx_ring)) {
+	if (ring_uses_build_skb(rx_ring)) {
 		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
 
 		dma_sync_single_range_for_cpu(rx_ring->dev,
@@ -1845,6 +1839,14 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 					      skb_frag_size(frag),
 					      DMA_FROM_DEVICE);
 	}
+
+	/* If the page was released, just unmap it. */
+	if (unlikely(IXGBE_CB(skb)->page_released)) {
+		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
+				     ixgbe_rx_pg_size(rx_ring),
+				     DMA_FROM_DEVICE,
+				     IXGBE_RX_DMA_ATTR);
+	}
 }
 
 /**
-- 
2.20.1



