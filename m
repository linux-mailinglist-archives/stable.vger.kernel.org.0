Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5023E811E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbhHJRzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236991AbhHJRyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:54:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A23A61355;
        Tue, 10 Aug 2021 17:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617446;
        bh=0NTkwnBfe2rGmx8ZNRuktMmSUZmfZGMdJ/Xpk63KK/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvIRKOxkod1NvoU6GuES9wdi4VVIt9GXOPUKDrLKmTZpQAKj59MH2Q9XpsOLDq0BA
         VBnE5pNNvOi2Gg711+B/Dx91hbBCfEJdysczxPCwpaWAkgTF/BVpg3ICPQzynDUQwI
         DDbrw6uPvpzKkKlc4va7DO31ai8vKz4pKoD+BZYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 029/175] dmaengine: stm32-dma: Fix PM usage counter imbalance in stm32 dma ops
Date:   Tue, 10 Aug 2021 19:28:57 +0200
Message-Id: <20210810173001.917671196@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
index f54ecb123a52..7dd1d3d0bf06 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -1200,7 +1200,7 @@ static int stm32_dma_alloc_chan_resources(struct dma_chan *c)
 
 	chan->config_init = false;
 
-	ret = pm_runtime_get_sync(dmadev->ddev.dev);
+	ret = pm_runtime_resume_and_get(dmadev->ddev.dev);
 	if (ret < 0)
 		return ret;
 
@@ -1470,7 +1470,7 @@ static int stm32_dma_suspend(struct device *dev)
 	struct stm32_dma_device *dmadev = dev_get_drvdata(dev);
 	int id, ret, scr;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



