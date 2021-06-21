Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1E53AF093
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhFUQua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232761AbhFUQsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:48:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A2C361458;
        Mon, 21 Jun 2021 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293240;
        bh=AlgjhKd+Dnlkxs65AqMCoedbfkv/5rXTQeyFulhIvSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+pogUOLIdNiBS+F1wNW44mxzBDl6E76NU0QoajVctDIzYs0zNBSnW1DkYhogzxaq
         bm/GMCqPRj+Vq3OVNn1907COhg5Rk7GeywY44hMreHre2f248mko9y6zwGrBsaHCeU
         yLdHcRZ2MU5Au6Y7/pF+zwXZY7a+gkE0ArZxWrTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jongho Park <jongho7.park@samsung.com>,
        Bumyong Lee <bumyong.lee@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.12 150/178] dmaengine: pl330: fix wrong usage of spinlock flags in dma_cyclc
Date:   Mon, 21 Jun 2021 18:16:04 +0200
Message-Id: <20210621154927.870951565@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bumyong Lee <bumyong.lee@samsung.com>

commit 4ad5dd2d7876d79507a20f026507d1a93b8fff10 upstream.

flags varible which is the input parameter of pl330_prep_dma_cyclic()
should not be used by spinlock_irq[save/restore] function.

Signed-off-by: Jongho Park <jongho7.park@samsung.com>
Signed-off-by: Bumyong Lee <bumyong.lee@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Link: https://lore.kernel.org/r/20210507063647.111209-1-chanho61.park@samsung.com
Fixes: f6f2421c0a1c ("dmaengine: pl330: Merge dma_pl330_dmac and pl330_dmac structs")
Cc: stable@vger.kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/pl330.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2694,13 +2694,15 @@ static struct dma_async_tx_descriptor *p
 	for (i = 0; i < len / period_len; i++) {
 		desc = pl330_get_desc(pch);
 		if (!desc) {
+			unsigned long iflags;
+
 			dev_err(pch->dmac->ddma.dev, "%s:%d Unable to fetch desc\n",
 				__func__, __LINE__);
 
 			if (!first)
 				return NULL;
 
-			spin_lock_irqsave(&pl330->pool_lock, flags);
+			spin_lock_irqsave(&pl330->pool_lock, iflags);
 
 			while (!list_empty(&first->node)) {
 				desc = list_entry(first->node.next,
@@ -2710,7 +2712,7 @@ static struct dma_async_tx_descriptor *p
 
 			list_move_tail(&first->node, &pl330->desc_pool);
 
-			spin_unlock_irqrestore(&pl330->pool_lock, flags);
+			spin_unlock_irqrestore(&pl330->pool_lock, iflags);
 
 			return NULL;
 		}


