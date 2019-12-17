Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314CF122047
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfLQAxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:53:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35430 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727125AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003Mi-Di; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005ap-CP; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Uwe Kleine-=?UTF-8?Q?K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        "Stephen Boyd" <sboyd@kernel.org>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>
Date:   Tue, 17 Dec 2019 00:47:11 +0000
Message-ID: <lsq.1576543535.596911348@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 097/136] clk: at91: avoid sleeping early
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit 658fd65cf0b0d511de1718e48d9a28844c385ae0 upstream.

It is not allowed to sleep to early in the boot process and this may lead
to kernel issues if the bootloader didn't prepare the slow clock and main
clock.

This results in the following error and dump stack on the AriettaG25:
   bad: scheduling from the idle thread!

Ensure it is possible to sleep, else simply have a delay.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lkml.kernel.org/r/20190920153906.20887-1-alexandre.belloni@bootlin.com
Fixes: 80eded6ce8bb ("clk: at91: add slow clks driver")
Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
[bwh: Backported to 3.16:
 - Drop changes in clk_sama5d4_slow_osc_prepare()
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/clk/at91/clk-main.c |  5 ++++-
 drivers/clk/at91/clk-slow.c | 20 ++++++++++++++++----
 2 files changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -374,7 +374,10 @@ static int clk_main_probe_frequency(stru
 		tmp = pmc_read(pmc, AT91_CKGR_MCFR);
 		if (tmp & AT91_PMC_MAINRDY)
 			return 0;
-		usleep_range(MAINF_LOOP_MIN_WAIT, MAINF_LOOP_MAX_WAIT);
+		if (system_state < SYSTEM_RUNNING)
+			udelay(MAINF_LOOP_MIN_WAIT);
+		else
+			usleep_range(MAINF_LOOP_MIN_WAIT, MAINF_LOOP_MAX_WAIT);
 	} while (time_before(prep_time, timeout));
 
 	return -ETIMEDOUT;
--- a/drivers/clk/at91/clk-slow.c
+++ b/drivers/clk/at91/clk-slow.c
@@ -83,7 +83,10 @@ static int clk_slow_osc_prepare(struct c
 
 	writel(tmp | AT91_SCKC_OSC32EN, sckcr);
 
-	usleep_range(osc->startup_usec, osc->startup_usec + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(osc->startup_usec);
+	else
+		usleep_range(osc->startup_usec, osc->startup_usec + 1);
 
 	return 0;
 }
@@ -202,7 +205,10 @@ static int clk_slow_rc_osc_prepare(struc
 
 	writel(readl(sckcr) | AT91_SCKC_RCEN, sckcr);
 
-	usleep_range(osc->startup_usec, osc->startup_usec + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(osc->startup_usec);
+	else
+		usleep_range(osc->startup_usec, osc->startup_usec + 1);
 
 	return 0;
 }
@@ -311,7 +317,10 @@ static int clk_sam9x5_slow_set_parent(st
 
 	writel(tmp, sckcr);
 
-	usleep_range(SLOWCK_SW_TIME_USEC, SLOWCK_SW_TIME_USEC + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(SLOWCK_SW_TIME_USEC);
+	else
+		usleep_range(SLOWCK_SW_TIME_USEC, SLOWCK_SW_TIME_USEC + 1);
 
 	return 0;
 }

