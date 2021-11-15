Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886A8451FA8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346726AbhKPAow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343725AbhKOTVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7A6B635D9;
        Mon, 15 Nov 2021 18:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001910;
        bh=V7pG7luS5Dn5jZqSoVh10Xv6MOneDPOPyqFVscC7crM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRooVwBROjJpIqNwM4qpjKgg6qX0CqLLNDiFSvZ9SdQhjTdCdVuAvYspbKX8wiPgw
         zQ95lF2yOlbJIEUAjgxn+QCMdo/erJLhRBk2S7wzvn8ONeVck8bodjnuGNH5LLTDhU
         7sN5YYtrLhmakiJxoJhABPA4PNgEEzUGyB46KYDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 367/917] ath11k: Avoid race during regd updates
Date:   Mon, 15 Nov 2021 17:57:42 +0100
Message-Id: <20211115165441.205997401@linuxfoundation.org>
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

From: Sriram R <srirrama@codeaurora.org>

[ Upstream commit 1db2b0d0a39102238fcbf9092cefa65a710642e9 ]

Whenever ath11k is bootup with a user country already set, cfg80211
notifies this country info to ath11k soon after registration, where the
notification is sent to the firmware for fetching the rules of this user
country input.

Multiple race conditions could be seen in this scenario where a new
request is either lost as pointed in [1] or a new regd overwrites the
default regd provided by the firmware during bootup. Note that, the
default regd is used for intersection purpose and hence it should not be
overwritten.

The main reason as pointed by [1] is the usage of ATH11K_FLAG_REGISTERED
flag which is updated after completion of core registration, whereas the
reg notification from cfg80211 and wmi events for the corresponding
request can happen much before that. Since the ATH11K_FLAG_REGISTERED is
currently used to determine if the event containing reg rules belong to
default regd or for user request, there is a possibility of the default
regd getting overwritten.

Since the default reg rules will be received only once per pdev on
firmware load, the above flag based check can be replaced with a check
to see if default_regd is already set, so that we can now always update
the new_regd. Also if the new_regd is set, this will be always used to
update the reg rules for the registered phy.

[1] https://patchwork.kernel.org/project/linux-wireless/patch/1829665.1PRlr7bOQj@ripper/

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01460-QCAHKSWPL_SILICONZ-1
Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")

Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210721212029.142388-4-jouni@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c |  2 +-
 drivers/net/wireless/ath/ath11k/reg.c | 11 ++++++-----
 drivers/net/wireless/ath/ath11k/reg.h |  2 +-
 drivers/net/wireless/ath/ath11k/wmi.c | 16 ++++++----------
 4 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index e9b3689331ec2..89a64ebd620f3 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6590,7 +6590,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 		ar->hw->wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MONITOR);
 
 	/* Apply the regd received during initialization */
-	ret = ath11k_regd_update(ar, true);
+	ret = ath11k_regd_update(ar);
 	if (ret) {
 		ath11k_err(ar->ab, "ath11k regd update failed: %d\n", ret);
 		goto err_unregister_hw;
diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index e1a1df169034b..92c59009a8ac2 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -198,7 +198,7 @@ static void ath11k_copy_regd(struct ieee80211_regdomain *regd_orig,
 		       sizeof(struct ieee80211_reg_rule));
 }
 
-int ath11k_regd_update(struct ath11k *ar, bool init)
+int ath11k_regd_update(struct ath11k *ar)
 {
 	struct ieee80211_regdomain *regd, *regd_copy = NULL;
 	int ret, regd_len, pdev_id;
@@ -209,7 +209,10 @@ int ath11k_regd_update(struct ath11k *ar, bool init)
 
 	spin_lock_bh(&ab->base_lock);
 
-	if (init) {
+	/* Prefer the latest regd update over default if it's available */
+	if (ab->new_regd[pdev_id]) {
+		regd = ab->new_regd[pdev_id];
+	} else {
 		/* Apply the regd received during init through
 		 * WMI_REG_CHAN_LIST_CC event. In case of failure to
 		 * receive the regd, initialize with a default world
@@ -222,8 +225,6 @@ int ath11k_regd_update(struct ath11k *ar, bool init)
 				    "failed to receive default regd during init\n");
 			regd = (struct ieee80211_regdomain *)&ath11k_world_regd;
 		}
-	} else {
-		regd = ab->new_regd[pdev_id];
 	}
 
 	if (!regd) {
@@ -683,7 +684,7 @@ void ath11k_regd_update_work(struct work_struct *work)
 					 regd_update_work);
 	int ret;
 
-	ret = ath11k_regd_update(ar, false);
+	ret = ath11k_regd_update(ar);
 	if (ret) {
 		/* Firmware has already moved to the new regd. We need
 		 * to maintain channel consistency across FW, Host driver
diff --git a/drivers/net/wireless/ath/ath11k/reg.h b/drivers/net/wireless/ath/ath11k/reg.h
index 65d56d44796f6..5fb9dc03a74e8 100644
--- a/drivers/net/wireless/ath/ath11k/reg.h
+++ b/drivers/net/wireless/ath/ath11k/reg.h
@@ -31,6 +31,6 @@ void ath11k_regd_update_work(struct work_struct *work);
 struct ieee80211_regdomain *
 ath11k_reg_build_regd(struct ath11k_base *ab,
 		      struct cur_regulatory_info *reg_info, bool intersect);
-int ath11k_regd_update(struct ath11k *ar, bool init);
+int ath11k_regd_update(struct ath11k *ar);
 int ath11k_reg_update_chan_list(struct ath11k *ar);
 #endif
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 72da1283f2ccb..a53eef8e2631c 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5841,10 +5841,10 @@ static int ath11k_reg_chan_list_event(struct ath11k_base *ab, struct sk_buff *sk
 	}
 
 	spin_lock(&ab->base_lock);
-	if (test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
-		/* Once mac is registered, ar is valid and all CC events from
-		 * fw is considered to be received due to user requests
-		 * currently.
+	if (ab->default_regd[pdev_idx]) {
+		/* The initial rules from FW after WMI Init is to build
+		 * the default regd. From then on, any rules updated for
+		 * the pdev could be due to user reg changes.
 		 * Free previously built regd before assigning the newly
 		 * generated regd to ar. NULL pointer handling will be
 		 * taken care by kfree itself.
@@ -5854,13 +5854,9 @@ static int ath11k_reg_chan_list_event(struct ath11k_base *ab, struct sk_buff *sk
 		ab->new_regd[pdev_idx] = regd;
 		ieee80211_queue_work(ar->hw, &ar->regd_update_work);
 	} else {
-		/* Multiple events for the same *ar is not expected. But we
-		 * can still clear any previously stored default_regd if we
-		 * are receiving this event for the same radio by mistake.
-		 * NULL pointer handling will be taken care by kfree itself.
+		/* This regd would be applied during mac registration and is
+		 * held constant throughout for regd intersection purpose
 		 */
-		kfree(ab->default_regd[pdev_idx]);
-		/* This regd would be applied during mac registration */
 		ab->default_regd[pdev_idx] = regd;
 	}
 	ab->dfs_region = reg_info->dfs_region;
-- 
2.33.0



