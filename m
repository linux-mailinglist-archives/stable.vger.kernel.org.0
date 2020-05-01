Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93ABC1C152D
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgEANqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731762AbgEANot (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:44:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BB34216FD;
        Fri,  1 May 2020 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340689;
        bh=LzaJ2JGuxR36Bl2C5fYqaxdJYoYBFLXUni+mnJfTD7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0iEbFqQ0orrXZbon0W/UK6Ta6wyKZ7jHgET87WhTGdo12Pnyv37/Z7caYddIVW1k
         J7eGohPaOZBGoI8G83yJaJYlgnYtq5b7NnNpYmFJjhKN6oUxKm1QCWQPW45ts6JMkX
         gWQQ8WJmDduYZPnElh2iYnJlrPtxE4QoYjXbtIoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 096/106] sfc: fix XDP-redirect in this driver
Date:   Fri,  1 May 2020 15:24:09 +0200
Message-Id: <20200501131554.859491441@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

commit 86e85bf6981c0c265c427d6bfe9e2a0111797444 upstream.

XDP-redirect is broken in this driver sfc. XDP_REDIRECT requires
tailroom for skb_shared_info when creating an SKB based on the
redirected xdp_frame (both in cpumap and veth).

The fix requires some initial explaining. The driver uses RX page-split
when possible. It reserves the top 64 bytes in the RX-page for storing
dma_addr (struct efx_rx_page_state). It also have the XDP recommended
headroom of XDP_PACKET_HEADROOM (256 bytes). As it doesn't reserve any
tailroom, it can still fit two standard MTU (1500) frames into one page.

The sizeof struct skb_shared_info in 320 bytes. Thus drivers like ixgbe
and i40e, reduce their XDP headroom to 192 bytes, which allows them to
fit two frames with max 1536 bytes into a 4K page (192+1536+320=2048).

The fix is to reduce this drivers headroom to 128 bytes and add the 320
bytes tailroom. This account for reserved top 64 bytes in the page, and
still fit two frame in a page for normal MTUs.

We must never go below 128 bytes of headroom for XDP, as one cacheline
is for xdp_frame area and next cacheline is reserved for metadata area.

Fixes: eb9a36be7f3e ("sfc: perform XDP processing on received packets")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/sfc/efx_common.c |    9 +++++----
 drivers/net/ethernet/sfc/net_driver.h |    6 ++++++
 drivers/net/ethernet/sfc/rx.c         |    2 +-
 drivers/net/ethernet/sfc/rx_common.c  |    6 +++---
 4 files changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -200,11 +200,11 @@ void efx_link_status_changed(struct efx_
 unsigned int efx_xdp_max_mtu(struct efx_nic *efx)
 {
 	/* The maximum MTU that we can fit in a single page, allowing for
-	 * framing, overhead and XDP headroom.
+	 * framing, overhead and XDP headroom + tailroom.
 	 */
 	int overhead = EFX_MAX_FRAME_LEN(0) + sizeof(struct efx_rx_page_state) +
 		       efx->rx_prefix_size + efx->type->rx_buffer_padding +
-		       efx->rx_ip_align + XDP_PACKET_HEADROOM;
+		       efx->rx_ip_align + EFX_XDP_HEADROOM + EFX_XDP_TAILROOM;
 
 	return PAGE_SIZE - overhead;
 }
@@ -302,8 +302,9 @@ static void efx_start_datapath(struct ef
 	efx->rx_dma_len = (efx->rx_prefix_size +
 			   EFX_MAX_FRAME_LEN(efx->net_dev->mtu) +
 			   efx->type->rx_buffer_padding);
-	rx_buf_len = (sizeof(struct efx_rx_page_state) + XDP_PACKET_HEADROOM +
-		      efx->rx_ip_align + efx->rx_dma_len);
+	rx_buf_len = (sizeof(struct efx_rx_page_state)   + EFX_XDP_HEADROOM +
+		      efx->rx_ip_align + efx->rx_dma_len + EFX_XDP_TAILROOM);
+
 	if (rx_buf_len <= PAGE_SIZE) {
 		efx->rx_scatter = efx->type->always_rx_scatter;
 		efx->rx_buffer_order = 0;
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -91,6 +91,12 @@
 #define EFX_RX_BUF_ALIGNMENT	4
 #endif
 
+/* Non-standard XDP_PACKET_HEADROOM and tailroom to satisfy XDP_REDIRECT and
+ * still fit two standard MTU size packets into a single 4K page.
+ */
+#define EFX_XDP_HEADROOM	128
+#define EFX_XDP_TAILROOM	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
+
 /* Forward declare Precision Time Protocol (PTP) support structure. */
 struct efx_ptp_data;
 struct hwtstamp_config;
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -302,7 +302,7 @@ static bool efx_do_xdp(struct efx_nic *e
 	       efx->rx_prefix_size);
 
 	xdp.data = *ehp;
-	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
+	xdp.data_hard_start = xdp.data - EFX_XDP_HEADROOM;
 
 	/* No support yet for XDP metadata */
 	xdp_set_data_meta_invalid(&xdp);
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -412,10 +412,10 @@ static int efx_init_rx_buffers(struct ef
 			index = rx_queue->added_count & rx_queue->ptr_mask;
 			rx_buf = efx_rx_buffer(rx_queue, index);
 			rx_buf->dma_addr = dma_addr + efx->rx_ip_align +
-					   XDP_PACKET_HEADROOM;
+					   EFX_XDP_HEADROOM;
 			rx_buf->page = page;
 			rx_buf->page_offset = page_offset + efx->rx_ip_align +
-					      XDP_PACKET_HEADROOM;
+					      EFX_XDP_HEADROOM;
 			rx_buf->len = efx->rx_dma_len;
 			rx_buf->flags = 0;
 			++rx_queue->added_count;
@@ -433,7 +433,7 @@ static int efx_init_rx_buffers(struct ef
 void efx_rx_config_page_split(struct efx_nic *efx)
 {
 	efx->rx_page_buf_step = ALIGN(efx->rx_dma_len + efx->rx_ip_align +
-				      XDP_PACKET_HEADROOM,
+				      EFX_XDP_HEADROOM + EFX_XDP_TAILROOM,
 				      EFX_RX_BUF_ALIGNMENT);
 	efx->rx_bufs_per_page = efx->rx_buffer_order ? 1 :
 		((PAGE_SIZE - sizeof(struct efx_rx_page_state)) /


