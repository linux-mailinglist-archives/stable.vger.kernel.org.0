Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8592A4981C5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbiAXOH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiAXOH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:07:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF1DC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 06:07:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A13BA61316
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DC8C340E1;
        Mon, 24 Jan 2022 14:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643033277;
        bh=Ol4YZ0Aryj0pvy1R+sE0sfbwdzgADJ8ymqabyQu9i8g=;
        h=Subject:To:Cc:From:Date:From;
        b=LbgYt6iTYgf3/ChqvEQgnVAqYJgaChmLiukQcHsLjCozvxXpizujef0Z1UtTpTSZb
         HekAhi6e6N8z5asrDDQeC1XLy1fzJueXhni8vtTkMT6KFcWPHQGv4LWLS3MnexzFPr
         AUViPw7MNP55QSRM8LR5qd4/84coBQeDP56wh0xM=
Subject: FAILED: patch "[PATCH] ath11k: add support for WCN6855 hw2.1" failed to apply to 5.16-stable tree
To:     quic_bqiang@quicinc.com, quic_kvalo@quicinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 15:07:54 +0100
Message-ID: <164303327421446@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d1147a316b53df9cb0152e415ec41dcb6ea62c1c Mon Sep 17 00:00:00 2001
From: Baochen Qiang <quic_bqiang@quicinc.com>
Date: Mon, 29 Nov 2021 10:56:12 +0800
Subject: [PATCH] ath11k: add support for WCN6855 hw2.1

Ath11k fails to probe WCN6855 hw2.1 chip:

[ 6.983821] ath11k_pci 0000:06:00.0: enabling device (0000 -> 0002)
[ 6.983841] ath11k_pci 0000:06:00.0: Unsupported WCN6855 SOC hardware version: 18 17

This is caused by the wrong bit mask setting of hardware major version:
for QCA6390/QCN6855, it should be BIT8-11, not BIT8-16, so change the
definition to GENMASK(11, 8).

Also, add a separate entry for WCN6855 hw2.1 in ath11k_hw_params.

Please note that currently WCN6855 hw2.1 shares the same firmwares
as hw2.0, so users of this chip need to create a symlink as below:

	ln -s hw2.0 hw2.1

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1
Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1
Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Fixes: 18ac1665e785 ("ath11k: pci: check TCSR_SOC_HW_VERSION")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20211129025613.21594-1-quic_bqiang@quicinc.com

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index dd1a1bb078c3..5f6bdee26f31 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -284,6 +284,59 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 			.max_fft_bins = 0,
 		},
 
+		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
+					BIT(NL80211_IFTYPE_AP),
+		.supports_monitor = false,
+		.supports_shadow_regs = true,
+		.idle_ps = true,
+		.supports_sta_ps = true,
+		.cold_boot_calib = false,
+		.supports_suspend = true,
+		.hal_desc_sz = sizeof(struct hal_rx_desc_wcn6855),
+		.fix_l1ss = false,
+		.credit_flow = true,
+		.max_tx_ring = DP_TCL_NUM_RING_MAX_QCA6390,
+		.hal_params = &ath11k_hw_hal_params_qca6390,
+		.supports_dynamic_smps_6ghz = false,
+		.alloc_cacheable_memory = false,
+		.wakeup_mhi = true,
+	},
+	{
+		.name = "wcn6855 hw2.1",
+		.hw_rev = ATH11K_HW_WCN6855_HW21,
+		.fw = {
+			.dir = "WCN6855/hw2.1",
+			.board_size = 256 * 1024,
+			.cal_offset = 128 * 1024,
+		},
+		.max_radios = 3,
+		.bdf_addr = 0x4B0C0000,
+		.hw_ops = &wcn6855_ops,
+		.ring_mask = &ath11k_hw_ring_mask_qca6390,
+		.internal_sleep_clock = true,
+		.regs = &wcn6855_regs,
+		.qmi_service_ins_id = ATH11K_QMI_WLFW_SERVICE_INS_ID_V01_QCA6390,
+		.host_ce_config = ath11k_host_ce_config_qca6390,
+		.ce_count = 9,
+		.target_ce_config = ath11k_target_ce_config_wlan_qca6390,
+		.target_ce_count = 9,
+		.svc_to_ce_map = ath11k_target_service_to_ce_map_wlan_qca6390,
+		.svc_to_ce_map_len = 14,
+		.single_pdev_only = true,
+		.rxdma1_enable = false,
+		.num_rxmda_per_pdev = 2,
+		.rx_mac_buf_ring = true,
+		.vdev_start_delay = true,
+		.htt_peer_map_v2 = false,
+
+		.spectral = {
+			.fft_sz = 0,
+			.fft_pad_sz = 0,
+			.summary_pad_sz = 0,
+			.fft_hdr_len = 0,
+			.max_fft_bins = 0,
+		},
+
 		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					BIT(NL80211_IFTYPE_AP),
 		.supports_monitor = false,
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 0103cfd0508d..1d13e6124693 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -117,6 +117,7 @@ enum ath11k_hw_rev {
 	ATH11K_HW_IPQ6018_HW10,
 	ATH11K_HW_QCN9074_HW10,
 	ATH11K_HW_WCN6855_HW20,
+	ATH11K_HW_WCN6855_HW21,
 };
 
 enum ath11k_firmware_mode {
diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index d0f94a785a59..9a8e61ca9964 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -366,6 +366,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 		break;
 	case ATH11K_HW_QCA6390_HW20:
 	case ATH11K_HW_WCN6855_HW20:
+	case ATH11K_HW_WCN6855_HW21:
 		ath11k_mhi_config = &ath11k_mhi_config_qca6390;
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 1898b1a33960..0a2b2ba4ae07 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -26,7 +26,7 @@
 #define WINDOW_RANGE_MASK		GENMASK(18, 0)
 
 #define TCSR_SOC_HW_VERSION		0x0224
-#define TCSR_SOC_HW_VERSION_MAJOR_MASK	GENMASK(16, 8)
+#define TCSR_SOC_HW_VERSION_MAJOR_MASK	GENMASK(11, 8)
 #define TCSR_SOC_HW_VERSION_MINOR_MASK	GENMASK(7, 0)
 
 /* BAR0 + 4k is always accessible, and no
@@ -1409,9 +1409,21 @@ static int ath11k_pci_probe(struct pci_dev *pdev,
 					   &soc_hw_version_minor);
 		switch (soc_hw_version_major) {
 		case 2:
-			ab->hw_rev = ATH11K_HW_WCN6855_HW20;
+			switch (soc_hw_version_minor) {
+			case 0x00:
+			case 0x01:
+				ab->hw_rev = ATH11K_HW_WCN6855_HW20;
+				break;
+			case 0x10:
+			case 0x11:
+				ab->hw_rev = ATH11K_HW_WCN6855_HW21;
+				break;
+			default:
+				goto unsupported_wcn6855_soc;
+			}
 			break;
 		default:
+unsupported_wcn6855_soc:
 			dev_err(&pdev->dev, "Unsupported WCN6855 SOC hardware version: %d %d\n",
 				soc_hw_version_major, soc_hw_version_minor);
 			ret = -EOPNOTSUPP;

