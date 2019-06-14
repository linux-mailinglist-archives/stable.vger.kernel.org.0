Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A30446AC0
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfFNU3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbfFNU3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:02 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F3A21852;
        Fri, 14 Jun 2019 20:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544141;
        bh=ymfTA8TIc50PZWNkDWCca0LUE+32hCvRBt8FdyzzDh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZI0jj/xjAyGd5VIEMWxUSX0oqAdyrYw/qQ+pLy+pNnb9gshOAqyC/zzFxjVMYhA6
         WD3hzOCNv8qEpiMtjzt+EwpAPvtDY0pCFbMwB2xwiajn7+Pqng+8SWoLDv76OS8mzH
         9BRNvglI4kG/7z0KLFk5/SvhOQVljLqrsAD7X/2g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 20/59] habanalabs: fix bug in checking huge page optimization
Date:   Fri, 14 Jun 2019 16:28:04 -0400
Message-Id: <20190614202843.26941-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>

[ Upstream commit d724170160f800fa8dfd3c0cdebb8b093570b504 ]

This patch fix a bug in the mmu code that checks whether we can use huge
page mappings for host pages.

The code is supposed to enable huge page mappings only if ALL DMA
addresses are aligned to 2MB AND the number of pages in each DMA chunk is
a modulo of the number of pages in 2MB. However, the code ignored the
first requirement for the first DMA chunk.

This patch fix that issue by making sure the requirement of address
alignment is validated against all DMA chunks.

Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/memory.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/misc/habanalabs/memory.c b/drivers/misc/habanalabs/memory.c
index fadaf557603f..425442819d31 100644
--- a/drivers/misc/habanalabs/memory.c
+++ b/drivers/misc/habanalabs/memory.c
@@ -675,11 +675,6 @@ static int init_phys_pg_pack_from_userptr(struct hl_ctx *ctx,
 
 		total_npages += npages;
 
-		if (first) {
-			first = false;
-			dma_addr &= PAGE_MASK_2MB;
-		}
-
 		if ((npages % PGS_IN_2MB_PAGE) ||
 					(dma_addr & (PAGE_SIZE_2MB - 1)))
 			is_huge_page_opt = false;
@@ -704,7 +699,6 @@ static int init_phys_pg_pack_from_userptr(struct hl_ctx *ctx,
 	phys_pg_pack->total_size = total_npages * page_size;
 
 	j = 0;
-	first = true;
 	for_each_sg(userptr->sgt->sgl, sg, userptr->sgt->nents, i) {
 		npages = get_sg_info(sg, &dma_addr);
 
-- 
2.20.1

