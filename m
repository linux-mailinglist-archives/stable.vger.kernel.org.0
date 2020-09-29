Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38A27CC0F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbgI2Mc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729671AbgI2LW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:22:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4A721924;
        Tue, 29 Sep 2020 11:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378432;
        bh=NwCF9XeKRtyUUhhvKla6mZ6gdqIX7WhwVCw/3o4iqNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/WsHNXVvIIdVhI//6TPg0LlH0NS8VzRU2wBqTSxxFyZxm/Pw69cep/81e5xiblJI
         uN3RwANd0aBnY4Lmwi+g9/7SaHnNZ6FiU1kHs5SzRslNIpTYkzusVM0eaamQi+53aJ
         oByRFZobMD0wT9cpp4r+CFDmbnURjvWFa4wuIDnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/245] ath10k: fix array out-of-bounds access
Date:   Tue, 29 Sep 2020 12:57:35 +0200
Message-Id: <20200929105947.202331793@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit c5329b2d5b8b4e41be14d31ee8505b4f5607bf9b ]

If firmware reports rate_max > WMI_TPC_RATE_MAX(WMI_TPC_FINAL_RATE_MAX)
or num_tx_chain > WMI_TPC_TX_N_CHAIN, it will cause array out-of-bounds
access, so print a warning and reset to avoid memory corruption.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00035

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/debug.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c   | 49 ++++++++++++++++---------
 2 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 0baaad90b8d18..aa333110eaba6 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1521,7 +1521,7 @@ static void ath10k_tpc_stats_print(struct ath10k_tpc_stats *tpc_stats,
 	*len += scnprintf(buf + *len, buf_len - *len,
 			  "No.  Preamble Rate_code ");
 
-	for (i = 0; i < WMI_TPC_TX_N_CHAIN; i++)
+	for (i = 0; i < tpc_stats->num_tx_chain; i++)
 		*len += scnprintf(buf + *len, buf_len - *len,
 				  "tpc_value%d ", i);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 3372dfa0deccf..3f3fbee631c34 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4550,16 +4550,13 @@ static void ath10k_tpc_config_disp_tables(struct ath10k *ar,
 	}
 
 	pream_idx = 0;
-	for (i = 0; i < __le32_to_cpu(ev->rate_max); i++) {
+	for (i = 0; i < tpc_stats->rate_max; i++) {
 		memset(tpc_value, 0, sizeof(tpc_value));
 		memset(buff, 0, sizeof(buff));
 		if (i == pream_table[pream_idx])
 			pream_idx++;
 
-		for (j = 0; j < WMI_TPC_TX_N_CHAIN; j++) {
-			if (j >= __le32_to_cpu(ev->num_tx_chain))
-				break;
-
+		for (j = 0; j < tpc_stats->num_tx_chain; j++) {
 			tpc[j] = ath10k_tpc_config_get_rate(ar, ev, i, j + 1,
 							    rate_code[i],
 							    type);
@@ -4672,7 +4669,7 @@ void ath10k_wmi_tpc_config_get_rate_code(u8 *rate_code, u16 *pream_table,
 
 void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar, struct sk_buff *skb)
 {
-	u32 num_tx_chain;
+	u32 num_tx_chain, rate_max;
 	u8 rate_code[WMI_TPC_RATE_MAX];
 	u16 pream_table[WMI_TPC_PREAM_TABLE_MAX];
 	struct wmi_pdev_tpc_config_event *ev;
@@ -4688,6 +4685,13 @@ void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar, struct sk_buff *skb)
 		return;
 	}
 
+	rate_max = __le32_to_cpu(ev->rate_max);
+	if (rate_max > WMI_TPC_RATE_MAX) {
+		ath10k_warn(ar, "number of rate is %d greater than TPC configured rate %d\n",
+			    rate_max, WMI_TPC_RATE_MAX);
+		rate_max = WMI_TPC_RATE_MAX;
+	}
+
 	tpc_stats = kzalloc(sizeof(*tpc_stats), GFP_ATOMIC);
 	if (!tpc_stats)
 		return;
@@ -4704,8 +4708,8 @@ void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar, struct sk_buff *skb)
 		__le32_to_cpu(ev->twice_antenna_reduction);
 	tpc_stats->power_limit = __le32_to_cpu(ev->power_limit);
 	tpc_stats->twice_max_rd_power = __le32_to_cpu(ev->twice_max_rd_power);
-	tpc_stats->num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
-	tpc_stats->rate_max = __le32_to_cpu(ev->rate_max);
+	tpc_stats->num_tx_chain = num_tx_chain;
+	tpc_stats->rate_max = rate_max;
 
 	ath10k_tpc_config_disp_tables(ar, ev, tpc_stats,
 				      rate_code, pream_table,
@@ -4900,16 +4904,13 @@ ath10k_wmi_tpc_stats_final_disp_tables(struct ath10k *ar,
 	}
 
 	pream_idx = 0;
-	for (i = 0; i < __le32_to_cpu(ev->rate_max); i++) {
+	for (i = 0; i < tpc_stats->rate_max; i++) {
 		memset(tpc_value, 0, sizeof(tpc_value));
 		memset(buff, 0, sizeof(buff));
 		if (i == pream_table[pream_idx])
 			pream_idx++;
 
-		for (j = 0; j < WMI_TPC_TX_N_CHAIN; j++) {
-			if (j >= __le32_to_cpu(ev->num_tx_chain))
-				break;
-
+		for (j = 0; j < tpc_stats->num_tx_chain; j++) {
 			tpc[j] = ath10k_wmi_tpc_final_get_rate(ar, ev, i, j + 1,
 							       rate_code[i],
 							       type, pream_idx);
@@ -4925,7 +4926,7 @@ ath10k_wmi_tpc_stats_final_disp_tables(struct ath10k *ar,
 
 void ath10k_wmi_event_tpc_final_table(struct ath10k *ar, struct sk_buff *skb)
 {
-	u32 num_tx_chain;
+	u32 num_tx_chain, rate_max;
 	u8 rate_code[WMI_TPC_FINAL_RATE_MAX];
 	u16 pream_table[WMI_TPC_PREAM_TABLE_MAX];
 	struct wmi_pdev_tpc_final_table_event *ev;
@@ -4933,12 +4934,24 @@ void ath10k_wmi_event_tpc_final_table(struct ath10k *ar, struct sk_buff *skb)
 
 	ev = (struct wmi_pdev_tpc_final_table_event *)skb->data;
 
+	num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
+	if (num_tx_chain > WMI_TPC_TX_N_CHAIN) {
+		ath10k_warn(ar, "number of tx chain is %d greater than TPC final configured tx chain %d\n",
+			    num_tx_chain, WMI_TPC_TX_N_CHAIN);
+		return;
+	}
+
+	rate_max = __le32_to_cpu(ev->rate_max);
+	if (rate_max > WMI_TPC_FINAL_RATE_MAX) {
+		ath10k_warn(ar, "number of rate is %d greater than TPC final configured rate %d\n",
+			    rate_max, WMI_TPC_FINAL_RATE_MAX);
+		rate_max = WMI_TPC_FINAL_RATE_MAX;
+	}
+
 	tpc_stats = kzalloc(sizeof(*tpc_stats), GFP_ATOMIC);
 	if (!tpc_stats)
 		return;
 
-	num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
-
 	ath10k_wmi_tpc_config_get_rate_code(rate_code, pream_table,
 					    num_tx_chain);
 
@@ -4951,8 +4964,8 @@ void ath10k_wmi_event_tpc_final_table(struct ath10k *ar, struct sk_buff *skb)
 		__le32_to_cpu(ev->twice_antenna_reduction);
 	tpc_stats->power_limit = __le32_to_cpu(ev->power_limit);
 	tpc_stats->twice_max_rd_power = __le32_to_cpu(ev->twice_max_rd_power);
-	tpc_stats->num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
-	tpc_stats->rate_max = __le32_to_cpu(ev->rate_max);
+	tpc_stats->num_tx_chain = num_tx_chain;
+	tpc_stats->rate_max = rate_max;
 
 	ath10k_wmi_tpc_stats_final_disp_tables(ar, ev, tpc_stats,
 					       rate_code, pream_table,
-- 
2.25.1



