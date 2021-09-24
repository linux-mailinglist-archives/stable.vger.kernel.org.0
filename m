Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E194173FF
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345699AbhIXNBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344849AbhIXM7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E58961283;
        Fri, 24 Sep 2021 12:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488005;
        bh=pNEvi4tY0qEvOUmY2GRGxyqS8i4BY84ocPzDov3hEI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BohiU9jZM2uXgvIu1HpLN+K4sMq5eWparBFDMHDsWSSuLXPZRzfkgIobDH4iktTOy
         7SlFMkh7+rgH4LPXhFZucin1P8HSR/XmOlLSOpldm1C2pv5BSdCdMq0IbKNGUIrBuo
         znTXG1+Uw2eaUnkV/kqP9FGl7gXcV35usce5Tipg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Huang <wei.huang2@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 047/100] iommu/amd: Relocate GAMSup check to early_enable_iommus
Date:   Fri, 24 Sep 2021 14:43:56 +0200
Message-Id: <20210924124343.022637791@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Huang <wei.huang2@amd.com>

[ Upstream commit c3811a50addd23b9bb5a36278609ee1638debcf6 ]

Currently, iommu_init_ga() checks and disables IOMMU VAPIC support
(i.e. AMD AVIC support in IOMMU) when GAMSup feature bit is not set.
However it forgets to clear IRQ_POSTING_CAP from the previously set
amd_iommu_irq_ops.capability.

This triggers an invalid page fault bug during guest VM warm reboot
if AVIC is enabled since the irq_remapping_cap(IRQ_POSTING_CAP) is
incorrectly set, and crash the system with the following kernel trace.

    BUG: unable to handle page fault for address: 0000000000400dd8
    RIP: 0010:amd_iommu_deactivate_guest_mode+0x19/0xbc
    Call Trace:
     svm_set_pi_irte_mode+0x8a/0xc0 [kvm_amd]
     ? kvm_make_all_cpus_request_except+0x50/0x70 [kvm]
     kvm_request_apicv_update+0x10c/0x150 [kvm]
     svm_toggle_avic_for_irq_window+0x52/0x90 [kvm_amd]
     svm_enable_irq_window+0x26/0xa0 [kvm_amd]
     vcpu_enter_guest+0xbbe/0x1560 [kvm]
     ? avic_vcpu_load+0xd5/0x120 [kvm_amd]
     ? kvm_arch_vcpu_load+0x76/0x240 [kvm]
     ? svm_get_segment_base+0xa/0x10 [kvm_amd]
     kvm_arch_vcpu_ioctl_run+0x103/0x590 [kvm]
     kvm_vcpu_ioctl+0x22a/0x5d0 [kvm]
     __x64_sys_ioctl+0x84/0xc0
     do_syscall_64+0x33/0x40
     entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes by moving the initializing of AMD IOMMU interrupt remapping mode
(amd_iommu_guest_ir) earlier before setting up the
amd_iommu_irq_ops.capability with appropriate IRQ_POSTING_CAP flag.

[joro:	Squashed the two patches and limited
	check_features_on_all_iommus() to CONFIG_IRQ_REMAP
	to fix a compile warning.]

Signed-off-by: Wei Huang <wei.huang2@amd.com>
Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20210820202957.187572-2-suravee.suthikulpanit@amd.com
Link: https://lore.kernel.org/r/20210820202957.187572-3-suravee.suthikulpanit@amd.com
Fixes: 8bda0cfbdc1a ("iommu/amd: Detect and initialize guest vAPIC log")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 46280e6e1535..5c21f1ee5098 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -298,6 +298,22 @@ int amd_iommu_get_num_iommus(void)
 	return amd_iommus_present;
 }
 
+#ifdef CONFIG_IRQ_REMAP
+static bool check_feature_on_all_iommus(u64 mask)
+{
+	bool ret = false;
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu) {
+		ret = iommu_feature(iommu, mask);
+		if (!ret)
+			return false;
+	}
+
+	return true;
+}
+#endif
+
 /*
  * For IVHD type 0x11/0x40, EFR is also available via IVHD.
  * Default to IVHD EFR since it is available sooner
@@ -854,13 +870,6 @@ static int iommu_init_ga(struct amd_iommu *iommu)
 	int ret = 0;
 
 #ifdef CONFIG_IRQ_REMAP
-	/* Note: We have already checked GASup from IVRS table.
-	 *       Now, we need to make sure that GAMSup is set.
-	 */
-	if (AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) &&
-	    !iommu_feature(iommu, FEATURE_GAM_VAPIC))
-		amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY_GA;
-
 	ret = iommu_init_ga_log(iommu);
 #endif /* CONFIG_IRQ_REMAP */
 
@@ -2477,6 +2486,14 @@ static void early_enable_iommus(void)
 	}
 
 #ifdef CONFIG_IRQ_REMAP
+	/*
+	 * Note: We have already checked GASup from IVRS table.
+	 *       Now, we need to make sure that GAMSup is set.
+	 */
+	if (AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) &&
+	    !check_feature_on_all_iommus(FEATURE_GAM_VAPIC))
+		amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY_GA;
+
 	if (AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
 		amd_iommu_irq_ops.capability |= (1 << IRQ_POSTING_CAP);
 #endif
-- 
2.33.0



