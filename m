Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6130383CCC
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfHFVd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbfHFVd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:33:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E160F217F4;
        Tue,  6 Aug 2019 21:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127207;
        bh=9ROhGXK6rd4BaOKuMuPMhYS46hgPSYfBc0TGKxduK+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGYpMKK6/tkud0U+Iu8DI+se9agLP045bN6ncjz9iDJUEOOylxEVF6MrIe5ImGM9x
         zacQXbzoxvaeGGznUEqf4IiPgFIAew2Xexx/A15NGKPxfd095Nl5u2Bzg01p2Y/ALh
         C3T+HyGEL8cCifDdLqDO7l6f9hGMrWdc6JnISWc4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.2 06/59] dma-mapping: check pfn validity in dma_common_{mmap,get_sgtable}
Date:   Tue,  6 Aug 2019 17:32:26 -0400
Message-Id: <20190806213319.19203-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 66d7780f18eae0232827fcffeaded39a6a168236 ]

Check that the pfn returned from arch_dma_coherent_to_pfn refers to
a valid page and reject the mmap / get_sgtable requests otherwise.

Based on the arm implementation of the mmap and get_sgtable methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/mapping.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index f7afdadb6770b..3401382bbca2f 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -116,11 +116,16 @@ int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
 	int ret;
 
 	if (!dev_is_dma_coherent(dev)) {
+		unsigned long pfn;
+
 		if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_COHERENT_TO_PFN))
 			return -ENXIO;
 
-		page = pfn_to_page(arch_dma_coherent_to_pfn(dev, cpu_addr,
-				dma_addr));
+		/* If the PFN is not valid, we do not have a struct page */
+		pfn = arch_dma_coherent_to_pfn(dev, cpu_addr, dma_addr);
+		if (!pfn_valid(pfn))
+			return -ENXIO;
+		page = pfn_to_page(pfn);
 	} else {
 		page = virt_to_page(cpu_addr);
 	}
@@ -170,7 +175,11 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 	if (!dev_is_dma_coherent(dev)) {
 		if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_COHERENT_TO_PFN))
 			return -ENXIO;
+
+		/* If the PFN is not valid, we do not have a struct page */
 		pfn = arch_dma_coherent_to_pfn(dev, cpu_addr, dma_addr);
+		if (!pfn_valid(pfn))
+			return -ENXIO;
 	} else {
 		pfn = page_to_pfn(virt_to_page(cpu_addr));
 	}
-- 
2.20.1

