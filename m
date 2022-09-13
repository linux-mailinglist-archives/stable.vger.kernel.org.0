Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E095B713D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiIMOmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiIMOle (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:41:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4EA6CF7F;
        Tue, 13 Sep 2022 07:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C39CB80FA0;
        Tue, 13 Sep 2022 14:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FE4C433D7;
        Tue, 13 Sep 2022 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078537;
        bh=5xW9K4lgNx1ZoGh7DfLEWCB95jRLepwiG5mVzvMe5So=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00qXHvi9Sak7l5cC7PdZlVTXukhHg9y+s/MiOBqhBRC9gDXJPCRTGeC8RzsTKK8sR
         KP91hIQkxhuq2kpxWbJK1IxUFKL1MuSih1EoFNpwVbv2ED5LJPVSQsocSWNNpMaJ8L
         YGKhoXOuSaE0jUeaYxibpycYRGCM5xzmAPok5obE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 178/192] iommu/vt-d: Fix possible recursive locking in intel_iommu_init()
Date:   Tue, 13 Sep 2022 16:04:44 +0200
Message-Id: <20220913140418.914135026@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 9cd4f1434479f1ac25c440c421fbf52069079914 ]

The global rwsem dmar_global_lock was introduced by commit 3a5670e8ac932
("iommu/vt-d: Introduce a rwsem to protect global data structures"). It
is used to protect DMAR related global data from DMAR hotplug operations.

The dmar_global_lock used in the intel_iommu_init() might cause recursive
locking issue, for example, intel_iommu_get_resv_regions() is taking the
dmar_global_lock from within a section where intel_iommu_init() already
holds it via probe_acpi_namespace_devices().

Using dmar_global_lock in intel_iommu_init() could be relaxed since it is
unlikely that any IO board must be hot added before the IOMMU subsystem is
initialized. This eliminates the possible recursive locking issue by moving
down DMAR hotplug support after the IOMMU is initialized and removing the
uses of dmar_global_lock in intel_iommu_init().

Fixes: d5692d4af08cd ("iommu/vt-d: Fix suspicious RCU usage in probe_acpi_namespace_devices()")
Reported-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/894db0ccae854b35c73814485569b634237b5538.1657034828.git.robin.murphy@arm.com
Link: https://lore.kernel.org/r/20220718235325.3952426-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c  |  7 +++++++
 drivers/iommu/intel/iommu.c | 27 ++-------------------------
 include/linux/dmar.h        |  4 +++-
 3 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 64b14ac4c7b02..fc8c1420c0b69 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -2368,6 +2368,13 @@ static int dmar_device_hotplug(acpi_handle handle, bool insert)
 	if (!dmar_in_use())
 		return 0;
 
+	/*
+	 * It's unlikely that any I/O board is hot added before the IOMMU
+	 * subsystem is initialized.
+	 */
+	if (IS_ENABLED(CONFIG_INTEL_IOMMU) && !intel_iommu_enabled)
+		return -EOPNOTSUPP;
+
 	if (dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD)) {
 		tmp = handle;
 	} else {
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5c0dce78586aa..936def2f416a2 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3123,13 +3123,7 @@ static int __init init_dmars(void)
 
 #ifdef CONFIG_INTEL_IOMMU_SVM
 		if (pasid_supported(iommu) && ecap_prs(iommu->ecap)) {
-			/*
-			 * Call dmar_alloc_hwirq() with dmar_global_lock held,
-			 * could cause possible lock race condition.
-			 */
-			up_write(&dmar_global_lock);
 			ret = intel_svm_enable_prq(iommu);
-			down_write(&dmar_global_lock);
 			if (ret)
 				goto free_iommu;
 		}
@@ -4035,7 +4029,6 @@ int __init intel_iommu_init(void)
 	force_on = (!intel_iommu_tboot_noforce && tboot_force_iommu()) ||
 		    platform_optin_force_iommu();
 
-	down_write(&dmar_global_lock);
 	if (dmar_table_init()) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR table\n");
@@ -4048,16 +4041,6 @@ int __init intel_iommu_init(void)
 		goto out_free_dmar;
 	}
 
-	up_write(&dmar_global_lock);
-
-	/*
-	 * The bus notifier takes the dmar_global_lock, so lockdep will
-	 * complain later when we register it under the lock.
-	 */
-	dmar_register_bus_notifier();
-
-	down_write(&dmar_global_lock);
-
 	if (!no_iommu)
 		intel_iommu_debugfs_init();
 
@@ -4105,11 +4088,9 @@ int __init intel_iommu_init(void)
 		pr_err("Initialization failed\n");
 		goto out_free_dmar;
 	}
-	up_write(&dmar_global_lock);
 
 	init_iommu_pm_ops();
 
-	down_read(&dmar_global_lock);
 	for_each_active_iommu(iommu, drhd) {
 		/*
 		 * The flush queue implementation does not perform
@@ -4127,13 +4108,11 @@ int __init intel_iommu_init(void)
 				       "%s", iommu->name);
 		iommu_device_register(&iommu->iommu, &intel_iommu_ops, NULL);
 	}
-	up_read(&dmar_global_lock);
 
 	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
 	if (si_domain && !hw_pass_through)
 		register_memory_notifier(&intel_iommu_memory_nb);
 
-	down_read(&dmar_global_lock);
 	if (probe_acpi_namespace_devices())
 		pr_warn("ACPI name space devices didn't probe correctly\n");
 
@@ -4144,17 +4123,15 @@ int __init intel_iommu_init(void)
 
 		iommu_disable_protect_mem_regions(iommu);
 	}
-	up_read(&dmar_global_lock);
-
-	pr_info("Intel(R) Virtualization Technology for Directed I/O\n");
 
 	intel_iommu_enabled = 1;
+	dmar_register_bus_notifier();
+	pr_info("Intel(R) Virtualization Technology for Directed I/O\n");
 
 	return 0;
 
 out_free_dmar:
 	intel_iommu_free_dmars();
-	up_write(&dmar_global_lock);
 	return ret;
 }
 
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index cbd714a198a0a..f3a3d95df5325 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -69,6 +69,7 @@ struct dmar_pci_notify_info {
 
 extern struct rw_semaphore dmar_global_lock;
 extern struct list_head dmar_drhd_units;
+extern int intel_iommu_enabled;
 
 #define for_each_drhd_unit(drhd)					\
 	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list,		\
@@ -92,7 +93,8 @@ extern struct list_head dmar_drhd_units;
 static inline bool dmar_rcu_check(void)
 {
 	return rwsem_is_locked(&dmar_global_lock) ||
-	       system_state == SYSTEM_BOOTING;
+	       system_state == SYSTEM_BOOTING ||
+	       (IS_ENABLED(CONFIG_INTEL_IOMMU) && !intel_iommu_enabled);
 }
 
 #define	dmar_rcu_dereference(p)	rcu_dereference_check((p), dmar_rcu_check())
-- 
2.35.1



