Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F884514A4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345787AbhKOUL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:11:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344886AbhKOTZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8329E633F3;
        Mon, 15 Nov 2021 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003167;
        bh=cUCufqyCkoUxfzYzIIFRB0ZfOKROhjkk/iWzbPfhXW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSTTWzpDDnu6V9boPxK7nidNkQBI1lomsYbVbJcY5dIvbiDcqqQiuz9khutTepqZ7
         HJem35BhmtQiO7y0kqogMPhQ23R37G8LmgEtUETDy5k7p/yMDplOlLTUMBJTHXPRwx
         4AYgfQyujTkZfar1zzIqgWwvndp9XMvoJvF6GHmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 835/917] net: hns3: fix pfc packet number incorrect after querying pfc parameters
Date:   Mon, 15 Nov 2021 18:05:30 +0100
Message-Id: <20211115165457.359070102@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 91cb578f56b80..90013c131e949 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -286,28 +286,24 @@ err_out:
 
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
index ffd85cd297ef3..66c407d0d507e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -26,8 +26,6 @@
 #include "hclge_devlink.h"
 
 #define HCLGE_NAME			"hclge"
-#define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
-#define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
 
 #define HCLGE_BUF_SIZE_UNIT	256U
 #define HCLGE_BUF_MUL_BY	2
@@ -548,7 +546,7 @@ static int hclge_mac_query_reg_num(struct hclge_dev *hdev, u32 *desc_num)
 	return 0;
 }
 
-static int hclge_mac_update_stats(struct hclge_dev *hdev)
+int hclge_mac_update_stats(struct hclge_dev *hdev)
 {
 	u32 desc_num;
 	int ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9111b8c84d786..2fa6e14c96e5b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -824,6 +824,9 @@ struct hclge_vf_vlan_cfg {
 		(y) = (_k_ ^ ~_v_) & (_k_); \
 	} while (0)
 
+#define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
+#define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
+
 #define HCLGE_MAC_TNL_LOG_SIZE	8
 #define HCLGE_VPORT_NUM 256
 struct hclge_dev {
@@ -1136,4 +1139,5 @@ void hclge_inform_vf_promisc_info(struct hclge_vport *vport);
 int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len);
 int hclge_push_vf_link_status(struct hclge_vport *vport);
 int hclge_enable_vport_vlan_filter(struct hclge_vport *vport, bool request_en);
+int hclge_mac_update_stats(struct hclge_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 95074e91a8466..a50e2edbf4a0f 100644
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
index 2ee9b795f71dc..1db7f40b45255 100644
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



