Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F643290E9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242650AbhCAURS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242363AbhCAUHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:07:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1257653A7;
        Mon,  1 Mar 2021 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621559;
        bh=NUH07b95z3ZyDAnFB8KBk6+xGZaHrviC7sWLH5CbWqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjCOrvMvN8JrkqZ9JnQlsL+/81W7F+adsUlqhHzyDSTuSoJKPF5XFF0/BV1Lk7CTj
         1sBmsKRSOo9ZxuvmJOnPCG/ulqfhsVWmiOr9RFRST3iQlnxJpGrAZyIFr2tMoT9c7t
         BvKdwy0JlHir8FCsunHh5kiM8zcFiCNDRS6ttHlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Ciosek <norbertx.ciosek@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 531/775] i40e: Fix endianness conversions
Date:   Mon,  1 Mar 2021 17:11:39 +0100
Message-Id: <20210301161227.730101941@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Ciosek <norbertx.ciosek@intel.com>

[ Upstream commit b32cddd2247cf730731f93f1967d0147a40682c7 ]

Fixes the following sparse warnings:
i40e_main.c:5953:32: warning: cast from restricted __le16
i40e_main.c:8008:29: warning: incorrect type in assignment (different base types)
i40e_main.c:8008:29:    expected unsigned int [assigned] [usertype] ipa
i40e_main.c:8008:29:    got restricted __le32 [usertype]
i40e_main.c:8008:29: warning: incorrect type in assignment (different base types)
i40e_main.c:8008:29:    expected unsigned int [assigned] [usertype] ipa
i40e_main.c:8008:29:    got restricted __le32 [usertype]
i40e_txrx.c:1950:59: warning: incorrect type in initializer (different base types)
i40e_txrx.c:1950:59:    expected unsigned short [usertype] vlan_tag
i40e_txrx.c:1950:59:    got restricted __le16 [usertype] l2tag1
i40e_txrx.c:1953:40: warning: cast to restricted __le16
i40e_xsk.c:448:38: warning: invalid assignment: |=
i40e_xsk.c:448:38:    left side has type restricted __le64
i40e_xsk.c:448:38:    right side has type int

Fixes: 2f4b411a3d67 ("i40e: Enable cloud filters via tc-flower")
Fixes: 2a508c64ad27 ("i40e: fix VLAN.TCI == 0 RX HW offload")
Fixes: 3106c580fb7c ("i40e: Use batched xsk Tx interfaces to increase performance")
Fixes: 8f88b3034db3 ("i40e: Add infrastructure for queue channel support")
Signed-off-by: Norbert Ciosek <norbertx.ciosek@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 ++++++------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 59971f62e6268..fcd6f623f2fd8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5920,7 +5920,7 @@ static int i40e_add_channel(struct i40e_pf *pf, u16 uplink_seid,
 	ch->enabled_tc = !i40e_is_channel_macvlan(ch) && enabled_tc;
 	ch->seid = ctxt.seid;
 	ch->vsi_number = ctxt.vsi_number;
-	ch->stat_counter_idx = cpu_to_le16(ctxt.info.stat_counter_idx);
+	ch->stat_counter_idx = le16_to_cpu(ctxt.info.stat_counter_idx);
 
 	/* copy just the sections touched not the entire info
 	 * since not all sections are valid as returned by
@@ -7599,8 +7599,8 @@ static inline void
 i40e_set_cld_element(struct i40e_cloud_filter *filter,
 		     struct i40e_aqc_cloud_filters_element_data *cld)
 {
-	int i, j;
 	u32 ipa;
+	int i;
 
 	memset(cld, 0, sizeof(*cld));
 	ether_addr_copy(cld->outer_mac, filter->dst_mac);
@@ -7611,14 +7611,14 @@ i40e_set_cld_element(struct i40e_cloud_filter *filter,
 
 	if (filter->n_proto == ETH_P_IPV6) {
 #define IPV6_MAX_INDEX	(ARRAY_SIZE(filter->dst_ipv6) - 1)
-		for (i = 0, j = 0; i < ARRAY_SIZE(filter->dst_ipv6);
-		     i++, j += 2) {
+		for (i = 0; i < ARRAY_SIZE(filter->dst_ipv6); i++) {
 			ipa = be32_to_cpu(filter->dst_ipv6[IPV6_MAX_INDEX - i]);
-			ipa = cpu_to_le32(ipa);
-			memcpy(&cld->ipaddr.raw_v6.data[j], &ipa, sizeof(ipa));
+
+			*(__le32 *)&cld->ipaddr.raw_v6.data[i * 2] = cpu_to_le32(ipa);
 		}
 	} else {
 		ipa = be32_to_cpu(filter->dst_ipv4);
+
 		memcpy(&cld->ipaddr.v4.data, &ipa, sizeof(ipa));
 	}
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 32d97315f3f52..903d4e8cb0a11 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1793,7 +1793,7 @@ void i40e_process_skb_fields(struct i40e_ring *rx_ring,
 	skb_record_rx_queue(skb, rx_ring->queue_index);
 
 	if (qword & BIT(I40E_RX_DESC_STATUS_L2TAG1P_SHIFT)) {
-		u16 vlan_tag = rx_desc->wb.qword0.lo_dword.l2tag1;
+		__le16 vlan_tag = rx_desc->wb.qword0.lo_dword.l2tag1;
 
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       le16_to_cpu(vlan_tag));
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 492ce213208d2..37a21fb999221 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -444,7 +444,7 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
 	struct i40e_tx_desc *tx_desc;
 
 	tx_desc = I40E_TX_DESC(xdp_ring, ntu);
-	tx_desc->cmd_type_offset_bsz |= (I40E_TX_DESC_CMD_RS << I40E_TXD_QW1_CMD_SHIFT);
+	tx_desc->cmd_type_offset_bsz |= cpu_to_le64(I40E_TX_DESC_CMD_RS << I40E_TXD_QW1_CMD_SHIFT);
 }
 
 /**
-- 
2.27.0



