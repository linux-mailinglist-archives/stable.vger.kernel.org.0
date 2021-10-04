Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F836420F22
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhJDNbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234860AbhJDN3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:29:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 147A4630EE;
        Mon,  4 Oct 2021 13:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353197;
        bh=qZ75XWmRJHr60jyHiriNAaXxKD+Lg009yY198zFv4T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or/cnmOl0iyxETsMHukiic1AsFlkOcq3XFAh9xX3BW0cAoz0Fxs/Du03fjdErh9FC
         gZ78xRyvYFDwvIxk49bAbtxaW0/STKRwLEF7YVRN7n2aBz3Gtqf/PfIjYcH5QqXh/r
         PCyqZv08qZYVIuyn1EuKSv1/dN85st0C4TWnOLMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 034/172] scsi: ufs: ufs-pci: Fix Intel LKF link stability
Date:   Mon,  4 Oct 2021 14:51:24 +0200
Message-Id: <20211004125046.076308113@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 1cbc9ad3eecd492be33b727b4606ae75bc880676 upstream.

Intel LKF can experience link errors. Make fixes to increase link
stability, especially when switching to high speed modes.

Link: https://lore.kernel.org/r/20210831145317.26306-1-adrian.hunter@intel.com
Fixes: b2c57925df1f ("scsi: ufs: ufs-pci: Add support for Intel LKF")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pci.c | 78 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c     |  3 +-
 drivers/scsi/ufs/ufshcd.h     |  1 +
 3 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index e6c334bfb4c2..40acca04d03b 100644
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
index 3a204324151a..bfc13f646d7b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4767,7 +4767,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	mutex_lock(&hba->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
-					       NOP_OUT_TIMEOUT);
+					  hba->nop_out_timeout);
 
 		if (!err || err == -ETIMEDOUT)
 			break;
@@ -9403,6 +9403,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->dev = dev;
 	*hba_handle = hba;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
+	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
 
 	INIT_LIST_HEAD(&hba->clk_list_head);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 86d4765a17b8..aa95deffb873 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -814,6 +814,7 @@ struct ufs_hba {
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
 	ktime_t last_dme_cmd_tstamp;
+	int nop_out_timeout;
 
 	/* Keeps information of the UFS device connected to this host */
 	struct ufs_dev_info dev_info;
-- 
2.33.0



