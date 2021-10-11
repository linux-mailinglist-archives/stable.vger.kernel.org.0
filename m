Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8CB428F8D
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbhJKN7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236894AbhJKN54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C713360E8B;
        Mon, 11 Oct 2021 13:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960470;
        bh=4RKgkISkbESJlFhvG4on8itP+82lxqG4cBxbchGuLV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znPj3isn2JtSy/Xt4VpPU6zxH+y/fs8S+V6mPMwUdiY0kln0weD3l7m2d/cROKF6P
         Kno4slJ7vBYUTFDGLKlw7QQBCFjMrBRvoWmGxNcF6DcGLiaDuRzlA5NLaMxBso3a+z
         rNvfCd+H9n13fVsElyh3lIpAllTYDUTlkkYbvPJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 67/83] powerpc/iommu: Report the correct most efficient DMA mask for PCI devices
Date:   Mon, 11 Oct 2021 15:46:27 +0200
Message-Id: <20211011134510.700666693@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 23c216b335d1fbd716076e8263b54a714ea3cf0e ]

According to dma-api.rst, the dma_get_required_mask() helper should return
"the mask that the platform requires to operate efficiently". Which in
the case of PPC64 means the bypass mask and not a mask from an IOMMU table
which is shorter and slower to use due to map/unmap operations (especially
expensive on "pseries").

However the existing implementation ignores the possibility of bypassing
and returns the IOMMU table mask on the pseries platform which makes some
drivers (mpt3sas is one example) choose 32bit DMA even though bypass is
supported. The powernv platform sort of handles it by having a bigger
default window with a mask >=40 but it only works as drivers choose
63/64bit if the required mask is >32 which is rather pointless.

This reintroduces the bypass capability check to let drivers make
a better choice of the DMA mask.

Fixes: f1565c24b596 ("powerpc: use the generic dma_ops_bypass mode")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210930034454.95794-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/dma-iommu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index a1c744194018..9ac0651795cf 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -117,6 +117,15 @@ u64 dma_iommu_get_required_mask(struct device *dev)
 	struct iommu_table *tbl = get_iommu_table_base(dev);
 	u64 mask;
 
+	if (dev_is_pci(dev)) {
+		u64 bypass_mask = dma_direct_get_required_mask(dev);
+
+		if (dma_iommu_dma_supported(dev, bypass_mask)) {
+			dev_info(dev, "%s: returning bypass mask 0x%llx\n", __func__, bypass_mask);
+			return bypass_mask;
+		}
+	}
+
 	if (!tbl)
 		return 0;
 
-- 
2.33.0



