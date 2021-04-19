Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7A364B70
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242401AbhDSUod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242382AbhDSUob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87FE7613C9;
        Mon, 19 Apr 2021 20:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865041;
        bh=sL2wviUKoZfmwofxZJu5uW934bvydhzmqXTAzeULgFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WckPTqRuYjvIDyUQCPMw3GEIcuCQnUGD8Ikaj7D3xQYYXTYTzKJ6FzMX74Cqcb0rI
         iXVjQSOpbAFJNIXfaDPgr2pFOi/AJmozEJWwdL8e7KprS4lqwJNZ+0ciqZWb5/g0HP
         KDvvsGhWU40cQHeMNcRrIVKCWHtUi8RXKZGRoX0yiJVt3LQwMrzJq083eHwuXMTrWx
         EBZfR3c3aIxWCJ2mT877yAjrESoXKrF0Z4524FIiiXt0Bm89jUuFYi3O6Nz9oR14vI
         gpMPUTX1GzSGv81ScjX6lzo2eliwDzDUMDpdry3nZnhLXQBWubb1VG08OpQE23izuV
         Z6yHdjUjgDzKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Thierry Reding <treding@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 12/23] dmaengine: tegra20: Fix runtime PM imbalance on error
Date:   Mon, 19 Apr 2021 16:43:31 -0400
Message-Id: <20210419204343.6134-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204343.6134-1-sashal@kernel.org>
References: <20210419204343.6134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 917a3200b9f467a154999c7572af345f2470aaf4 ]

pm_runtime_get_sync() will increase the runtime PM counter
even it returns an error. Thus a pairing decrement is needed
to prevent refcount leak. Fix this by replacing this API with
pm_runtime_resume_and_get(), which will not change the runtime
PM counter on error.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20210409082805.23643-1-dinghao.liu@zju.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra20-apb-dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 71827d9b0aa1..b7260749e8ee 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -723,7 +723,7 @@ static void tegra_dma_issue_pending(struct dma_chan *dc)
 		goto end;
 	}
 	if (!tdc->busy) {
-		err = pm_runtime_get_sync(tdc->tdma->dev);
+		err = pm_runtime_resume_and_get(tdc->tdma->dev);
 		if (err < 0) {
 			dev_err(tdc2dev(tdc), "Failed to enable DMA\n");
 			goto end;
@@ -818,7 +818,7 @@ static void tegra_dma_synchronize(struct dma_chan *dc)
 	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
 	int err;
 
-	err = pm_runtime_get_sync(tdc->tdma->dev);
+	err = pm_runtime_resume_and_get(tdc->tdma->dev);
 	if (err < 0) {
 		dev_err(tdc2dev(tdc), "Failed to synchronize DMA: %d\n", err);
 		return;
-- 
2.30.2

