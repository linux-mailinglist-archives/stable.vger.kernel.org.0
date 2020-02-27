Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7410B171DEF
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388688AbgB0ONR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388279AbgB0ONQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:13:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60DD8246AE;
        Thu, 27 Feb 2020 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812795;
        bh=c+QAZKsKDYydly6rBU7pvwbpwsaQPeBfWnjJxll7xWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VR1WFxK7jk8L3ppQg01yR3BhFhoMyMOY3d+EiOH2o/w3XeGZ7yKzG/e7fxT2iKqu4
         JPmO2Lth4H+DSaHu/cRGNKjOCz7cgoGZyKwLodXEjhZdrgblo0KuYjspqef6MYhaME
         Mm3VBWASBTYjHRprdLI2I3TPtwdF5B0MlkQoP0pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.5 002/150] iommu/vt-d: Add attach_deferred() helper
Date:   Thu, 27 Feb 2020 14:35:39 +0100
Message-Id: <20200227132233.148997736@linuxfoundation.org>
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

commit 1d4615978f525b769990a4a4ef22fb1b9a04cdf1 upstream.

Implement a helper function to check whether a device's attach process
is deferred.

Fixes: 1ee0186b9a12 ("iommu/vt-d: Refactor find_domain() helper")
Cc: stable@vger.kernel.org # v5.5
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -732,6 +732,11 @@ static int iommu_dummy(struct device *de
 	return dev->archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO;
 }
 
+static bool attach_deferred(struct device *dev)
+{
+	return dev->archdata.iommu == DEFER_DEVICE_DOMAIN_INFO;
+}
+
 /**
  * is_downstream_to_pci_bridge - test if a device belongs to the PCI
  *				 sub-hierarchy of a candidate PCI-PCI bridge
@@ -2424,8 +2429,7 @@ static struct dmar_domain *find_domain(s
 {
 	struct device_domain_info *info;
 
-	if (unlikely(dev->archdata.iommu == DEFER_DEVICE_DOMAIN_INFO ||
-		     dev->archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO))
+	if (unlikely(attach_deferred(dev) || iommu_dummy(dev)))
 		return NULL;
 
 	/* No lock here, assumes no domain exit in normal case */
@@ -2438,7 +2442,7 @@ static struct dmar_domain *find_domain(s
 
 static struct dmar_domain *deferred_attach_domain(struct device *dev)
 {
-	if (unlikely(dev->archdata.iommu == DEFER_DEVICE_DOMAIN_INFO)) {
+	if (unlikely(attach_deferred(dev))) {
 		struct iommu_domain *domain;
 
 		dev->archdata.iommu = NULL;
@@ -5989,7 +5993,7 @@ intel_iommu_aux_get_pasid(struct iommu_d
 static bool intel_iommu_is_attach_deferred(struct iommu_domain *domain,
 					   struct device *dev)
 {
-	return dev->archdata.iommu == DEFER_DEVICE_DOMAIN_INFO;
+	return attach_deferred(dev);
 }
 
 const struct iommu_ops intel_iommu_ops = {


