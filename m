Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F506B4688
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjCJOoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbjCJOnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:43:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5D9F6C45
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B3ACB822DD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07D2C433EF;
        Fri, 10 Mar 2023 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459417;
        bh=AvZWhyc2chsXPo55AExN5en5/J0xkkBTakL4AM0pPHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJGWyqoiKQTyOw84VDLV/OCppO7/b2yVtLywHxlRokE5mM2xxI6yivjgRTmN1rSxE
         gl/ipLeaDLjrANoOOjwywFZ+uuO+wi1Y1sF4UhGy4ofLYobIh6b4fP8sU1O3ZuG38z
         CmLxZwItHp794M39TqXzE6zK5FxMxVXjwUujfp4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <mripard@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 324/357] rtc: sun6i: Make external 32k oscillator optional
Date:   Fri, 10 Mar 2023 14:40:13 +0100
Message-Id: <20230310133748.957723675@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit ec98a87509f40324807dc179a7e3163d40709eba ]

Some boards, like OrangePi PC2 (H5), OrangePi Plus 2E (H3) and Tanix TX6
(H6) don't have external 32kHz oscillator. Till H6, it didn't really
matter if external oscillator was enabled because HW detected error and
fall back to internal one. H6 has same functionality but it's the first
SoC which have "auto switch bypass" bit documented and always enabled in
driver. This prevents RTC to work correctly if external crystal is not
present on board. There are other side effects - all peripherals which
depends on this clock also don't work (HDMI CEC for example).

Make clocks property optional. If it is present, select external
oscillator. If not, stay on internal.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20200308135849.106333-2-jernej.skrabec@siol.net
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 344f4030f6c5 ("rtc: sun6i: Always export the internal oscillator")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sun6i.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index c41bc8084d7cc..b13af0368ef61 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -251,19 +251,17 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 		writel(reg, rtc->base + SUN6I_LOSC_CTRL);
 	}
 
-	/* Switch to the external, more precise, oscillator */
-	reg |= SUN6I_LOSC_CTRL_EXT_OSC;
-	if (rtc->data->has_losc_en)
-		reg |= SUN6I_LOSC_CTRL_EXT_LOSC_EN;
+	/* Switch to the external, more precise, oscillator, if present */
+	if (of_get_property(node, "clocks", NULL)) {
+		reg |= SUN6I_LOSC_CTRL_EXT_OSC;
+		if (rtc->data->has_losc_en)
+			reg |= SUN6I_LOSC_CTRL_EXT_LOSC_EN;
+	}
 	writel(reg, rtc->base + SUN6I_LOSC_CTRL);
 
 	/* Yes, I know, this is ugly. */
 	sun6i_rtc = rtc;
 
-	/* Deal with old DTs */
-	if (!of_get_property(node, "clocks", NULL))
-		goto err;
-
 	/* Only read IOSC name from device tree if it is exported */
 	if (rtc->data->export_iosc)
 		of_property_read_string_index(node, "clock-output-names", 2,
@@ -280,11 +278,13 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 	}
 
 	parents[0] = clk_hw_get_name(rtc->int_osc);
+	/* If there is no external oscillator, this will be NULL and ... */
 	parents[1] = of_clk_get_parent_name(node, 0);
 
 	rtc->hw.init = &init;
 
 	init.parent_names = parents;
+	/* ... number of clock parents will be 1. */
 	init.num_parents = of_clk_get_parent_count(node) + 1;
 	of_property_read_string_index(node, "clock-output-names", 0,
 				      &init.name);
-- 
2.39.2



