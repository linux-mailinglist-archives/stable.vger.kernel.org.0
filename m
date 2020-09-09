Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D226262A67
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 10:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIIIey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 04:34:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55189 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725948AbgIIIey (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 04:34:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599640492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pQkZFjFYaSMWuy1euxemi9N3xZazaBJbMNo8OCGEPv8=;
        b=hK4Y+ZZBiq/FuFRqqZsERmG0a9VgnIT/PXsSUevQUS6ZsQLk14GsQpC1ZlQuufWDIecIa6
        orRLbxWILqATX9lHkliL71RCw9XrmcGv/hb5QLVyPJZWv19kaKigdOfJkbFwIRFfK279l3
        TEYr0CrDhpWZwt2gGJ3fjsxCoQyOXO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-BbmXKeMKNK-Ie1nQ57nZIA-1; Wed, 09 Sep 2020 04:34:51 -0400
X-MC-Unique: BbmXKeMKNK-Ie1nQ57nZIA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB81018BE160;
        Wed,  9 Sep 2020 08:34:47 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-24.pek2.redhat.com [10.72.12.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 654E278380;
        Wed,  9 Sep 2020 08:34:34 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc:     eperezma@redhat.com, peterx@redhat.com, mst@redhat.com,
        Jason Wang <jasowang@redhat.com>, stable@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH] intel-iommu: don't disable ATS for device without page aligned request
Date:   Wed,  9 Sep 2020 16:34:32 +0800
Message-Id: <20200909083432.9464-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 61363c1474b1 ("iommu/vt-d: Enable ATS only if the device uses
page aligned address.") disables ATS for device that can do unaligned
page request.

This looks wrong, since the commit log said it's because the page
request descriptor doesn't support reporting unaligned request.

A victim is Qemu's virtio-pci which doesn't advertise the page aligned
address. Fixing by disable PRI instead of ATS if device doesn't have
page aligned request.

Cc: stable@vger.kernel.org
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/iommu/intel/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e9864e52b0e9..ef5214a8a4dd 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1440,10 +1440,11 @@ static void iommu_enable_dev_iotlb(struct device_domain_info *info)
 
 	if (info->pri_supported &&
 	    (info->pasid_enabled ? pci_prg_resp_pasid_required(pdev) : 1)  &&
+	    pci_ats_page_aligned(pdev) &&
 	    !pci_reset_pri(pdev) && !pci_enable_pri(pdev, 32))
 		info->pri_enabled = 1;
 #endif
-	if (info->ats_supported && pci_ats_page_aligned(pdev) &&
+	if (info->ats_supported &&
 	    !pci_enable_ats(pdev, VTD_PAGE_SHIFT)) {
 		info->ats_enabled = 1;
 		domain_update_iotlb(info->domain);
-- 
2.20.1

