Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BCD6AF0F8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjCGShV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjCGSea (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:34:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D563B8600
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 051246154D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8AAC433D2;
        Tue,  7 Mar 2023 18:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213581;
        bh=XdYoLPUsmNb3zP6NWeLy9B63ysP6zFJD11QxKKM3PGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=birWY8O61Xv0AZO/vnukA8z2QGtEkB5+1mI+QY5BRqRI8GLxQnmc1biCSckxMfTgG
         JLKPpah8z1MRZ/9yAagf/U0GtyOxPQJyHRyDJaIhXIC8j1amTlL2CUcnkrj3SckOXl
         PY1F1Yo5Rx78FxuB5uqs4ok1tV7yYCiTtl1gEr8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Marko <robert.marko@sartura.hr>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 553/885] wifi: ath11k: debugfs: fix to work with multiple PCI devices
Date:   Tue,  7 Mar 2023 17:58:07 +0100
Message-Id: <20230307170026.512406324@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalle Valo <quic_kvalo@quicinc.com>

[ Upstream commit 323d91d4684d238f6bc3693fed93caf795378fe0 ]

ath11k fails to load if there are multiple ath11k PCI devices with same name:

 ath11k_pci 0000:01:00.0: Hardware name qcn9074 hw1.0
 debugfs: Directory 'ath11k' with parent '/' already present!
 ath11k_pci 0000:01:00.0: failed to create ath11k debugfs
 ath11k_pci 0000:01:00.0: failed to create soc core: -17
 ath11k_pci 0000:01:00.0: failed to init core: -17
 ath11k_pci: probe of 0000:01:00.0 failed with error -17

Fix this by creating a directory for each ath11k device using schema
<bus>-<devname>, for example "pci-0000:06:00.0". This directory created under
the top-level ath11k directory, for example /sys/kernel/debug/ath11k.

The reference to the toplevel ath11k directory is not stored anymore within ath11k, instead
it's retrieved using debugfs_lookup(). If the directory does not exist it will
be created. After the last directory from the ath11k directory is removed, for
example when doing rmmod ath11k, the empty ath11k directory is left in place,
it's a minor cosmetic issue anyway.

Here's an example hierarchy with one WCN6855:

ath11k
`-- pci-0000:06:00.0
    |-- mac0
    |   |-- dfs_block_radar_events
    |   |-- dfs_simulate_radar
    |   |-- ext_rx_stats
    |   |-- ext_tx_stats
    |   |-- fw_dbglog_config
    |   |-- fw_stats
    |   |   |-- beacon_stats
    |   |   |-- pdev_stats
    |   |   `-- vdev_stats
    |   |-- htt_stats
    |   |-- htt_stats_reset
    |   |-- htt_stats_type
    |   `-- pktlog_filter
    |-- simulate_fw_crash
    `-- soc_dp_stats

I didn't have a test setup where I could connect multiple ath11k devices to the
same the host, so I have only tested this with one device.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.9
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

Tested-by: Robert Marko <robert.marko@sartura.hr>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221220121231.20120-1-kvalo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.h    |  1 -
 drivers/net/wireless/ath/ath11k/debugfs.c | 48 +++++++++++++++++++----
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index c20e84e031fad..bd06536f82a64 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -912,7 +912,6 @@ struct ath11k_base {
 	enum ath11k_dfs_region dfs_region;
 #ifdef CONFIG_ATH11K_DEBUGFS
 	struct dentry *debugfs_soc;
-	struct dentry *debugfs_ath11k;
 #endif
 	struct ath11k_soc_dp_stats soc_stats;
 
diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index ccdf3d5ba1ab6..5bb6fd17fdf6f 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -976,10 +976,6 @@ int ath11k_debugfs_pdev_create(struct ath11k_base *ab)
 	if (test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags))
 		return 0;
 
-	ab->debugfs_soc = debugfs_create_dir(ab->hw_params.name, ab->debugfs_ath11k);
-	if (IS_ERR(ab->debugfs_soc))
-		return PTR_ERR(ab->debugfs_soc);
-
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
 
@@ -1001,15 +997,51 @@ void ath11k_debugfs_pdev_destroy(struct ath11k_base *ab)
 
 int ath11k_debugfs_soc_create(struct ath11k_base *ab)
 {
-	ab->debugfs_ath11k = debugfs_create_dir("ath11k", NULL);
+	struct dentry *root;
+	bool dput_needed;
+	char name[64];
+	int ret;
+
+	root = debugfs_lookup("ath11k", NULL);
+	if (!root) {
+		root = debugfs_create_dir("ath11k", NULL);
+		if (IS_ERR_OR_NULL(root))
+			return PTR_ERR(root);
+
+		dput_needed = false;
+	} else {
+		/* a dentry from lookup() needs dput() after we don't use it */
+		dput_needed = true;
+	}
+
+	scnprintf(name, sizeof(name), "%s-%s", ath11k_bus_str(ab->hif.bus),
+		  dev_name(ab->dev));
+
+	ab->debugfs_soc = debugfs_create_dir(name, root);
+	if (IS_ERR_OR_NULL(ab->debugfs_soc)) {
+		ret = PTR_ERR(ab->debugfs_soc);
+		goto out;
+	}
+
+	ret = 0;
 
-	return PTR_ERR_OR_ZERO(ab->debugfs_ath11k);
+out:
+	if (dput_needed)
+		dput(root);
+
+	return ret;
 }
 
 void ath11k_debugfs_soc_destroy(struct ath11k_base *ab)
 {
-	debugfs_remove_recursive(ab->debugfs_ath11k);
-	ab->debugfs_ath11k = NULL;
+	debugfs_remove_recursive(ab->debugfs_soc);
+	ab->debugfs_soc = NULL;
+
+	/* We are not removing ath11k directory on purpose, even if it
+	 * would be empty. This simplifies the directory handling and it's
+	 * a minor cosmetic issue to leave an empty ath11k directory to
+	 * debugfs.
+	 */
 }
 EXPORT_SYMBOL(ath11k_debugfs_soc_destroy);
 
-- 
2.39.2



