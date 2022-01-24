Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15B64996C6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446106AbiAXVGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54896 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444201AbiAXVAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:00:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35D25B811FB;
        Mon, 24 Jan 2022 21:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F51AC340E5;
        Mon, 24 Jan 2022 21:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058015;
        bh=rQ607IDeFU2nWSVgGXcNI0jU6mG3sRhHTCFIHXP0PwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02cnn9g3tm6G5Yke4Y0cOmSh98cuFGucDmqAsHFRDBs/LS7CZ0uUDKnhKkku9kw91
         5Mrl7IHxu5fkCPvUE5vXok4PUy78HYbh+E3+0IXu10j+fzvmw2pJA6PM/Fm7epKZez
         S0+o9E8HMjYjE4739Mo1iECZh437OrV0sSAbHvS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0152/1039] ath11k: set correct NL80211_FEATURE_DYNAMIC_SMPS for WCN6855
Date:   Mon, 24 Jan 2022 19:32:21 +0100
Message-Id: <20220124184130.267861766@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit 82c434c103408842a87404e873992b7698b6df2b ]

Commit 6f4d70308e5e ("ath11k: support SMPS configuration for 6 GHz") changed
"if (ht_cap & WMI_HT_CAP_DYNAMIC_SMPS)" to "if (ht_cap &
WMI_HT_CAP_DYNAMIC_SMPS || ar->supports_6ghz)" which means
NL80211_FEATURE_DYNAMIC_SMPS is enabled for all chips which support 6 GHz.
However, WCN6855 supports 6 GHz but it does not support feature
NL80211_FEATURE_DYNAMIC_SMPS, and this can lead to MU-MIMO test failures for
WCN6855.

Disable NL80211_FEATURE_DYNAMIC_SMPS for WCN6855 since its ht_cap does not
support WMI_HT_CAP_DYNAMIC_SMPS. Enable the feature only on QCN9074 as that's
the only other device supporting 6 GHz band.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210914163726.38604-3-jouni@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 5 +++++
 drivers/net/wireless/ath/ath11k/hw.h   | 1 +
 drivers/net/wireless/ath/ath11k/mac.c  | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index b5a2af3ffc3e1..7ee2ccc49c747 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -82,6 +82,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.fix_l1ss = true,
 		.max_tx_ring = DP_TCL_NUM_RING_MAX,
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
+		.supports_dynamic_smps_6ghz = false,
 	},
 	{
 		.hw_rev = ATH11K_HW_IPQ6018_HW10,
@@ -131,6 +132,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.fix_l1ss = true,
 		.max_tx_ring = DP_TCL_NUM_RING_MAX,
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
+		.supports_dynamic_smps_6ghz = false,
 	},
 	{
 		.name = "qca6390 hw2.0",
@@ -179,6 +181,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.fix_l1ss = true,
 		.max_tx_ring = DP_TCL_NUM_RING_MAX_QCA6390,
 		.hal_params = &ath11k_hw_hal_params_qca6390,
+		.supports_dynamic_smps_6ghz = false,
 	},
 	{
 		.name = "qcn9074 hw1.0",
@@ -227,6 +230,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.fix_l1ss = true,
 		.max_tx_ring = DP_TCL_NUM_RING_MAX,
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
+		.supports_dynamic_smps_6ghz = true,
 	},
 	{
 		.name = "wcn6855 hw2.0",
@@ -275,6 +279,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.fix_l1ss = false,
 		.max_tx_ring = DP_TCL_NUM_RING_MAX_QCA6390,
 		.hal_params = &ath11k_hw_hal_params_qca6390,
+		.supports_dynamic_smps_6ghz = false,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 19223d36846e8..6dcac596e3fe5 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -176,6 +176,7 @@ struct ath11k_hw_params {
 	bool fix_l1ss;
 	u8 max_tx_ring;
 	const struct ath11k_hw_hal_params *hal_params;
+	bool supports_dynamic_smps_6ghz;
 };
 
 struct ath11k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 9ed7eb09bdb70..821332cbeb5de 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -7674,7 +7674,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	 * for each band for a dual band capable radio. It will be tricky to
 	 * handle it when the ht capability different for each band.
 	 */
-	if (ht_cap & WMI_HT_CAP_DYNAMIC_SMPS || ar->supports_6ghz)
+	if (ht_cap & WMI_HT_CAP_DYNAMIC_SMPS ||
+	    (ar->supports_6ghz && ab->hw_params.supports_dynamic_smps_6ghz))
 		ar->hw->wiphy->features |= NL80211_FEATURE_DYNAMIC_SMPS;
 
 	ar->hw->wiphy->max_scan_ssids = WLAN_SCAN_PARAMS_MAX_SSID;
-- 
2.34.1



