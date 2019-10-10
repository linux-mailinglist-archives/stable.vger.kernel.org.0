Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D80AD2373
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388598AbfJJImm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388593AbfJJIml (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:42:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91B6C2054F;
        Thu, 10 Oct 2019 08:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696961;
        bh=iWYDgRkJIH2M1HsFbcNkn3aCB9lB+OjRA7emx/q8cHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7p1bUdHCh2jod6pOaXdQ4TEm6AW4KUp3PD9HCEUQVhPo/BepAed9qdnT3pR3srfu
         vYAdBl6xJL+3+Prl8GKmb6UHstWn2w51Q5ytykoZKmNkfpwMCiZ9i8vhkuOJI2je5Y
         BYAUzORliAQO1nhXoGfKz1dw2JNIxycnycLJLlEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Dulea <adulea@amazon.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 115/148] iommu/amd: Fix downgrading default page-sizes in alloc_pte()
Date:   Thu, 10 Oct 2019 10:36:16 +0200
Message-Id: <20191010083618.068607397@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Dulea <adulea@amazon.de>

[ Upstream commit 6ccb72f8374e17d60b58a7bfd5570496332c54e2 ]

Downgrading an existing large mapping to a mapping using smaller
page-sizes works only for the mappings created with page-mode 7 (i.e.
non-default page size).

Treat large mappings created with page-mode 0 (i.e. default page size)
like a non-present mapping and allow to overwrite it in alloc_pte().

While around, make sure that we flush the TLB only if we change an
existing mapping, otherwise we might end up acting on garbage PTEs.

Fixes: 6d568ef9a622 ("iommu/amd: Allow downgrading page-sizes in alloc_pte()")
Signed-off-by: Andrei Dulea <adulea@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index e1259429ded2f..3b1d7ae6f75e0 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1490,6 +1490,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 		pte_level = PM_PTE_LEVEL(__pte);
 
 		if (!IOMMU_PTE_PRESENT(__pte) ||
+		    pte_level == PAGE_MODE_NONE ||
 		    pte_level == PAGE_MODE_7_LEVEL) {
 			page = (u64 *)get_zeroed_page(gfp);
 			if (!page)
@@ -1500,7 +1501,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 			/* pte could have been changed somewhere. */
 			if (cmpxchg64(pte, __pte, __npte) != __pte)
 				free_page((unsigned long)page);
-			else if (pte_level == PAGE_MODE_7_LEVEL)
+			else if (IOMMU_PTE_PRESENT(__pte))
 				domain->updated = true;
 
 			continue;
-- 
2.20.1



