Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C14498902
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245596AbiAXSwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343617AbiAXSvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:51:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45EEC0617A3;
        Mon, 24 Jan 2022 10:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68941B810BD;
        Mon, 24 Jan 2022 18:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9980BC340E5;
        Mon, 24 Jan 2022 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050245;
        bh=ZKj5uNOC/s2GY6wnIqIljyZ3oiYEhoGF8RHpon+/GPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ju+cgYghedEWVbVAGTtpRu5pyHv0ZqcKp+4PaOKiQUsi+PQO+ifIduTMlARTvjCZS
         Ph5CrOT95UuZGBamz4j8gqtQP9VLk4mkxKRxKYxnUTGmAVNlmHxE+HWUmTTek8oNGj
         1vNYn+O1/Ph0VIJ+imD5sYzwRScIsY3bW9U5xjVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 049/114] uio: uio_dmem_genirq: Catch the Exception
Date:   Mon, 24 Jan 2022 19:42:24 +0100
Message-Id: <20220124183928.616303968@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
index a00b4aee6c799..a31b9d5260ca0 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -194,7 +194,11 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
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



