Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069BB1CAB7B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgEHMoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbgEHMoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A00A20720;
        Fri,  8 May 2020 12:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941840;
        bh=w3HMVEItd//SSI0ayVCAHvyQdcWATCUJbt5WZpXajVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbj7KS6E3OjLjOlPfwtChWd6gewnReeDropr2UVi2q8KTOCflmkVsxYErDHcovTnW
         8o5KHaI9n5CTof2hx/mZsN3yS5h8kLAzNDYYaWImBI2T41XyWBjwGybAi9nFg073wm
         OP9B2gO8PeZz9o1eGRB3ynoHj7d1bJrHcqHhAb4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 143/312] mmc: dw_mmc: rockchip: Set the drive phase properly
Date:   Fri,  8 May 2020 14:32:14 +0200
Message-Id: <20200508123134.529736767@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit d4aa908c7978f60557a799ca53b5ae4166fd8355 upstream.

Historically for Rockchip devices we've relied on the power-on
default (or perhaps the firmware setting) to get the correct drive
phase for dw_mmc devices.  This worked OK for the most part, but:

* Relying on the setting just "being right" is a bit fragile.

* As soon as there is an instance where the power on default is wrong or
  where the firmware didn't configure this properly then we'll get a
  mysterious failure.

In commit 7a03fe6f48f3 ("clk: rockchip: reset init state before mmc card
initialization") we actually started setting this explicitly in the
kernel, but that commit wasn't quite right and also wasn't quite
enough.  See <https://patchwork.kernel.org/patch/9085311/> for some
details.

Let's explicitly set this phase in dw_mmc.

The comments inside this patch try to explain the situation quite
throughly, but the high level overview of this is:

Before this patch on rk3288 devices tested (after revert of the clock
patch described above):
* eMMC: 180 degrees
* SDMMC/SDIO0/SDIO1: 90 degrees

After this patch:
* Use 90 degree phase offset usually.
* Use 180 degree phase offset for MMC_DDR52, SDR104, HS200.

That means we are _changing_ behavior for those devices in this way:

* If we have HS200 eMMC or DDR52 eMMC, we'll run ID mode at 90
  degrees (vs 180) but otherwise have no change.

* For any non-HS200 / non-DDR52 eMMC devices we'll now _always_ run at
  90 degrees (vs 180).  It seems fairly unlikely that building modern
  hardware is using an eMMC that isn't using DDR52 or HS200, of course.

* For SDR104 cards we'll now run with 180 degree phase offset (vs 90).
  It's expected that 90 degree phase offset would have worked OK, but
  this gives us extra margin.

I have tested this by inserting my collection of uSD cards (mostly UHS,
though a few not) into a veyron_minnie and confirmed that they still
seem to enumerate properly.  For a subset of them I tried putting a
filesystem on them and also tried running mmc_test.

Fixes: 7a03fe6f48f3 ("clk: rockchip: reset init state before mmc card initialization")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/dw_mmc-rockchip.c |   64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -78,6 +78,70 @@ static void dw_mci_rk3288_set_ios(struct
 	/* Make sure we use phases which we can enumerate with */
 	if (!IS_ERR(priv->sample_clk))
 		clk_set_phase(priv->sample_clk, priv->default_sample_phase);
+
+	/*
+	 * Set the drive phase offset based on speed mode to achieve hold times.
+	 *
+	 * NOTE: this is _not_ a value that is dynamically tuned and is also
+	 * _not_ a value that will vary from board to board.  It is a value
+	 * that could vary between different SoC models if they had massively
+	 * different output clock delays inside their dw_mmc IP block (delay_o),
+	 * but since it's OK to overshoot a little we don't need to do complex
+	 * calculations and can pick values that will just work for everyone.
+	 *
+	 * When picking values we'll stick with picking 0/90/180/270 since
+	 * those can be made very accurately on all known Rockchip SoCs.
+	 *
+	 * Note that these values match values from the DesignWare Databook
+	 * tables for the most part except for SDR12 and "ID mode".  For those
+	 * two modes the databook calculations assume a clock in of 50MHz.  As
+	 * seen above, we always use a clock in rate that is exactly the
+	 * card's input clock (times RK3288_CLKGEN_DIV, but that gets divided
+	 * back out before the controller sees it).
+	 *
+	 * From measurement of a single device, it appears that delay_o is
+	 * about .5 ns.  Since we try to leave a bit of margin, it's expected
+	 * that numbers here will be fine even with much larger delay_o
+	 * (the 1.4 ns assumed by the DesignWare Databook would result in the
+	 * same results, for instance).
+	 */
+	if (!IS_ERR(priv->drv_clk)) {
+		int phase;
+
+		/*
+		 * In almost all cases a 90 degree phase offset will provide
+		 * sufficient hold times across all valid input clock rates
+		 * assuming delay_o is not absurd for a given SoC.  We'll use
+		 * that as a default.
+		 */
+		phase = 90;
+
+		switch (ios->timing) {
+		case MMC_TIMING_MMC_DDR52:
+			/*
+			 * Since clock in rate with MMC_DDR52 is doubled when
+			 * bus width is 8 we need to double the phase offset
+			 * to get the same timings.
+			 */
+			if (ios->bus_width == MMC_BUS_WIDTH_8)
+				phase = 180;
+			break;
+		case MMC_TIMING_UHS_SDR104:
+		case MMC_TIMING_MMC_HS200:
+			/*
+			 * In the case of 150 MHz clock (typical max for
+			 * Rockchip SoCs), 90 degree offset will add a delay
+			 * of 1.67 ns.  That will meet min hold time of .8 ns
+			 * as long as clock output delay is < .87 ns.  On
+			 * SoCs measured this seems to be OK, but it doesn't
+			 * hurt to give margin here, so we use 180.
+			 */
+			phase = 180;
+			break;
+		}
+
+		clk_set_phase(priv->drv_clk, phase);
+	}
 }
 
 #define NUM_PHASES			360


