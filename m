Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D672F7AF0
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbhAOMex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387533AbhAOMev (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:34:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19A7B23359;
        Fri, 15 Jan 2021 12:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714076;
        bh=UzfAEKJY8rc8SY6lA7OSso4IDYsVqTBY144XalJuV+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBevTQo5efaq2jNxAf2R9CVIjhtddCPjFHRyPvUUI1x0fYmjDs19q/9icU18uy5kw
         OuLcGeWwMZjtPAX/DsCYbPZqJH/OLzd1W/c7phAYxahSZ1bS3SlZRPDhpsI17leCxN
         mBD26JacSEoyqfDNCmcEF+zKm1SEThK6y2r1lDKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 35/62] dmaengine: dw-edma: Fix use after free in dw_edma_alloc_chunk()
Date:   Fri, 15 Jan 2021 13:27:57 +0100
Message-Id: <20210115122000.092494711@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
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
@@ -85,12 +85,12 @@ static struct dw_edma_chunk *dw_edma_all
 
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


