Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F6717FB07
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbgCJNKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730947AbgCJNKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:10:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46D2C246D9;
        Tue, 10 Mar 2020 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845808;
        bh=FLADw+GKBExK9ezf3kJ+0wVCGT6MykYNqQ0rey0KKok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6M/4ZaOUyBWycx1ajxa1CMOhseGrTH3Kub1R9SlF2BP3i8H6QANpYer9XsM9NCY8
         PdyKxpEGt4OSVBf0YkRqZxfGdIKG2uhSef6InmLakNusMJAiKiwjVuvFK3Q90GQ0Rd
         UIWUIl5TiuXzYC0byFHb7KOndM0U3dLXPQ+d9q+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 108/126] dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list
Date:   Tue, 10 Mar 2020 13:42:09 +0100
Message-Id: <20200310124210.489864389@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit c33ee1301c393a241d6424e36eff1071811b1064 upstream.

The interrupt handler puts a half-completed DMA descriptor on a free list
and then schedules tasklet to process bottom half of the descriptor that
executes client's callback, this creates possibility to pick up the busy
descriptor from the free list. Thus, let's disallow descriptor's re-use
until it is fully processed.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200209163356.6439-3-digetx@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/tegra20-apb-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -288,7 +288,7 @@ static struct tegra_dma_desc *tegra_dma_
 
 	/* Do not allocate if desc are waiting for ack */
 	list_for_each_entry(dma_desc, &tdc->free_dma_desc, node) {
-		if (async_tx_test_ack(&dma_desc->txd)) {
+		if (async_tx_test_ack(&dma_desc->txd) && !dma_desc->cb_count) {
 			list_del(&dma_desc->node);
 			spin_unlock_irqrestore(&tdc->lock, flags);
 			dma_desc->txd.flags = 0;


