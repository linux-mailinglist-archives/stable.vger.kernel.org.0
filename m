Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15EF167331
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732464AbgBUIKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:10:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732453AbgBUIJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:09:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67C33222C4;
        Fri, 21 Feb 2020 08:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272598;
        bh=IDpon7Kel+MjWfOUEwoMjIHhIYdi6Oyu2TpugZYs3X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJC4cOKag59tbtLTXlpvPs9bMY2wtb7k4kWomT4Qbd6X6zN982uKDSUtoe0AIZgWh
         GPnCUBLV8DZI4w18CeEw5iXPmjn6AXAVa06SmHyrBAr9hRJ7gNp37hwO/bh7u7CRY6
         GrCsjqfaEWPqnS4ZkOAjkoSJ2F5rUFgWZ/awoByk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/344] bnxt: Detach page from page pool before sending up the stack
Date:   Fri, 21 Feb 2020 08:40:02 +0100
Message-Id: <20200221072407.533078487@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit 3071c51783b39d6a676d02a9256c3b3f87804285 ]

When running in XDP mode, pages come from the page pool, and should
be freed back to the same pool or specifically detached.  Currently,
when the driver re-initializes, the page pool destruction is delayed
forever since it thinks there are oustanding pages.

Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 41297533b4a86..68618891b0e42 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -942,6 +942,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 	dma_addr -= bp->rx_dma_offset;
 	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
 			     DMA_ATTR_WEAK_ORDERING);
+	page_pool_release_page(rxr->page_pool, page);
 
 	if (unlikely(!payload))
 		payload = eth_get_headlen(bp->dev, data_ptr, len);
-- 
2.20.1



