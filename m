Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C17816778B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgBUHxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:53:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730125AbgBUHxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:53:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34A224653;
        Fri, 21 Feb 2020 07:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271617;
        bh=TR7zXGPKrRyVAFY0prVY1a+2it4hknv8ec1MtPqoews=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr6bVFqvv1/D+O6vbPltiQK1y4Cu6LX+jg6dxIHXzVMETXO7dV1lg6O6ltkiFqhwB
         8DCz/RjalCvzhN/NFaYPskSGa6k2vQ+EYDXBM15iuafpdhlzxHuyE2texzc6TCc7DO
         691l86hMUVurm/0FXQv5MoTx8OzONzQBEpVP2ius=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 232/399] bnxt: Detach page from page pool before sending up the stack
Date:   Fri, 21 Feb 2020 08:39:17 +0100
Message-Id: <20200221072425.313970278@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
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
index 01b603c5e76ad..9d62200b6c335 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -944,6 +944,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 	dma_addr -= bp->rx_dma_offset;
 	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
 			     DMA_ATTR_WEAK_ORDERING);
+	page_pool_release_page(rxr->page_pool, page);
 
 	if (unlikely(!payload))
 		payload = eth_get_headlen(bp->dev, data_ptr, len);
-- 
2.20.1



