Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABA114800B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389321AbgAXLHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:07:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389422AbgAXLHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:07:14 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F022A2071A;
        Fri, 24 Jan 2020 11:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864033;
        bh=bRK+u7gfryV7ZS7Xau4+S80l13Tz7+AFfgeSbnpwlpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojEYenvdPrc7uvO0o4pczC28v9teF4A71JOXhrTxZHtan439impb8XSBt4UaK5NEp
         bq/5emrSUzxbDPOaZEqWvFVak4aLx1xNHkfBQDRpAUYBOuFDfevhVhr+klUYPcJzTK
         vfwFH99UEYzQrrQaSR64ZrBHLzf6ORsYCZ3lt5Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Keerthy <j-keerthy@ti.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Kemnade <andreas@kemnade.info>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/639] bus: ti-sysc: Fix timer handling with drop pm_runtime_irq_safe()
Date:   Fri, 24 Jan 2020 10:25:23 +0100
Message-Id: <20200124093106.382897205@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9bd34c63f5536c490c152833c77fa47f59aeade3 ]

Commit 84badc5ec5fc ("ARM: dts: omap4: Move l4 child devices to probe
them with ti-sysc") started producing a warning for pwm-omap-dmtimer:

WARNING: CPU: 0 PID: 77 at drivers/bus/omap_l3_noc.c:147
l3_interrupt_handler+0x2f8/0x388
44000000.ocp:L3 Custom Error: MASTER MPU TARGET L4PER2 (Idle):
Data Access in Supervisor mode during Functional access
...
__pm_runtime_idle
omap_dm_timer_disable
pwm_omap_dmtimer_start
pwm_omap_dmtimer_enable
pwm_apply_state
pwm_vibrator_start
pwm_vibrator_play_work

This is because the timer that pwm-omap-dmtimer is using is now being
probed with ti-sysc interconnect target module instead of omap_device
and the ti-sysc quirk for SYSC_QUIRK_LEGACY_IDLE is not fully
compatible with what omap_device has been doing.

We could fix this by reverting the timer changes and have the timer
probe again with omap_device. Or we could add more quirk handling to
ti-sysc driver. But as these options don't work nicely as longer term
solutions, let's just make timers probe with ti-sysc without any
quirks.

To do this, all we need to do is remove quirks for timers for ti-sysc,
and drop the bogus pm_runtime_irq_safe() flag for timer-ti-dm.

We should not use pm_runtime_irq_safe() anyways for drivers as it will
take a permanent use count on the parent device blocking the parent
devices from idling and has been forcing ti-sysc driver to use a
quirk flag.

Note that we will move the timer data to DEBUG section later on in
clean-up patches.

Fixes: 84badc5ec5fc ("ARM: dts: omap4: Move l4 child devices to probe them with ti-sysc")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: H. Nikolaus Schaller <hns@goldelico.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Tested-By: Andreas Kemnade <andreas@kemnade.info>
Tested-By: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c             | 4 ++--
 drivers/clocksource/timer-ti-dm.c | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 926c83398b27b..2813f9ed57c0d 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -888,10 +888,10 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("smartreflex", 0, -1, 0x38, -1, 0x00000000, 0xffffffff,
 		   SYSC_QUIRK_LEGACY_IDLE),
 	SYSC_QUIRK("timer", 0, 0, 0x10, 0x14, 0x00000015, 0xffffffff,
-		   SYSC_QUIRK_LEGACY_IDLE),
+		   0),
 	/* Some timers on omap4 and later */
 	SYSC_QUIRK("timer", 0, 0, 0x10, -1, 0x4fff1301, 0xffffffff,
-		   SYSC_QUIRK_LEGACY_IDLE),
+		   0),
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x00000052, 0xffffffff,
 		   SYSC_QUIRK_LEGACY_IDLE),
 	/* Uarts on omap4 and later */
diff --git a/drivers/clocksource/timer-ti-dm.c b/drivers/clocksource/timer-ti-dm.c
index 3ecf84706640b..23414dddc3bae 100644
--- a/drivers/clocksource/timer-ti-dm.c
+++ b/drivers/clocksource/timer-ti-dm.c
@@ -868,7 +868,6 @@ static int omap_dm_timer_probe(struct platform_device *pdev)
 	timer->pdev = pdev;
 
 	pm_runtime_enable(dev);
-	pm_runtime_irq_safe(dev);
 
 	if (!timer->reserved) {
 		ret = pm_runtime_get_sync(dev);
-- 
2.20.1



