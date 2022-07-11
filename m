Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6069956FC4A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbiGKJl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbiGKJl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832AF90DB3;
        Mon, 11 Jul 2022 02:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AABD612E8;
        Mon, 11 Jul 2022 09:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC76FC34115;
        Mon, 11 Jul 2022 09:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531256;
        bh=veREzOZlBf95QLXM5VTk9WLdU/1eFzIUtrtNp0cu6sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umh5QyddX7m1rvIQXZUvcMa392QykRcbZexjh6tPuYE2Pu5j71yvyy8745s6NrDDS
         MI4ELhwoF1P9tLFeSu36DiMpbaNRflUkGsTkIBrvU0tTqhINiZKgtPaI1YdKzEmEhH
         a/qfKRY3bIwi5B5Tx0Wwuhkt8PoOkBw3fpyI7JtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Seevalamuthu Mariappan <quic_seevalam@quicinc.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/230] ath11k: add hw_param for wakeup_mhi
Date:   Mon, 11 Jul 2022 11:04:54 +0200
Message-Id: <20220711090605.164478217@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 7dcf6b13f794..48b4151e13a3 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -71,6 +71,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = false,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_ipq8074),
 		.fix_l1ss = true,
+		.wakeup_mhi = false,
 	},
 	{
 		.hw_rev = ATH11K_HW_IPQ6018_HW10,
@@ -112,6 +113,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = false,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_ipq8074),
 		.fix_l1ss = true,
+		.wakeup_mhi = false,
 	},
 	{
 		.name = "qca6390 hw2.0",
@@ -152,6 +154,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = true,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_ipq8074),
 		.fix_l1ss = true,
+		.wakeup_mhi = true,
 	},
 	{
 		.name = "qcn9074 hw1.0",
@@ -190,6 +193,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = false,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_qcn9074),
 		.fix_l1ss = true,
+		.wakeup_mhi = false,
 	},
 	{
 		.name = "wcn6855 hw2.0",
@@ -230,6 +234,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = true,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_wcn6855),
 		.fix_l1ss = false,
+		.wakeup_mhi = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 62f5978b3005..4fe051625edf 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -163,6 +163,7 @@ struct ath11k_hw_params {
 	bool supports_suspend;
 	u32 hal_desc_sz;
 	bool fix_l1ss;
+	bool wakeup_mhi;
 };
 
 struct ath11k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 353a2d669fcd..7d0be9388f89 100644
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
2.35.1



