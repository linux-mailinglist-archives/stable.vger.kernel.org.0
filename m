Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7E776AAC
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfGZNkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727622AbfGZNkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7909122BEF;
        Fri, 26 Jul 2019 13:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148413;
        bh=VBtzKvIqMJOCwVo9MEpzdpTmmq1gqn2zMMkGHbgXXtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AeUhxQDODCGLP2yCyutzOZzPFFdYuZL/HomnkJwCS7syWdvToIVIxarOg+NEEGgS
         W+isjsJYdPINiMm49wDvicwKsJAZc6HGQ8glkJ3684swN6H3UMjPaw/OjU+ZCY3/ww
         2JNqxJr3OgEL2/updWsp1dMFd+HzNQJCcl2QHzDM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 20/85] dmaengine: rcar-dmac: Reject zero-length slave DMA requests
Date:   Fri, 26 Jul 2019 09:38:30 -0400
Message-Id: <20190726133936.11177-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

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
index 33ab1b607e2b..54de669c38b8 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1165,7 +1165,7 @@ rcar_dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct rcar_dmac_chan *rchan = to_rcar_dmac_chan(chan);
 
 	/* Someone calling slave DMA on a generic channel? */
-	if (rchan->mid_rid < 0 || !sg_len) {
+	if (rchan->mid_rid < 0 || !sg_len || !sg_dma_len(sgl)) {
 		dev_warn(chan->device->dev,
 			 "%s: bad parameter: len=%d, id=%d\n",
 			 __func__, sg_len, rchan->mid_rid);
-- 
2.20.1

