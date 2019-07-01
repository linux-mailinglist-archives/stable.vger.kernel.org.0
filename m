Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95D62F5BB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfE3DLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfE3DLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:08 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0523124476;
        Thu, 30 May 2019 03:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185867;
        bh=eh6h31HQ7VhWfJe/YCSWiRRtJiJ7KBMSnVVSP8weWXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0yigU2cyWm8G/da5ZtkJNlYHXMmtqQuRt7BoW8bAGPMzXGiSJgEZfOMAgmFoeV0rW
         YP4AJRg9rXXb5ixgA9h2HHhm3dyVX8u/apCyyGOKYsxrvP1/T/96OeXPptDvtdzlmg
         QbHdVvRdTKKTpzgX8dQvBtfsrjuZ0j6/e0W/6s8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 189/405] ACPI/IORT: Reject platform device creation on NUMA node mapping failure
Date:   Wed, 29 May 2019 20:03:07 -0700
Message-Id: <20190530030550.586483052@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 36a2ba07757df790b4a874efb1a105b9330a9ae7 ]

In a system where, through IORT firmware mappings, the SMMU device is
mapped to a NUMA node that is not online, the kernel bootstrap results
in the following crash:

  Unable to handle kernel paging request at virtual address 0000000000001388
  Mem abort info:
    ESR = 0x96000004
    Exception class = DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
  Data abort info:
    ISV = 0, ISS = 0x00000004
    CM = 0, WnR = 0
  [0000000000001388] user address but active_mm is swapper
  Internal error: Oops: 96000004 [#1] SMP
  Modules linked in:
  CPU: 5 PID: 1 Comm: swapper/0 Not tainted 5.0.0 #15
  pstate: 80c00009 (Nzcv daif +PAN +UAO)
  pc : __alloc_pages_nodemask+0x13c/0x1068
  lr : __alloc_pages_nodemask+0xdc/0x1068
  ...
  Process swapper/0 (pid: 1, stack limit = 0x(____ptrval____))
  Call trace:
   __alloc_pages_nodemask+0x13c/0x1068
   new_slab+0xec/0x570
   ___slab_alloc+0x3e0/0x4f8
   __slab_alloc+0x60/0x80
   __kmalloc_node_track_caller+0x10c/0x478
   devm_kmalloc+0x44/0xb0
   pinctrl_bind_pins+0x4c/0x188
   really_probe+0x78/0x2b8
   driver_probe_device+0x64/0x110
   device_driver_attach+0x74/0x98
   __driver_attach+0x9c/0xe8
   bus_for_each_dev+0x84/0xd8
   driver_attach+0x30/0x40
   bus_add_driver+0x170/0x218
   driver_register+0x64/0x118
   __platform_driver_register+0x54/0x60
   arm_smmu_driver_init+0x24/0x2c
   do_one_initcall+0xbc/0x328
   kernel_init_freeable+0x304/0x3ac
   kernel_init+0x18/0x110
   ret_from_fork+0x10/0x1c
  Code: f90013b5 b9410fa1 1a9f0694 b50014c2 (b9400804)
  ---[ end trace dfeaed4c373a32da ]--

Change the dev_set_proximity() hook prototype so that it returns a
value and make it return failure if the PXM->NUMA-node mapping
corresponds to an offline node, fixing the crash.

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Link: https://lore.kernel.org/linux-arm-kernel/20190315021940.86905-1-wangkefeng.wang@huawei.com/
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/iort.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index e48894e002ba8..a46c2c162c03e 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1232,18 +1232,24 @@ static bool __init arm_smmu_v3_is_coherent(struct acpi_iort_node *node)
 /*
  * set numa proximity domain for smmuv3 device
  */
-static void  __init arm_smmu_v3_set_proximity(struct device *dev,
+static int  __init arm_smmu_v3_set_proximity(struct device *dev,
 					      struct acpi_iort_node *node)
 {
 	struct acpi_iort_smmu_v3 *smmu;
 
 	smmu = (struct acpi_iort_smmu_v3 *)node->node_data;
 	if (smmu->flags & ACPI_IORT_SMMU_V3_PXM_VALID) {
-		set_dev_node(dev, acpi_map_pxm_to_node(smmu->pxm));
+		int node = acpi_map_pxm_to_node(smmu->pxm);
+
+		if (node != NUMA_NO_NODE && !node_online(node))
+			return -EINVAL;
+
+		set_dev_node(dev, node);
 		pr_info("SMMU-v3[%llx] Mapped to Proximity domain %d\n",
 			smmu->base_address,
 			smmu->pxm);
 	}
+	return 0;
 }
 #else
 #define arm_smmu_v3_set_proximity NULL
@@ -1318,7 +1324,7 @@ struct iort_dev_config {
 	int (*dev_count_resources)(struct acpi_iort_node *node);
 	void (*dev_init_resources)(struct resource *res,
 				     struct acpi_iort_node *node);
-	void (*dev_set_proximity)(struct device *dev,
+	int (*dev_set_proximity)(struct device *dev,
 				    struct acpi_iort_node *node);
 };
 
@@ -1369,8 +1375,11 @@ static int __init iort_add_platform_device(struct acpi_iort_node *node,
 	if (!pdev)
 		return -ENOMEM;
 
-	if (ops->dev_set_proximity)
-		ops->dev_set_proximity(&pdev->dev, node);
+	if (ops->dev_set_proximity) {
+		ret = ops->dev_set_proximity(&pdev->dev, node);
+		if (ret)
+			goto dev_put;
+	}
 
 	count = ops->dev_count_resources(node);
 
-- 
2.20.1



