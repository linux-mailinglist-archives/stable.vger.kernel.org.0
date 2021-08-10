Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3873B3E7F95
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhHJRlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235502AbhHJRjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DAC610E9;
        Tue, 10 Aug 2021 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617047;
        bh=kl/MC41rDUibgOXQxAs3lSt2yLtyFcKMleVJChWeWwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGAljml0edt+IvWdN6x3bT5z2J5ZuwD1H5dK4xS+gOku/wE0uRe73rpz2/2QoDefn
         Aax+YQgBmtNNvXZJv3lvOnJO6RNwnId+jenLTcBUyfuQCZtThxT/0rsAjWANAwYlt5
         7h04wvRFYDPsB0P7YiPj0VLKTG7AvB+tmDoDD6KI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/135] dmaengine: stm32-dma: Fix PM usage counter imbalance in stm32 dma ops
Date:   Tue, 10 Aug 2021 19:29:15 +0200
Message-Id: <20210810172956.389833662@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit d54db74ad6e0dea8c253fb68c689b836657ab914 ]

pm_runtime_get_sync will increment pm usage counter
even it failed. Forgetting to putting operation will
result in reference leak here. We fix it by replacing
it with pm_runtime_resume_and_get to keep usage counter
balanced.

Fixes: 48bc73ba14bcd ("dmaengine: stm32-dma: Add PM Runtime support")
Fixes: 05f8740a0e6fc ("dmaengine: stm32-dma: add suspend/resume power management support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20210607064640.121394-2-zhangqilong3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index d0055d2f0b9a..1150aa90eab6 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -1187,7 +1187,7 @@ static int stm32_dma_alloc_chan_resources(struct dma_chan *c)
 
 	chan->config_init = false;
 
-	ret = pm_runtime_get_sync(dmadev->ddev.dev);
+	ret = pm_runtime_resume_and_get(dmadev->ddev.dev);
 	if (ret < 0)
 		return ret;
 
@@ -1455,7 +1455,7 @@ static int stm32_dma_suspend(struct device *dev)
 	struct stm32_dma_device *dmadev = dev_get_drvdata(dev);
 	int id, ret, scr;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



