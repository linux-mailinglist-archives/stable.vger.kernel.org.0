Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FFF2F798B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733303AbhAOMhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbhAOMhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F40F323136;
        Fri, 15 Jan 2021 12:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714257;
        bh=Aur8r4zcMCdQyAcmwoktwnLpJDw3XiEOAVoyvjVo9yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdpJ5ljz/+2Mm/vBvRGKHoVhH3SqIEa53QyX4hM0lI/RbL3p/0R78ux/e/3/6cAU9
         ATi+vdQ2iHgXegPpiQeA6sXg8w9k7X32uupxejckmWExFVfp897lipQ53JyQyOAM8s
         n6n73MexZ9g9aEHcpBYHYcNy6DMvCPWo9VzUziN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 054/103] dmaengine: dw-edma: Fix use after free in dw_edma_alloc_chunk()
Date:   Fri, 15 Jan 2021 13:27:47 +0100
Message-Id: <20210115122008.667193692@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 595a334148449bd1d27cf5d6fcb3b0d718cb1b9f upstream.

If the dw_edma_alloc_burst() function fails then we free "chunk" but
it's still on the "desc->chunk->list" list so it will lead to a use
after free.  Also the "->chunks_alloc" count is incremented when it
shouldn't be.

In current kernels small allocations are guaranteed to succeed and
dw_edma_alloc_burst() can't fail so this will not actually affect
runtime.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
Link: https://lore.kernel.org/r/X9dTBFrUPEvvW7qc@mwanda
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dw-edma/dw-edma-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -86,12 +86,12 @@ static struct dw_edma_chunk *dw_edma_all
 
 	if (desc->chunk) {
 		/* Create and add new element into the linked list */
-		desc->chunks_alloc++;
-		list_add_tail(&chunk->list, &desc->chunk->list);
 		if (!dw_edma_alloc_burst(chunk)) {
 			kfree(chunk);
 			return NULL;
 		}
+		desc->chunks_alloc++;
+		list_add_tail(&chunk->list, &desc->chunk->list);
 	} else {
 		/* List head */
 		chunk->burst = NULL;


