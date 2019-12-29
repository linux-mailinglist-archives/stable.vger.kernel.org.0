Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F0512C8E5
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387487AbfL2R6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387479AbfL2R6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D046208C4;
        Sun, 29 Dec 2019 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642294;
        bh=18jO5xaFDERdyOV7io7aSLzAQta4hBJaafpYNrc6a2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMhZ8taUf1dCHuB5Yi+SaCfyB0IfHeC2F+VZWumBj8jC7c1YpGbdpsUdMUoujwfQ1
         l4z+3pTXUG2yz5cAL5Taekt6O64j3KeqIkg5uMEb3tcO5ZGXbULFbsw+pK94adva9b
         Chea5xtoEdVnPGIB+sSVnz1p2RhVDF8BUrplshuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, cprt <cprt@protonmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 370/434] iommu/vt-d: Set ISA bridge reserved region as relaxable
Date:   Sun, 29 Dec 2019 18:27:03 +0100
Message-Id: <20191229172726.563166748@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

commit d8018a0e9195ba9f0fb9cf0fd3843807c8b952d5 upstream.

Commit d850c2ee5fe2 ("iommu/vt-d: Expose ISA direct mapping region via
iommu_get_resv_regions") created a direct-mapped reserved memory region
in order to replace the static identity mapping of the ISA address
space, where the latter was then removed in commit df4f3c603aeb
("iommu/vt-d: Remove static identity map code").  According to the
history of this code and the Kconfig option surrounding it, this direct
mapping exists for the benefit of legacy ISA drivers that are not
compatible with the DMA API.

In conjuntion with commit 9b77e5c79840 ("vfio/type1: check dma map
request is within a valid iova range") this change introduced a
regression where the vfio IOMMU backend enforces reserved memory regions
per IOMMU group, preventing userspace from creating IOMMU mappings
conflicting with prescribed reserved regions.  A necessary prerequisite
for the vfio change was the introduction of "relaxable" direct mappings
introduced by commit adfd37382090 ("iommu: Introduce
IOMMU_RESV_DIRECT_RELAXABLE reserved memory regions").  These relaxable
direct mappings provide the same identity mapping support in the default
domain, but also indicate that the reservation is software imposed and
may be relaxed under some conditions, such as device assignment.

Convert the ISA bridge direct-mapped reserved region to relaxable to
reflect that the restriction is self imposed and need not be enforced
by drivers such as vfio.

Fixes: 1c5c59fbad20 ("iommu/vt-d: Differentiate relaxable and non relaxable RMRRs")
Cc: stable@vger.kernel.org # v5.3+
Link: https://lore.kernel.org/linux-iommu/20191211082304.2d4fab45@x1.home
Reported-by: cprt <cprt@protonmail.com>
Tested-by: cprt <cprt@protonmail.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5698,7 +5698,7 @@ static void intel_iommu_get_resv_regions
 
 		if ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA) {
 			reg = iommu_alloc_resv_region(0, 1UL << 24, 0,
-						      IOMMU_RESV_DIRECT);
+						   IOMMU_RESV_DIRECT_RELAXABLE);
 			if (reg)
 				list_add_tail(&reg->list, head);
 		}


