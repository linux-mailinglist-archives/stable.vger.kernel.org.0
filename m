Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7F713A4E0
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgANKDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgANKDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:03:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E2602467A;
        Tue, 14 Jan 2020 10:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996193;
        bh=Y8n5Xq7QrrHdn51y6Y+MiO1NJwW6aO/i/vy85JvAh30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XiVDGZ80SF7eBWg/dUy/tGi6VlgujKyiDw+qyCEEdes9OKuQ2sT5hwujBueW/FLC
         VmvBXPVDhTqGpXrXvU7KAbJHET3smwk1aMZ9lEMcQE9vZb8qLAw6kmaIX6mMsadJil
         Q9SGN4PwcutfrbYQlSAGvlZnhqGtwA2eIjFRE9qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <mripard@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 13/78] rtc: sun6i: Add support for RTC clocks on R40
Date:   Tue, 14 Jan 2020 11:00:47 +0100
Message-Id: <20200114094354.475637579@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

commit 111bf02b8f544f98de53ea1f912ae01f598b161b upstream.

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
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20191205085054.6049-1-wens@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-sun6i.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -380,6 +380,22 @@ static void __init sun50i_h6_rtc_clk_ini
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


