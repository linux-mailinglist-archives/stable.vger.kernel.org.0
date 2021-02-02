Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACD930CA21
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238725AbhBBSj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233774AbhBBOER (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:04:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84C3164F87;
        Tue,  2 Feb 2021 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273714;
        bh=V8h6N2k7t+dguqt4d7N6Uf1h0AxrXaklZuvMbkRFFhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vvxs9f6Qi1J7ROP8YGpvAyOysmzlzQnbkkU5Q6/21dHM9r1yn/k8f8NJEqluINkVj
         +IQDAf1pYqjHDZ4uN7bI/Tbw7Nk40niNvS0qZlhCow0QiIwrw0lJy2gpigCE//Xyxs
         ODNV6XHpyIqnaiXL0mL8ulEL1NKKIH8PcZdYh9kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Filippo Sironi <sironi@amazon.de>
Subject: [PATCH 5.4 54/61] iommu/vt-d: Gracefully handle DMAR units with no supported address widths
Date:   Tue,  2 Feb 2021 14:38:32 +0100
Message-Id: <20210202132948.768875320@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit c40aaaac1018ff1382f2d35df5129a6bcea3df6b upstream.

Instead of bailing out completely, such a unit can still be used for
interrupt remapping.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/linux-iommu/549928db2de6532117f36c9c810373c14cf76f51.camel@infradead.org/
Signed-off-by: Joerg Roedel <jroedel@suse.de>
[ context change due to moving drivers/iommu/dmar.c to
  drivers/iommu/intel/dmar.c ]
Signed-off-by: Filippo Sironi <sironi@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dmar.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1020,8 +1020,8 @@ static int alloc_iommu(struct dmar_drhd_
 {
 	struct intel_iommu *iommu;
 	u32 ver, sts;
-	int agaw = 0;
-	int msagaw = 0;
+	int agaw = -1;
+	int msagaw = -1;
 	int err;
 
 	if (!drhd->reg_base_addr) {
@@ -1046,17 +1046,28 @@ static int alloc_iommu(struct dmar_drhd_
 	}
 
 	err = -EINVAL;
-	agaw = iommu_calculate_agaw(iommu);
-	if (agaw < 0) {
-		pr_err("Cannot get a valid agaw for iommu (seq_id = %d)\n",
-			iommu->seq_id);
-		goto err_unmap;
-	}
-	msagaw = iommu_calculate_max_sagaw(iommu);
-	if (msagaw < 0) {
-		pr_err("Cannot get a valid max agaw for iommu (seq_id = %d)\n",
-			iommu->seq_id);
-		goto err_unmap;
+	if (cap_sagaw(iommu->cap) == 0) {
+		pr_info("%s: No supported address widths. Not attempting DMA translation.\n",
+			iommu->name);
+		drhd->ignored = 1;
+	}
+
+	if (!drhd->ignored) {
+		agaw = iommu_calculate_agaw(iommu);
+		if (agaw < 0) {
+			pr_err("Cannot get a valid agaw for iommu (seq_id = %d)\n",
+			       iommu->seq_id);
+			drhd->ignored = 1;
+		}
+	}
+	if (!drhd->ignored) {
+		msagaw = iommu_calculate_max_sagaw(iommu);
+		if (msagaw < 0) {
+			pr_err("Cannot get a valid max agaw for iommu (seq_id = %d)\n",
+			       iommu->seq_id);
+			drhd->ignored = 1;
+			agaw = -1;
+		}
 	}
 	iommu->agaw = agaw;
 	iommu->msagaw = msagaw;
@@ -1083,7 +1094,12 @@ static int alloc_iommu(struct dmar_drhd_
 
 	raw_spin_lock_init(&iommu->register_lock);
 
-	if (intel_iommu_enabled) {
+	/*
+	 * This is only for hotplug; at boot time intel_iommu_enabled won't
+	 * be set yet. When intel_iommu_init() runs, it registers the units
+	 * present at boot time, then sets intel_iommu_enabled.
+	 */
+	if (intel_iommu_enabled && !drhd->ignored) {
 		err = iommu_device_sysfs_add(&iommu->iommu, NULL,
 					     intel_iommu_groups,
 					     "%s", iommu->name);
@@ -1112,7 +1128,7 @@ error:
 
 static void free_iommu(struct intel_iommu *iommu)
 {
-	if (intel_iommu_enabled) {
+	if (intel_iommu_enabled && iommu->iommu.ops) {
 		iommu_device_unregister(&iommu->iommu);
 		iommu_device_sysfs_remove(&iommu->iommu);
 	}


