Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23584328CBC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbhCAS5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:57:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240559AbhCASwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:52:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF40064F07;
        Mon,  1 Mar 2021 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620914;
        bh=0hKniYT9P+3ALacwHjD2nY0Eon86ck5jYVcMObYbxnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akXt6VI+LJSadXDQKBjUSiXeGukYuLp+6hEp/5F7OrTQEwK9hwwuv7fs77p/2Kjtq
         38uO2955Fr6B1OAs4ASASU+/9I3RX4oYgI+e33SB/YOpEjNTEzRigaNcmwzShOYhF3
         63LNWj9/weutUTtlrDsJ9zJOZW9XM3O3YLwjTT1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 325/775] dmaengine: fsldma: Fix a resource leak in an error handling path of the probe function
Date:   Mon,  1 Mar 2021 17:08:13 +0100
Message-Id: <20210301161217.677546597@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 554f70a0c18c0..f8459cc5315df 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1214,6 +1214,7 @@ static int fsldma_of_probe(struct platform_device *op)
 {
 	struct fsldma_device *fdev;
 	struct device_node *child;
+	unsigned int i;
 	int err;
 
 	fdev = kzalloc(sizeof(*fdev), GFP_KERNEL);
@@ -1292,6 +1293,10 @@ static int fsldma_of_probe(struct platform_device *op)
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



