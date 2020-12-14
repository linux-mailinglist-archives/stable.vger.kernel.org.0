Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60772D9EB3
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502379AbgLNRjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:39:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502354AbgLNRjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:00 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Will Deacon <will@kernel.org>, Andy Gross <agross@kernel.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Saravana Kannan <saravanak@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Lina Iyer <ilina@codeaurora.org>,
        iommu@lists.linux-foundation.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 057/105] arm-smmu-qcom: Ensure the qcom_scm driver has finished probing
Date:   Mon, 14 Dec 2020 18:28:31 +0100
Message-Id: <20201214172558.015053959@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

[ Upstream commit 72b55c96f3a5ae6e486c20b5dacf5114060ed042 ]

Robin Murphy pointed out that if the arm-smmu driver probes before
the qcom_scm driver, we may call qcom_scm_qsmmu500_wait_safe_toggle()
before the __scm is initialized.

Now, getting this to happen is a bit contrived, as in my efforts it
required enabling asynchronous probing for both drivers, moving the
firmware dts node to the end of the dtsi file, as well as forcing a
long delay in the qcom_scm_probe function.

With those tweaks we ran into the following crash:
[    2.631040] arm-smmu 15000000.iommu:         Stage-1: 48-bit VA -> 48-bit IPA
[    2.633372] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
...
[    2.633402] [0000000000000000] user address but active_mm is swapper
[    2.633409] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[    2.633415] Modules linked in:
[    2.633427] CPU: 5 PID: 117 Comm: kworker/u16:2 Tainted: G        W         5.10.0-rc1-mainline-00025-g272a618fc36-dirty #3971
[    2.633430] Hardware name: Thundercomm Dragonboard 845c (DT)
[    2.633448] Workqueue: events_unbound async_run_entry_fn
[    2.633456] pstate: 80c00005 (Nzcv daif +PAN +UAO -TCO BTYPE=--)
[    2.633465] pc : qcom_scm_qsmmu500_wait_safe_toggle+0x78/0xb0
[    2.633473] lr : qcom_smmu500_reset+0x58/0x78
[    2.633476] sp : ffffffc0105a3b60
...
[    2.633567] Call trace:
[    2.633572]  qcom_scm_qsmmu500_wait_safe_toggle+0x78/0xb0
[    2.633576]  qcom_smmu500_reset+0x58/0x78
[    2.633581]  arm_smmu_device_reset+0x194/0x270
[    2.633585]  arm_smmu_device_probe+0xc94/0xeb8
[    2.633592]  platform_drv_probe+0x58/0xa8
[    2.633597]  really_probe+0xec/0x398
[    2.633601]  driver_probe_device+0x5c/0xb8
[    2.633606]  __driver_attach_async_helper+0x64/0x88
[    2.633610]  async_run_entry_fn+0x4c/0x118
[    2.633617]  process_one_work+0x20c/0x4b0
[    2.633621]  worker_thread+0x48/0x460
[    2.633628]  kthread+0x14c/0x158
[    2.633634]  ret_from_fork+0x10/0x18
[    2.633642] Code: a9034fa0 d0007f73 29107fa0 91342273 (f9400020)

To avoid this, this patch adds a check on qcom_scm_is_available() in
the qcom_smmu_impl_init() function, returning -EPROBE_DEFER if its
not ready.

This allows the driver to try to probe again later after qcom_scm has
finished probing.

Reported-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Maulik Shah <mkshah@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Lina Iyer <ilina@codeaurora.org>
Cc: iommu@lists.linux-foundation.org
Cc: linux-arm-msm <linux-arm-msm@vger.kernel.org>
Link: https://lore.kernel.org/r/20201112220520.48159-1-john.stultz@linaro.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index be4318044f96c..702fbaa6c9ada 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -69,6 +69,10 @@ struct arm_smmu_device *qcom_smmu_impl_init(struct arm_smmu_device *smmu)
 {
 	struct qcom_smmu *qsmmu;
 
+	/* Check to make sure qcom_scm has finished probing */
+	if (!qcom_scm_is_available())
+		return ERR_PTR(-EPROBE_DEFER);
+
 	qsmmu = devm_kzalloc(smmu->dev, sizeof(*qsmmu), GFP_KERNEL);
 	if (!qsmmu)
 		return ERR_PTR(-ENOMEM);
-- 
2.27.0



