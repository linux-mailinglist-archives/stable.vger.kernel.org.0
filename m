Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA310167163
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgBUHxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:53:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730153AbgBUHxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:53:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CC0420801;
        Fri, 21 Feb 2020 07:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271626;
        bh=UsiEZwaNCOzGinm9GY9LYQeSFH9pbbl3cGztO6ANsr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNXvGvZmdjPLjC+sCYojhNLTjQv6SZYhzlbMs+rrNkyCAmTaHh7yfiIHP1nWoBHGl
         G5h4opTvO5AYV0oBGco2qR5HCmi7P8NUj/XrtJ35ZGt1eJM6C/A/hEta9+PmFHKoyH
         myXTs4vVbvVUxpIWEbgvWIPmHFuKIJNn+MR349ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 199/399] ice: add extra check for null Rx descriptor
Date:   Fri, 21 Feb 2020 08:38:44 +0100
Message-Id: <20200221072422.152591489@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit 1f45ebe0d8fbe6178670b663005f38ef8535db5d ]

In the case where the hardware gives us a null Rx descriptor, it is
theoretically possible that we could call one of our skb-construction
functions with no data pointer, which would cause a panic.

In real life, this will never happen - we only get null RX
descriptors as the final descriptor in a chain of otherwise-valid
descriptors. When this happens, the skb will be extant and we'll just
call ice_add_rx_frag(), which can deal with empty data buffers.

Unfortunately, Coverity does not have intimate knowledge of our
hardware, so we must add a check here.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 2c212f64d99f2..8b2b9e254d28d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1071,13 +1071,16 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		ice_put_rx_buf(rx_ring, rx_buf);
 		continue;
 construct_skb:
-		if (skb)
+		if (skb) {
 			ice_add_rx_frag(rx_ring, rx_buf, skb, size);
-		else if (ice_ring_uses_build_skb(rx_ring))
-			skb = ice_build_skb(rx_ring, rx_buf, &xdp);
-		else
+		} else if (likely(xdp.data)) {
+			if (ice_ring_uses_build_skb(rx_ring))
+				skb = ice_build_skb(rx_ring, rx_buf, &xdp);
+			else
+				skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
+		} else {
 			skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
-
+		}
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buf_failed++;
-- 
2.20.1



