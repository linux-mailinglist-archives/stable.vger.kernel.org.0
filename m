Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA86328F5A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbhCATuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:50:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241581AbhCATlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:41:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A7BC64F0E;
        Mon,  1 Mar 2021 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620927;
        bh=g1usZ+0fyh63Zw3piHj29Zi3LnenuyArO9xSGTFUz3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXKmh0z2pLBQTsgH0WHR/xYTwduYnTiNTTXB2tgksQ/BT2k5U9IsYOnpoepWbQK+s
         qoth0bX2ENbTQGkfhI+h2+mVzlpyomdENpUlxybun+yT1wb5l12UH0X/MIjNRFQ9wr
         U/BFwtMNTy6RV1XmGPAW5g9OzUcTHt1T/I1JJimY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 329/775] dmaengine: ti: k3-udma: Set rflow count for BCDMA split channels
Date:   Mon,  1 Mar 2021 17:08:17 +0100
Message-Id: <20210301161217.875590942@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit aecf9d38361090857aa58708e500ee79bed1e273 ]

BCDMA RX channels have one flow per channel, therefore set the rflow_cnt
to rchan_cnt.

Without this patch, request for BCDMA RX channel allocation fails as
rflow_cnt is 0 thus fails to reserve a rflow for the channel.

Fixes: 8844898028d4 ("dmaengine: ti: k3-udma: Add support for BCDMA channel TPL handling")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20210112141403.30286-1-vigneshr@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index f474a12323354..46bc1a419bdfb 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -4306,6 +4306,7 @@ static int udma_get_mmrs(struct platform_device *pdev, struct udma_dev *ud)
 		ud->bchan_cnt = BCDMA_CAP2_BCHAN_CNT(cap2);
 		ud->tchan_cnt = BCDMA_CAP2_TCHAN_CNT(cap2);
 		ud->rchan_cnt = BCDMA_CAP2_RCHAN_CNT(cap2);
+		ud->rflow_cnt = ud->rchan_cnt;
 		break;
 	case DMA_TYPE_PKTDMA:
 		cap4 = udma_read(ud->mmrs[MMR_GCFG], 0x30);
-- 
2.27.0



