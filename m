Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929E141750D
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346802AbhIXNOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346200AbhIXNL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DD62615E3;
        Fri, 24 Sep 2021 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488319;
        bh=F92ISwVmLQx+ABEa1k1jblVKd+7X0jAFi/2U2Z0P1Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+EFFFr9tdlIdzXGI652NgXQMyH/qiyLGKyMR++meWFBwg9casaATlbHm2g4il8ha
         /zyxhOSUWekN6lOfZp/VJaAVtwLVD+c/nJy7C3fKuI+wKNSlUdxsHnmyvE5yh3UF5o
         fkcTw+KYtZvcUuebF33swd4VnCEG9g2Q8TMmfLkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Huang <wei.huang2@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/63] iommu/amd: Relocate GAMSup check to early_enable_iommus
Date:   Fri, 24 Sep 2021 14:44:39 +0200
Message-Id: <20210924124335.613031622@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
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
index fa57986c2309..28de889aa516 100644
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
 
@@ -2396,6 +2405,14 @@ static void early_enable_iommus(void)
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



