Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AECF2C9E03
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391001AbgLAJaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387905AbgLAI6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:58:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA592220B;
        Tue,  1 Dec 2020 08:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813053;
        bh=7I7J0UzPgStHEb0JKi15gc+kzYE5qf0SyK4RLnQ5Rbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/hyxgrUuGzwhfF/3tWNx+FNYIjG3QuHGsnZGjJ6DRufIauMK16PA2V3MZ0sHnehd
         5cuZ+OETxXWA+W9RvAxLsVxQS6r60HJAmnMgr/KmcUQpTSI4vFKi36aJhnqcie/aBe
         kSlu+5B+90GIpnv38K0nnt76DIgKkzS2X1C2WEUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Ferland <ferlandm@amotus.ca>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/50] dmaengine: xilinx_dma: use readl_poll_timeout_atomic variant
Date:   Tue,  1 Dec 2020 09:53:16 +0100
Message-Id: <20201201084647.290910646@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Ferland <ferlandm@amotus.ca>

[ Upstream commit 0ba2df09f1500d3f27398a3382b86d39c3e6abe2 ]

The xilinx_dma_poll_timeout macro is sometimes called while holding a
spinlock (see xilinx_dma_issue_pending() for an example) this means we
shouldn't sleep when polling the dma channel registers. To address it
in xilinx poll timeout macro use readl_poll_timeout_atomic instead of
readl_poll_timeout variant.

Signed-off-by: Marc Ferland <ferlandm@amotus.ca>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1604473206-32573-2-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 2db352308e5c0..314f175cf8d05 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -422,8 +422,8 @@ struct xilinx_dma_device {
 #define to_dma_tx_descriptor(tx) \
 	container_of(tx, struct xilinx_dma_tx_descriptor, async_tx)
 #define xilinx_dma_poll_timeout(chan, reg, val, cond, delay_us, timeout_us) \
-	readl_poll_timeout(chan->xdev->regs + chan->ctrl_offset + reg, val, \
-			   cond, delay_us, timeout_us)
+	readl_poll_timeout_atomic(chan->xdev->regs + chan->ctrl_offset + reg, \
+				  val, cond, delay_us, timeout_us)
 
 /* IO accessors */
 static inline u32 dma_read(struct xilinx_dma_chan *chan, u32 reg)
-- 
2.27.0



