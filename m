Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEE81A5A63
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgDKXmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728437AbgDKXGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DC6E20787;
        Sat, 11 Apr 2020 23:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646391;
        bh=0SPryoYmUi+Ig0ImQ453oQJ0Z9MhCZSQAku6YWUmkKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fBEObkAJ35wKc3ZZj6xzc8uZ2qM03sWwkfAP1OMGpq7xcK2k2b9DLg8Em3IEnAUh
         a35PQw/qij4T2/ank3eDTRv84qgrr1EN1igmACLYP8H4BcVOt0WTyn9MZ+CzrldMcr
         G3yvyeJQWWUBjquXFJTois8BpV6jZN4CwGGS3170=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 130/149] dmaengine: sun4i: use 'linear_mode' in sun4i_dma_prep_dma_cyclic
Date:   Sat, 11 Apr 2020 19:03:27 -0400
Message-Id: <20200411230347.22371-130-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 6ebb827f7aad504ea438d0d2903293bd6f904463 ]

drivers/dma/sun4i-dma.c: In function sun4i_dma_prep_dma_cyclic:
drivers/dma/sun4i-dma.c:672:24: warning:
 variable linear_mode set but not used [-Wunused-but-set-variable]

commit ffc079a4accc ("dmaengine: sun4i: Add support for cyclic requests with dedicated DMA")
involved this, explicitly using the value makes the code more readable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20200207024445.44600-1-yuehaibing@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sun4i-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/sun4i-dma.c b/drivers/dma/sun4i-dma.c
index bbc2bda3b902f..e87fc7c460dd4 100644
--- a/drivers/dma/sun4i-dma.c
+++ b/drivers/dma/sun4i-dma.c
@@ -698,10 +698,12 @@ sun4i_dma_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf, size_t len,
 		endpoints = SUN4I_DMA_CFG_DST_DRQ_TYPE(vchan->endpoint) |
 			    SUN4I_DMA_CFG_DST_ADDR_MODE(io_mode) |
 			    SUN4I_DMA_CFG_SRC_DRQ_TYPE(ram_type);
+			    SUN4I_DMA_CFG_SRC_ADDR_MODE(linear_mode);
 	} else {
 		src = sconfig->src_addr;
 		dest = buf;
 		endpoints = SUN4I_DMA_CFG_DST_DRQ_TYPE(ram_type) |
+			    SUN4I_DMA_CFG_DST_ADDR_MODE(linear_mode) |
 			    SUN4I_DMA_CFG_SRC_DRQ_TYPE(vchan->endpoint) |
 			    SUN4I_DMA_CFG_SRC_ADDR_MODE(io_mode);
 	}
-- 
2.20.1

