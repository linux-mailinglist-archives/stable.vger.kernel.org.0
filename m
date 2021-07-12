Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8467E3C533F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352192AbhGLHyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244029AbhGLHtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:49:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBCE961993;
        Mon, 12 Jul 2021 07:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075794;
        bh=5zlbmlvk1VlahUaiaHBzlrBgUx3osJ++wGdNjSq0qWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZIJ+vFdhQ5qOM+S474MRCaqJ0wAnnfU1bx0AAwqXEjdksNorFk9M+yY01SmgZo7s
         iza7CyWYIhenDQGkON/EvEC9GvHWC1/vysi2dHsB24Ftqn91fp63BdSru5KP6UlQpS
         EsDPwNWOsXLwx/g2BlOsPYKl+GuLFZCbkMePdStE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Adam Ford <aford173@gmail.com>,
        Andreas Kemnade <andreas@kemnade.info>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 366/800] clocksource/drivers/timer-ti-dm: Save and restore timer TIOCP_CFG
Date:   Mon, 12 Jul 2021 08:06:29 +0200
Message-Id: <20210712061005.993464797@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9517c577f9f722270584cfb1a7b4e1354e408658 ]

As we are using cpu_pm to save and restore context, we must also save and
restore the timer sysconfig register TIOCP_CFG. This is needed because
we are not calling PM runtime functions at all with cpu_pm.

Fixes: b34677b0999a ("clocksource/drivers/timer-ti-dm: Implement cpu_pm notifier for context save and restore")
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Adam Ford <aford173@gmail.com>
Cc: Andreas Kemnade <andreas@kemnade.info>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210415085506.56828-1-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm.c | 6 ++++++
 include/clocksource/timer-ti-dm.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/clocksource/timer-ti-dm.c b/drivers/clocksource/timer-ti-dm.c
index 33eeabf9c3d1..e5c631f1b5cb 100644
--- a/drivers/clocksource/timer-ti-dm.c
+++ b/drivers/clocksource/timer-ti-dm.c
@@ -78,6 +78,9 @@ static void omap_dm_timer_write_reg(struct omap_dm_timer *timer, u32 reg,
 
 static void omap_timer_restore_context(struct omap_dm_timer *timer)
 {
+	__omap_dm_timer_write(timer, OMAP_TIMER_OCP_CFG_OFFSET,
+			      timer->context.ocp_cfg, 0);
+
 	omap_dm_timer_write_reg(timer, OMAP_TIMER_WAKEUP_EN_REG,
 				timer->context.twer);
 	omap_dm_timer_write_reg(timer, OMAP_TIMER_COUNTER_REG,
@@ -95,6 +98,9 @@ static void omap_timer_restore_context(struct omap_dm_timer *timer)
 
 static void omap_timer_save_context(struct omap_dm_timer *timer)
 {
+	timer->context.ocp_cfg =
+		__omap_dm_timer_read(timer, OMAP_TIMER_OCP_CFG_OFFSET, 0);
+
 	timer->context.tclr =
 			omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
 	timer->context.twer =
diff --git a/include/clocksource/timer-ti-dm.h b/include/clocksource/timer-ti-dm.h
index 4c61dade8835..f6da8a132639 100644
--- a/include/clocksource/timer-ti-dm.h
+++ b/include/clocksource/timer-ti-dm.h
@@ -74,6 +74,7 @@
 #define OMAP_TIMER_ERRATA_I103_I767			0x80000000
 
 struct timer_regs {
+	u32 ocp_cfg;
 	u32 tidr;
 	u32 tier;
 	u32 twer;
-- 
2.30.2



