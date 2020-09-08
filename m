Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF71261432
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbgIHQJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbgIHQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F292404C;
        Tue,  8 Sep 2020 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580093;
        bh=Jhn6tsgXt3uDCSv/y/lcHKqsyitqFv95Y1a/+DZ85ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kw2PDSM9M/kqd+ev3nAUMO6/FcOOgvF7+/ubHVtlbOKNNmddekUUHoOJvhu7MYc+r
         AGNAd7DiNOavGxBdv+rTFWYWwXPA0r9QgDlIkvHySwzvy31WF0rKbF6SJB/0Q1D3BA
         Yy1WUxQK+maqHfAYNBG7UgbwOb9XfDlZPQo2XnAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/88] dmaengine: pl330: Fix burst length if burst size is smaller than bus width
Date:   Tue,  8 Sep 2020 17:25:30 +0200
Message-Id: <20200908152222.532997810@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 0661cef675d37e2c4b66a996389ebeae8568e49e ]

Move the burst len fixup after setting the generic value for it. This
finally enables the fixup introduced by commit 137bd11090d8 ("dmaengine:
pl330: Align DMA memcpy operations to MFIFO width"), which otherwise was
overwritten by the generic value.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 137bd11090d8 ("dmaengine: pl330: Align DMA memcpy operations to MFIFO width")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20200825064617.16193-1-m.szyprowski@samsung.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index bc8050c025b7b..c564df713efc3 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2769,6 +2769,7 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	while (burst != (1 << desc->rqcfg.brst_size))
 		desc->rqcfg.brst_size++;
 
+	desc->rqcfg.brst_len = get_burst_len(desc, len);
 	/*
 	 * If burst size is smaller than bus width then make sure we only
 	 * transfer one at a time to avoid a burst stradling an MFIFO entry.
@@ -2776,7 +2777,6 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	if (desc->rqcfg.brst_size * 8 < pl330->pcfg.data_bus_width)
 		desc->rqcfg.brst_len = 1;
 
-	desc->rqcfg.brst_len = get_burst_len(desc, len);
 	desc->bytes_requested = len;
 
 	desc->txd.flags = flags;
-- 
2.25.1



