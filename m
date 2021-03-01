Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9DC328892
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhCARmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:42:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238649AbhCAReh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:34:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2320364FAF;
        Mon,  1 Mar 2021 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617628;
        bh=lvSioZrPufv+YkzjPxIoyPnZScM3P1pmgR+sextaszY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvCkBDWVmfbCZ7Z6UTr6Il8DpoYOMrS9gtir/0XgYl/yCQlDHDK+4VvPFkG1i8ftx
         8XFQ9H6ARCoge7CoHiU/JiRuQOm40SZFGy553qx9W8iX7KKldil3qVI4sEKU3fcjtd
         6EoH4PWZBeJdtxRsKPlYpptoaqY760cN1b+HfMdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/340] dmaengine: owl-dma: Fix a resource leak in the remove function
Date:   Mon,  1 Mar 2021 17:11:25 +0100
Message-Id: <20210301161055.262289433@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index af20e9a790a2a..bb9c361e224bc 100644
--- a/drivers/dma/owl-dma.c
+++ b/drivers/dma/owl-dma.c
@@ -1201,6 +1201,7 @@ static int owl_dma_remove(struct platform_device *pdev)
 	owl_dma_free(od);
 
 	clk_disable_unprepare(od->clk);
+	dma_pool_destroy(od->lli_pool);
 
 	return 0;
 }
-- 
2.27.0



