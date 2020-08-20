Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D95624B9D6
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbgHTLzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729773AbgHTKCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:02:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F3622173E;
        Thu, 20 Aug 2020 10:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917742;
        bh=FtQK3OuT05MKO0BrAWzqDNrKA75UHoJT3HbAFAWALMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SycUWgLtChkg9mO+4o5dHAxEoq7d08xxnXPhS1NuS1H7kipqpDayUI3CIvdGhHp+J
         8ogSUfHR6/6CKv8QkpkO6FduvjIb8+dPmGpeUgh6Er/tyHhAIz8rpIvwWyeomLPXDg
         mO3Q7tPhoUWX49w6pr8xpVvovnDcZ9MD1NT3afEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 142/212] net: spider_net: Fix the size used in a dma_free_coherent() call
Date:   Thu, 20 Aug 2020 11:21:55 +0200
Message-Id: <20200820091609.520632077@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
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
index 1085987946212..9507ca2e02acd 100644
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



