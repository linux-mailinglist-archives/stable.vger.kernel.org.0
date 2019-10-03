Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F88CA940
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404843AbfJCQje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404349AbfJCQjc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:39:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D71802070B;
        Thu,  3 Oct 2019 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120772;
        bh=AW86f9tuNuQ3Cckl92NcJjBerWskZPFWFXKAJraaCrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uU/Xa3pnYXjO/ILDncDNt5Ga3xngk6VsUczTQgVg7pFYV593Bcja7bOkKxhmIBkG9
         zC+1jUxKFDi3ADBfLD3aojD1ByZNGcgMvuRwi3gyktEZvpVY/wyFVmbptlp97UUOl+
         jks4JKyZoNOVvXzmVdh/NY3nUfACwMiNEWOEvgdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 009/344] net: stmmac: Fix page pool size
Date:   Thu,  3 Oct 2019 17:49:34 +0200
Message-Id: <20191003154541.001833168@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 4f28bd956e081fc018fe9b41ffa31573f17bfb61 ]

The size of individual pages in the page pool in given by an order. The
order is the binary logarithm of the number of pages that make up one of
the pages in the pool. However, the driver currently passes the number
of pages rather than the order, so it ends up wasting quite a bit of
memory.

Fix this by taking the binary logarithm and passing that in the order
field.

Fixes: 2af6106ae949 ("net: stmmac: Introducing support for Page Pool")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1532,13 +1532,15 @@ static int alloc_dma_rx_desc_resources(s
 	for (queue = 0; queue < rx_count; queue++) {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 		struct page_pool_params pp_params = { 0 };
+		unsigned int num_pages;
 
 		rx_q->queue_index = queue;
 		rx_q->priv_data = priv;
 
 		pp_params.flags = PP_FLAG_DMA_MAP;
 		pp_params.pool_size = DMA_RX_SIZE;
-		pp_params.order = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+		num_pages = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+		pp_params.order = ilog2(num_pages);
 		pp_params.nid = dev_to_node(priv->device);
 		pp_params.dev = priv->device;
 		pp_params.dma_dir = DMA_FROM_DEVICE;


