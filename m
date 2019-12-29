Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A4912C89A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbfL2R41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732750AbfL2R41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822F3222D9;
        Sun, 29 Dec 2019 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642187;
        bh=MDlhEhj2G1pFcoetkRyZjXVVe1s/XlYTo1QrtkXMKTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvI9kuHb5yigdwFHUAjFyJ4WILLXn6uHMdPcpseR+66VpTWnJY8c7fzFMZucq++4k
         KGHF1qQJc8iXvf9DcSdE0303xFoHSAvnEu9sM3KCmjJ5AN+/VgLEUQrwTNrmhaY6g6
         2yicBlQHXpXFIXK2lVT0THAoZzgX98ZBbEgAYWaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: [PATCH 5.4 371/434] iommu/vt-d: Allocate reserved region for ISA with correct permission
Date:   Sun, 29 Dec 2019 18:27:04 +0100
Message-Id: <20191229172726.637712160@linuxfoundation.org>
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

From: Jerry Snitselaar <jsnitsel@redhat.com>

commit cde9319e884eb6267a0df446f3c131fe1108defb upstream.

Currently the reserved region for ISA is allocated with no
permissions. If a dma domain is being used, mapping this region will
fail. Set the permissions to DMA_PTE_READ|DMA_PTE_WRITE.

Cc: Joerg Roedel <jroedel@suse.de>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: stable@vger.kernel.org # v5.3+
Fixes: d850c2ee5fe2 ("iommu/vt-d: Expose ISA direct mapping region via iommu_get_resv_regions")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5697,7 +5697,7 @@ static void intel_iommu_get_resv_regions
 		struct pci_dev *pdev = to_pci_dev(device);
 
 		if ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA) {
-			reg = iommu_alloc_resv_region(0, 1UL << 24, 0,
+			reg = iommu_alloc_resv_region(0, 1UL << 24, prot,
 						   IOMMU_RESV_DIRECT_RELAXABLE);
 			if (reg)
 				list_add_tail(&reg->list, head);


