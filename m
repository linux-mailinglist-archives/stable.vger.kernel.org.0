Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BD4499B9C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575144AbiAXVvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572905AbiAXVmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB417C0419DF;
        Mon, 24 Jan 2022 12:31:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE9361382;
        Mon, 24 Jan 2022 20:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332B7C340E5;
        Mon, 24 Jan 2022 20:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056285;
        bh=QGCFPH1WYvDgr9p4O+VQEVXKCX82xetHO6mmGWOWw2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8OKTXTqq57Z4X8yKl1SJMaa1d4FmCCdDD30VE+tEb03s6CWXzhYcka7cOugsV1OY
         idq0wN7Y56vt9CPSyas/zzAQQmHJVzpC8HDEeilU40It4dEeIGpudhYqEMpLgEdvdX
         3dwCQzd/qu1OoVbrEevzxT1bIJD6N6z5/9+VKXNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 401/846] uio: uio_dmem_genirq: Catch the Exception
Date:   Mon, 24 Jan 2022 19:38:38 +0100
Message-Id: <20220124184114.788768037@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit eec91694f927d1026974444eb6a3adccd4f1cbc2 ]

The return value of dma_set_coherent_mask() is not always 0.
To catch the exception in case that dma is not support the mask.

Fixes: 0a0c3b5a24bd ("Add new uio device for dynamic memory allocation")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20211204000326.1592687-1-jiasheng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_dmem_genirq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index 6b5cfa5b06733..1106f33764047 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -188,7 +188,11 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(&pdev->dev, "DMA enable failed\n");
+		return ret;
+	}
 
 	priv->uioinfo = uioinfo;
 	spin_lock_init(&priv->lock);
-- 
2.34.1



