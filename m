Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2162C0998
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732831AbgKWNJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:09:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732781AbgKWMsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBD9D2158C;
        Mon, 23 Nov 2020 12:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135677;
        bh=YZej0oFCHfEySeRMmAj+CJN5Dp4nWdKSWd/ZBBpkli0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHwl7OpyNeKOE/LU7zgWiin2PgCl7Y80bBg9N5+WAaKVVlczgiyx1EPGI+24fphBi
         Ok/FCHZY7V6cwlgkJW3IfTZtEU9mGroYOPJqj9DcwQBj4tnsgxcO7nK7Dv+mjGzmCZ
         eRJoBktyCk1RaInvy7bk/mMS4PiTgxVokUFmlaxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 156/252] iommu/vt-d: Move intel_iommu_gfx_mapped to Intel IOMMU header
Date:   Mon, 23 Nov 2020 13:21:46 +0100
Message-Id: <20201123121843.121692548@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c7eb900f5f45eeab1ea1bed997a2a12d8b5907bc ]

Static analyzer is not happy about intel_iommu_gfx_mapped declaration:

.../drivers/iommu/intel/iommu.c:364:5: warning: symbol 'intel_iommu_gfx_mapped' was not declared. Should it be static?

Move its declaration to Intel IOMMU header file.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20200828161212.71294-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/intel-gtt.h     | 5 +----
 include/linux/intel-iommu.h | 1 +
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/drm/intel-gtt.h b/include/drm/intel-gtt.h
index 71d81923e6b06..abfefaaf897a0 100644
--- a/include/drm/intel-gtt.h
+++ b/include/drm/intel-gtt.h
@@ -5,6 +5,7 @@
 #define	_DRM_INTEL_GTT_H
 
 #include <linux/agp_backend.h>
+#include <linux/intel-iommu.h>
 #include <linux/kernel.h>
 
 void intel_gtt_get(u64 *gtt_total,
@@ -33,8 +34,4 @@ void intel_gtt_clear_range(unsigned int first_entry, unsigned int num_entries);
 /* flag for GFDT type */
 #define AGP_USER_CACHED_MEMORY_GFDT (1 << 3)
 
-#ifdef CONFIG_INTEL_IOMMU
-extern int intel_iommu_gfx_mapped;
-#endif
-
 #endif
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index b1ed2f25f7c0d..6a3ddaabf3f50 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -792,6 +792,7 @@ extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
 extern int dmar_disabled;
 extern int intel_iommu_enabled;
 extern int intel_iommu_tboot_noforce;
+extern int intel_iommu_gfx_mapped;
 #else
 static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
 {
-- 
2.27.0



