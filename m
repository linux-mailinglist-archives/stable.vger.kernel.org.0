Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFCD676EE8
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjAVPPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjAVPPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:15:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C16622038
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:15:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA7EC60BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B01C4339B;
        Sun, 22 Jan 2023 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400538;
        bh=hNQhI3TpdMbVsCPKt6vzbrDiYSYC0SVCM39E2qLWATg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMDDDQQQgtGlVY0MdQIOnMU43lCpTf0uS5zwPuLu6CL8UCVwWjneDiNMDPXplsBRi
         GZtAerTRaV4yGUkqGcJ1XYWjtO6MoB7Vxfd5js2vPtdZTfiw0mlVQCq+3QGrZXr0n6
         25HN8/PuGAX10dmcmAAdaPYqNc3TcmZbXp7weSAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/117] fbdev: omapfb: avoid stack overflow warning
Date:   Sun, 22 Jan 2023 16:03:24 +0100
Message-Id: <20230122150233.293663374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 634cf6ead93988b0da9ac054521ab63a3ba189db ]

The dsi_irq_stats structure is a little too big to fit on the
stack of a 32-bit task, depending on the specific gcc options:

fbdev/omap2/omapfb/dss/dsi.c: In function 'dsi_dump_dsidev_irqs':
fbdev/omap2/omapfb/dss/dsi.c:1621:1: error: the frame size of 1064 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Since this is only a debugfs file, performance is not critical,
so just dynamically allocate it, and print an error message
in there in place of a failure code when the allocation fails.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c | 28 ++++++++++++++--------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
index d43b081d592f..db84a662e8de 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
@@ -1538,22 +1538,28 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 {
 	struct dsi_data *dsi = dsi_get_dsidrv_data(dsidev);
 	unsigned long flags;
-	struct dsi_irq_stats stats;
+	struct dsi_irq_stats *stats;
+
+	stats = kzalloc(sizeof(*stats), GFP_KERNEL);
+	if (!stats) {
+		seq_printf(s, "out of memory\n");
+		return;
+	}
 
 	spin_lock_irqsave(&dsi->irq_stats_lock, flags);
 
-	stats = dsi->irq_stats;
+	*stats = dsi->irq_stats;
 	memset(&dsi->irq_stats, 0, sizeof(dsi->irq_stats));
 	dsi->irq_stats.last_reset = jiffies;
 
 	spin_unlock_irqrestore(&dsi->irq_stats_lock, flags);
 
 	seq_printf(s, "period %u ms\n",
-			jiffies_to_msecs(jiffies - stats.last_reset));
+			jiffies_to_msecs(jiffies - stats->last_reset));
 
-	seq_printf(s, "irqs %d\n", stats.irq_count);
+	seq_printf(s, "irqs %d\n", stats->irq_count);
 #define PIS(x) \
-	seq_printf(s, "%-20s %10d\n", #x, stats.dsi_irqs[ffs(DSI_IRQ_##x)-1])
+	seq_printf(s, "%-20s %10d\n", #x, stats->dsi_irqs[ffs(DSI_IRQ_##x)-1])
 
 	seq_printf(s, "-- DSI%d interrupts --\n", dsi->module_id + 1);
 	PIS(VC0);
@@ -1577,10 +1583,10 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d %10d %10d %10d\n", #x, \
-			stats.vc_irqs[0][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[1][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[2][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[3][ffs(DSI_VC_IRQ_##x)-1]);
+			stats->vc_irqs[0][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[1][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[2][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[3][ffs(DSI_VC_IRQ_##x)-1]);
 
 	seq_printf(s, "-- VC interrupts --\n");
 	PIS(CS);
@@ -1596,7 +1602,7 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d\n", #x, \
-			stats.cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
+			stats->cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
 
 	seq_printf(s, "-- CIO interrupts --\n");
 	PIS(ERRSYNCESC1);
@@ -1620,6 +1626,8 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 	PIS(ULPSACTIVENOT_ALL0);
 	PIS(ULPSACTIVENOT_ALL1);
 #undef PIS
+
+	kfree(stats);
 }
 
 static void dsi1_dump_irqs(struct seq_file *s)
-- 
2.35.1



