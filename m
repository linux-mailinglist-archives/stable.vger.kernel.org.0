Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36EC35BD65
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbhDLIvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238221AbhDLItL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31676611F0;
        Mon, 12 Apr 2021 08:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217292;
        bh=L4gsoKHDn0DJ3SkURN/gpJ9xRVCzSx/hetyA+zH0/wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8SNJlxRRSai4DTlmjQz3AibcMC1AZ4PipMpEI/flOtxvvKYIOERuTjcbWLt+K1Uf
         Fi39Y43rgLIRbwVblxatLftgZJAMUQcZ8QXvThONZu1XjidtH5LYioOueH/PtO1Nt7
         wC9o8mEXAFUo6C05t4EPHy84c5O72Gd7hrdCK7LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eryk Rybak <eryk.roch.rybak@intel.com>,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/111] i40e: Fix display statistics for veb_tc
Date:   Mon, 12 Apr 2021 10:40:51 +0200
Message-Id: <20210412084006.700412183@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eryk Rybak <eryk.roch.rybak@intel.com>

[ Upstream commit c3214de929dbf1b7374add8bbed30ce82b197bbb ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 52 ++++++++++++++++---
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 20562ffd1ab3..b519e5af5ed9 100644
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
@@ -2213,6 +2222,29 @@ static int i40e_get_sset_count(struct net_device *netdev, int sset)
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
@@ -2297,8 +2329,16 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
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



