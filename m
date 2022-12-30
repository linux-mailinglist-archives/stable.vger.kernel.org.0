Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDED657B31
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiL1PTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiL1PTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:19:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4182813FB0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:18:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3071CE136C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B783EC433D2;
        Wed, 28 Dec 2022 15:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240727;
        bh=aJfkUkuXUF7EqR04rhyjaS7Hfv7ONuqyBVdhK/yieX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdyhI1Zg84dliHd4ItDkpE/pahXyR1cKV0V65Vk1S1kzg6USkFc3o52e4lOTPM+YT
         RCOrqu4LyGnzNm54GY5K1uvqIzVJpxLKrhCDLflfxWCwFwrS2lHcoSSFQv1K5QXTor
         uxh7169tbmsiTWT3DnGxf5COsdrbbpHAx8dzless=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Aditya Kumar Singh <quic_adisi@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0196/1073] wifi: ath11k: move firmware stats out of debugfs
Date:   Wed, 28 Dec 2022 15:29:44 +0100
Message-Id: <20221228144333.338711527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

[ Upstream commit ec8918f922b8a40a12cb86793245026f08b79812 ]

Currently, firmware stats, comprising pdev, vdev and beacon stats are
part of debugfs. In firmware pdev stats, firmware reports the final
Tx power used to transmit each packet. If driver wants to know the
final Tx power being used at firmware level, it can leverage from
firmware pdev stats.

Move firmware stats out of debugfs context in order to leverage
the final Tx power reported in it even when debugfs is disabled.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1
Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220603082814.31466-2-quic_adisi@quicinc.com
Stable-dep-of: 3ff51d7416ee ("wifi: ath11k: fix firmware assert during bandwidth change for peer sta")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c    |  46 +++++++
 drivers/net/wireless/ath/ath11k/core.h    |  12 +-
 drivers/net/wireless/ath/ath11k/debugfs.c | 139 +++++-----------------
 drivers/net/wireless/ath/ath11k/debugfs.h |   6 +-
 drivers/net/wireless/ath/ath11k/wmi.c     |  48 +++++++-
 5 files changed, 137 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 9df6aaae8a44..1e9e4eae7a1e 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -535,6 +535,52 @@ static inline struct ath11k_pdev *ath11k_core_get_single_pdev(struct ath11k_base
 	return &ab->pdevs[0];
 }
 
+void ath11k_fw_stats_pdevs_free(struct list_head *head)
+{
+	struct ath11k_fw_stats_pdev *i, *tmp;
+
+	list_for_each_entry_safe(i, tmp, head, list) {
+		list_del(&i->list);
+		kfree(i);
+	}
+}
+
+void ath11k_fw_stats_vdevs_free(struct list_head *head)
+{
+	struct ath11k_fw_stats_vdev *i, *tmp;
+
+	list_for_each_entry_safe(i, tmp, head, list) {
+		list_del(&i->list);
+		kfree(i);
+	}
+}
+
+void ath11k_fw_stats_bcn_free(struct list_head *head)
+{
+	struct ath11k_fw_stats_bcn *i, *tmp;
+
+	list_for_each_entry_safe(i, tmp, head, list) {
+		list_del(&i->list);
+		kfree(i);
+	}
+}
+
+void ath11k_fw_stats_init(struct ath11k *ar)
+{
+	INIT_LIST_HEAD(&ar->fw_stats.pdevs);
+	INIT_LIST_HEAD(&ar->fw_stats.vdevs);
+	INIT_LIST_HEAD(&ar->fw_stats.bcn);
+
+	init_completion(&ar->fw_stats_complete);
+}
+
+void ath11k_fw_stats_free(struct ath11k_fw_stats *stats)
+{
+	ath11k_fw_stats_pdevs_free(&stats->pdevs);
+	ath11k_fw_stats_vdevs_free(&stats->vdevs);
+	ath11k_fw_stats_bcn_free(&stats->bcn);
+}
+
 int ath11k_core_suspend(struct ath11k_base *ab)
 {
 	int ret;
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index afad8f55e433..b4aac98497cb 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -545,9 +545,6 @@ struct ath11k_debug {
 	struct dentry *debugfs_pdev;
 	struct ath11k_dbg_htt_stats htt_stats;
 	u32 extd_tx_stats;
-	struct ath11k_fw_stats fw_stats;
-	struct completion fw_stats_complete;
-	bool fw_stats_done;
 	u32 extd_rx_stats;
 	u32 pktlog_filter;
 	u32 pktlog_mode;
@@ -710,6 +707,9 @@ struct ath11k {
 	u8 twt_enabled;
 	bool nlo_enabled;
 	u8 alpha2[REG_ALPHA2_LEN + 1];
+	struct ath11k_fw_stats fw_stats;
+	struct completion fw_stats_complete;
+	bool fw_stats_done;
 };
 
 struct ath11k_band_cap {
@@ -1112,6 +1112,12 @@ struct ath11k_fw_stats_bcn {
 	u32 tx_bcn_outage_cnt;
 };
 
+void ath11k_fw_stats_init(struct ath11k *ar);
+void ath11k_fw_stats_pdevs_free(struct list_head *head);
+void ath11k_fw_stats_vdevs_free(struct list_head *head);
+void ath11k_fw_stats_bcn_free(struct list_head *head);
+void ath11k_fw_stats_free(struct ath11k_fw_stats *stats);
+
 extern const struct ce_pipe_config ath11k_target_ce_config_wlan_ipq8074[];
 extern const struct service_to_pipe ath11k_target_service_to_ce_map_wlan_ipq8074[];
 extern const struct service_to_pipe ath11k_target_service_to_ce_map_wlan_ipq6018[];
diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 9648e0017393..649bf4495e4a 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -91,91 +91,35 @@ void ath11k_debugfs_add_dbring_entry(struct ath11k *ar,
 	spin_unlock_bh(&dbr_data->lock);
 }
 
-static void ath11k_fw_stats_pdevs_free(struct list_head *head)
-{
-	struct ath11k_fw_stats_pdev *i, *tmp;
-
-	list_for_each_entry_safe(i, tmp, head, list) {
-		list_del(&i->list);
-		kfree(i);
-	}
-}
-
-static void ath11k_fw_stats_vdevs_free(struct list_head *head)
-{
-	struct ath11k_fw_stats_vdev *i, *tmp;
-
-	list_for_each_entry_safe(i, tmp, head, list) {
-		list_del(&i->list);
-		kfree(i);
-	}
-}
-
-static void ath11k_fw_stats_bcn_free(struct list_head *head)
-{
-	struct ath11k_fw_stats_bcn *i, *tmp;
-
-	list_for_each_entry_safe(i, tmp, head, list) {
-		list_del(&i->list);
-		kfree(i);
-	}
-}
-
 static void ath11k_debugfs_fw_stats_reset(struct ath11k *ar)
 {
 	spin_lock_bh(&ar->data_lock);
-	ar->debug.fw_stats_done = false;
-	ath11k_fw_stats_pdevs_free(&ar->debug.fw_stats.pdevs);
-	ath11k_fw_stats_vdevs_free(&ar->debug.fw_stats.vdevs);
+	ar->fw_stats_done = false;
+	ath11k_fw_stats_pdevs_free(&ar->fw_stats.pdevs);
+	ath11k_fw_stats_vdevs_free(&ar->fw_stats.vdevs);
 	spin_unlock_bh(&ar->data_lock);
 }
 
-void ath11k_debugfs_fw_stats_process(struct ath11k_base *ab, struct sk_buff *skb)
+void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *stats)
 {
-	struct ath11k_fw_stats stats = {};
-	struct ath11k *ar;
+	struct ath11k_base *ab = ar->ab;
 	struct ath11k_pdev *pdev;
 	bool is_end;
 	static unsigned int num_vdev, num_bcn;
 	size_t total_vdevs_started = 0;
-	int i, ret;
-
-	INIT_LIST_HEAD(&stats.pdevs);
-	INIT_LIST_HEAD(&stats.vdevs);
-	INIT_LIST_HEAD(&stats.bcn);
-
-	ret = ath11k_wmi_pull_fw_stats(ab, skb, &stats);
-	if (ret) {
-		ath11k_warn(ab, "failed to pull fw stats: %d\n", ret);
-		goto free;
-	}
-
-	rcu_read_lock();
-	ar = ath11k_mac_get_ar_by_pdev_id(ab, stats.pdev_id);
-	if (!ar) {
-		rcu_read_unlock();
-		ath11k_warn(ab, "failed to get ar for pdev_id %d: %d\n",
-			    stats.pdev_id, ret);
-		goto free;
-	}
+	int i;
 
-	spin_lock_bh(&ar->data_lock);
+	/* WMI_REQUEST_PDEV_STAT request has been already processed */
 
-	if (stats.stats_id == WMI_REQUEST_PDEV_STAT) {
-		list_splice_tail_init(&stats.pdevs, &ar->debug.fw_stats.pdevs);
-		ar->debug.fw_stats_done = true;
-		goto complete;
-	}
-
-	if (stats.stats_id == WMI_REQUEST_RSSI_PER_CHAIN_STAT) {
-		ar->debug.fw_stats_done = true;
-		goto complete;
+	if (stats->stats_id == WMI_REQUEST_RSSI_PER_CHAIN_STAT) {
+		ar->fw_stats_done = true;
+		return;
 	}
 
-	if (stats.stats_id == WMI_REQUEST_VDEV_STAT) {
-		if (list_empty(&stats.vdevs)) {
+	if (stats->stats_id == WMI_REQUEST_VDEV_STAT) {
+		if (list_empty(&stats->vdevs)) {
 			ath11k_warn(ab, "empty vdev stats");
-			goto complete;
+			return;
 		}
 		/* FW sends all the active VDEV stats irrespective of PDEV,
 		 * hence limit until the count of all VDEVs started
@@ -188,43 +132,34 @@ void ath11k_debugfs_fw_stats_process(struct ath11k_base *ab, struct sk_buff *skb
 
 		is_end = ((++num_vdev) == total_vdevs_started);
 
-		list_splice_tail_init(&stats.vdevs,
-				      &ar->debug.fw_stats.vdevs);
+		list_splice_tail_init(&stats->vdevs,
+				      &ar->fw_stats.vdevs);
 
 		if (is_end) {
-			ar->debug.fw_stats_done = true;
+			ar->fw_stats_done = true;
 			num_vdev = 0;
 		}
-		goto complete;
+		return;
 	}
 
-	if (stats.stats_id == WMI_REQUEST_BCN_STAT) {
-		if (list_empty(&stats.bcn)) {
+	if (stats->stats_id == WMI_REQUEST_BCN_STAT) {
+		if (list_empty(&stats->bcn)) {
 			ath11k_warn(ab, "empty bcn stats");
-			goto complete;
+			return;
 		}
 		/* Mark end until we reached the count of all started VDEVs
 		 * within the PDEV
 		 */
 		is_end = ((++num_bcn) == ar->num_started_vdevs);
 
-		list_splice_tail_init(&stats.bcn,
-				      &ar->debug.fw_stats.bcn);
+		list_splice_tail_init(&stats->bcn,
+				      &ar->fw_stats.bcn);
 
 		if (is_end) {
-			ar->debug.fw_stats_done = true;
+			ar->fw_stats_done = true;
 			num_bcn = 0;
 		}
 	}
-complete:
-	complete(&ar->debug.fw_stats_complete);
-	rcu_read_unlock();
-	spin_unlock_bh(&ar->data_lock);
-
-free:
-	ath11k_fw_stats_pdevs_free(&stats.pdevs);
-	ath11k_fw_stats_vdevs_free(&stats.vdevs);
-	ath11k_fw_stats_bcn_free(&stats.bcn);
 }
 
 static int ath11k_debugfs_fw_stats_request(struct ath11k *ar,
@@ -245,7 +180,7 @@ static int ath11k_debugfs_fw_stats_request(struct ath11k *ar,
 
 	ath11k_debugfs_fw_stats_reset(ar);
 
-	reinit_completion(&ar->debug.fw_stats_complete);
+	reinit_completion(&ar->fw_stats_complete);
 
 	ret = ath11k_wmi_send_stats_request_cmd(ar, req_param);
 
@@ -255,9 +190,8 @@ static int ath11k_debugfs_fw_stats_request(struct ath11k *ar,
 		return ret;
 	}
 
-	time_left =
-	wait_for_completion_timeout(&ar->debug.fw_stats_complete,
-				    1 * HZ);
+	time_left = wait_for_completion_timeout(&ar->fw_stats_complete, 1 * HZ);
+
 	if (!time_left)
 		return -ETIMEDOUT;
 
@@ -266,7 +200,7 @@ static int ath11k_debugfs_fw_stats_request(struct ath11k *ar,
 			break;
 
 		spin_lock_bh(&ar->data_lock);
-		if (ar->debug.fw_stats_done) {
+		if (ar->fw_stats_done) {
 			spin_unlock_bh(&ar->data_lock);
 			break;
 		}
@@ -338,8 +272,7 @@ static int ath11k_open_pdev_stats(struct inode *inode, struct file *file)
 		goto err_free;
 	}
 
-	ath11k_wmi_fw_stats_fill(ar, &ar->debug.fw_stats, req_param.stats_id,
-				 buf);
+	ath11k_wmi_fw_stats_fill(ar, &ar->fw_stats, req_param.stats_id, buf);
 
 	file->private_data = buf;
 
@@ -410,8 +343,7 @@ static int ath11k_open_vdev_stats(struct inode *inode, struct file *file)
 		goto err_free;
 	}
 
-	ath11k_wmi_fw_stats_fill(ar, &ar->debug.fw_stats, req_param.stats_id,
-				 buf);
+	ath11k_wmi_fw_stats_fill(ar, &ar->fw_stats, req_param.stats_id, buf);
 
 	file->private_data = buf;
 
@@ -488,14 +420,13 @@ static int ath11k_open_bcn_stats(struct inode *inode, struct file *file)
 		}
 	}
 
-	ath11k_wmi_fw_stats_fill(ar, &ar->debug.fw_stats, req_param.stats_id,
-				 buf);
+	ath11k_wmi_fw_stats_fill(ar, &ar->fw_stats, req_param.stats_id, buf);
 
 	/* since beacon stats request is looped for all active VDEVs, saved fw
 	 * stats is not freed for each request until done for all active VDEVs
 	 */
 	spin_lock_bh(&ar->data_lock);
-	ath11k_fw_stats_bcn_free(&ar->debug.fw_stats.bcn);
+	ath11k_fw_stats_bcn_free(&ar->fw_stats.bcn);
 	spin_unlock_bh(&ar->data_lock);
 
 	file->private_data = buf;
@@ -1025,7 +956,7 @@ void ath11k_debugfs_fw_stats_init(struct ath11k *ar)
 	struct dentry *fwstats_dir = debugfs_create_dir("fw_stats",
 							ar->debug.debugfs_pdev);
 
-	ar->debug.fw_stats.debugfs_fwstats = fwstats_dir;
+	ar->fw_stats.debugfs_fwstats = fwstats_dir;
 
 	/* all stats debugfs files created are under "fw_stats" directory
 	 * created per PDEV
@@ -1036,12 +967,6 @@ void ath11k_debugfs_fw_stats_init(struct ath11k *ar)
 			    &fops_vdev_stats);
 	debugfs_create_file("beacon_stats", 0600, fwstats_dir, ar,
 			    &fops_bcn_stats);
-
-	INIT_LIST_HEAD(&ar->debug.fw_stats.pdevs);
-	INIT_LIST_HEAD(&ar->debug.fw_stats.vdevs);
-	INIT_LIST_HEAD(&ar->debug.fw_stats.bcn);
-
-	init_completion(&ar->debug.fw_stats_complete);
 }
 
 static ssize_t ath11k_write_pktlog_filter(struct file *file,
diff --git a/drivers/net/wireless/ath/ath11k/debugfs.h b/drivers/net/wireless/ath/ath11k/debugfs.h
index 30c00cb28311..0a84645e2e06 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.h
+++ b/drivers/net/wireless/ath/ath11k/debugfs.h
@@ -269,7 +269,7 @@ int ath11k_debugfs_pdev_create(struct ath11k_base *ab);
 void ath11k_debugfs_pdev_destroy(struct ath11k_base *ab);
 int ath11k_debugfs_register(struct ath11k *ar);
 void ath11k_debugfs_unregister(struct ath11k *ar);
-void ath11k_debugfs_fw_stats_process(struct ath11k_base *ab, struct sk_buff *skb);
+void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *stats);
 
 void ath11k_debugfs_fw_stats_init(struct ath11k *ar);
 int ath11k_debugfs_get_fw_stats(struct ath11k *ar, u32 pdev_id,
@@ -341,8 +341,8 @@ static inline void ath11k_debugfs_unregister(struct ath11k *ar)
 {
 }
 
-static inline void ath11k_debugfs_fw_stats_process(struct ath11k_base *ab,
-						   struct sk_buff *skb)
+static inline void ath11k_debugfs_fw_stats_process(struct ath11k *ar,
+						   struct ath11k_fw_stats *stats)
 {
 }
 
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index b658ea60dcf7..ec9b7e954dfc 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -7409,7 +7409,53 @@ static void ath11k_peer_assoc_conf_event(struct ath11k_base *ab, struct sk_buff
 
 static void ath11k_update_stats_event(struct ath11k_base *ab, struct sk_buff *skb)
 {
-	ath11k_debugfs_fw_stats_process(ab, skb);
+	struct ath11k_fw_stats stats = {};
+	struct ath11k *ar;
+	int ret;
+
+	INIT_LIST_HEAD(&stats.pdevs);
+	INIT_LIST_HEAD(&stats.vdevs);
+	INIT_LIST_HEAD(&stats.bcn);
+
+	ret = ath11k_wmi_pull_fw_stats(ab, skb, &stats);
+	if (ret) {
+		ath11k_warn(ab, "failed to pull fw stats: %d\n", ret);
+		goto free;
+	}
+
+	rcu_read_lock();
+	ar = ath11k_mac_get_ar_by_pdev_id(ab, stats.pdev_id);
+	if (!ar) {
+		rcu_read_unlock();
+		ath11k_warn(ab, "failed to get ar for pdev_id %d: %d\n",
+			    stats.pdev_id, ret);
+		goto free;
+	}
+
+	spin_lock_bh(&ar->data_lock);
+
+	/* WMI_REQUEST_PDEV_STAT can be requested via .get_txpower mac ops or via
+	 * debugfs fw stats. Therefore, processing it separately.
+	 */
+	if (stats.stats_id == WMI_REQUEST_PDEV_STAT) {
+		list_splice_tail_init(&stats.pdevs, &ar->fw_stats.pdevs);
+		ar->fw_stats_done = true;
+		goto complete;
+	}
+
+	/* WMI_REQUEST_VDEV_STAT, WMI_REQUEST_BCN_STAT and WMI_REQUEST_RSSI_PER_CHAIN_STAT
+	 * are currently requested only via debugfs fw stats. Hence, processing these
+	 * in debugfs context
+	 */
+	ath11k_debugfs_fw_stats_process(ar, &stats);
+
+complete:
+	complete(&ar->fw_stats_complete);
+	rcu_read_unlock();
+	spin_unlock_bh(&ar->data_lock);
+
+free:
+	ath11k_fw_stats_free(&stats);
 }
 
 /* PDEV_CTL_FAILSAFE_CHECK_EVENT is received from FW when the frequency scanned
-- 
2.35.1



