Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987651E2AD2
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390510AbgEZS7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390483AbgEZS7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E379E2084C;
        Tue, 26 May 2020 18:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519555;
        bh=14eDN6iWkvLygluEYtdkN4nLLdQl8xArd15UGUNLXjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SY5DIdQBN9zX+cxVptq5apKsdoGBozi/spCV5nDrEoIp3CepU8L6cBSfrseu/EvRo
         deD97NoX+IAb5zuSEXEse5jirQL5gOhthZi0wFwicjeswvS+z4OtxpkYmvqq5IL8EQ
         wLlLjUw/pTmQbO+X9kyZgz9VIx4Nq0ZA7XPNkhEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.9 50/64] dmaengine: tegra210-adma: Fix an error handling path in tegra_adma_probe()
Date:   Tue, 26 May 2020 20:53:19 +0200
Message-Id: <20200526183930.291900499@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 3a5fd0dbd87853f8bd2ea275a5b3b41d6686e761 upstream.

Commit b53611fb1ce9 ("dmaengine: tegra210-adma: Fix crash during probe")
has moved some code in the probe function and reordered the error handling
path accordingly.
However, a goto has been missed.

Fix it and goto the right label if 'dma_async_device_register()' fails, so
that all resources are released.

Fixes: b53611fb1ce9 ("dmaengine: tegra210-adma: Fix crash during probe")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20200516214205.276266-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/tegra210-adma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -793,7 +793,7 @@ static int tegra_adma_probe(struct platf
 	ret = dma_async_device_register(&tdma->dma_dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "ADMA registration failed: %d\n", ret);
-		goto irq_dispose;
+		goto rpm_put;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node,


