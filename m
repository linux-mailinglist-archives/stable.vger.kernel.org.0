Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC92246C71
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbgHQQQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731080AbgHQQQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:16:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C60A20658;
        Mon, 17 Aug 2020 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680942;
        bh=OtTp3PyblAUp8Wp+dnJEmCKgocH/UUyepd5ozcYHdiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHltiM7LoZAAaRUnZuTl+pn5quMKxjQ9GT5WQV0KCqNAz7w0qbbFnSNfiNHeUVhPt
         c70qjJg0lzCGoPNof+lyTafJuVxLcy/tZzeziB2ntokyFEYEo9zknM+XMkrVV2noYL
         +q2/OjgahVjSVUrrs0TSexo8nCNCdPTC99CcZ3fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/168] net: spider_net: Fix the size used in a dma_free_coherent() call
Date:   Mon, 17 Aug 2020 17:17:30 +0200
Message-Id: <20200817143739.620295702@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 36f28f7687a9ce665479cce5d64ce7afaa9e77ae ]

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()', in
'spider_net_init_chain()'.

Fixes: d4ed8f8d1fb7 ("Spidernet DMA coalescing")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/toshiba/spider_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 23417266b7ecc..e66014e0427f7 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -296,8 +296,8 @@ spider_net_free_chain(struct spider_net_card *card,
 		descr = descr->next;
 	} while (descr != chain->ring);
 
-	dma_free_coherent(&card->pdev->dev, chain->num_desc,
-	    chain->hwring, chain->dma_addr);
+	dma_free_coherent(&card->pdev->dev, chain->num_desc * sizeof(struct spider_net_hw_descr),
+			  chain->hwring, chain->dma_addr);
 }
 
 /**
-- 
2.25.1



