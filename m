Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01AF30C304
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhBBPHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:07:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhBBOQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:16:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A36076505D;
        Tue,  2 Feb 2021 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612274048;
        bh=fGNxcoOBw5SK8+jRNbMJD3FXC3oqvM88gq4ywzwXqSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqnTIwyx0oeb0QtcWOC+bfb55aI/5QSKw/ctOoOnKI+9Xwmo76Jy/FUFL5l0xTAu3
         DiJcGZSserIagPKY5emXVUJFpFdmsZalgSEoVZXqk/HRYZDKOeSa2iOv+QIpON29no
         NwtkeZiotM6Rbd1nIaE8VJKTkyJ8cryMRGsspVKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Joerg Roedel <jroedel@suse.de>,
        Filippo Sironi <sironi@amazon.de>
Subject: [PATCH 4.19 32/37] iommu/vt-d: Dont dereference iommu_device if IOMMU_API is not built
Date:   Tue,  2 Feb 2021 14:39:15 +0100
Message-Id: <20210202132944.273327443@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

commit 9def3b1a07c41e21c68a0eb353e3e569fdd1d2b1 upstream.

Since commit c40aaaac1018 ("iommu/vt-d: Gracefully handle DMAR units
with no supported address widths") dmar.c needs struct iommu_device to
be selected. We can drop this dependency by not dereferencing struct
iommu_device if IOMMU_API is not selected and by reusing the information
stored in iommu->drhd->ignored instead.

This fixes the following build error when IOMMU_API is not selected:

drivers/iommu/dmar.c: In function ‘free_iommu’:
drivers/iommu/dmar.c:1139:41: error: ‘struct iommu_device’ has no member named ‘ops’
 1139 |  if (intel_iommu_enabled && iommu->iommu.ops) {
                                                ^

Fixes: c40aaaac1018 ("iommu/vt-d: Gracefully handle DMAR units with no supported address widths")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Link: https://lore.kernel.org/r/20201013073055.11262-1-brgl@bgdev.pl
Signed-off-by: Joerg Roedel <jroedel@suse.de>
[ - context change due to moving drivers/iommu/dmar.c to
    drivers/iommu/intel/dmar.c
  - set the drhr in the iommu like in upstream commit b1012ca8dc4f
    ("iommu/vt-d: Skip TE disabling on quirky gfx dedicated iommu") ]
Signed-off-by: Filippo Sironi <sironi@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dmar.c        |    3 ++-
 include/linux/intel-iommu.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1123,6 +1123,7 @@ static int alloc_iommu(struct dmar_drhd_
 	}
 
 	drhd->iommu = iommu;
+	iommu->drhd = drhd;
 
 	return 0;
 
@@ -1137,7 +1138,7 @@ error:
 
 static void free_iommu(struct intel_iommu *iommu)
 {
-	if (intel_iommu_enabled && iommu->iommu.ops) {
+	if (intel_iommu_enabled && !iommu->drhd->ignored) {
 		iommu_device_unregister(&iommu->iommu);
 		iommu_device_sysfs_remove(&iommu->iommu);
 	}
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -472,6 +472,8 @@ struct intel_iommu {
 	struct iommu_device iommu;  /* IOMMU core code handle */
 	int		node;
 	u32		flags;      /* Software defined flags */
+
+	struct dmar_drhd_unit *drhd;
 };
 
 /* PCI domain-device relationship */


