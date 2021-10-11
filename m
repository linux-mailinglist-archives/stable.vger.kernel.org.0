Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6141C4290BC
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbhJKOMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238737AbhJKOJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:09:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 356AB61152;
        Mon, 11 Oct 2021 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960933;
        bh=8HvAYNZiwdKdHQpmMzvvq6qGMizidtyT/yMhcaQoOJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhYQO3ZCmi8JcYpL4dFdFSFFoYS3ZJ9Y+YZ+MjPXmX7v6lFiiQln/RU7XzAoZVQA4
         Ec9lcx7SD4ny9XDp/aKblCFiZ16KHuC+DiLVFctNcQlZkMhwgsm1n9hiO9/h9FRFCk
         PgskKmoFhWP/0ql8WHgYql1aLRxg7zd2o6BrHIOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 118/151] powerpc/iommu: Report the correct most efficient DMA mask for PCI devices
Date:   Mon, 11 Oct 2021 15:46:30 +0200
Message-Id: <20211011134521.636910296@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
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
index 111249fd619d..038ce8d9061d 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -184,6 +184,15 @@ u64 dma_iommu_get_required_mask(struct device *dev)
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



