Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C006B45AC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjCJOgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjCJOfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:35:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4707EF8288
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:35:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC8FEB822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC2FC4339B;
        Fri, 10 Mar 2023 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458945;
        bh=XKWy4UhBXEbZsALsOJDKRGW9GAY3tOE9SpFc7YABkv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKMxv0eje3JUI6l7XIE2UmYFs68utbQqGh92JpuQZ8y/HfRw5S51aab7//RtfkTtz
         uGlSEE7pvL62y7DVOUeQ5ClAlrmawAlVkHv1u4tI0DNoPO4JZ7RqvX09HtTF4A9h0U
         gmyDQ0H20kYRWbs4E3p5Td4ecgriNQ9LMqSh7200=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/357] drm/omap: dsi: Fix excessive stack usage
Date:   Fri, 10 Mar 2023 14:38:06 +0100
Message-Id: <20230310133743.414146333@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit cfca78971b9233aef0891507a98fba62046d4542 ]

dsi_dump_dsi_irqs(), a function used for debugfs prints, has a large
struct in its frame, which can result in:

drivers/gpu/drm/omapdrm/dss/dsi.c:1126:1: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]

As the performance of the function is of no concern, let's allocate the
struct with kmalloc instead.

Compile-tested only.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220916082206.167427-1-tomi.valkeinen@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/dsi.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index b30fcaa2d0f55..993d48fb8064d 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -1444,22 +1444,26 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 {
 	struct dsi_data *dsi = s->private;
 	unsigned long flags;
-	struct dsi_irq_stats stats;
+	struct dsi_irq_stats *stats;
+
+	stats = kmalloc(sizeof(*stats), GFP_KERNEL);
+	if (!stats)
+		return -ENOMEM;
 
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
-	seq_printf(s, "%-20s %10d\n", #x, stats.dsi_irqs[ffs(DSI_IRQ_##x)-1]);
+	seq_printf(s, "%-20s %10d\n", #x, stats->dsi_irqs[ffs(DSI_IRQ_##x)-1]);
 
 	seq_printf(s, "-- DSI%d interrupts --\n", dsi->module_id + 1);
 	PIS(VC0);
@@ -1483,10 +1487,10 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 
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
@@ -1502,7 +1506,7 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d\n", #x, \
-			stats.cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
+			stats->cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
 
 	seq_printf(s, "-- CIO interrupts --\n");
 	PIS(ERRSYNCESC1);
@@ -1527,6 +1531,8 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 	PIS(ULPSACTIVENOT_ALL1);
 #undef PIS
 
+	kfree(stats);
+
 	return 0;
 }
 #endif
-- 
2.39.2



