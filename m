Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890BE3D5FCE
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbhGZPTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236212AbhGZPSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78E2E60F90;
        Mon, 26 Jul 2021 15:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315151;
        bh=5It0TIh4acb63RvBXTlGJuxmxqPEwl8XIrykQv9lt+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njDRyEnXJTC03WXvkeuLOtTAl0fhcXTm2JWk8iCNPt2uAo1/2EwohKdGh1/k3GGHR
         QySpmgEU+vQdT2qEBCaSZf2dITZVeWDplIIIc0xh0/lVOU3hnYSIwnHpm8qrt+3865
         K8IQ33c9cL2l6qF+/NtLpr6VjAhnTcMXcPbpyV/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Boehme <markubo@amazon.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 093/108] ixgbe: Fix packet corruption due to missing DMA sync
Date:   Mon, 26 Jul 2021 17:39:34 +0200
Message-Id: <20210726153834.665192420@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Boehme <markubo@amazon.com>

commit 09cfae9f13d51700b0fecf591dcd658fc5375428 upstream.

When receiving a packet with multiple fragments, hardware may still
touch the first fragment until the entire packet has been received. The
driver therefore keeps the first fragment mapped for DMA until end of
packet has been asserted, and delays its dma_sync call until then.

The driver tries to fit multiple receive buffers on one page. When using
3K receive buffers (e.g. using Jumbo frames and legacy-rx is turned
off/build_skb is being used) on an architecture with 4K pages, the
driver allocates an order 1 compound page and uses one page per receive
buffer. To determine the correct offset for a delayed DMA sync of the
first fragment of a multi-fragment packet, the driver then cannot just
use PAGE_MASK on the DMA address but has to construct a mask based on
the actual size of the backing page.

Using PAGE_MASK in the 3K RX buffer/4K page architecture configuration
will always sync the first page of a compound page. With the SWIOTLB
enabled this can lead to corrupted packets (zeroed out first fragment,
re-used garbage from another packet) and various consequences, such as
slow/stalling data transfers and connection resets. For example, testing
on a link with MTU exceeding 3058 bytes on a host with SWIOTLB enabled
(e.g. "iommu=soft swiotlb=262144,force") TCP transfers quickly fizzle
out without this patch.

Cc: stable@vger.kernel.org
Fixes: 0c5661ecc5dd7 ("ixgbe: fix crash in build_skb Rx code path")
Signed-off-by: Markus Boehme <markubo@amazon.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1827,7 +1827,8 @@ static void ixgbe_dma_sync_frag(struct i
 				struct sk_buff *skb)
 {
 	if (ring_uses_build_skb(rx_ring)) {
-		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
+		unsigned long mask = (unsigned long)ixgbe_rx_pg_size(rx_ring) - 1;
+		unsigned long offset = (unsigned long)(skb->data) & mask;
 
 		dma_sync_single_range_for_cpu(rx_ring->dev,
 					      IXGBE_CB(skb)->dma,


