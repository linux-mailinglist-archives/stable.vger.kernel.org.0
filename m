Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E4326F0CD
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgIRCqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgIRCJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 089C823A03;
        Fri, 18 Sep 2020 02:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394990;
        bh=oeQh2faaJrkwcSxYRQm7EI3c0i3vlI+q5lipaebE1J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xp9MFmQqlEli2ZQQkg/Fog7tgj8K30nae/B6gpGiZlgEDKtJvG92xWFpFmLwQyq/+
         cR2c6kf7lXPRFK7tpSnYO3O3nulVr788H3JHolCt68A5ipDbKp3jpLVXkvYjR4He6b
         3mEYLZiRDMkF3cwTqGh+PtFIapP1Z0GjxYM4zGLQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 089/206] dmaengine: tegra-apb: Prevent race conditions on channel's freeing
Date:   Thu, 17 Sep 2020 22:06:05 -0400
Message-Id: <20200918020802.2065198-89-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 8e84172e372bdca20c305d92d51d33640d2da431 ]

It's incorrect to check the channel's "busy" state without taking a lock.
That shouldn't cause any real troubles, nevertheless it's always better
not to have any race conditions in the code.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20200209163356.6439-5-digetx@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra20-apb-dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 15481aeaeecd1..5ccd24a46e381 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1225,8 +1225,7 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 
 	dev_dbg(tdc2dev(tdc), "Freeing channel %d\n", tdc->id);
 
-	if (tdc->busy)
-		tegra_dma_terminate_all(dc);
+	tegra_dma_terminate_all(dc);
 
 	spin_lock_irqsave(&tdc->lock, flags);
 	list_splice_init(&tdc->pending_sg_req, &sg_req_list);
-- 
2.25.1

