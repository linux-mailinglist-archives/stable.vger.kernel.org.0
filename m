Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED439468DF
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfFNU2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbfFNU2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:28:53 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 517E52186A;
        Fri, 14 Jun 2019 20:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544131;
        bh=v1aZ80rCPAZc/VTMHWYtYVRdyC/Tp44TTIvq+21x6MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCngdZZ8qHpBjwTCDazCL8Zw8TYv5/1p00yWJuHjWAYAzPpnlnfhKbPBn0fvd/T4e
         cW4XhwwE4ikP1ipHGmljzObY/YoE0QwNlp8cpXuUNMVXOHr3sbg1XzL1vspcQWYpM5
         QKmysU5sWPaVL79vV6C5VJ0rBnH346Nu+klUCKGg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Long <eric.long@unisoc.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 09/59] dmaengine: sprd: Fix block length overflow
Date:   Fri, 14 Jun 2019 16:27:53 -0400
Message-Id: <20190614202843.26941-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Long <eric.long@unisoc.com>

[ Upstream commit 89d03b3c126d683f7b2cd5b07178493993d12448 ]

The maximum value of block length is 0xffff, so if the configured transfer length
is more than 0xffff, that will cause block length overflow to lead a configuration
error.

Thus we can set block length as the maximum burst length to avoid this issue, since
the maximum burst length will not be a big value which is more than 0xffff.

Signed-off-by: Eric Long <eric.long@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 0f92e60529d1..a01c23246632 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -778,7 +778,7 @@ static int sprd_dma_fill_desc(struct dma_chan *chan,
 	temp |= slave_cfg->src_maxburst & SPRD_DMA_FRG_LEN_MASK;
 	hw->frg_len = temp;
 
-	hw->blk_len = len & SPRD_DMA_BLK_LEN_MASK;
+	hw->blk_len = slave_cfg->src_maxburst & SPRD_DMA_BLK_LEN_MASK;
 	hw->trsc_len = len & SPRD_DMA_TRSC_LEN_MASK;
 
 	temp = (dst_step & SPRD_DMA_TRSF_STEP_MASK) << SPRD_DMA_DEST_TRSF_STEP_OFFSET;
-- 
2.20.1

