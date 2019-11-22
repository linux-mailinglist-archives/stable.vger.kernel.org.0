Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B669106A48
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfKVKde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfKVKdc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:33:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E1D20708;
        Fri, 22 Nov 2019 10:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418812;
        bh=NYn043bx4MnFOiz3nSb2ma/6pRSTOnBpZQfujKJhvyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mY1zU4dqTsIthZlRiBQ4ccgOBSVhkUyUhz7cO1CRo8XoBaYEgNT6A43yP8sHBFlA0
         P+vNqqfoszqprsfTfIF6dnyYfj1JQN9/UlGCmvuB35VNh4OPj8idBH2YZ4Oyk2+4vE
         BnSEbe5lr5lZ62qTsgggcGsx8gqkB+esJ5iCxD/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Breno Leitao <leitao@debian.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 059/159] powerpc/iommu: Avoid derefence before pointer check
Date:   Fri, 22 Nov 2019 11:27:30 +0100
Message-Id: <20191122100750.400464968@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a8e3490b54e3b..4c9b5970af371 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -764,9 +764,9 @@ dma_addr_t iommu_map_page(struct device *dev, struct iommu_table *tbl,
 
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



