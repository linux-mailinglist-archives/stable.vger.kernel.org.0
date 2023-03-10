Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F054D6B4208
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjCJN7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjCJN7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:59:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818145C113
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FED5B822B7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E99C4339B;
        Fri, 10 Mar 2023 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456737;
        bh=ZyqQw6i9d7eSgJWLY6Sc4Sni22S1Vpps3/Gjhtmp+kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHpzu5N5Xicyiu1QQf2kYkRG6pTAfySa79i8SeHYaa4d7Jd/VGkCZVAT5d+kZqp0U
         YObj47wubD1ZHSziPXeQtYI5XD/lfIreRJYMgtZdVOsB+iakmYzlP1Ug7csPPE2L7g
         WpQVa+iKFhpNpgrfHoJ9QyocZLUKVNrEpOL9P2Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 105/211] rtc: sun6i: Always export the internal oscillator
Date:   Fri, 10 Mar 2023 14:38:05 +0100
Message-Id: <20230310133721.953569353@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 344f4030f6c50a9db2d03021884c4bf36191b53a ]

On all variants of the hardware, the internal oscillator is one possible
parent for the AR100 clock. It needs to be exported so we can model that
relationship correctly in the devicetree.

Fixes: c56afc1844d6 ("rtc: sun6i: Expose internal oscillator through device tree")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221229215319.14145-1-samuel@sholland.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sun6i.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index ed5516089e9a0..7038f47d77ff4 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -136,7 +136,6 @@ struct sun6i_rtc_clk_data {
 	unsigned int fixed_prescaler : 16;
 	unsigned int has_prescaler : 1;
 	unsigned int has_out_clk : 1;
-	unsigned int export_iosc : 1;
 	unsigned int has_losc_en : 1;
 	unsigned int has_auto_swt : 1;
 };
@@ -271,10 +270,8 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 	/* Yes, I know, this is ugly. */
 	sun6i_rtc = rtc;
 
-	/* Only read IOSC name from device tree if it is exported */
-	if (rtc->data->export_iosc)
-		of_property_read_string_index(node, "clock-output-names", 2,
-					      &iosc_name);
+	of_property_read_string_index(node, "clock-output-names", 2,
+				      &iosc_name);
 
 	rtc->int_osc = clk_hw_register_fixed_rate_with_accuracy(NULL,
 								iosc_name,
@@ -315,13 +312,10 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 		goto err_register;
 	}
 
-	clk_data->num = 2;
+	clk_data->num = 3;
 	clk_data->hws[0] = &rtc->hw;
 	clk_data->hws[1] = __clk_get_hw(rtc->ext_losc);
-	if (rtc->data->export_iosc) {
-		clk_data->hws[2] = rtc->int_osc;
-		clk_data->num = 3;
-	}
+	clk_data->hws[2] = rtc->int_osc;
 	of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	return;
 
@@ -361,7 +355,6 @@ static const struct sun6i_rtc_clk_data sun8i_h3_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 };
 
 static void __init sun8i_h3_rtc_clk_init(struct device_node *node)
@@ -379,7 +372,6 @@ static const struct sun6i_rtc_clk_data sun50i_h6_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 	.has_losc_en = 1,
 	.has_auto_swt = 1,
 };
-- 
2.39.2



