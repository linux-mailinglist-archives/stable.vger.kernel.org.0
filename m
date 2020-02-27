Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655F4171DF3
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgB0OYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388973AbgB0ON1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:13:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9340320801;
        Thu, 27 Feb 2020 14:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812807;
        bh=FhDWb/RYnGRiiU8odP5whwWF/muNFYva5uLwSwHCnZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kB0vgMprnzJMw8oUjuIAY8tf49be6iFKjWBPJwthcnSEFxiJ6chCWvkGvG4s+dgdq
         dB2gZfK7WLvBTKtXrvkVR5ZeBRPtS4JX0vEwoB6d+65aVXZE/3nRYWD5rWYu82KzHc
         hh5k82kdzryD4jNttvkKRPgO3Q9fFzA5ZNT84q6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.5 005/150] iommu/vt-d: Remove deferred_attach_domain()
Date:   Thu, 27 Feb 2020 14:35:42 +0100
Message-Id: <20200227132233.517585617@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 96d170f3b1a607612caf3618c534d5c64fc2d61b upstream.

The function is now only a wrapper around find_domain(). Remove the
function and call find_domain() directly at the call-sites.

Fixes: 1ee0186b9a12 ("iommu/vt-d: Refactor find_domain() helper")
Cc: stable@vger.kernel.org # v5.5
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2450,11 +2450,6 @@ static void do_deferred_attach(struct de
 		intel_iommu_attach_device(domain, dev);
 }
 
-static struct dmar_domain *deferred_attach_domain(struct device *dev)
-{
-	return find_domain(dev);
-}
-
 static inline struct device_domain_info *
 dmar_search_domain_by_dev_info(int segment, int bus, int devfn)
 {
@@ -3526,7 +3521,7 @@ static dma_addr_t __intel_map_single(str
 
 	BUG_ON(dir == DMA_NONE);
 
-	domain = deferred_attach_domain(dev);
+	domain = find_domain(dev);
 	if (!domain)
 		return DMA_MAPPING_ERROR;
 
@@ -3746,7 +3741,7 @@ static int intel_map_sg(struct device *d
 	if (!iommu_need_mapping(dev))
 		return dma_direct_map_sg(dev, sglist, nelems, dir, attrs);
 
-	domain = deferred_attach_domain(dev);
+	domain = find_domain(dev);
 	if (!domain)
 		return 0;
 
@@ -3844,7 +3839,7 @@ bounce_map_single(struct device *dev, ph
 	if (unlikely(attach_deferred(dev)))
 		do_deferred_attach(dev);
 
-	domain = deferred_attach_domain(dev);
+	domain = find_domain(dev);
 
 	if (WARN_ON(dir == DMA_NONE || !domain))
 		return DMA_MAPPING_ERROR;


