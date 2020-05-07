Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEE91C9036
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgEGO1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgEGO1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:27:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 149052084D;
        Thu,  7 May 2020 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861655;
        bh=3l+OqPkT9XKfyeX0lxDdjvyXUc/liQWx6S4UZK0lAMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAzc/daYx15gUcN9WkSaK1Gz0Gr5ooelVbEm3dw2WM/SC41pg2CV1wJpvtqvlHtpW
         OOIPgDtvlVXvoNb9JFVX2t3f/ju1bFByMUMQNjNl+nVqQeNBJxZzO3fkCJ4Xa4CjJf
         G0G8trW4hXfH/Uoe1H4Ng6eTpfinn43EYIrO6/VM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 07/50] vfio: avoid possible overflow in vfio_iommu_type1_pin_pages
Date:   Thu,  7 May 2020 10:26:43 -0400
Message-Id: <20200507142726.25751-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
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
index a177bf2c66834..ec9be79ba2d79 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -554,7 +554,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 			continue;
 		}
 
-		remote_vaddr = dma->vaddr + iova - dma->iova;
+		remote_vaddr = dma->vaddr + (iova - dma->iova);
 		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
 					     do_accounting);
 		if (ret)
-- 
2.20.1

