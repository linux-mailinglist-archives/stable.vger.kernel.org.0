Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE13A35B88B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbhDLCXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236608AbhDLCXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 314E161210;
        Mon, 12 Apr 2021 02:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194186;
        bh=yTRJRkQlYhWH758rCJXeHV4yXsnyTdCfgZn05hC8d8Q=;
        h=From:To:Cc:Subject:Date:From;
        b=fRR/j1XUAAyIJ+iTaQwpZqVkhHvrrtRiT22iFWdFdPavoAj7d0WEmLyKq0s0c+M5G
         4g9bBvhxWTTMkmzDKnO7ftY26dBuu9VzHqRYeYg6BdoGdRZr/2ClUTijeP8LeTWQ75
         ZVvUpOA+S6W30pHJkH3v5M0wmv7V57wPQcXAkwtx85hoSeyH3vIGFEY+pxE3GP6jpe
         TUIS7VlofTrPbKd5vpyju1BY1viT6x1j4pkWKBASNDaywwUAI4JsbhuS/F8wig0Fuv
         GVd6ShqtaLMxNSvLO+dwQ7M1H6D4SCAtAgEC5LsHQJ+MiaHYBAXDSk4INuOgIgaL9w
         hA4BVI21gS5Sw==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, eryk.roch.rybak@intel.com
Cc:     Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: FAILED: Patch "i40e: Fix display statistics for veb_tc" failed to apply to 4.19-stable tree
Date:   Sun, 11 Apr 2021 22:23:05 -0400
Message-Id: <20210412022305.283751-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From c3214de929dbf1b7374add8bbed30ce82b197bbb Mon Sep 17 00:00:00 2001
From: Eryk Rybak <eryk.roch.rybak@intel.com>
Date: Tue, 2 Mar 2021 08:46:27 +0100
Subject: [PATCH] i40e: Fix display statistics for veb_tc

If veb-stats was enabled, the ethtool stats triggered a warning
due to invalid size: 'unexpected stat size for veb.tc_%u_tx_packets'.
This was due to an incorrect structure definition for the statistics.
Structures and functions have been improved in line with requirements
for the presentation of statistics, in particular for the functions:
'i40e_add_ethtool_stats' and 'i40e_add_stat_strings'.

Fixes: 1510ae0be2a4 ("i40e: convert VEB TC stats to use an i40e_stats array")
Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 52 ++++++++++++++++---
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 2c637a5678b3..96d5202a73e8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -232,6 +232,8 @@ static void __i40e_add_stat_strings(u8 **p, const struct i40e_stats stats[],
 	I40E_STAT(struct i40e_vsi, _name, _stat)
 #define I40E_VEB_STAT(_name, _stat) \
 	I40E_STAT(struct i40e_veb, _name, _stat)
+#define I40E_VEB_TC_STAT(_name, _stat) \
+	I40E_STAT(struct i40e_cp_veb_tc_stats, _name, _stat)
 #define I40E_PFC_STAT(_name, _stat) \
 	I40E_STAT(struct i40e_pfc_stats, _name, _stat)
 #define I40E_QUEUE_STAT(_name, _stat) \
@@ -266,11 +268,18 @@ static const struct i40e_stats i40e_gstrings_veb_stats[] = {
 	I40E_VEB_STAT("veb.rx_unknown_protocol", stats.rx_unknown_protocol),
 };
 
+struct i40e_cp_veb_tc_stats {
+	u64 tc_rx_packets;
+	u64 tc_rx_bytes;
+	u64 tc_tx_packets;
+	u64 tc_tx_bytes;
+};
+
 static const struct i40e_stats i40e_gstrings_veb_tc_stats[] = {
-	I40E_VEB_STAT("veb.tc_%u_tx_packets", tc_stats.tc_tx_packets),
-	I40E_VEB_STAT("veb.tc_%u_tx_bytes", tc_stats.tc_tx_bytes),
-	I40E_VEB_STAT("veb.tc_%u_rx_packets", tc_stats.tc_rx_packets),
-	I40E_VEB_STAT("veb.tc_%u_rx_bytes", tc_stats.tc_rx_bytes),
+	I40E_VEB_TC_STAT("veb.tc_%u_tx_packets", tc_tx_packets),
+	I40E_VEB_TC_STAT("veb.tc_%u_tx_bytes", tc_tx_bytes),
+	I40E_VEB_TC_STAT("veb.tc_%u_rx_packets", tc_rx_packets),
+	I40E_VEB_TC_STAT("veb.tc_%u_rx_bytes", tc_rx_bytes),
 };
 
 static const struct i40e_stats i40e_gstrings_misc_stats[] = {
@@ -2217,6 +2226,29 @@ static int i40e_get_sset_count(struct net_device *netdev, int sset)
 	}
 }
 
+/**
+ * i40e_get_veb_tc_stats - copy VEB TC statistics to formatted structure
+ * @tc: the TC statistics in VEB structure (veb->tc_stats)
+ * @i: the index of traffic class in (veb->tc_stats) structure to copy
+ *
+ * Copy VEB TC statistics from structure of arrays (veb->tc_stats) to
+ * one dimensional structure i40e_cp_veb_tc_stats.
+ * Produce formatted i40e_cp_veb_tc_stats structure of the VEB TC
+ * statistics for the given TC.
+ **/
+static struct i40e_cp_veb_tc_stats
+i40e_get_veb_tc_stats(struct i40e_veb_tc_stats *tc, unsigned int i)
+{
+	struct i40e_cp_veb_tc_stats veb_tc = {
+		.tc_rx_packets = tc->tc_rx_packets[i],
+		.tc_rx_bytes = tc->tc_rx_bytes[i],
+		.tc_tx_packets = tc->tc_tx_packets[i],
+		.tc_tx_bytes = tc->tc_tx_bytes[i],
+	};
+
+	return veb_tc;
+}
+
 /**
  * i40e_get_pfc_stats - copy HW PFC statistics to formatted structure
  * @pf: the PF device structure
@@ -2301,8 +2333,16 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
 			       i40e_gstrings_veb_stats);
 
 	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
-		i40e_add_ethtool_stats(&data, veb_stats ? veb : NULL,
-				       i40e_gstrings_veb_tc_stats);
+		if (veb_stats) {
+			struct i40e_cp_veb_tc_stats veb_tc =
+				i40e_get_veb_tc_stats(&veb->tc_stats, i);
+
+			i40e_add_ethtool_stats(&data, &veb_tc,
+					       i40e_gstrings_veb_tc_stats);
+		} else {
+			i40e_add_ethtool_stats(&data, NULL,
+					       i40e_gstrings_veb_tc_stats);
+		}
 
 	i40e_add_ethtool_stats(&data, pf, i40e_gstrings_stats);
 
-- 
2.30.2




