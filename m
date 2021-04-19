Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC9636431E
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239857AbhDSNOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239801AbhDSNNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:13:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D961613C1;
        Mon, 19 Apr 2021 13:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837928;
        bh=rP77+dYE08bF8G0bIypziEsVuyFv3H4HRzvg1ozErUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qYqamL63epIUNux4hHzcNFfa25wyz4cZca6qqH6qGTYFnuVq5ZXJE4bZ4J5ebJZ3
         2Y781X3X4jjFEJhOi9JDMfSgqgPZhtpmw3+/sHubfQuXDe1p8Z/n3BCToI0hffKdid
         nxldoMFyS0uxaKDzQiKlTH1zfaf7zWOAi9zHW+dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 069/122] ixgbe: Fix NULL pointer dereference in ethtool loopback test
Date:   Mon, 19 Apr 2021 15:05:49 +0200
Message-Id: <20210419130532.526335588@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

commit 31166efb1cee348eb6314e9c0095d84cbeb66b9d upstream.

The ixgbe driver currently generates a NULL pointer dereference when
performing the ethtool loopback test. This is due to the fact that there
isn't a q_vector associated with the test ring when it is setup as
interrupts are not normally added to the test rings.

To address this I have added code that will check for a q_vector before
returning a napi_id value. If a q_vector is not present it will return a
value of 0.

Fixes: b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6540,6 +6540,13 @@ err_setup_tx:
 	return err;
 }
 
+static int ixgbe_rx_napi_id(struct ixgbe_ring *rx_ring)
+{
+	struct ixgbe_q_vector *q_vector = rx_ring->q_vector;
+
+	return q_vector ? q_vector->napi.napi_id : 0;
+}
+
 /**
  * ixgbe_setup_rx_resources - allocate Rx resources (Descriptors)
  * @adapter: pointer to ixgbe_adapter
@@ -6587,7 +6594,7 @@ int ixgbe_setup_rx_resources(struct ixgb
 
 	/* XDP RX-queue info */
 	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
-			     rx_ring->queue_index, rx_ring->q_vector->napi.napi_id) < 0)
+			     rx_ring->queue_index, ixgbe_rx_napi_id(rx_ring)) < 0)
 		goto err;
 
 	rx_ring->xdp_prog = adapter->xdp_prog;


