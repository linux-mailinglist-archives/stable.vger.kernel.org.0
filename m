Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD77F30C92D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbhBBSMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:12:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhBBOHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:07:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 415296501E;
        Tue,  2 Feb 2021 13:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273776;
        bh=9k8PyRlU8mCeuiThMNH+yc+A+Hm/WLiovHkAqVZJzKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJo1JFIPVTHYVMsS8oT3lgp5WrOxrbmbC0bbroR7emfCWa0FpOZlkUQy07Afc+TkL
         9g86S72wldtgD8RZ+CU2uU2T3Ag49TluxfnyZ0sES7y9we9t4A6qfQ5P2+lyE3F2/v
         cJ3RhVgnVZXiKjrJhhNgs9iqmJjJESVm46JojPFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Filippo Sironi <sironi@amazon.de>
Subject: [PATCH 4.4 25/28] iommu/vt-d: Gracefully handle DMAR units with no supported address widths
Date:   Tue,  2 Feb 2021 14:38:45 +0100
Message-Id: <20210202132942.198454131@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
References: <20210202132941.180062901@linuxfoundation.org>
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
[ - context change due to moving drivers/iommu/dmar.c to
    drivers/iommu/intel/dmar.c
  - remove the unused err_unmap label
  - use iommu->iommu_dev instead of iommu->iommu.ops to decide whether
    when freeing ]
Signed-off-by: Filippo Sironi <sironi@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dmar.c |   44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1012,8 +1012,8 @@ static int alloc_iommu(struct dmar_drhd_
 {
 	struct intel_iommu *iommu;
 	u32 ver, sts;
-	int agaw = 0;
-	int msagaw = 0;
+	int agaw = -1;
+	int msagaw = -1;
 	int err;
 
 	if (!drhd->reg_base_addr) {
@@ -1038,17 +1038,28 @@ static int alloc_iommu(struct dmar_drhd_
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
@@ -1077,15 +1088,13 @@ static int alloc_iommu(struct dmar_drhd_
 
 	drhd->iommu = iommu;
 
-	if (intel_iommu_enabled)
+	if (intel_iommu_enabled && !drhd->ignored)
 		iommu->iommu_dev = iommu_device_create(NULL, iommu,
 						       intel_iommu_groups,
 						       "%s", iommu->name);
 
 	return 0;
 
-err_unmap:
-	unmap_iommu(iommu);
 error_free_seq_id:
 	dmar_free_seq_id(iommu);
 error:
@@ -1095,7 +1104,8 @@ error:
 
 static void free_iommu(struct intel_iommu *iommu)
 {
-	iommu_device_destroy(iommu->iommu_dev);
+	if (intel_iommu_enabled && iommu->iommu_dev)
+		iommu_device_destroy(iommu->iommu_dev);
 
 	if (iommu->irq) {
 		if (iommu->pr_irq) {


