Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07346B41D3
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjCJN5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjCJN5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8C1116BAF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:56:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4521E617D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F73EC433D2;
        Fri, 10 Mar 2023 13:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456604;
        bh=4q5PH/kOmPxsLS9edmiJufDxJZOVDOba8jWI2RfdqXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aT9rHzi9qfB51nu7tLXbRG00TLHEzx5amyehzi7AOhDMZZ40eTsIviRVNFc2FKhZd
         nKrI7JlYwkpwVv8oT9RaNx/ouc340mQTm1LMXHbUG7haRZ3U+Sh9y3kXMj2+ewmRPB
         0Ved3NIZBJgkJ7hM0E5x8L8uXhmkp8wXJrVdpKO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 061/211] watchdog: rzg2l_wdt: Handle TYPE-B reset for RZ/V2M
Date:   Fri, 10 Mar 2023 14:37:21 +0100
Message-Id: <20230310133720.584121691@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit f769f97917c1e756e12ff042a93f6e3167254b5b ]

As per section 48.4 of the HW User Manual, IPs in the RZ/V2M
SoC need either a TYPE-A reset sequence or a TYPE-B reset
sequence. More specifically, the watchdog IP needs a TYPE-B
reset sequence.

If the proper reset sequence isn't implemented, then resetting
IPs may lead to undesired behaviour. In the restart callback of
the watchdog driver the reset has basically no effect on the
desired funcionality, as the register writes following the reset
happen before the IP manages to come out of reset.

Implement the TYPE-B reset sequence in the watchdog driver to
address the issues with the restart callback on RZ/V2M.

Fixes: ec122fd94eeb ("watchdog: rzg2l_wdt: Add rzv2m support")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20221117114907.138583-3-fabrizio.castro.jz@renesas.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rzg2l_wdt.c | 37 +++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/rzg2l_wdt.c b/drivers/watchdog/rzg2l_wdt.c
index ceca42db08374..d404953d0e0f4 100644
--- a/drivers/watchdog/rzg2l_wdt.c
+++ b/drivers/watchdog/rzg2l_wdt.c
@@ -8,6 +8,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
@@ -35,6 +36,8 @@
 
 #define F2CYCLE_NSEC(f)			(1000000000 / (f))
 
+#define RZV2M_A_NSEC			730
+
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
@@ -51,11 +54,35 @@ struct rzg2l_wdt_priv {
 	struct reset_control *rstc;
 	unsigned long osc_clk_rate;
 	unsigned long delay;
+	unsigned long minimum_assertion_period;
 	struct clk *pclk;
 	struct clk *osc_clk;
 	enum rz_wdt_type devtype;
 };
 
+static int rzg2l_wdt_reset(struct rzg2l_wdt_priv *priv)
+{
+	int err, status;
+
+	if (priv->devtype == WDT_RZV2M) {
+		/* WDT needs TYPE-B reset control */
+		err = reset_control_assert(priv->rstc);
+		if (err)
+			return err;
+		ndelay(priv->minimum_assertion_period);
+		err = reset_control_deassert(priv->rstc);
+		if (err)
+			return err;
+		err = read_poll_timeout(reset_control_status, status,
+					status != 1, 0, 1000, false,
+					priv->rstc);
+	} else {
+		err = reset_control_reset(priv->rstc);
+	}
+
+	return err;
+}
+
 static void rzg2l_wdt_wait_delay(struct rzg2l_wdt_priv *priv)
 {
 	/* delay timer when change the setting register */
@@ -115,7 +142,7 @@ static int rzg2l_wdt_stop(struct watchdog_device *wdev)
 {
 	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
-	reset_control_reset(priv->rstc);
+	rzg2l_wdt_reset(priv);
 	pm_runtime_put(wdev->parent);
 
 	return 0;
@@ -154,6 +181,7 @@ static int rzg2l_wdt_restart(struct watchdog_device *wdev,
 		rzg2l_wdt_write(priv, PEEN_FORCE, PEEN);
 	} else {
 		/* RZ/V2M doesn't have parity error registers */
+		rzg2l_wdt_reset(priv);
 
 		wdev->timeout = 0;
 
@@ -251,6 +279,13 @@ static int rzg2l_wdt_probe(struct platform_device *pdev)
 
 	priv->devtype = (uintptr_t)of_device_get_match_data(dev);
 
+	if (priv->devtype == WDT_RZV2M) {
+		priv->minimum_assertion_period = RZV2M_A_NSEC +
+			3 * F2CYCLE_NSEC(pclk_rate) + 5 *
+			max(F2CYCLE_NSEC(priv->osc_clk_rate),
+			    F2CYCLE_NSEC(pclk_rate));
+	}
+
 	pm_runtime_enable(&pdev->dev);
 
 	priv->wdev.info = &rzg2l_wdt_ident;
-- 
2.39.2



