Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189F61C8FDD
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgEGOfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbgEGO2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B17ED21473;
        Thu,  7 May 2020 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861715;
        bh=qk7tSIhT4NHOa1YS8VMGgGrRgUSkVbypKJoUjlDwgGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDJf3jvJKHfI/u82RU0bn0OMaQ7DqQ7WmvxNzg9r/YGTMkia0MEtd7a5yiRX/tdcI
         LyDPui42/JED08ND86I/oYtdeRGdDjvwpTPX56Lv0qWvXX+P2R/LQaHYYoihJSIBKr
         Ond6pO0Utnj4h7QZ/ASKMjESCkXwYokD9jjouGPE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/35] vfio: avoid possible overflow in vfio_iommu_type1_pin_pages
Date:   Thu,  7 May 2020 10:27:58 -0400
Message-Id: <20200507142830.26239-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
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
index d864277ea16f3..f471600985ff7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -593,7 +593,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 			continue;
 		}
 
-		remote_vaddr = dma->vaddr + iova - dma->iova;
+		remote_vaddr = dma->vaddr + (iova - dma->iova);
 		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
 					     do_accounting);
 		if (ret)
-- 
2.20.1

