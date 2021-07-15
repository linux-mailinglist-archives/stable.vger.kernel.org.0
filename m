Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903123CA5BD
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhGOSoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231941AbhGOSoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:44:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22CA7613CF;
        Thu, 15 Jul 2021 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374481;
        bh=+n/x3X3syMB0NwAeBa2LIF0LSLn5ym67R9S5/kr0OG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ON877WVZ7qN2DYZi9LZexB+CTkJNuokTSL+tH6qsGK4oOONiiqu/s+lQQP/dAPZam
         9eKb8pMSlHfLCYY8VsNpFmg9o4frCtmrmTWvaiwUdux9VsrxnjOmSsZ/Y8tiX/BSBn
         pvznAJwsbNq7oHyjF2xmQZHIm/O00lJHFQTWXfLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/122] igb: handle vlan types with checker enabled
Date:   Thu, 15 Jul 2021 20:37:45 +0200
Message-Id: <20210715182454.272470353@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
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
index 7a4e2b014dd6..c37f0590b3a4 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2651,7 +2651,8 @@ static int igb_parse_cls_flower(struct igb_adapter *adapter,
 			}
 
 			input->filter.match_flags |= IGB_FILTER_FLAG_VLAN_TCI;
-			input->filter.vlan_tci = match.key->vlan_priority;
+			input->filter.vlan_tci =
+				(__force __be16)match.key->vlan_priority;
 		}
 	}
 
@@ -8255,7 +8256,7 @@ static void igb_process_skb_fields(struct igb_ring *rx_ring,
 
 		if (igb_test_staterr(rx_desc, E1000_RXDEXT_STATERR_LB) &&
 		    test_bit(IGB_RING_FLAG_RX_LB_VLAN_BSWAP, &rx_ring->flags))
-			vid = be16_to_cpu(rx_desc->wb.upper.vlan);
+			vid = be16_to_cpu((__force __be16)rx_desc->wb.upper.vlan);
 		else
 			vid = le16_to_cpu(rx_desc->wb.upper.vlan);
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 0f2b68f4bb0f..77cb2ab7dab4 100644
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



