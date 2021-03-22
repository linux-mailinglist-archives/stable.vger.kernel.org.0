Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A293344268
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhCVMlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231370AbhCVMjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7482F619B4;
        Mon, 22 Mar 2021 12:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416703;
        bh=pUbJ9kc09KfHQA7igCCOZqd+CU2f+yL9URjBvHUgLng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBqljZtQEUxCk4IkidpOE/zFUUh61PNqjJXUiLTsnyOQ9LmNEvoOqs2Aa73OWvtra
         8jIUXUpcHKagVI2/JLhjTwWvP/NvsIWNGuBWkSFspKxPxOQC410PzMcU8ProCLbkhf
         p9+Q0G43pNNu91Mz8Rc+HeqVnjBV5WE0HUSzLNoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Ciosek <norbertx.ciosek@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/157] i40e: Fix endianness conversions
Date:   Mon, 22 Mar 2021 13:27:25 +0100
Message-Id: <20210322121936.575621538@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3e4a4d6f0419..4a2d03cada01 100644
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
index 38dec49ac64d..899714243af7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1782,7 +1782,7 @@ void i40e_process_skb_fields(struct i40e_ring *rx_ring,
 	skb_record_rx_queue(skb, rx_ring->queue_index);
 
 	if (qword & BIT(I40E_RX_DESC_STATUS_L2TAG1P_SHIFT)) {
-		u16 vlan_tag = rx_desc->wb.qword0.lo_dword.l2tag1;
+		__le16 vlan_tag = rx_desc->wb.qword0.lo_dword.l2tag1;
 
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       le16_to_cpu(vlan_tag));
-- 
2.30.1



