Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59052C0993
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388765AbgKWNJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732831AbgKWMsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79F08204EF;
        Mon, 23 Nov 2020 12:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135680;
        bh=wOLVgXt1BIm5JgZmu+pMVz9nGUgUHX7kubNWWTCShxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExpxgiObtVxWunAaHjR0hoUkrwktZJE54VmHCSElAMsV/6Tg7Nm3Tc+8IJEuXckPx
         SlmnffK0Ec8srJtr9xbRbA5TdgqBmQkHUG2LIEsyWk9Fu4NkxW+dbDn4+VuFVtKG5K
         Aqgbx68zJ6qeC89mDEsoD0uHwT9dsBvazZBGsp8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Lukasz Hawrylko <lukasz.hawrylko@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 157/252] iommu/vt-d: Avoid panic if iommu init fails in tboot system
Date:   Mon, 23 Nov 2020 13:21:47 +0100
Message-Id: <20201123121843.169617158@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

[ Upstream commit 4d213e76a359e540ca786ee937da7f35faa8e5f8 ]

"intel_iommu=off" command line is used to disable iommu but iommu is force
enabled in a tboot system for security reason.

However for better performance on high speed network device, a new option
"intel_iommu=tboot_noforce" is introduced to disable the force on.

By default kernel should panic if iommu init fail in tboot for security
reason, but it's unnecessory if we use "intel_iommu=tboot_noforce,off".

Fix the code setting force_on and move intel_iommu_tboot_noforce
from tboot code to intel iommu code.

Fixes: 7304e8f28bb2 ("iommu/vt-d: Correctly disable Intel IOMMU force on")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Tested-by: Lukasz Hawrylko <lukasz.hawrylko@linux.intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20201110071908.3133-1-zhenzhong.duan@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/tboot.c     | 3 ---
 drivers/iommu/intel/iommu.c | 5 +++--
 include/linux/intel-iommu.h | 1 -
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 992fb1415c0f1..420be871d9d45 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -514,9 +514,6 @@ int tboot_force_iommu(void)
 	if (!tboot_enabled())
 		return 0;
 
-	if (intel_iommu_tboot_noforce)
-		return 1;
-
 	if (no_iommu || swiotlb || dmar_disabled)
 		pr_warn("Forcing Intel-IOMMU to enabled\n");
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e58be1fe7585e..f67b7e6ddf1bc 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -179,7 +179,7 @@ static int rwbf_quirk;
  * (used when kernel is launched w/ TXT)
  */
 static int force_on = 0;
-int intel_iommu_tboot_noforce;
+static int intel_iommu_tboot_noforce;
 static int no_platform_optin;
 
 #define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
@@ -4846,7 +4846,8 @@ int __init intel_iommu_init(void)
 	 * Intel IOMMU is required for a TXT/tboot launch or platform
 	 * opt in, so enforce that.
 	 */
-	force_on = tboot_force_iommu() || platform_optin_force_iommu();
+	force_on = (!intel_iommu_tboot_noforce && tboot_force_iommu()) ||
+		    platform_optin_force_iommu();
 
 	if (iommu_init_mempool()) {
 		if (force_on)
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 6a3ddaabf3f50..bdf80d7a70fb3 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -791,7 +791,6 @@ extern int iommu_calculate_agaw(struct intel_iommu *iommu);
 extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
 extern int dmar_disabled;
 extern int intel_iommu_enabled;
-extern int intel_iommu_tboot_noforce;
 extern int intel_iommu_gfx_mapped;
 #else
 static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
-- 
2.27.0



