Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2780427CCE6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgI2MkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728988AbgI2LP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:15:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09EB6206A5;
        Tue, 29 Sep 2020 11:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378126;
        bh=qFgC6457DI4DR0BkQRI6sC0Q4iXFaMCeFOu+hKsflFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ostj1LwJ8k3L1X3h8lSWfiOcqCI6YIRUcj63HhjjbZOwq4/ZZa9MaGriiIcSQuwE5
         v3MPbhi8rCRTVyerPpk4MOSsABdR6WuGhPySXFWq4Cr1tOsa+fsaKJhtEmBJlkVKoa
         1FkTDBn7iJnOuaoRIA+DtjFrvFhGDN+8l+edKap4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 071/166] dmaengine: tegra-apb: Prevent race conditions on channels freeing
Date:   Tue, 29 Sep 2020 12:59:43 +0200
Message-Id: <20200929105938.768626568@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3402494cadf99..78e098b4bd89e 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1208,8 +1208,7 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 
 	dev_dbg(tdc2dev(tdc), "Freeing channel %d\n", tdc->id);
 
-	if (tdc->busy)
-		tegra_dma_terminate_all(dc);
+	tegra_dma_terminate_all(dc);
 
 	spin_lock_irqsave(&tdc->lock, flags);
 	list_splice_init(&tdc->pending_sg_req, &sg_req_list);
-- 
2.25.1



