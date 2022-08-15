Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B005950D5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiHPEq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiHPEpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:45:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9669EAEDAC;
        Mon, 15 Aug 2022 13:42:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 324626122B;
        Mon, 15 Aug 2022 20:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266B3C433D6;
        Mon, 15 Aug 2022 20:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596152;
        bh=vo0TAGeRPJNhuCFG7rNuv/V9pYpe7Wt0kisbfUGzm10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUDO7eswnmuQQt8NGRcqJfaA3ODJw3o47JXDZFW1Rbx+mUz6/TJpGX3KVgBSzhqtT
         ySYinR7J6pCzLDUYV0EV+dkUwqKQ5dLfgNfdBTZbt/HF/GfspBLitXGAhmNYq9S1ik
         8FFwyrme9XHO2vTXvmhA9TBCHHbvcqQh7onKADsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0990/1157] video: fbdev: amba-clcd: Fix refcount leak bugs
Date:   Mon, 15 Aug 2022 20:05:46 +0200
Message-Id: <20220815180519.322641360@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 26c2b7d9fac42eb8317f3ceefa4c1a9a9170ca69 ]

In clcdfb_of_init_display(), we should call of_node_put() for the
references returned by of_graph_get_next_endpoint() and
of_graph_get_remote_port_parent() which have increased the refcount.

Besides, we should call of_node_put() both in fail path or when
the references are not used anymore.

Fixes: d10715be03bd ("video: ARM CLCD: Add DT support")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/amba-clcd.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
index 8080116aea84..f65c96d1394d 100644
--- a/drivers/video/fbdev/amba-clcd.c
+++ b/drivers/video/fbdev/amba-clcd.c
@@ -698,16 +698,18 @@ static int clcdfb_of_init_display(struct clcd_fb *fb)
 		return -ENODEV;
 
 	panel = of_graph_get_remote_port_parent(endpoint);
-	if (!panel)
-		return -ENODEV;
+	if (!panel) {
+		err = -ENODEV;
+		goto out_endpoint_put;
+	}
 
 	err = clcdfb_of_get_backlight(&fb->dev->dev, fb->panel);
 	if (err)
-		return err;
+		goto out_panel_put;
 
 	err = clcdfb_of_get_mode(&fb->dev->dev, panel, fb->panel);
 	if (err)
-		return err;
+		goto out_panel_put;
 
 	err = of_property_read_u32(fb->dev->dev.of_node, "max-memory-bandwidth",
 			&max_bandwidth);
@@ -736,11 +738,21 @@ static int clcdfb_of_init_display(struct clcd_fb *fb)
 
 	if (of_property_read_u32_array(endpoint,
 			"arm,pl11x,tft-r0g0b0-pads",
-			tft_r0b0g0, ARRAY_SIZE(tft_r0b0g0)) != 0)
-		return -ENOENT;
+			tft_r0b0g0, ARRAY_SIZE(tft_r0b0g0)) != 0) {
+		err = -ENOENT;
+		goto out_panel_put;
+	}
+
+	of_node_put(panel);
+	of_node_put(endpoint);
 
 	return clcdfb_of_init_tft_panel(fb, tft_r0b0g0[0],
 					tft_r0b0g0[1],  tft_r0b0g0[2]);
+out_panel_put:
+	of_node_put(panel);
+out_endpoint_put:
+	of_node_put(endpoint);
+	return err;
 }
 
 static int clcdfb_of_vram_setup(struct clcd_fb *fb)
-- 
2.35.1



