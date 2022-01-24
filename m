Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C089649A546
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370755AbiAYAGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2359447AbiAXXch (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:32:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E63C0424C2;
        Mon, 24 Jan 2022 11:54:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6A3E6090A;
        Mon, 24 Jan 2022 19:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FCAC340E5;
        Mon, 24 Jan 2022 19:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054047;
        bh=CrsAMLvUKyiVAjFDGVtOADoyn++mkZi/qdhbrG2tSOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGdrSwR1a4KaOsshw5ZpOkNyVzhSrPNJ5CH1wQg9zrwecguvqW91mfFGNrvObS+w8
         fXzOlruPkmUMeEHpUXyfwtjFIVBJwW+We+zN1e792r3QNGw5KhzZklRaRUVBjjafin
         BN9JmoiB1W+fdSHmGgrLFBPc5/HBIkXcZ1RnSh3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/563] uio: uio_dmem_genirq: Catch the Exception
Date:   Mon, 24 Jan 2022 19:40:27 +0100
Message-Id: <20220124184033.490683244@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index ec7f66f4555a6..bf39a424ea77d 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -183,7 +183,11 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
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



