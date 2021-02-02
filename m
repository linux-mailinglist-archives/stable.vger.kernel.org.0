Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C49030C92E
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbhBBSMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233911AbhBBOHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:07:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DE6B65020;
        Tue,  2 Feb 2021 13:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273779;
        bh=fN+Aj2lTXcbrh5ZVEFwVZJqs4byeBpGm1LSRDATtzmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nD2w9cDSIU9q8QQXQcOPFpPAZQvI1MJYjuOQ54acj30TfEQ9fOvCYrv2pu+71+5LQ
         SNUq9sVelrPa+7iKtjRl7KdwKucD97y6zlH1h5lW3f5GuDboP2yaNPfBqj8YnEWA4c
         34Kw50xNoVl/S7s6TYgOORCZHzGZJa9ZCc6VYcoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Joerg Roedel <jroedel@suse.de>,
        Filippo Sironi <sironi@amazon.de>
Subject: [PATCH 4.4 26/28] iommu/vt-d: Dont dereference iommu_device if IOMMU_API is not built
Date:   Tue,  2 Feb 2021 14:38:46 +0100
Message-Id: <20210202132942.237450115@linuxfoundation.org>
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
@@ -1087,6 +1087,7 @@ static int alloc_iommu(struct dmar_drhd_
 	raw_spin_lock_init(&iommu->register_lock);
 
 	drhd->iommu = iommu;
+	iommu->drhd = drhd;
 
 	if (intel_iommu_enabled && !drhd->ignored)
 		iommu->iommu_dev = iommu_device_create(NULL, iommu,
@@ -1104,7 +1105,7 @@ error:
 
 static void free_iommu(struct intel_iommu *iommu)
 {
-	if (intel_iommu_enabled && iommu->iommu_dev)
+	if (intel_iommu_enabled && !iommu->drhd->ignored)
 		iommu_device_destroy(iommu->iommu_dev);
 
 	if (iommu->irq) {
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -447,6 +447,8 @@ struct intel_iommu {
 	struct device	*iommu_dev; /* IOMMU-sysfs device */
 	int		node;
 	u32		flags;      /* Software defined flags */
+
+	struct dmar_drhd_unit *drhd;
 };
 
 static inline void __iommu_flush_cache(


