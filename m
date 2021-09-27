Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D01C419C38
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhI0R0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238063AbhI0RYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:24:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F153D61406;
        Mon, 27 Sep 2021 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762941;
        bh=V8QBZXTM6IlzafIwE8mDu6or0szhcE8lQfbwd5h45vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GycGqs7QVAyjz1TYjrnOuuAlgXhROXT2JeT6oe7RqlYiWrIEJYm7KcqgpTl8SrgZ2
         531dKVhnFfEEDCXHNjEx63vdeVTmPsrktbsB0qZLBgmoC4nBeo3usxZ/U9bi+YPJs7
         Z1W3AW/LZgBOeJ85MgWF36csuWgzbpXgijCTY6QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 091/162] drm/amdkfd: fix dma mapping leaking warning
Date:   Mon, 27 Sep 2021 19:02:17 +0200
Message-Id: <20210927170236.588991777@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit f63251184a81039ebc805306505838c2a073e51a ]

For xnack off, restore work dma unmap previous system memory page, and
dma map the updated system memory page to update GPU mapping, this is
not dma mapping leaking, remove the WARN_ONCE for dma mapping leaking.

prange->dma_addr store the VRAM page pfn after the range migrated to
VRAM, should not dma unmap VRAM page when updating GPU mapping or
remove prange. Add helper svm_is_valid_dma_mapping_addr to check VRAM
page and error cases.

Mask out SVM_RANGE_VRAM_DOMAIN flag in dma_addr before calling amdgpu vm
update to avoid BUG_ON(*addr & 0xFFFF00000000003FULL), and set it again
immediately after. This flag is used to know the type of page later to
dma unmapping system memory page.

Fixes: 1d5dbfe6c06a ("drm/amdkfd: classify and map mixed svm range pages in GPU")
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index ddac10b5bd3a..e85035fd1ccb 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -118,6 +118,13 @@ static void svm_range_remove_notifier(struct svm_range *prange)
 		mmu_interval_notifier_remove(&prange->notifier);
 }
 
+static bool
+svm_is_valid_dma_mapping_addr(struct device *dev, dma_addr_t dma_addr)
+{
+	return dma_addr && !dma_mapping_error(dev, dma_addr) &&
+	       !(dma_addr & SVM_RANGE_VRAM_DOMAIN);
+}
+
 static int
 svm_range_dma_map_dev(struct amdgpu_device *adev, struct svm_range *prange,
 		      unsigned long offset, unsigned long npages,
@@ -139,8 +146,7 @@ svm_range_dma_map_dev(struct amdgpu_device *adev, struct svm_range *prange,
 
 	addr += offset;
 	for (i = 0; i < npages; i++) {
-		if (WARN_ONCE(addr[i] && !dma_mapping_error(dev, addr[i]),
-			      "leaking dma mapping\n"))
+		if (svm_is_valid_dma_mapping_addr(dev, addr[i]))
 			dma_unmap_page(dev, addr[i], PAGE_SIZE, dir);
 
 		page = hmm_pfn_to_page(hmm_pfns[i]);
@@ -209,7 +215,7 @@ void svm_range_dma_unmap(struct device *dev, dma_addr_t *dma_addr,
 		return;
 
 	for (i = offset; i < offset + npages; i++) {
-		if (!dma_addr[i] || dma_mapping_error(dev, dma_addr[i]))
+		if (!svm_is_valid_dma_mapping_addr(dev, dma_addr[i]))
 			continue;
 		pr_debug("dma unmapping 0x%llx\n", dma_addr[i] >> PAGE_SHIFT);
 		dma_unmap_page(dev, dma_addr[i], PAGE_SIZE, dir);
@@ -1165,7 +1171,7 @@ svm_range_map_to_gpu(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 	unsigned long last_start;
 	int last_domain;
 	int r = 0;
-	int64_t i;
+	int64_t i, j;
 
 	last_start = prange->start + offset;
 
@@ -1201,6 +1207,10 @@ svm_range_map_to_gpu(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 						NULL, dma_addr,
 						&vm->last_update,
 						&table_freed);
+
+		for (j = last_start - prange->start; j <= i; j++)
+			dma_addr[j] |= last_domain;
+
 		if (r) {
 			pr_debug("failed %d to map to gpu 0x%lx\n", r, prange->start);
 			goto out;
-- 
2.33.0



