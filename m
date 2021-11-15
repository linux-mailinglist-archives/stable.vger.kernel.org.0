Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B654512A0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347094AbhKOTiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:38:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244934AbhKOTSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4922D634DB;
        Mon, 15 Nov 2021 18:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000746;
        bh=ho+Lif5wCyG3OLGyY5eypZXHnx4Sb/O6s0dzGA5tQSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mol3L9piukAnsNACVO7H4BBoplFMg4mQRmjPNAhNOoNinMXx465olpAqrO1/7Z39R
         Yp8AWD621VCKxEehF8z5dSuKRc4tJmOT88/2gc4Uw94rHar6qlqHNQbwuCypxv1prx
         np8DDDwhbxqGOLgQWieu5CSWVIpzrLS0Kvls3FcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 775/849] net: hns3: fix pfc packet number incorrect after querying pfc parameters
Date:   Mon, 15 Nov 2021 18:04:18 +0100
Message-Id: <20211115165446.465532728@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 0b653a81a26d66ffe526a54c2177e24fb1400301 ]

Currently, driver will send command to firmware to query pfc packet number
when user uses dcb tool to get pfc parameters. However, the periodic
service task will also periodically query and record MAC statistics,
including pfc packet number.

As the hardware registers of statistics is cleared after reading, it will
cause pfc packet number of MAC statistics are not correct after using dcb
tool to get pfc parameters.

To fix this problem, when user uses dcb tool to get pfc parameters, driver
updates MAC statistics firstly and then get pfc packet number from MAC
statistics.

Fixes: 64fd2300fcc1 ("net: hns3: add support for querying pfc puase packets statistic")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         | 18 ++---
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  4 +-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  4 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 68 +++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |  4 +-
 5 files changed, 48 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index c60d0626062cf..64cc019cb67ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -265,28 +265,24 @@ err_out:
 
 static int hclge_ieee_getpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 {
-	u64 requests[HNAE3_MAX_TC], indications[HNAE3_MAX_TC];
 	struct hclge_vport *vport = hclge_get_vport(h);
 	struct hclge_dev *hdev = vport->back;
 	int ret;
-	u8 i;
 
 	memset(pfc, 0, sizeof(*pfc));
 	pfc->pfc_cap = hdev->pfc_max;
 	pfc->pfc_en = hdev->tm_info.pfc_en;
 
-	ret = hclge_pfc_tx_stats_get(hdev, requests);
-	if (ret)
+	ret = hclge_mac_update_stats(hdev);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to update MAC stats, ret = %d.\n", ret);
 		return ret;
+	}
 
-	ret = hclge_pfc_rx_stats_get(hdev, indications);
-	if (ret)
-		return ret;
+	hclge_pfc_tx_stats_get(hdev, pfc->requests);
+	hclge_pfc_rx_stats_get(hdev, pfc->indications);
 
-	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
-		pfc->requests[i] = requests[i];
-		pfc->indications[i] = indications[i];
-	}
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 494af494fc5b1..a066b9f5ba11c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -25,8 +25,6 @@
 #include "hnae3.h"
 
 #define HCLGE_NAME			"hclge"
-#define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
-#define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
 
 #define HCLGE_BUF_SIZE_UNIT	256U
 #define HCLGE_BUF_MUL_BY	2
@@ -547,7 +545,7 @@ static int hclge_mac_query_reg_num(struct hclge_dev *hdev, u32 *desc_num)
 	return 0;
 }
 
-static int hclge_mac_update_stats(struct hclge_dev *hdev)
+int hclge_mac_update_stats(struct hclge_dev *hdev)
 {
 	u32 desc_num;
 	int ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 29d916055c657..3a4d04884cd34 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -822,6 +822,9 @@ struct hclge_vf_vlan_cfg {
 		(y) = (_k_ ^ ~_v_) & (_k_); \
 	} while (0)
 
+#define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
+#define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
+
 #define HCLGE_MAC_TNL_LOG_SIZE	8
 #define HCLGE_VPORT_NUM 256
 struct hclge_dev {
@@ -1128,4 +1131,5 @@ void hclge_inform_vf_promisc_info(struct hclge_vport *vport);
 int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len);
 int hclge_push_vf_link_status(struct hclge_vport *vport);
 int hclge_enable_vport_vlan_filter(struct hclge_vport *vport, bool request_en);
+int hclge_mac_update_stats(struct hclge_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 124791e4bfeed..5ff2c98a55427 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -113,50 +113,50 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 	return 0;
 }
 
-static int hclge_pfc_stats_get(struct hclge_dev *hdev,
-			       enum hclge_opcode_type opcode, u64 *stats)
-{
-	struct hclge_desc desc[HCLGE_TM_PFC_PKT_GET_CMD_NUM];
-	int ret, i, j;
-
-	if (!(opcode == HCLGE_OPC_QUERY_PFC_RX_PKT_CNT ||
-	      opcode == HCLGE_OPC_QUERY_PFC_TX_PKT_CNT))
-		return -EINVAL;
-
-	for (i = 0; i < HCLGE_TM_PFC_PKT_GET_CMD_NUM - 1; i++) {
-		hclge_cmd_setup_basic_desc(&desc[i], opcode, true);
-		desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	}
-
-	hclge_cmd_setup_basic_desc(&desc[i], opcode, true);
+static const u16 hclge_pfc_tx_stats_offset[] = {
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri0_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri1_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri2_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri3_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri4_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri5_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri6_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri7_pkt_num)
+};
 
-	ret = hclge_cmd_send(&hdev->hw, desc, HCLGE_TM_PFC_PKT_GET_CMD_NUM);
-	if (ret)
-		return ret;
+static const u16 hclge_pfc_rx_stats_offset[] = {
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri0_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri1_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri2_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri3_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri4_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri5_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri6_pkt_num),
+	HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri7_pkt_num)
+};
 
-	for (i = 0; i < HCLGE_TM_PFC_PKT_GET_CMD_NUM; i++) {
-		struct hclge_pfc_stats_cmd *pfc_stats =
-				(struct hclge_pfc_stats_cmd *)desc[i].data;
+static void hclge_pfc_stats_get(struct hclge_dev *hdev, bool tx, u64 *stats)
+{
+	const u16 *offset;
+	int i;
 
-		for (j = 0; j < HCLGE_TM_PFC_NUM_GET_PER_CMD; j++) {
-			u32 index = i * HCLGE_TM_PFC_PKT_GET_CMD_NUM + j;
+	if (tx)
+		offset = hclge_pfc_tx_stats_offset;
+	else
+		offset = hclge_pfc_rx_stats_offset;
 
-			if (index < HCLGE_MAX_TC_NUM)
-				stats[index] =
-					le64_to_cpu(pfc_stats->pkt_num[j]);
-		}
-	}
-	return 0;
+	for (i = 0; i < HCLGE_MAX_TC_NUM; i++)
+		stats[i] = HCLGE_STATS_READ(&hdev->mac_stats, offset[i]);
 }
 
-int hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats)
+void hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats)
 {
-	return hclge_pfc_stats_get(hdev, HCLGE_OPC_QUERY_PFC_RX_PKT_CNT, stats);
+	hclge_pfc_stats_get(hdev, false, stats);
 }
 
-int hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats)
+void hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats)
 {
-	return hclge_pfc_stats_get(hdev, HCLGE_OPC_QUERY_PFC_TX_PKT_CNT, stats);
+	hclge_pfc_stats_get(hdev, true, stats);
 }
 
 int hclge_mac_pause_en_cfg(struct hclge_dev *hdev, bool tx, bool rx)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 4b2c3a7889800..72563cd0d1e26 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -228,8 +228,8 @@ int hclge_tm_dwrr_cfg(struct hclge_dev *hdev);
 int hclge_tm_init_hw(struct hclge_dev *hdev, bool init);
 int hclge_mac_pause_en_cfg(struct hclge_dev *hdev, bool tx, bool rx);
 int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
-int hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
-int hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
+void hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
+void hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
 int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate);
 int hclge_tm_get_qset_num(struct hclge_dev *hdev, u16 *qset_num);
 int hclge_tm_get_pri_num(struct hclge_dev *hdev, u8 *pri_num);
-- 
2.33.0



