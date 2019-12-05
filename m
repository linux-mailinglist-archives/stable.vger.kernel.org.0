Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2431B113D55
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 09:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfLEIu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 03:50:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfLEIu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 03:50:59 -0500
Received: from wens.tw (mirror2.csie.ntu.edu.tw [140.112.30.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DB4F205ED;
        Thu,  5 Dec 2019 08:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575535858;
        bh=jv3bVtccHNR/eO6WUrlGuplkynPeqmKgBox/+jgglmY=;
        h=From:To:Cc:Subject:Date:From;
        b=zJ2Pgng4JVDyPDNCnaCPVIuU4jWEK7fe+PHC7tvpnKoUvx93g75P4sFbdREl/Zw8p
         /bM6Ao3pHaM1MNS83wq5HStQHqVgS9QC7HkwRQM/Q82q0WsFYYTRjWadNWKsj/FWWK
         2sWWQ1VmT1c9uzt3wrafhsOLLDYXqPNnwbzhpNkI=
Received: by wens.tw (Postfix, from userid 1000)
        id C09F55FA9F; Thu,  5 Dec 2019 16:50:54 +0800 (CST)
From:   Chen-Yu Tsai <wens@kernel.org>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Maxime Ripard <mripard@kernel.org>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-rtc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] rtc: sun6i: Add support for RTC clocks on R40
Date:   Thu,  5 Dec 2019 16:50:54 +0800
Message-Id: <20191205085054.6049-1-wens@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

When support for the R40 in the rtc-sun6i driver was split out for a
separate compatible string, only the RTC half was covered, and not the
clock half. Unfortunately this results in the whole driver not working,
as the RTC half expects the clock half to have been initialized.

Add support for the clock part as well. The clock part is like the H3,
but does not need to export the internal oscillator, nor does it have
a gateable LOSC external output.

This fixes issues with WiFi and Bluetooth not working on the BPI M2U.

Fixes: d6624cc75021 ("rtc: sun6i: Add R40 compatible")
Cc: <stable@vger.kernel.org> # 5.3.x
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---

Please merge this for fixes.

---
 drivers/rtc/rtc-sun6i.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index 5e2bd9f1d01e..fc32be687606 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -380,6 +380,22 @@ static void __init sun50i_h6_rtc_clk_init(struct device_node *node)
 CLK_OF_DECLARE_DRIVER(sun50i_h6_rtc_clk, "allwinner,sun50i-h6-rtc",
 		      sun50i_h6_rtc_clk_init);
 
+/*
+ * The R40 user manual is self-conflicting on whether the prescaler is
+ * fixed or configurable. The clock diagram shows it as fixed, but there
+ * is also a configurable divider in the RTC block.
+ */
+static const struct sun6i_rtc_clk_data sun8i_r40_rtc_data = {
+	.rc_osc_rate = 16000000,
+	.fixed_prescaler = 512,
+};
+static void __init sun8i_r40_rtc_clk_init(struct device_node *node)
+{
+	sun6i_rtc_clk_init(node, &sun8i_r40_rtc_data);
+}
+CLK_OF_DECLARE_DRIVER(sun8i_r40_rtc_clk, "allwinner,sun8i-r40-rtc",
+		      sun8i_r40_rtc_clk_init);
+
 static const struct sun6i_rtc_clk_data sun8i_v3_rtc_data = {
 	.rc_osc_rate = 32000,
 	.has_out_clk = 1,
-- 
2.24.0

