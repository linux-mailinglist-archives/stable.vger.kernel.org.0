Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40803507A1
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbfFXKIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbfFXKIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:08:37 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA0A1214DA;
        Mon, 24 Jun 2019 10:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370916;
        bh=hwX8jqJDODpfp7mZIgOC0uQF0I4HYA6THLExm7VxaZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zj44TLBz970hpFdmFv4vDdAckkIUVfWfwRdmT9Jkc3gofXvwVJIACdo5gzwDIVobV
         XpulnrZt5TOJ2WJePqMFIe2RE6OACnKci0TqQNM03SIIJ5Czad/iq4dAz5mg9eJ2YS
         FqHDbwOK8yeSRsbJgncVntpvIt3PWvMgQtqqkmq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 049/121] habanalabs: fix bug in checking huge page optimization
Date:   Mon, 24 Jun 2019 17:56:21 +0800
Message-Id: <20190624092323.261803905@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



