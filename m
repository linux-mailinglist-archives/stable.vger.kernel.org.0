Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A929D167626
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732331AbgBUIJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:09:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732183AbgBUIJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:09:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 572EB20722;
        Fri, 21 Feb 2020 08:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272558;
        bh=IL0DlRLZwPFnTOfxoGC0+a/kYVgGNy0nkZp7u869IZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/ekA8uLFdbuxygQlg21NwYsnUi2CQ8lDKp3S5/j8ToZlhgYc2CbkvvRrHQTBUf+w
         RotKfH4nPGUOT5K80vQmsTItq/dVCKZtjo8WcyYVS98Hsu4tEYdR3XhyRJCmiVvxBQ
         RenVJNbU7qlV0Ho3ZufDrvNf07Irs670uB6eDSEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/344] vfio/spapr/nvlink2: Skip unpinning pages on error exit
Date:   Fri, 21 Feb 2020 08:39:40 +0100
Message-Id: <20200221072405.436944838@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 338b4e10f939a71194d8ecef7ece205a942cec05 ]

The nvlink2 subdriver for IBM Witherspoon machines preregisters
GPU memory in the IOMMI API so KVM TCE code can map this memory
for DMA as well. This is done by mm_iommu_newdev() called from
vfio_pci_nvgpu_regops::mmap.

In an unlikely event of failure the data->mem remains NULL and
since mm_iommu_put() (which unregisters the region and unpins memory
if that was regular memory) does not expect mem=NULL, it should not be
called.

This adds a check to only call mm_iommu_put() for a valid data->mem.

Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] subdriver")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_nvlink2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index f2983f0f84bea..3f5f8198a6bb1 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -97,8 +97,10 @@ static void vfio_pci_nvgpu_release(struct vfio_pci_device *vdev,
 
 	/* If there were any mappings at all... */
 	if (data->mm) {
-		ret = mm_iommu_put(data->mm, data->mem);
-		WARN_ON(ret);
+		if (data->mem) {
+			ret = mm_iommu_put(data->mm, data->mem);
+			WARN_ON(ret);
+		}
 
 		mmdrop(data->mm);
 	}
-- 
2.20.1



