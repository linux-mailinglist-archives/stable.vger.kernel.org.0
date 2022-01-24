Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E9D498DAD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347350AbiAXTeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:34:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57524 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347726AbiAXTc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:32:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83488614FF;
        Mon, 24 Jan 2022 19:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9D3C340E8;
        Mon, 24 Jan 2022 19:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052745;
        bh=mqGBQO0RBQ+6UJAqYAr8k4AtoulFgo2/JKjKWkwUVn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guAuDynlZoFpsz9/e+5ALs4ovfkesO4fFECDRFo6ZHXbOp3oaWk21nYyOpK89CiMu
         +0s5vDHThtD2W+7HICKum0bSnHLYgOkQgmX4tS+/hKpwbruelKg5S2GwklJheA/Kg7
         YJY64gvihpxpJiiwH0vjOJfQH4j6q8aOgCsa8814=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/320] uio: uio_dmem_genirq: Catch the Exception
Date:   Mon, 24 Jan 2022 19:41:57 +0100
Message-Id: <20220124183958.189526620@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 44858f70f5f52..bdba9dc06f63b 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -192,7 +192,11 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
 		goto bad0;
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



