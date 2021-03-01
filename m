Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457BA32838D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhCAQV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237735AbhCAQTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:19:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE00764EC8;
        Mon,  1 Mar 2021 16:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615455;
        bh=FXJ3kJ9AMFHWUP9nBTlTds/FTRjv6lIWTbkbKC954Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrFhOEX2v4yhNcyO6657ZVOUkyHKrZmEJlEgAtyS4AJmG+ey2+ncmbA2CGPMX0A9R
         VzHQcMYk4jx/Y4YoYInfxz6/34nSkYCYnS15e/IDjZPD399wxyMQKhQffMUFFxO9Vw
         G1nyhS/6GWEDKdMb74ck/6vUPe1t6rbcYHYFQw7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 36/93] dmaengine: fsldma: Fix a resource leak in the remove function
Date:   Mon,  1 Mar 2021 17:12:48 +0100
Message-Id: <20210301161008.686274159@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index 2209f75fdf05b..1a637104cc08e 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1436,6 +1436,7 @@ static int fsldma_of_remove(struct platform_device *op)
 		if (fdev->chan[i])
 			fsl_dma_chan_remove(fdev->chan[i]);
 	}
+	irq_dispose_mapping(fdev->irq);
 
 	iounmap(fdev->regs);
 	kfree(fdev);
-- 
2.27.0



