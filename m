Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B33406187
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhIJAnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232374AbhIJASz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C44CA6120F;
        Fri, 10 Sep 2021 00:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233048;
        bh=S0fKkRoX8OM+lseDySOUOxA9WY08+Gq3ZQnlBa7LJTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqPEZPYZoOmKw+Val1MlwV/VKAGw2r/YgUIcJ+lVoILuNBOwsPVI/dp9CRuOHf91B
         D0g85j/rlJ+/Wl5D1c8fQnRIEiyVbRUvGW2K4XZ7yujtdwVno2yef+Q6iH3Agy/RdH
         oa98XUsSCpxmoHdgMnkzurxyaxMh2WKvySbIDgrURpuXR/gsw4rPCE7c9aizsWMVNO
         bvCkMPv49yK335MXgTzyREJHnKBk0FFHK5rm4HiCqDp4Wgqk15dAsWzOr+U+mXIkHz
         KSFuKA7shVo/XM16tJ1cBtb8RJGmpkMT5PBlgX6vxwDu/T4EAPiGsOMcgxq1sDECMc
         4jh0jgxhjANoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Yznaga <anthony.yznaga@oracle.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 65/99] vfio/type1: Fix vfio_find_dma_valid return
Date:   Thu,  9 Sep 2021 20:15:24 -0400
Message-Id: <20210910001558.173296-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Yznaga <anthony.yznaga@oracle.com>

[ Upstream commit ffc95d1b8edb80d2dab77f2e8a823c8d93b06419 ]

vfio_find_dma_valid is defined to return WAITED on success if it was
necessary to wait.  However, the loop forgets the WAITED value returned
by vfio_wait() and returns 0 in a later iteration.  Fix it.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Reviewed-by: Steve Sistare <steven.sistare@oracle.com>
Link: https://lore.kernel.org/r/1629736550-2388-1-git-send-email-anthony.yznaga@oracle.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4f7c174c7a..0e9217687f5c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -612,17 +612,17 @@ static int vfio_wait(struct vfio_iommu *iommu)
 static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
 			       size_t size, struct vfio_dma **dma_p)
 {
-	int ret;
+	int ret = 0;
 
 	do {
 		*dma_p = vfio_find_dma(iommu, start, size);
 		if (!*dma_p)
-			ret = -EINVAL;
+			return -EINVAL;
 		else if (!(*dma_p)->vaddr_invalid)
-			ret = 0;
+			return ret;
 		else
 			ret = vfio_wait(iommu);
-	} while (ret > 0);
+	} while (ret == WAITED);
 
 	return ret;
 }
-- 
2.30.2

