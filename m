Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D029171C94
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388631AbgB0ONY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388787AbgB0ONY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:13:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6071024697;
        Thu, 27 Feb 2020 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812803;
        bh=/Z1FwlrqAQpiZx5xw6ycJeKA6LZrTe39tMRJSFipyms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=III6pwndXVrDw2sSpMB/o/8vLZaJIppbhhZM46tJC9JvJYOl6KOO2jgzC69HcsvEB
         v2zim9nMNhcrRjE85UZSjiU96kP7CqEF0VNcLSu/nVRsLbewu1ZS2Tr+JoL3Oa5AQk
         KzH8zacm7dkC0OQdvUGG4x63shNDoV7jwrDe8/wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.5 004/150] iommu/vt-d: Do deferred attachment in iommu_need_mapping()
Date:   Thu, 27 Feb 2020 14:35:41 +0100
Message-Id: <20200227132233.391493066@linuxfoundation.org>
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

commit a11bfde9c77df1fd350ea27169ab921f511bf5d0 upstream.

The attachment of deferred devices needs to happen before the check
whether the device is identity mapped or not. Otherwise the check will
return wrong results, cause warnings boot failures in kdump kernels, like

	WARNING: CPU: 0 PID: 318 at ../drivers/iommu/intel-iommu.c:592 domain_get_iommu+0x61/0x70

	[...]

	 Call Trace:
	  __intel_map_single+0x55/0x190
	  intel_alloc_coherent+0xac/0x110
	  dmam_alloc_attrs+0x50/0xa0
	  ahci_port_start+0xfb/0x1f0 [libahci]
	  ata_host_start.part.39+0x104/0x1e0 [libata]

With the earlier check the kdump boot succeeds and a crashdump is written.

Fixes: 1ee0186b9a12 ("iommu/vt-d: Refactor find_domain() helper")
Cc: stable@vger.kernel.org # v5.5
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2452,9 +2452,6 @@ static void do_deferred_attach(struct de
 
 static struct dmar_domain *deferred_attach_domain(struct device *dev)
 {
-	if (unlikely(attach_deferred(dev)))
-		do_deferred_attach(dev);
-
 	return find_domain(dev);
 }
 
@@ -3478,6 +3475,9 @@ static bool iommu_need_mapping(struct de
 	if (iommu_dummy(dev))
 		return false;
 
+	if (unlikely(attach_deferred(dev)))
+		do_deferred_attach(dev);
+
 	ret = identity_mapping(dev);
 	if (ret) {
 		u64 dma_mask = *dev->dma_mask;
@@ -3841,7 +3841,11 @@ bounce_map_single(struct device *dev, ph
 	int prot = 0;
 	int ret;
 
+	if (unlikely(attach_deferred(dev)))
+		do_deferred_attach(dev);
+
 	domain = deferred_attach_domain(dev);
+
 	if (WARN_ON(dir == DMA_NONE || !domain))
 		return DMA_MAPPING_ERROR;
 


