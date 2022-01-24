Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6125649968A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445732AbiAXVEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51218 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444219AbiAXVAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:00:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCC4960B03;
        Mon, 24 Jan 2022 21:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A88C340E5;
        Mon, 24 Jan 2022 21:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058021;
        bh=zG9/q/7DBS3gFy3qP4yp2B1jug0PJjs6Zr51MkeY0PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qssL+0VgvgNl4CklRdHsY2FeEncA15MyeWJixHUTIdzIorEftXMFBeOfizJKKY+vp
         4zdIIunC86JT1FLDUIcdWQPsLDGb/pKor9wdrtkx+f8OI58eu+X4lHtr54ElerZtiX
         2qwDH7/qJ2vwkhksnLgKNflKlXi0W8BPrNKqkCeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Seevalamuthu Mariappan <quic_seevalam@quicinc.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0154/1039] ath11k: add hw_param for wakeup_mhi
Date:   Mon, 24 Jan 2022 19:32:23 +0100
Message-Id: <20220124184130.335105573@linuxfoundation.org>
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

From: Seevalamuthu Mariappan <quic_seevalam@quicinc.com>

[ Upstream commit 081e2d6476e30399433b509684d5da4d1844e430 ]

Wakeup mhi is needed before pci_read/write only for QCA6390 and WCN6855. Since
wakeup & release mhi is enabled for all hardwares, below mhi assert is seen in
QCN9074 when doing 'rmmod ath11k_pci':

	Kernel panic - not syncing: dev_wake != 0
	CPU: 2 PID: 13535 Comm: procd Not tainted 4.4.60 #1
	Hardware name: Generic DT based system
	[<80316dac>] (unwind_backtrace) from [<80313700>] (show_stack+0x10/0x14)
	[<80313700>] (show_stack) from [<805135dc>] (dump_stack+0x7c/0x9c)
	[<805135dc>] (dump_stack) from [<8032136c>] (panic+0x84/0x1f8)
	[<8032136c>] (panic) from [<80549b24>] (mhi_pm_disable_transition+0x3b8/0x5b8)
	[<80549b24>] (mhi_pm_disable_transition) from [<80549ddc>] (mhi_power_down+0xb8/0x100)
	[<80549ddc>] (mhi_power_down) from [<7f5242b0>] (ath11k_mhi_op_status_cb+0x284/0x3ac [ath11k_pci])
	[E][__mhi_device_get_sync] Did not enter M0 state, cur_state:RESET pm_state:SHUTDOWN Process
	[E][__mhi_device_get_sync] Did not enter M0 state, cur_state:RESET pm_state:SHUTDOWN Process
	[E][__mhi_device_get_sync] Did not enter M0 state, cur_state:RESET pm_state:SHUTDOWN Process
	[<7f5242b0>] (ath11k_mhi_op_status_cb [ath11k_pci]) from [<7f524878>] (ath11k_mhi_stop+0x10/0x20 [ath11k_pci])
	[<7f524878>] (ath11k_mhi_stop [ath11k_pci]) from [<7f525b94>] (ath11k_pci_power_down+0x54/0x90 [ath11k_pci])
	[<7f525b94>] (ath11k_pci_power_down [ath11k_pci]) from [<8056b2a8>] (pci_device_shutdown+0x30/0x44)
	[<8056b2a8>] (pci_device_shutdown) from [<805cfa0c>] (device_shutdown+0x124/0x174)
	[<805cfa0c>] (device_shutdown) from [<8033aaa4>] (kernel_restart+0xc/0x50)
	[<8033aaa4>] (kernel_restart) from [<8033ada8>] (SyS_reboot+0x178/0x1ec)
	[<8033ada8>] (SyS_reboot) from [<80301b80>] (ret_fast_syscall+0x0/0x34)

Hence, disable wakeup/release mhi using hw_param for other hardwares.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01060-QCAHKSWPL_SILICONZ-1

Fixes: a05bd8513335 ("ath11k: read and write registers below unwindowed address")
Signed-off-by: Seevalamuthu Mariappan <quic_seevalam@quicinc.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1636702019-26142-1-git-send-email-quic_seevalam@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c |  5 +++++
 drivers/net/wireless/ath/ath11k/hw.h   |  1 +
 drivers/net/wireless/ath/ath11k/pci.c  | 12 ++++++++----
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 280f1c6411aeb..638dc97669df2 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -84,6 +84,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
 		.supports_dynamic_smps_6ghz = false,
 		.alloc_cacheable_memory = true,
+		.wakeup_mhi = false,
 	},
 	{
 		.hw_rev = ATH11K_HW_IPQ6018_HW10,
@@ -135,6 +136,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
 		.supports_dynamic_smps_6ghz = false,
 		.alloc_cacheable_memory = true,
+		.wakeup_mhi = false,
 	},
 	{
 		.name = "qca6390 hw2.0",
@@ -185,6 +187,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.hal_params = &ath11k_hw_hal_params_qca6390,
 		.supports_dynamic_smps_6ghz = false,
 		.alloc_cacheable_memory = false,
+		.wakeup_mhi = true,
 	},
 	{
 		.name = "qcn9074 hw1.0",
@@ -235,6 +238,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
 		.supports_dynamic_smps_6ghz = true,
 		.alloc_cacheable_memory = true,
+		.wakeup_mhi = false,
 	},
 	{
 		.name = "wcn6855 hw2.0",
@@ -285,6 +289,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.hal_params = &ath11k_hw_hal_params_qca6390,
 		.supports_dynamic_smps_6ghz = false,
 		.alloc_cacheable_memory = false,
+		.wakeup_mhi = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index de9e9546f2ec6..aa93f0619f936 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -178,6 +178,7 @@ struct ath11k_hw_params {
 	const struct ath11k_hw_hal_params *hal_params;
 	bool supports_dynamic_smps_6ghz;
 	bool alloc_cacheable_memory;
+	bool wakeup_mhi;
 };
 
 struct ath11k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 3d353e7c9d5c2..fadded5ef84b2 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -182,7 +182,8 @@ void ath11k_pci_write32(struct ath11k_base *ab, u32 offset, u32 value)
 	/* for offset beyond BAR + 4K - 32, may
 	 * need to wakeup MHI to access.
 	 */
-	if (test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
+	if (ab->hw_params.wakeup_mhi &&
+	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
 		mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
 
@@ -206,7 +207,8 @@ void ath11k_pci_write32(struct ath11k_base *ab, u32 offset, u32 value)
 		}
 	}
 
-	if (test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
+	if (ab->hw_params.wakeup_mhi &&
+	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
 		mhi_device_put(ab_pci->mhi_ctrl->mhi_dev);
 }
@@ -219,7 +221,8 @@ u32 ath11k_pci_read32(struct ath11k_base *ab, u32 offset)
 	/* for offset beyond BAR + 4K - 32, may
 	 * need to wakeup MHI to access.
 	 */
-	if (test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
+	if (ab->hw_params.wakeup_mhi &&
+	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
 		mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
 
@@ -243,7 +246,8 @@ u32 ath11k_pci_read32(struct ath11k_base *ab, u32 offset)
 		}
 	}
 
-	if (test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
+	if (ab->hw_params.wakeup_mhi &&
+	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
 		mhi_device_put(ab_pci->mhi_ctrl->mhi_dev);
 
-- 
2.34.1



