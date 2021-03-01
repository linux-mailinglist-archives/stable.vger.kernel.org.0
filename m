Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99263286A4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbhCARNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:13:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235345AbhCARHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:07:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D26D665005;
        Mon,  1 Mar 2021 16:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616840;
        bh=BF3VPEwwcLfCtWzdmAPkzAZWuW/xqEPWF5cHpl2DP1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c69d59PP+dwJfaAdanZJCGhFsYKaUBe8Ro2AtDNCwdu+/20yNsHPSlKpMaiBbGkZe
         P1gKXLMPKuNbCkx8y0QfZrnErHH0b4fBltauIdGSgFYDteCMpP2dEDvwLmp2P65R4g
         cnSJh7ucvglV8ahlJlDY3uSVgX8FelIZidnjR/SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/247] dmaengine: fsldma: Fix a resource leak in the remove function
Date:   Mon,  1 Mar 2021 17:12:13 +0100
Message-Id: <20210301161037.205399370@linuxfoundation.org>
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

[ Upstream commit cbc0ad004c03ad7971726a5db3ec84dba3dcb857 ]

A 'irq_dispose_mapping()' call is missing in the remove function.
Add it.

This is needed to undo the 'irq_of_parse_and_map() call from the probe
function and already part of the error handling path of the probe function.

It was added in the probe function only in commit d3f620b2c4fe ("fsldma:
simplify IRQ probing and handling")

Fixes: 77cd62e8082b ("fsldma: allow Freescale Elo DMA driver to be compiled as a module")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201212160516.92515-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsldma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 1117b5123a6fc..e3412be957122 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1318,6 +1318,7 @@ static int fsldma_of_remove(struct platform_device *op)
 		if (fdev->chan[i])
 			fsl_dma_chan_remove(fdev->chan[i]);
 	}
+	irq_dispose_mapping(fdev->irq);
 
 	iounmap(fdev->regs);
 	kfree(fdev);
-- 
2.27.0



