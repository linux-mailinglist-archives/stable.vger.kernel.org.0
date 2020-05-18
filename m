Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB131D8076
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgERRj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbgERRj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:39:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55F312083E;
        Mon, 18 May 2020 17:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823595;
        bh=krDD4ztRtlpneNTbB+Wy4C8g2LMKXTuwNJpmlDzaQhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1fMFdYXRSVEC4QcQoyUeOj3+tftt6Za6wiZkEjSArLChlKFH+8W/xEwH86y8dzS4x
         22gr/aqc7TuJ2dsuurumey3T6tMC+Q6h6q7km684NZqFE+BP4wKgtUwMMOBnoQ6ta6
         1ZPqrNy7EuPK1eGMK6YSCMVy3+Q/hfxIBLLrRP/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 44/86] dmaengine: mmp_tdma: Reset channel error on release
Date:   Mon, 18 May 2020 19:36:15 +0200
Message-Id: <20200518173459.426322918@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 0c89446379218698189a47871336cb30286a7197 ]

When a channel configuration fails, the status of the channel is set to
DEV_ERROR so that an attempt to submit it fails. However, this status
sticks until the heat end of the universe, making it impossible to
recover from the error.

Let's reset it when the channel is released so that further use of the
channel with correct configuration is not impacted.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://lore.kernel.org/r/20200419164912.670973-5-lkundrak@v3.sk
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mmp_tdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 3df0422607d59..ac9aede1bfbec 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -364,6 +364,8 @@ static void mmp_tdma_free_descriptor(struct mmp_tdma_chan *tdmac)
 		gen_pool_free(gpool, (unsigned long)tdmac->desc_arr,
 				size);
 	tdmac->desc_arr = NULL;
+	if (tdmac->status == DMA_ERROR)
+		tdmac->status = DMA_COMPLETE;
 
 	return;
 }
-- 
2.20.1



