Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D3F3286A6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbhCARNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237086AbhCARHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:07:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B225164F7B;
        Mon,  1 Mar 2021 16:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616843;
        bh=nFYfDVaO2qIceaxVSQmrrkMzf1+Y2HWYZyLWgu2Jqj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1u6+Uv+TrflVWmVmqJe+t1bVmfKXxGr/BycjSMs0PeP0h7OGNA7x1Aqvw69rmiDPr
         HRrAa+kt2TjVd/zZ3B1fhBEL3FA8WECAASqmLNe5Us6ZhlQbjpqvCyvBTbE94Wuy28
         QyrrXtFQoY1X/nvzqL351jca0zwai9tNm/EhTfQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/247] dmaengine: fsldma: Fix a resource leak in an error handling path of the probe function
Date:   Mon,  1 Mar 2021 17:12:14 +0100
Message-Id: <20210301161037.253339487@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b202d4e82531a62a33a6b14d321dd2aad491578e ]

In case of error, the previous 'fsl_dma_chan_probe()' calls must be undone
by some 'fsl_dma_chan_remove()', as already done in the remove function.

It was added in the remove function in commit 77cd62e8082b ("fsldma: allow
Freescale Elo DMA driver to be compiled as a module")

Fixes: d3f620b2c4fe ("fsldma: simplify IRQ probing and handling")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201212160614.92576-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsldma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index e3412be957122..e7ca3175dbc30 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1218,6 +1218,7 @@ static int fsldma_of_probe(struct platform_device *op)
 {
 	struct fsldma_device *fdev;
 	struct device_node *child;
+	unsigned int i;
 	int err;
 
 	fdev = kzalloc(sizeof(*fdev), GFP_KERNEL);
@@ -1296,6 +1297,10 @@ static int fsldma_of_probe(struct platform_device *op)
 	return 0;
 
 out_free_fdev:
+	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
+		if (fdev->chan[i])
+			fsl_dma_chan_remove(fdev->chan[i]);
+	}
 	irq_dispose_mapping(fdev->irq);
 	iounmap(fdev->regs);
 out_free:
-- 
2.27.0



