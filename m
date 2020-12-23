Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C239C2E16C7
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgLWDCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728716AbgLWCTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 785AF225AB;
        Wed, 23 Dec 2020 02:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689948;
        bh=PtJXlG+7otVt3v+1uuqmlPy/lhsqk23d0pMQ5jDpIjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/UwJOPgC+gHV3LGv3b2Yy8iyDKyeSVOkUsoMp1xf8r8ffAw+wJvfwiDMNgQpCf0+
         e4I9ojo5trxEUMZFCkB4l3T95ucVXLj5zMB0TY670Z/Tj6tbNUjhtGN3Ut7rIthCud
         i2aq+mAIYAXYECaPepM28+QYgFJpNltYpLyCVmrMikVqsR6lmhFE02TTLDw9mOUZoh
         oLyQqg2jiX5pH5VIWb4c9VWYRZXmFgpInweycYM1AC8lVAOKzV/iPD/RmHPbAn4vEl
         CdA27Zt50LueR4q4zAjy1qpAVmXBTcmUeU0v0vQnlKpiicdzI17YluYgoWpHbBzV9b
         KxNTD46MOaPDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 042/130] media: venus: handle use after free for iommu_map/iommu_unmap
Date:   Tue, 22 Dec 2020 21:16:45 -0500
Message-Id: <20201223021813.2791612-42-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit de15e6231e6a3ca58d58d7e2c614a76c940dbb38 ]

In concurrency usecase and reboot scenario we are seeing muliple
crashes related to iommu_map/iommu_unamp of core->fw.iommu_domain.

In one case we are seeing "Unable to handle kernel NULL pointer
dereference at virtual address 0000000000000008" crash, this is
because of core->fw.iommu_domain in venus_firmware_deinit() and
trying to map in venus_boot() during venus_sys_error_handler()

Call trace:
 __iommu_map+0x4c/0x348
 iommu_map+0x5c/0x70
 venus_boot+0x184/0x230 [venus_core]
 venus_sys_error_handler+0xa0/0x14c [venus_core]
 process_one_work+0x210/0x3d0
 worker_thread+0x248/0x3f4
 kthread+0x11c/0x12c
 ret_from_fork+0x10/0x18

In second case we are seeing "Unable to handle kernel paging request
at virtual address 006b6b6b6b6b6b9b" crash, this is because of
unmapping iommu domain which is already unmapped.

Call trace:
 venus_remove+0xf8/0x108 [venus_core]
 venus_core_shutdown+0x1c/0x34 [venus_core]
 platform_drv_shutdown+0x28/0x34
 device_shutdown+0x154/0x1fc
 kernel_restart_prepare+0x40/0x4c
 kernel_restart+0x1c/0x64
 __arm64_sys_reboot+0x190/0x238
 el0_svc_common+0xa4/0x154
 el0_svc_compat_handler+0x2c/0x38
 el0_svc_compat+0x8/0x10

Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/firmware.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 33f70e1def943..9a9c0979e7bbb 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -172,9 +172,14 @@ static int venus_shutdown_no_tz(struct venus_core *core)
 
 	iommu = core->fw.iommu_domain;
 
-	unmapped = iommu_unmap(iommu, VENUS_FW_START_ADDR, mapped);
-	if (unmapped != mapped)
-		dev_err(dev, "failed to unmap firmware\n");
+	if (core->fw.mapped_mem_size && iommu) {
+		unmapped = iommu_unmap(iommu, VENUS_FW_START_ADDR, mapped);
+
+		if (unmapped != mapped)
+			dev_err(dev, "failed to unmap firmware\n");
+		else
+			core->fw.mapped_mem_size = 0;
+	}
 
 	return 0;
 }
@@ -289,7 +294,11 @@ void venus_firmware_deinit(struct venus_core *core)
 	iommu = core->fw.iommu_domain;
 
 	iommu_detach_device(iommu, core->fw.dev);
-	iommu_domain_free(iommu);
+
+	if (core->fw.iommu_domain) {
+		iommu_domain_free(iommu);
+		core->fw.iommu_domain = NULL;
+	}
 
 	platform_device_unregister(to_platform_device(core->fw.dev));
 }
-- 
2.27.0

