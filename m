Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D3F2C9B39
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388308AbgLAJF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbgLAJFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:05:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECFC9206CA;
        Tue,  1 Dec 2020 09:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813497;
        bh=FhDmjBZNZeQM0CB6LGPMJTYOdqpVmxDZ5mUk+ebL/Co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfNRI+OV6+n14kaAW1InqKm8ZCdql+KDjaP2HV0GdwwwE+Vh/xq0RZg2sGQaHuAaL
         zgHK/0mwll6noPEsmY3wIW5ulM2pqm7+CcYrHriQXsfajJQGXZs1+fVSfifrMjPSec
         l6A0mb/7Yv8xzqMIUPWsUWgKHRNXAsNyxGL/pXIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Ferland <ferlandm@amotus.ca>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/98] dmaengine: xilinx_dma: use readl_poll_timeout_atomic variant
Date:   Tue,  1 Dec 2020 09:53:06 +0100
Message-Id: <20201201084656.355009357@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
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
index 43acba2a1c0ee..a6abfe702c5a3 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -454,8 +454,8 @@ struct xilinx_dma_device {
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



