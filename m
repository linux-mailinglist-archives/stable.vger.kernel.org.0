Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD2417FE84
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgCJMny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727244AbgCJMnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:43:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FB5424686;
        Tue, 10 Mar 2020 12:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844232;
        bh=LvoDkPCC2XEbe7aaD8Vw49Jo/0wxjYor8N3VJ65Bkb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHBbDz2YDj68aCmGidZ8vq0inppykGjA6ShsmgS1mIVzuNEx0rUNDjUqpV54q8MuL
         yHAGBMh/asaFLAdo4qzz9zCwUcvh8Uo8xY244fAJL12j6g7ZldpUShZ2FCfNMlp0tP
         lzK97MD+L9b2GU6xJaMSfaq5SN9UHV6azvKqUKd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.4 61/72] dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list
Date:   Tue, 10 Mar 2020 13:39:14 +0100
Message-Id: <20200310123616.452611215@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
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
@@ -285,7 +285,7 @@ static struct tegra_dma_desc *tegra_dma_
 
 	/* Do not allocate if desc are waiting for ack */
 	list_for_each_entry(dma_desc, &tdc->free_dma_desc, node) {
-		if (async_tx_test_ack(&dma_desc->txd)) {
+		if (async_tx_test_ack(&dma_desc->txd) && !dma_desc->cb_count) {
 			list_del(&dma_desc->node);
 			spin_unlock_irqrestore(&tdc->lock, flags);
 			dma_desc->txd.flags = 0;


