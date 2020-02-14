Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CC415ED04
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390715AbgBNRbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:31:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390598AbgBNQHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B0852067D;
        Fri, 14 Feb 2020 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696430;
        bh=IL0DlRLZwPFnTOfxoGC0+a/kYVgGNy0nkZp7u869IZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmXwT/mB2UEieua5DL0roq3cZK3dnZ1UwM0hpPCF4Tz8TRmot9wS8TjEPUTSOtD59
         ThD+JL0t3DGJKaeSh2ob5iqV/2oryxV0d5wz9zJxt8GUa12Kwa6vlZEz9ZytWfupIc
         zK1MZBYkQywzpDe/NahSHdQIxkmIWs0Bkt/4Jnks=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 249/459] vfio/spapr/nvlink2: Skip unpinning pages on error exit
Date:   Fri, 14 Feb 2020 10:58:19 -0500
Message-Id: <20200214160149.11681-249-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

