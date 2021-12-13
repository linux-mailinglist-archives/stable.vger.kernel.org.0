Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6149E472649
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhLMJuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:50:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33628 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbhLMJr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 685D5B80E12;
        Mon, 13 Dec 2021 09:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88507C00446;
        Mon, 13 Dec 2021 09:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388876;
        bh=1PI75Fm7LMFPUYy0Y8jZ3JmJUveYJsFnz9/VvhGPj6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3ETQtuSqDp+tdO37dAt7LYwxraYB4wROtT4Qw2zZbYQxKF7Q+twO7wl9tcyVEGIu
         3Ff2IGnugpRUY1G8x9idnPiUR2y/bvurDO9qzX/3Bbevb0xcTrvIl53iMo5Scy8W7j
         HnhEgP33LW6eFfRjTDXFpEdQIHmCX9WbkZLX6sng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Michal Maloszewski <michal.maloszewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 039/132] iavf: Fix reporting when setting descriptor count
Date:   Mon, 13 Dec 2021 10:29:40 +0100
Message-Id: <20211213092940.461292711@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Maloszewski <michal.maloszewski@intel.com>

commit 1a1aa356ddf3f16539f5962c01c5f702686dfc15 upstream.

iavf_set_ringparams doesn't communicate to the user that

1. The user requested descriptor count is out of range. Instead it
   just quietly sets descriptors to the "clamped" value and calls it
   done. This makes it look an invalid value was successfully set as
   the descriptor count when this isn't actually true.

2. The user provided descriptor count needs to be inflated for alignment
   reasons.

This behavior is confusing. The ice driver has already addressed this
by rejecting invalid values for descriptor count and
messaging for alignment adjustments.
Do the same thing here by adding the error and info messages.

Fixes: fbb7ddfef253 ("i40evf: core ethtool functionality")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Michal Maloszewski <michal.maloszewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c |   45 ++++++++++++++++++-------
 1 file changed, 33 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -612,23 +612,44 @@ static int iavf_set_ringparam(struct net
 	if ((ring->rx_mini_pending) || (ring->rx_jumbo_pending))
 		return -EINVAL;
 
-	new_tx_count = clamp_t(u32, ring->tx_pending,
-			       IAVF_MIN_TXD,
-			       IAVF_MAX_TXD);
-	new_tx_count = ALIGN(new_tx_count, IAVF_REQ_DESCRIPTOR_MULTIPLE);
-
-	new_rx_count = clamp_t(u32, ring->rx_pending,
-			       IAVF_MIN_RXD,
-			       IAVF_MAX_RXD);
-	new_rx_count = ALIGN(new_rx_count, IAVF_REQ_DESCRIPTOR_MULTIPLE);
+	if (ring->tx_pending > IAVF_MAX_TXD ||
+	    ring->tx_pending < IAVF_MIN_TXD ||
+	    ring->rx_pending > IAVF_MAX_RXD ||
+	    ring->rx_pending < IAVF_MIN_RXD) {
+		netdev_err(netdev, "Descriptors requested (Tx: %d / Rx: %d) out of range [%d-%d] (increment %d)\n",
+			   ring->tx_pending, ring->rx_pending, IAVF_MIN_TXD,
+			   IAVF_MAX_RXD, IAVF_REQ_DESCRIPTOR_MULTIPLE);
+		return -EINVAL;
+	}
+
+	new_tx_count = ALIGN(ring->tx_pending, IAVF_REQ_DESCRIPTOR_MULTIPLE);
+	if (new_tx_count != ring->tx_pending)
+		netdev_info(netdev, "Requested Tx descriptor count rounded up to %d\n",
+			    new_tx_count);
+
+	new_rx_count = ALIGN(ring->rx_pending, IAVF_REQ_DESCRIPTOR_MULTIPLE);
+	if (new_rx_count != ring->rx_pending)
+		netdev_info(netdev, "Requested Rx descriptor count rounded up to %d\n",
+			    new_rx_count);
 
 	/* if nothing to do return success */
 	if ((new_tx_count == adapter->tx_desc_count) &&
-	    (new_rx_count == adapter->rx_desc_count))
+	    (new_rx_count == adapter->rx_desc_count)) {
+		netdev_dbg(netdev, "Nothing to change, descriptor count is same as requested\n");
 		return 0;
+	}
+
+	if (new_tx_count != adapter->tx_desc_count) {
+		netdev_dbg(netdev, "Changing Tx descriptor count from %d to %d\n",
+			   adapter->tx_desc_count, new_tx_count);
+		adapter->tx_desc_count = new_tx_count;
+	}
 
-	adapter->tx_desc_count = new_tx_count;
-	adapter->rx_desc_count = new_rx_count;
+	if (new_rx_count != adapter->rx_desc_count) {
+		netdev_dbg(netdev, "Changing Rx descriptor count from %d to %d\n",
+			   adapter->rx_desc_count, new_rx_count);
+		adapter->rx_desc_count = new_rx_count;
+	}
 
 	if (netif_running(netdev)) {
 		adapter->flags |= IAVF_FLAG_RESET_NEEDED;


