Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667BF81BE6
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfHENRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729070AbfHENEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:04:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5010020880;
        Mon,  5 Aug 2019 13:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010273;
        bh=K186CMLLLr3fRwM23MxOmgDBaGSOo6sQZai733wpBDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hv3BcYB6+WR5KVApFhSIBA55Xo1dWHr9jwynjE3WXHUnZ5W6FTaWRilTQYXm26TbR
         l5Jbi8LeomiWyG2uxKvNzCl7ErjRT3dqWk9HH8JQwo5wsryE2lTiSiOfGPkeVGHewI
         A9+PVMdxvnvVeAAzaoQq9wmjj2c/CKMGJzIgImWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugeniu Rosca <erosca@de.adit-jv.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 4.4 05/22] dmaengine: rcar-dmac: Reject zero-length slave DMA requests
Date:   Mon,  5 Aug 2019 15:02:42 +0200
Message-Id: <20190805124919.905295750@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124918.070468681@linuxfoundation.org>
References: <20190805124918.070468681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 78efb76ab4dfb8f74f290ae743f34162cd627f19 ]

While the .device_prep_slave_sg() callback rejects empty scatterlists,
it still accepts single-entry scatterlists with a zero-length segment.
These may happen if a driver calls dmaengine_prep_slave_single() with a
zero len parameter.  The corresponding DMA request will never complete,
leading to messages like:

    rcar-dmac e7300000.dma-controller: Channel Address Error happen

and DMA timeouts.

Although requesting a zero-length DMA request is a driver bug, rejecting
it early eases debugging.  Note that the .device_prep_dma_memcpy()
callback already rejects requests to copy zero bytes.

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Analyzed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/rcar-dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index 2b36d1c63aa5f..956189a1ba81c 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1030,7 +1030,7 @@ rcar_dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	dma_addr_t dev_addr;
 
 	/* Someone calling slave DMA on a generic channel? */
-	if (rchan->mid_rid < 0 || !sg_len) {
+	if (rchan->mid_rid < 0 || !sg_len || !sg_dma_len(sgl)) {
 		dev_warn(chan->device->dev,
 			 "%s: bad parameter: len=%d, id=%d\n",
 			 __func__, sg_len, rchan->mid_rid);
-- 
2.20.1



