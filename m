Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9018F13F47F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389623AbgAPRJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389592AbgAPRJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 945C42467C;
        Thu, 16 Jan 2020 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194550;
        bh=pnGhygOX4JqLJYH3+6P61ZFc3qssG4FVfSiYvbA+iaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjDJq7TeirYXqCXbYqzPa7pVjQzMhyRVra4br05d6XS+vMc0xN2PbomUeDYDIFYnX
         7tbMOUeV37LFXOpUyf801BOiL8x/HzATD8Jr7CLnraLLl66P7zlwGdp7JiaztzHk+k
         iEhgTM+YeYtoWCOW/MDiOuT+8X1iJudMK4jfaWag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 433/671] dmaengine: hsu: Revert "set HSU_CH_MTSR to memory width"
Date:   Thu, 16 Jan 2020 12:01:11 -0500
Message-Id: <20200116170509.12787-170-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c24a5c735f87d0549060de31367c095e8810b895 ]

The commit

  080edf75d337 ("dmaengine: hsu: set HSU_CH_MTSR to memory width")

has been mistakenly submitted. The further investigations show that
the original code does better job since the memory side transfer size
has never been configured by DMA users.

As per latest revision of documentation: "Channel minimum transfer size
(CHnMTSR)... For IOSF UART, maximum value that can be programmed is 64 and
minimum value that can be programmed is 1."

This reverts commit 080edf75d337d35faa6fc3df99342b10d2848d16.

Fixes: 080edf75d337 ("dmaengine: hsu: set HSU_CH_MTSR to memory width")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/hsu/hsu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/hsu/hsu.c b/drivers/dma/hsu/hsu.c
index 202ffa9f7611..18f155a974db 100644
--- a/drivers/dma/hsu/hsu.c
+++ b/drivers/dma/hsu/hsu.c
@@ -64,10 +64,10 @@ static void hsu_dma_chan_start(struct hsu_dma_chan *hsuc)
 
 	if (hsuc->direction == DMA_MEM_TO_DEV) {
 		bsr = config->dst_maxburst;
-		mtsr = config->src_addr_width;
+		mtsr = config->dst_addr_width;
 	} else if (hsuc->direction == DMA_DEV_TO_MEM) {
 		bsr = config->src_maxburst;
-		mtsr = config->dst_addr_width;
+		mtsr = config->src_addr_width;
 	}
 
 	hsu_chan_disable(hsuc);
-- 
2.20.1

