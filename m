Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E784188FC
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 15:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhIZNMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 09:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231673AbhIZNMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 09:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E7FE61019;
        Sun, 26 Sep 2021 13:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632661842;
        bh=09WcvrCoer06qp4mLfXfK4/d/Q+volkfFcNoJoNpIfM=;
        h=Subject:To:Cc:From:Date:From;
        b=n9QHm7a8fW51fQrbFLnZGH8UAhL3B92yD1SrefvKGUz7urWM6HR8MTRkAQ0uZSYZr
         v4HT9pGRQmFNSrC396wT5+0spoXFKT80rRtVAjLj4a2wM0xzpmD3o3fH/s4yuGX6Vx
         U+gEXNJ+cmZxb7iadh5kJvcJM3GcMj0bZ2h31i6o=
Subject: FAILED: patch "[PATCH] scsi: ufs: ufs-pci: Fix Intel LKF link stability" failed to apply to 5.14-stable tree
To:     adrian.hunter@intel.com, martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 15:10:40 +0200
Message-ID: <163266184010660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1cbc9ad3eecd492be33b727b4606ae75bc880676 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Tue, 31 Aug 2021 17:53:17 +0300
Subject: [PATCH] scsi: ufs: ufs-pci: Fix Intel LKF link stability

Intel LKF can experience link errors. Make fixes to increase link
stability, especially when switching to high speed modes.

Link: https://lore.kernel.org/r/20210831145317.26306-1-adrian.hunter@intel.com
Fixes: b2c57925df1f ("scsi: ufs: ufs-pci: Add support for Intel LKF")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index b3bcc5c882da..149c1aa09103 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -128,6 +128,81 @@ static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_intel_set_lanes(struct ufs_hba *hba, u32 lanes)
+{
+	struct ufs_pa_layer_attr pwr_info = hba->pwr_info;
+	int ret;
+
+	pwr_info.lane_rx = lanes;
+	pwr_info.lane_tx = lanes;
+	ret = ufshcd_config_pwr_mode(hba, &pwr_info);
+	if (ret)
+		dev_err(hba->dev, "%s: Setting %u lanes, err = %d\n",
+			__func__, lanes, ret);
+	return ret;
+}
+
+static int ufs_intel_lkf_pwr_change_notify(struct ufs_hba *hba,
+				enum ufs_notify_change_status status,
+				struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
+{
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		if (ufshcd_is_hs_mode(dev_max_params) &&
+		    (hba->pwr_info.lane_rx != 2 || hba->pwr_info.lane_tx != 2))
+			ufs_intel_set_lanes(hba, 2);
+		memcpy(dev_req_params, dev_max_params, sizeof(*dev_req_params));
+		break;
+	case POST_CHANGE:
+		if (ufshcd_is_hs_mode(dev_req_params)) {
+			u32 peer_granularity;
+
+			usleep_range(1000, 1250);
+			err = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_GRANULARITY),
+						  &peer_granularity);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
+{
+	u32 granularity, peer_granularity;
+	u32 pa_tactivate, peer_pa_tactivate;
+	int ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_GRANULARITY), &granularity);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_GRANULARITY), &peer_granularity);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_TACTIVATE), &pa_tactivate);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_TACTIVATE), &peer_pa_tactivate);
+	if (ret)
+		goto out;
+
+	if (granularity == peer_granularity) {
+		u32 new_peer_pa_tactivate = pa_tactivate + 2;
+
+		ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(PA_TACTIVATE), new_peer_pa_tactivate);
+	}
+out:
+	return ret;
+}
+
 #define INTEL_ACTIVELTR		0x804
 #define INTEL_IDLELTR		0x808
 
@@ -351,6 +426,7 @@ static int ufs_intel_lkf_init(struct ufs_hba *hba)
 	struct ufs_host *ufs_host;
 	int err;
 
+	hba->nop_out_timeout = 200;
 	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
 	hba->caps |= UFSHCD_CAP_CRYPTO;
 	err = ufs_intel_common_init(hba);
@@ -381,6 +457,8 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.pwr_change_notify	= ufs_intel_lkf_pwr_change_notify,
+	.apply_dev_quirks	= ufs_intel_lkf_apply_dev_quirks,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
 };
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..67889d74761c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4776,7 +4776,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	mutex_lock(&hba->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
-					       NOP_OUT_TIMEOUT);
+					  hba->nop_out_timeout);
 
 		if (!err || err == -ETIMEDOUT)
 			break;
@@ -9483,6 +9483,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->host = host;
 	hba->dev = dev;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
+	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
 	INIT_LIST_HEAD(&hba->clk_list_head);
 	spin_lock_init(&hba->outstanding_lock);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 52ea6f350b18..4723f27a55d1 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -858,6 +858,7 @@ struct ufs_hba {
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
 	ktime_t last_dme_cmd_tstamp;
+	int nop_out_timeout;
 
 	/* Keeps information of the UFS device connected to this host */
 	struct ufs_dev_info dev_info;

