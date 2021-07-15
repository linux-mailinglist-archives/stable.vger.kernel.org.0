Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14433CAA09
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242415AbhGOTLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243119AbhGOTJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE0DE61407;
        Thu, 15 Jul 2021 19:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375895;
        bh=x/TGLfcvFQTK05DH7cz8+oSwvSEKDiS4YVKlfxRErkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMyb4SkKPC+SLQa8S58oewVPXthwyzTAVyQ7n+rwlt2G4gvUlCi34z+WBd5Tn80J3
         mDXk3IVohJRuEnwgZkdCa055kh1eq63HFfwPyamYrU4SAQsYqadJkj3X2zrl2rmGD7
         7UAppMVPphFZoFN9f1pg6JVg2bLyG4uMAoGNG1b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 040/266] igb: handle vlan types with checker enabled
Date:   Thu, 15 Jul 2021 20:36:35 +0200
Message-Id: <20210715182621.339001432@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit c7cbfb028b95360403d579c47aaaeef1ff140964 ]

The sparse build (C=2) finds some issues with how the driver
dealt with the (very difficult) hardware that in some generations
uses little-endian, and in others uses big endian, for the VLAN
field. The code as written picks __le16 as a type and for some
hardware revisions we override it to __be16 as done in this
patch. This impacted the VF driver as well so fix it there too.

Also change the vlan_tci assignment to override the sparse
warning without changing functionality.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 5 +++--
 drivers/net/ethernet/intel/igbvf/netdev.c | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b2a042f825ff..b0232a8de343 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2643,7 +2643,8 @@ static int igb_parse_cls_flower(struct igb_adapter *adapter,
 			}
 
 			input->filter.match_flags |= IGB_FILTER_FLAG_VLAN_TCI;
-			input->filter.vlan_tci = match.key->vlan_priority;
+			input->filter.vlan_tci =
+				(__force __be16)match.key->vlan_priority;
 		}
 	}
 
@@ -8592,7 +8593,7 @@ static void igb_process_skb_fields(struct igb_ring *rx_ring,
 
 		if (igb_test_staterr(rx_desc, E1000_RXDEXT_STATERR_LB) &&
 		    test_bit(IGB_RING_FLAG_RX_LB_VLAN_BSWAP, &rx_ring->flags))
-			vid = be16_to_cpu(rx_desc->wb.upper.vlan);
+			vid = be16_to_cpu((__force __be16)rx_desc->wb.upper.vlan);
 		else
 			vid = le16_to_cpu(rx_desc->wb.upper.vlan);
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index fb3fbcb13331..630c1155f196 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -83,14 +83,14 @@ static int igbvf_desc_unused(struct igbvf_ring *ring)
 static void igbvf_receive_skb(struct igbvf_adapter *adapter,
 			      struct net_device *netdev,
 			      struct sk_buff *skb,
-			      u32 status, u16 vlan)
+			      u32 status, __le16 vlan)
 {
 	u16 vid;
 
 	if (status & E1000_RXD_STAT_VP) {
 		if ((adapter->flags & IGBVF_FLAG_RX_LB_VLAN_BSWAP) &&
 		    (status & E1000_RXDEXT_STATERR_LB))
-			vid = be16_to_cpu(vlan) & E1000_RXD_SPC_VLAN_MASK;
+			vid = be16_to_cpu((__force __be16)vlan) & E1000_RXD_SPC_VLAN_MASK;
 		else
 			vid = le16_to_cpu(vlan) & E1000_RXD_SPC_VLAN_MASK;
 		if (test_bit(vid, adapter->active_vlans))
-- 
2.30.2



