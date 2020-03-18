Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6372218A5F6
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgCRUzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbgCRUzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84781208FE;
        Wed, 18 Mar 2020 20:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564907;
        bh=KhXKLg0E5X3GQoOjUX4QuxQP+ZL5Xk6biSK6CjgOnCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/1xrewfFrG+xnILRqx7wvjB0LWv7rxJRChThxtLe16tjQH6i+Y9GXxDgn6oJr5aL
         Mn7MXA4FD1/JsznKyd3sfVdfNt3d0eTArDHfzSGiayAv4zXnKlKacNuhzaBzsoc/Fw
         Hda6Lw7mQQcuQGVoVf++Pttts8DcWWfWa1E+OiwA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Megha Dey <megha.dey@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 73/73] iommu/vt-d: Populate debugfs if IOMMUs are detected
Date:   Wed, 18 Mar 2020 16:53:37 -0400
Message-Id: <20200318205337.16279-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

[ Upstream commit 1da8347d8505c137fb07ff06bbcd3f2bf37409bc ]

Currently, the intel iommu debugfs directory(/sys/kernel/debug/iommu/intel)
gets populated only when DMA remapping is enabled (dmar_disabled = 0)
irrespective of whether interrupt remapping is enabled or not.

Instead, populate the intel iommu debugfs directory if any IOMMUs are
detected.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: ee2636b8670b1 ("iommu/vt-d: Enable base Intel IOMMU debugfs support")
Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu-debugfs.c | 11 ++++++++++-
 drivers/iommu/intel-iommu.c         |  4 +++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu-debugfs.c b/drivers/iommu/intel-iommu-debugfs.c
index 80378c10dd77a..bdf095e9dbe03 100644
--- a/drivers/iommu/intel-iommu-debugfs.c
+++ b/drivers/iommu/intel-iommu-debugfs.c
@@ -281,9 +281,16 @@ static int dmar_translation_struct_show(struct seq_file *m, void *unused)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
+	u32 sts;
 
 	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
+		sts = dmar_readl(iommu->reg + DMAR_GSTS_REG);
+		if (!(sts & DMA_GSTS_TES)) {
+			seq_printf(m, "DMA Remapping is not enabled on %s\n",
+				   iommu->name);
+			continue;
+		}
 		root_tbl_walk(m, iommu);
 		seq_putc(m, '\n');
 	}
@@ -353,6 +360,7 @@ static int ir_translation_struct_show(struct seq_file *m, void *unused)
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
 	u64 irta;
+	u32 sts;
 
 	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
@@ -362,7 +370,8 @@ static int ir_translation_struct_show(struct seq_file *m, void *unused)
 		seq_printf(m, "Remapped Interrupt supported on IOMMU: %s\n",
 			   iommu->name);
 
-		if (iommu->ir_table) {
+		sts = dmar_readl(iommu->reg + DMAR_GSTS_REG);
+		if (iommu->ir_table && (sts & DMA_GSTS_IRES)) {
 			irta = virt_to_phys(iommu->ir_table->base);
 			seq_printf(m, " IR table address:%llx\n", irta);
 			ir_tbl_remap_entry_show(m, iommu);
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index be39363244389..ef38e98b5bceb 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4961,6 +4961,9 @@ int __init intel_iommu_init(void)
 
 	down_write(&dmar_global_lock);
 
+	if (!no_iommu)
+		intel_iommu_debugfs_init();
+
 	if (no_iommu || dmar_disabled) {
 		/*
 		 * We exit the function here to ensure IOMMU's remapping and
@@ -5056,7 +5059,6 @@ int __init intel_iommu_init(void)
 	pr_info("Intel(R) Virtualization Technology for Directed I/O\n");
 
 	intel_iommu_enabled = 1;
-	intel_iommu_debugfs_init();
 
 	return 0;
 
-- 
2.20.1

