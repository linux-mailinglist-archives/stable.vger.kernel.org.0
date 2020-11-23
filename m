Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EF12C084A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbgKWMr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:47:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732810AbgKWMrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A07552100A;
        Mon, 23 Nov 2020 12:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135637;
        bh=dLOFmVFX569vU+8nCk4HIlUJ3+kFzN7nzJcRt6ZTqmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLf1b0pIuldHuxAsyfjhd56fxlyChOC0C2iYkyyZDOGoKk/zGxeK5QDRmtwSzLH7x
         PcO5jI1oZwlzhpoCvv9U0p3TI5UefWZ7+umQwYV5eWjORn5/RQBHmZX2Y1P3+QhAia
         SxfimmkRxVBE1SwJ82AEZ4W0B5VljQiDMXn4Ib7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 113/252] dmaengine: ti: omap-dma: Block PM if SDMA is busy to fix audio
Date:   Mon, 23 Nov 2020 13:21:03 +0100
Message-Id: <20201123121841.047579023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 29a25b9246f7f24203d30d59424cbe22bd905dfc ]

We now use cpu_pm for saving and restoring device context for deeper SoC
idle states. But for omap3, we must also block idle if SDMA is busy.

If we don't block idle when SDMA is busy, we eventually end up saving and
restoring SDMA register state on PER domain idle while SDMA is active and
that causes at least audio playback to fail.

Fixes: 4c74ecf79227 ("dmaengine: ti: omap-dma: Add device tree match data and use it for cpu_pm")
Reported-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20201109154013.11950-1-tony@atomide.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/omap-dma.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/ti/omap-dma.c b/drivers/dma/ti/omap-dma.c
index 918301e175525..3339f0952074a 100644
--- a/drivers/dma/ti/omap-dma.c
+++ b/drivers/dma/ti/omap-dma.c
@@ -1522,29 +1522,38 @@ static void omap_dma_free(struct omap_dmadev *od)
 	}
 }
 
+/* Currently used by omap2 & 3 to block deeper SoC idle states */
+static bool omap_dma_busy(struct omap_dmadev *od)
+{
+	struct omap_chan *c;
+	int lch = -1;
+
+	while (1) {
+		lch = find_next_bit(od->lch_bitmap, od->lch_count, lch + 1);
+		if (lch >= od->lch_count)
+			break;
+		c = od->lch_map[lch];
+		if (!c)
+			continue;
+		if (omap_dma_chan_read(c, CCR) & CCR_ENABLE)
+			return true;
+	}
+
+	return false;
+}
+
 /* Currently only used for omap2. For omap1, also a check for lcd_dma is needed */
 static int omap_dma_busy_notifier(struct notifier_block *nb,
 				  unsigned long cmd, void *v)
 {
 	struct omap_dmadev *od;
-	struct omap_chan *c;
-	int lch = -1;
 
 	od = container_of(nb, struct omap_dmadev, nb);
 
 	switch (cmd) {
 	case CPU_CLUSTER_PM_ENTER:
-		while (1) {
-			lch = find_next_bit(od->lch_bitmap, od->lch_count,
-					    lch + 1);
-			if (lch >= od->lch_count)
-				break;
-			c = od->lch_map[lch];
-			if (!c)
-				continue;
-			if (omap_dma_chan_read(c, CCR) & CCR_ENABLE)
-				return NOTIFY_BAD;
-		}
+		if (omap_dma_busy(od))
+			return NOTIFY_BAD;
 		break;
 	case CPU_CLUSTER_PM_ENTER_FAILED:
 	case CPU_CLUSTER_PM_EXIT:
@@ -1595,6 +1604,8 @@ static int omap_dma_context_notifier(struct notifier_block *nb,
 
 	switch (cmd) {
 	case CPU_CLUSTER_PM_ENTER:
+		if (omap_dma_busy(od))
+			return NOTIFY_BAD;
 		omap_dma_context_save(od);
 		break;
 	case CPU_CLUSTER_PM_ENTER_FAILED:
-- 
2.27.0



