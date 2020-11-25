Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A0E2C444A
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbgKYPm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:42:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730354AbgKYPgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E332420857;
        Wed, 25 Nov 2020 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318562;
        bh=oB9+iQFPwSRpfKRYDu4lhJbolyTBNVjtkPe2QzPJE/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYi655Bf0Ur1muW/AOUfDnhfZdLIlf8WX6r59CVw31J2/LQEm10PcLyniGmeRq6Ib
         19J4zZtrHCHALSjXTBDjM7chUUcbSUVMMEy/Hm4TVj9oUrLujBfcWuejU6n/oNMbbF
         0bFFCT8carWVfYZ84WhKBPGp+VyQUZSbOrR+Pm1Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Ferland <ferlandm@amotus.ca>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 09/33] dmaengine: xilinx_dma: use readl_poll_timeout_atomic variant
Date:   Wed, 25 Nov 2020 10:35:26 -0500
Message-Id: <20201125153550.810101-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0fc432567b857..993297d585c01 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -517,8 +517,8 @@ struct xilinx_dma_device {
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

