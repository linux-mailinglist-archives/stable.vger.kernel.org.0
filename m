Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8E75088C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfFXKQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729670AbfFXKQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:04 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF8D9205ED;
        Mon, 24 Jun 2019 10:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371363;
        bh=6F0uQCMTnlWtg++gfb6hQFg+O79tkm8+jbu/aXD6iy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+IsMYwGVz1NtBOkYeSFfihKOPqlY4NEXotNZ5PGexyU+75Y1Lp8+VJQ+F7tc37en
         jf/NuvdOU6xukKLUTxnfURJLxFzurkQBZaQFsuAzJdnKOu0WCpK8D55RmRqLUUAgCc
         UQKji1eed6298ZjNzXhA+JN6DOc6OUHAPC/EyLiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Long <eric.long@unisoc.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 040/121] dmaengine: sprd: Fix the right place to configure 2-stage transfer
Date:   Mon, 24 Jun 2019 17:56:12 +0800
Message-Id: <20190624092322.847607054@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c434e377dad1dec05cad1870ce21bc539e1e024f ]

Move the 2-stage configuration before configuring the link-list mode,
since we will use some 2-stage configuration to fill the link-list
configuration.

Signed-off-by: Eric Long <eric.long@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index a01c23246632..01abed5cde49 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -911,6 +911,12 @@ sprd_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		schan->linklist.virt_addr = 0;
 	}
 
+	/* Set channel mode and trigger mode for 2-stage transfer */
+	schan->chn_mode =
+		(flags >> SPRD_DMA_CHN_MODE_SHIFT) & SPRD_DMA_CHN_MODE_MASK;
+	schan->trg_mode =
+		(flags >> SPRD_DMA_TRG_MODE_SHIFT) & SPRD_DMA_TRG_MODE_MASK;
+
 	sdesc = kzalloc(sizeof(*sdesc), GFP_NOWAIT);
 	if (!sdesc)
 		return NULL;
@@ -944,12 +950,6 @@ sprd_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		}
 	}
 
-	/* Set channel mode and trigger mode for 2-stage transfer */
-	schan->chn_mode =
-		(flags >> SPRD_DMA_CHN_MODE_SHIFT) & SPRD_DMA_CHN_MODE_MASK;
-	schan->trg_mode =
-		(flags >> SPRD_DMA_TRG_MODE_SHIFT) & SPRD_DMA_TRG_MODE_MASK;
-
 	ret = sprd_dma_fill_desc(chan, &sdesc->chn_hw, 0, 0, src, dst, len,
 				 dir, flags, slave_cfg);
 	if (ret) {
-- 
2.20.1



