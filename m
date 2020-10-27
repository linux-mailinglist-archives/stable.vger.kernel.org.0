Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DEF29B531
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793934AbgJ0PJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793916AbgJ0PJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:09:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E074C206F4;
        Tue, 27 Oct 2020 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811349;
        bh=xY4tDXnwwKQuGgM7gkuKXttAzi3VIUbCG+AB6r+fZOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7HO0PitKK09giS5xN6yhLe62H/aN6N1wK2+WEXsvf6QfBQs2m+D2Ja6fFv51c1n8
         1M+TczU4Ju/xZVkhWrDYGH0Dg1FJ0VAdTcWt6sTnJhjoN9GCytPVuJtSjgn+dfPino
         WnCywUeVXjp3T6XRTv6ApzLy5s5sxjVUcJbhdD4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoyang Xu <xuxiaoyang2@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 462/633] vfio iommu type1: Fix memory leak in vfio_iommu_type1_pin_pages
Date:   Tue, 27 Oct 2020 14:53:25 +0100
Message-Id: <20201027135544.395337555@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoyang Xu <xuxiaoyang2@huawei.com>

[ Upstream commit 2e6cfd496f5b57034cf2aec738799571b5a52124 ]

pfn is not added to pfn_list when vfio_add_to_pfn_list fails.
vfio_unpin_page_external will exit directly without calling
vfio_iova_put_vfio_pfn.  This will lead to a memory leak.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>
[aw: simplified logic, add Fixes]
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index eb7bb14e4f62a..00d3cf12e92c3 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -693,7 +693,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
 		if (ret) {
-			vfio_unpin_page_external(dma, iova, do_accounting);
+			if (put_pfn(phys_pfn[i], dma->prot) && do_accounting)
+				vfio_lock_acct(dma, -1, true);
 			goto pin_unwind;
 		}
 
-- 
2.25.1



