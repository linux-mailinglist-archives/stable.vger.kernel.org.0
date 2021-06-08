Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181403A00B1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbhFHSqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234953AbhFHSnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:43:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D32E613CE;
        Tue,  8 Jun 2021 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177366;
        bh=TSZW2gIdiGR3JjeKFgZ1dIFNndfUAXUWJL8acTA0aV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQ9Ra1EBqykW5Yum+M4az7avDlbBoyMkfGsU2OI7TpR0th6RbXevc7O1KUJVZ8evg
         AKJLzftqYvCySwg6C+iEwFu3rBV6qhFgIrwXaOAcEME1Qs+fqZ4ijXFSE7alo+Sqpw
         NMcs33eOebPZLrZEFpFh6i8IRupFlI4f2YCrI4t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/78] ice: Allow all LLDP packets from PF to Tx
Date:   Tue,  8 Jun 2021 20:26:55 +0200
Message-Id: <20210608175936.150925370@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit f9f83202b7263ac371d616d6894a2c9ed79158ef ]

Currently in the ice driver, the check whether to
allow a LLDP packet to egress the interface from the
PF_VSI is being based on the SKB's priority field.
It checks to see if the packets priority is equal to
TC_PRIO_CONTROL.  Injected LLDP packets do not always
meet this condition.

SCAPY defaults to a sk_buff->protocol value of ETH_P_ALL
(0x0003) and does not set the priority field.  There will
be other injection methods (even ones used by end users)
that will not correctly configure the socket so that
SKB fields are correctly populated.

Then ethernet header has to have to correct value for
the protocol though.

Add a check to also allow packets whose ethhdr->h_proto
matches ETH_P_LLDP (0x88CC).

Fixes: 0c3a6101ff2d ("ice: Allow egress control packets from PF_VSI")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 33dd103035dc..2b55efe5ed96 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2109,6 +2109,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 	struct ice_tx_offload_params offload = { 0 };
 	struct ice_vsi *vsi = tx_ring->vsi;
 	struct ice_tx_buf *first;
+	struct ethhdr *eth;
 	unsigned int count;
 	int tso, csum;
 
@@ -2156,7 +2157,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 		goto out_drop;
 
 	/* allow CONTROL frames egress from main VSI if FW LLDP disabled */
-	if (unlikely(skb->priority == TC_PRIO_CONTROL &&
+	eth = (struct ethhdr *)skb_mac_header(skb);
+	if (unlikely((skb->priority == TC_PRIO_CONTROL ||
+		      eth->h_proto == htons(ETH_P_LLDP)) &&
 		     vsi->type == ICE_VSI_PF &&
 		     vsi->port_info->is_sw_lldp))
 		offload.cd_qw1 |= (u64)(ICE_TX_DESC_DTYPE_CTX |
-- 
2.30.2



