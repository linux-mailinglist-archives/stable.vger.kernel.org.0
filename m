Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFAE206075
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392477AbgFWUnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392473AbgFWUnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:43:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF0821941;
        Tue, 23 Jun 2020 20:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944985;
        bh=TQ4RRLMwABj/h2pa92vRnNrTUg18wAIi0ZH1SJOFJI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QjaGPLjoJsORclqqcyPBD7yaGgTwIO5wBLEyIBNRS2eKO+3hWfAda8jngctT9qQDT
         vD57UwALaV2MwiQXsiX9I/9WdsG1LuS/7uJ45Vgyx8jHne5qimwZ8WDG3KVGHlNS1B
         yh6ZkMnMNDCKGdKDrd6OcEisPXxzzpTsvX+IRin0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 202/206] net: octeon: mgmt: Repair filling of RX ring
Date:   Tue, 23 Jun 2020 21:58:50 +0200
Message-Id: <20200623195326.979645687@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

commit 0c34bb598c510e070160029f34efeeb217000f8d upstream.

The removal of mips_swiotlb_ops exposed a problem in octeon_mgmt Ethernet
driver. mips_swiotlb_ops had an mb() after most of the operations and the
removal of the ops had broken the receive functionality of the driver.
My code inspection has shown no other places except
octeon_mgmt_rx_fill_ring() where an explicit barrier would be obviously
missing. The latter function however has to make sure that "ringing the
bell" doesn't happen before RX ring entry is really written.

The patch has been successfully tested on Octeon II.

Fixes: a999933db9ed ("MIPS: remove mips_swiotlb_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -235,6 +235,11 @@ static void octeon_mgmt_rx_fill_ring(str
 
 		/* Put it in the ring.  */
 		p->rx_ring[p->rx_next_fill] = re.d64;
+		/* Make sure there is no reorder of filling the ring and ringing
+		 * the bell
+		 */
+		wmb();
+
 		dma_sync_single_for_device(p->dev, p->rx_ring_handle,
 					   ring_size_to_bytes(OCTEON_MGMT_RX_RING_SIZE),
 					   DMA_BIDIRECTIONAL);


