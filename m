Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB92328B30
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbhCASaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239770AbhCASWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:22:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3FBD64F06;
        Mon,  1 Mar 2021 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620917;
        bh=bIc0N4zkEpzsYuYllFhHuEhyHmNPdVnmw5J1qvhdeWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VO0mtLfvENyS7jmsf5ZcOOz0TwB0q7FKn8PP8eceD18c4oLPlFWh/CLLs8dMqw0qI
         LZAQ1uWiReqyhvPXJO+1mwX7Cfro/Mn9G8XxdC6+m7gRjpH1DUi9FjZ2czzp3KJb0i
         A2A+AbFptxLEhpT/xW0cJKHgx2OLyqTxkqGXV3Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 326/775] dmaengine: owl-dma: Fix a resource leak in the remove function
Date:   Mon,  1 Mar 2021 17:08:14 +0100
Message-Id: <20210301161217.729343289@linuxfoundation.org>
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

[ Upstream commit 1f0a16f04113f9f0ab0c8e6d3abe661edab549e6 ]

A 'dma_pool_destroy()' call is missing in the remove function.
Add it.

This call is already made in the error handling path of the probe function.

Fixes: 47e20577c24d ("dmaengine: Add Actions Semi Owl family S900 DMA driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201212162535.95727-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/owl-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/owl-dma.c b/drivers/dma/owl-dma.c
index 9fede32641e9e..04202d75f4eed 100644
--- a/drivers/dma/owl-dma.c
+++ b/drivers/dma/owl-dma.c
@@ -1245,6 +1245,7 @@ static int owl_dma_remove(struct platform_device *pdev)
 	owl_dma_free(od);
 
 	clk_disable_unprepare(od->clk);
+	dma_pool_destroy(od->lli_pool);
 
 	return 0;
 }
-- 
2.27.0



