Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8189CF64E2
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfKJCsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:48:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729327AbfKJCsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:48:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6161422573;
        Sun, 10 Nov 2019 02:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354132;
        bh=ekjUL9iEKKF0msi9brH469zdJuKPgU6PU/D6LgKa3SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iluuvFwOyTcb2MUUd31672baK6BvMk2EzqFbSk4Y6gYJtBFzW/BxBItspwcEM4KJ7
         qiqBXiCxQPYUDJGPVzvBuLwqeVhIY/pTeVUhV0+PauSzvpzFIo7vLpGwYRE9J6Eg7K
         MrmKgLvTEOr9VUIMzrOVccr3O2rHeWCMDNdT7Xwg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Breno Leitao <leitao@debian.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 04/66] powerpc/iommu: Avoid derefence before pointer check
Date:   Sat,  9 Nov 2019 21:47:43 -0500
Message-Id: <20191110024846.32598-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 984ecdd68de0fa1f63ce205d6c19ef5a7bc67b40 ]

The tbl pointer is being derefenced by IOMMU_PAGE_SIZE prior the check
if it is not NULL.

Just moving the dereference code to after the check, where there will
be guarantee that 'tbl' will not be NULL.

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 5f202a566ec5f..9bfdd2510fd5e 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -765,9 +765,9 @@ dma_addr_t iommu_map_page(struct device *dev, struct iommu_table *tbl,
 
 	vaddr = page_address(page) + offset;
 	uaddr = (unsigned long)vaddr;
-	npages = iommu_num_pages(uaddr, size, IOMMU_PAGE_SIZE(tbl));
 
 	if (tbl) {
+		npages = iommu_num_pages(uaddr, size, IOMMU_PAGE_SIZE(tbl));
 		align = 0;
 		if (tbl->it_page_shift < PAGE_SHIFT && size >= PAGE_SIZE &&
 		    ((unsigned long)vaddr & ~PAGE_MASK) == 0)
-- 
2.20.1

