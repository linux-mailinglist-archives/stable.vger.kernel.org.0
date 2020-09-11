Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA768266627
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgIKRVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbgIKNAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:00:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09FEB22272;
        Fri, 11 Sep 2020 12:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828986;
        bh=4Vv2RDw7nKUlCzjSveipl9l0b2eKWH3UxDWSeO7rktA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcLGz/D/E3donIIIn5JrUKp/rN2RukJcEAOiSHFwvXyI+LsYTMo2UT3HTKwiwuWRO
         W0pCiGBNtLHZn30jIF/chlRWo+2j29dobSfqYESuq6CkpFfqm9FHpGYx0kJ4qVbRV3
         2Faw38BsiHv1tsSEuETBXVBiXHn4EM+c9x5GB6Xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 21/71] dmaengine: pl330: Fix burst length if burst size is smaller than bus width
Date:   Fri, 11 Sep 2020 14:46:05 +0200
Message-Id: <20200911122505.999081976@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
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
index 57b375d0de292..16c08846ea0e1 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2677,6 +2677,7 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	while (burst != (1 << desc->rqcfg.brst_size))
 		desc->rqcfg.brst_size++;
 
+	desc->rqcfg.brst_len = get_burst_len(desc, len);
 	/*
 	 * If burst size is smaller than bus width then make sure we only
 	 * transfer one at a time to avoid a burst stradling an MFIFO entry.
@@ -2684,7 +2685,6 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	if (desc->rqcfg.brst_size * 8 < pl330->pcfg.data_bus_width)
 		desc->rqcfg.brst_len = 1;
 
-	desc->rqcfg.brst_len = get_burst_len(desc, len);
 	desc->bytes_requested = len;
 
 	desc->txd.flags = flags;
-- 
2.25.1



