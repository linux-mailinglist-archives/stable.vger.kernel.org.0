Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DDC1C8EC4
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgEGO3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728515AbgEGO3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E58EF2083B;
        Thu,  7 May 2020 14:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861761;
        bh=DPE8s2oC1JMVuEkSyn2rkj3IAwdAdBt9u5pz3lRE9H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oA7gIpzUi8r7+b4dXU3AoiEsb2cCBe6WAov+Tk8ArCE2ydiTH3NJKgnvQCh+ozwsg
         FH3nsNAHLmb6lkMpm6E822VD6Ks2QayJsxOAJQ8SGA6clmVKW+4RCB4GK4aTe2Vbii
         WDqOUry13SkzqQ4YMgeH7jKS78MAf5IdJ9FET7Ow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/20] vfio: avoid possible overflow in vfio_iommu_type1_pin_pages
Date:   Thu,  7 May 2020 10:28:59 -0400
Message-Id: <20200507142917.26612-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142917.26612-1-sashal@kernel.org>
References: <20200507142917.26612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

[ Upstream commit 0ea971f8dcd6dee78a9a30ea70227cf305f11ff7 ]

add parentheses to avoid possible vaddr overflow.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c362757540866..c635ba3167f7b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -598,7 +598,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 			continue;
 		}
 
-		remote_vaddr = dma->vaddr + iova - dma->iova;
+		remote_vaddr = dma->vaddr + (iova - dma->iova);
 		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
 					     do_accounting);
 		if (ret)
-- 
2.20.1

