Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C02B113463
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfLDSCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729944AbfLDSCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:02:54 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3680C206DF;
        Wed,  4 Dec 2019 18:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482573;
        bh=cUBxm5bpX3BNZcvYOv8A70HiYFqDP/A/TSE0hj9URx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooGSiKPoBClAUwwsDayXXRIMKCCIXLF2IpjOrokfnEXc7sYH5fJ2tl6tHhFFumQgh
         Obl0i0aN7AUTCztom4nw1CJ3xmY+iZsVIoFSOFZwpSjzOcIG+r21gi6JZGdZMuW4w4
         hXbxXH66ZLms8bqS8CYhiHmsNYCTDaYXoRCP+zCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 008/209] clk: at91: avoid sleeping early
Date:   Wed,  4 Dec 2019 18:53:40 +0100
Message-Id: <20191204175322.181704522@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 658fd65cf0b0d511de1718e48d9a28844c385ae0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-main.c |  5 ++++-
 drivers/clk/at91/sckc.c     | 20 ++++++++++++++++----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
index 2f97a843d6d6b..fb5c14af8cc8d 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -354,7 +354,10 @@ static int clk_main_probe_frequency(struct regmap *regmap)
 		regmap_read(regmap, AT91_CKGR_MCFR, &mcfr);
 		if (mcfr & AT91_PMC_MAINRDY)
 			return 0;
-		usleep_range(MAINF_LOOP_MIN_WAIT, MAINF_LOOP_MAX_WAIT);
+		if (system_state < SYSTEM_RUNNING)
+			udelay(MAINF_LOOP_MIN_WAIT);
+		else
+			usleep_range(MAINF_LOOP_MIN_WAIT, MAINF_LOOP_MAX_WAIT);
 	} while (time_before(prep_time, timeout));
 
 	return -ETIMEDOUT;
diff --git a/drivers/clk/at91/sckc.c b/drivers/clk/at91/sckc.c
index ab6ecefc49ad8..43ba2a8b03faf 100644
--- a/drivers/clk/at91/sckc.c
+++ b/drivers/clk/at91/sckc.c
@@ -74,7 +74,10 @@ static int clk_slow_osc_prepare(struct clk_hw *hw)
 
 	writel(tmp | AT91_SCKC_OSC32EN, sckcr);
 
-	usleep_range(osc->startup_usec, osc->startup_usec + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(osc->startup_usec);
+	else
+		usleep_range(osc->startup_usec, osc->startup_usec + 1);
 
 	return 0;
 }
@@ -197,7 +200,10 @@ static int clk_slow_rc_osc_prepare(struct clk_hw *hw)
 
 	writel(readl(sckcr) | AT91_SCKC_RCEN, sckcr);
 
-	usleep_range(osc->startup_usec, osc->startup_usec + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(osc->startup_usec);
+	else
+		usleep_range(osc->startup_usec, osc->startup_usec + 1);
 
 	return 0;
 }
@@ -310,7 +316,10 @@ static int clk_sam9x5_slow_set_parent(struct clk_hw *hw, u8 index)
 
 	writel(tmp, sckcr);
 
-	usleep_range(SLOWCK_SW_TIME_USEC, SLOWCK_SW_TIME_USEC + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(SLOWCK_SW_TIME_USEC);
+	else
+		usleep_range(SLOWCK_SW_TIME_USEC, SLOWCK_SW_TIME_USEC + 1);
 
 	return 0;
 }
@@ -443,7 +452,10 @@ static int clk_sama5d4_slow_osc_prepare(struct clk_hw *hw)
 		return 0;
 	}
 
-	usleep_range(osc->startup_usec, osc->startup_usec + 1);
+	if (system_state < SYSTEM_RUNNING)
+		udelay(osc->startup_usec);
+	else
+		usleep_range(osc->startup_usec, osc->startup_usec + 1);
 	osc->prepared = true;
 
 	return 0;
-- 
2.20.1



