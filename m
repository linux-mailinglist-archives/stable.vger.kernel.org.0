Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFEA4FD9A1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355752AbiDLH3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353704AbiDLHP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:15:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28D53BA7C;
        Mon, 11 Apr 2022 23:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEDDC61589;
        Tue, 12 Apr 2022 06:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0F8C385A6;
        Tue, 12 Apr 2022 06:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746638;
        bh=pju8H28xBBewxX0CjRzuhP4p7Dhhb2oKAr+nf7duDtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGYlwoZSLD7tp0d1OP1wXrZEOrakJUCIJt1YcbUsEn09b3PgIf1IaEmrPq72O/Hxa
         iOMXL0Xb1zBT40t8FaJS5sxUVXQrkyuJVnzYDjfWTY8RgqHkKyWTlhjobzFtqBTfFh
         xkxgWH1jS7LIfyk5kQhuKr6RbdiAOE81kyaJlHT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 027/285] ath11k: pci: fix crash on suspend if board file is not found
Date:   Tue, 12 Apr 2022 08:28:04 +0200
Message-Id: <20220412062944.462216527@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalle Valo <quic_kvalo@quicinc.com>

[ Upstream commit b4f4c56459a5c744f7f066b9fc2b54ea995030c5 ]

Mario reported that the kernel was crashing on suspend if ath11k was not able
to find a board file:

[  473.693286] PM: Suspending system (s2idle)
[  473.693291] printk: Suspending console(s) (use no_console_suspend to debug)
[  474.407787] BUG: unable to handle page fault for address: 0000000000002070
[  474.407791] #PF: supervisor read access in kernel mode
[  474.407794] #PF: error_code(0x0000) - not-present page
[  474.407798] PGD 0 P4D 0
[  474.407801] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  474.407805] CPU: 2 PID: 2350 Comm: kworker/u32:14 Tainted: G        W         5.16.0 #248
[...]
[  474.407868] Call Trace:
[  474.407870]  <TASK>
[  474.407874]  ? _raw_spin_lock_irqsave+0x2a/0x60
[  474.407882]  ? lock_timer_base+0x72/0xa0
[  474.407889]  ? _raw_spin_unlock_irqrestore+0x29/0x3d
[  474.407892]  ? try_to_del_timer_sync+0x54/0x80
[  474.407896]  ath11k_dp_rx_pktlog_stop+0x49/0xc0 [ath11k]
[  474.407912]  ath11k_core_suspend+0x34/0x130 [ath11k]
[  474.407923]  ath11k_pci_pm_suspend+0x1b/0x50 [ath11k_pci]
[  474.407928]  pci_pm_suspend+0x7e/0x170
[  474.407935]  ? pci_pm_freeze+0xc0/0xc0
[  474.407939]  dpm_run_callback+0x4e/0x150
[  474.407947]  __device_suspend+0x148/0x4c0
[  474.407951]  async_suspend+0x20/0x90
dmesg-efi-164255130401001:
Oops#1 Part1
[  474.407955]  async_run_entry_fn+0x33/0x120
[  474.407959]  process_one_work+0x220/0x3f0
[  474.407966]  worker_thread+0x4a/0x3d0
[  474.407971]  kthread+0x17a/0x1a0
[  474.407975]  ? process_one_work+0x3f0/0x3f0
[  474.407979]  ? set_kthread_struct+0x40/0x40
[  474.407983]  ret_from_fork+0x22/0x30
[  474.407991]  </TASK>

The issue here is that board file loading happens after ath11k_pci_probe()
succesfully returns (ath11k initialisation happends asynchronously) and the
suspend handler is still enabled, of course failing as ath11k is not properly
initialised. Fix this by checking ATH11K_FLAG_QMI_FAIL during both suspend and
resume.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03003-QCAHSPSWPL_V1_V2_SILICONZ_LITE-2

Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215504
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220127090117.2024-1-kvalo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 4c348bacf2cb..754578f3dcf1 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1419,6 +1419,11 @@ static __maybe_unused int ath11k_pci_pm_suspend(struct device *dev)
 	struct ath11k_base *ab = dev_get_drvdata(dev);
 	int ret;
 
+	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+		ath11k_dbg(ab, ATH11K_DBG_BOOT, "boot skipping pci suspend as qmi is not initialised\n");
+		return 0;
+	}
+
 	ret = ath11k_core_suspend(ab);
 	if (ret)
 		ath11k_warn(ab, "failed to suspend core: %d\n", ret);
@@ -1431,6 +1436,11 @@ static __maybe_unused int ath11k_pci_pm_resume(struct device *dev)
 	struct ath11k_base *ab = dev_get_drvdata(dev);
 	int ret;
 
+	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+		ath11k_dbg(ab, ATH11K_DBG_BOOT, "boot skipping pci resume as qmi is not initialised\n");
+		return 0;
+	}
+
 	ret = ath11k_core_resume(ab);
 	if (ret)
 		ath11k_warn(ab, "failed to resume core: %d\n", ret);
-- 
2.35.1



