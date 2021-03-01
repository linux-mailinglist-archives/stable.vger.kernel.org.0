Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1694B328459
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhCAQdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234840AbhCAQ3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 761F364F49;
        Mon,  1 Mar 2021 16:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615762;
        bh=06W9OjmK5npGvjgITadR5hHypBrj9Vnsz8U9lByzxEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un7fwF6kV8DisTehaGWcMlr3Szgshahy/Gh84Xyfqf5Q1NhCjTHz5HoOFs/LlQ55M
         xhmpUB3GQFNwAv6s4WFvEpHC5kj8ELRNDP5NTjP+q7q1XdlJPzl1Yf80GDSUEidfne
         iZnesq7u8g7//eKbOG0uQBL5UgZLR54QPfjg0axg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/134] dmaengine: fsldma: Fix a resource leak in the remove function
Date:   Mon,  1 Mar 2021 17:12:32 +0100
Message-Id: <20210301161016.072652350@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 51c75bf2b9b68..a5687864e8830 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1433,6 +1433,7 @@ static int fsldma_of_remove(struct platform_device *op)
 		if (fdev->chan[i])
 			fsl_dma_chan_remove(fdev->chan[i]);
 	}
+	irq_dispose_mapping(fdev->irq);
 
 	iounmap(fdev->regs);
 	kfree(fdev);
-- 
2.27.0



