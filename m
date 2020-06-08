Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1491F2D44
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgFIAcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbgFHXPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF36B2076C;
        Mon,  8 Jun 2020 23:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658118;
        bh=QkkKrfXIqBTewevv8yU5ylGQpIpEznDfIwmX3poadq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUJsubXgLnxli/j2JGKMhkNVdw5Jltwh4jQHWGf7awAruTrtAfbaM5xoUAOuSyYQA
         cfdfKL6MmHW/Y4+OiNawgAxAa/NNnr9oml1USzj7HlwfFZXdhsY/iW1Lvk70uk6wUg
         0m1cZfgn5VSz7Fmv8Sz1RY7hVnUml+gCLk3HN5kw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 156/606] dmaengine: tegra210-adma: Fix an error handling path in 'tegra_adma_probe()'
Date:   Mon,  8 Jun 2020 19:04:41 -0400
Message-Id: <20200608231211.3363633-156-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/dma/tegra210-adma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index 6e1268552f74..914901a680c8 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -900,7 +900,7 @@ static int tegra_adma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(&tdma->dma_dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "ADMA registration failed: %d\n", ret);
-		goto irq_dispose;
+		goto rpm_put;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node,
-- 
2.25.1

