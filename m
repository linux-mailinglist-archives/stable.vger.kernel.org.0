Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30711E2D89
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391586AbgEZTVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404079AbgEZTLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:11:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8409220888;
        Tue, 26 May 2020 19:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520291;
        bh=tKXQmljvVS67CsXNIjd1NAZlest5cr4b3g4C5vd/z5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFQbviB7SYEkvihwSxFgx2m9C5PbGoxGpouApP3JqWjOThcAEDhAtZyj1d9m0MwJY
         ojCgql0KH0i1QtrfQRBXIgMVPZPvBqkwXi4eRVbKklJG8eNYFv+LbD8QkdgyfHbqZO
         sLcBGyk9z+tgFm+UB2KeKnEbagq41gSuHO0Rnvjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Tom Murphy <murphyt7@tcd.ie>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 021/126] iommu: Fix deferred domain attachment
Date:   Tue, 26 May 2020 20:52:38 +0200
Message-Id: <20200526183939.443147529@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit bd421264ed307dd296eab036851221b225071a32 ]

The IOMMU core code has support for deferring the attachment of a domain
to a device. This is needed in kdump kernels where the new domain must
not be attached to a device before the device driver takes it over.

When the AMD IOMMU driver got converted to use the dma-iommu
implementation, the deferred attaching got lost. The code in
dma-iommu.c has support for deferred attaching, but it calls into
iommu_attach_device() to actually do it. But iommu_attach_device()
will check if the device should be deferred in it code-path and do
nothing, breaking deferred attachment.

Move the is_deferred_attach() check out of the attach_device path and
into iommu_group_add_device() to make deferred attaching work from the
dma-iommu code.

Fixes: 795bbbb9b6f8 ("iommu/dma-iommu: Handle deferred devices")
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Tom Murphy <murphyt7@tcd.ie>
Cc: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20200519130340.14564-1-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8d2477941fd9..22b28076d48e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -692,6 +692,15 @@ out:
 	return ret;
 }
 
+static bool iommu_is_attach_deferred(struct iommu_domain *domain,
+				     struct device *dev)
+{
+	if (domain->ops->is_attach_deferred)
+		return domain->ops->is_attach_deferred(domain, dev);
+
+	return false;
+}
+
 /**
  * iommu_group_add_device - add a device to an iommu group
  * @group: the group into which to add the device (reference should be held)
@@ -746,7 +755,7 @@ rename:
 
 	mutex_lock(&group->mutex);
 	list_add_tail(&device->list, &group->devices);
-	if (group->domain)
+	if (group->domain  && !iommu_is_attach_deferred(group->domain, dev))
 		ret = __iommu_attach_device(group->domain, dev);
 	mutex_unlock(&group->mutex);
 	if (ret)
@@ -1652,9 +1661,6 @@ static int __iommu_attach_device(struct iommu_domain *domain,
 				 struct device *dev)
 {
 	int ret;
-	if ((domain->ops->is_attach_deferred != NULL) &&
-	    domain->ops->is_attach_deferred(domain, dev))
-		return 0;
 
 	if (unlikely(domain->ops->attach_dev == NULL))
 		return -ENODEV;
@@ -1726,8 +1732,7 @@ EXPORT_SYMBOL_GPL(iommu_sva_unbind_gpasid);
 static void __iommu_detach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
-	if ((domain->ops->is_attach_deferred != NULL) &&
-	    domain->ops->is_attach_deferred(domain, dev))
+	if (iommu_is_attach_deferred(domain, dev))
 		return;
 
 	if (unlikely(domain->ops->detach_dev == NULL))
-- 
2.25.1



