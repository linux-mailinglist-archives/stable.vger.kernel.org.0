Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC236451EDA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243598AbhKPAhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344729AbhKOTZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C42A363278;
        Mon, 15 Nov 2021 19:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002996;
        bh=45ZJCceUUvUW6UIrrGAmsv1isRggW6JSEpTRfj4mi8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nxg3cQt2SH7B8LBfy2j62OJ8jmUMXz32ySRPrSeo6rd9u+gsMZYMfeSOAsFEgOKh/
         bFN9xJMQ1vl/E/1zVQO/tAET8Wvq8+q43TRu1NhP6ZxkXTndzYeknYDKWwuxQhBiuG
         NISilRQoIOntt0qOFNhlQx0zh33WRVbJ2CRe/paw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 739/917] dmaengine: tegra210-adma: fix pm runtime unbalance
Date:   Mon, 15 Nov 2021 18:03:54 +0100
Message-Id: <20211115165453.971279813@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit c5a51fc89c0103c03b8a54cf12dac7d014b3a2bf ]

The previous commit 059e969c2a7d ("dmaengine: tegra210-adma: Using
pm_runtime_resume_and_get to replace open coding") forgets to replace
the pm_runtime_get_sync in the tegra_adma_probe, but removes the
pm_runtime_put_noidle.

Fix this by continuing to replace pm_runtime_get_sync with
pm_runtime_resume_and_get in tegra_adma_probe.

Fixes: 059e969c2a7d ("dmaengine: tegra210-adma: Using pm_runtime_resume_and_get to replace open coding")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20211021030538.3465287-1-mudongliangabcd@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra210-adma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index b1115a6d1935c..d1dff3a29db59 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -867,7 +867,7 @@ static int tegra_adma_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(&pdev->dev);
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		goto rpm_disable;
 
-- 
2.33.0



