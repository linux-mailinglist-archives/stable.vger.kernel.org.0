Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D7059DBB7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357338AbiHWLmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357927AbiHWLjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:39:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FE567462;
        Tue, 23 Aug 2022 02:28:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC84BCE1B40;
        Tue, 23 Aug 2022 09:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74A7C433C1;
        Tue, 23 Aug 2022 09:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246906;
        bh=XIyPzMQLBgtYoio64LREgctipDK0aA5owJ2+ONDYE6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTDXuCrL9Sr/qT9p/5AnrjNqM6HMSTHsHdYOGCpDS2hAXNCfJpFA7NPjKAWe9LZ21
         WhpyqiRgxH78LwpdJL+5U/BrOAwqDRgNv1c5vU+PzdLgQXzCg66jByQ5hPTGQ5d+j+
         PxKHHFM6wmdGkg6YHZ5gF6GEr71WskLSwJd99TwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/389] video: fbdev: amba-clcd: Fix refcount leak bugs
Date:   Tue, 23 Aug 2022 10:25:08 +0200
Message-Id: <20220823080125.204491240@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index 3b7a7c74bf0a..09774ada36fb 100644
--- a/drivers/video/fbdev/amba-clcd.c
+++ b/drivers/video/fbdev/amba-clcd.c
@@ -714,16 +714,18 @@ static int clcdfb_of_init_display(struct clcd_fb *fb)
 		return -ENODEV;
 
 	panel = of_graph_get_remote_port_parent(endpoint);
-	if (!panel)
-		return -ENODEV;
+	if (!panel) {
+		err = -ENODEV;
+		goto out_endpoint_put;
+	}
 
 	err = clcdfb_of_get_backlight(panel, fb->panel);
 	if (err)
-		return err;
+		goto out_panel_put;
 
 	err = clcdfb_of_get_mode(&fb->dev->dev, panel, fb->panel);
 	if (err)
-		return err;
+		goto out_panel_put;
 
 	err = of_property_read_u32(fb->dev->dev.of_node, "max-memory-bandwidth",
 			&max_bandwidth);
@@ -752,11 +754,21 @@ static int clcdfb_of_init_display(struct clcd_fb *fb)
 
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



