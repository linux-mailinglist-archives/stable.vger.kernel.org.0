Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE0966C9EB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbjAPQ5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbjAPQ51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:57:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB435999C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C67696105A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD92AC433F0;
        Mon, 16 Jan 2023 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887213;
        bh=byfGjJcE9TSs+QzPf69ugM7pJQW6DUL4JOTZX5yekpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsSTYKelH0Tn/VJC8IE2ewJjSAY9xg2O4WDoq8pCLkN2P68AOoGUYXLYDMQPioxXo
         u/E7fIKcfkQPfVHjDx84LXnuptU7AYOsWCAnLqNGCYoN2UjF9B5tZmHlPL8TXjnhsw
         TGmH6cnnnAyU+jGvE47QOK2xd14enaynphekxgew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/521] clocksource/drivers/sh_cmt: Make sure channel clock supply is enabled
Date:   Mon, 16 Jan 2023 16:45:25 +0100
Message-Id: <20230116154850.052303926@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2a97d55333e4299f32c98cca6dc5c4db1c5855fc ]

The Renesas Compare Match Timer 0 and 1 (CMT0/1) variants have a
register to control the clock supply to the individual channels.
Currently the driver does not touch this register, and relies on the
documented initial value, which has the clock supply enabled for all
channels present.

However, when Linux starts on the APE6-EVM development board, only the
clock supply to the first CMT1 channel is enabled.  Hence the first
channel (used as a clockevent) works, while the second channel (used as
a clocksource) does not.  Note that the default system clocksource is
the Cortex-A15 architectured timer, and the user needs to manually
switch to the CMT1 clocksource to trigger the broken behavior.

Fix this by removing the fragile dependency on implicit reset and/or
boot loader state, and by enabling the clock supply explicitly for all
channels used instead.  This requires postponing the clk_disable() call,
else the timer's registers cannot be accessed in sh_cmt_setup_channel().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201210194648.2901899-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/sh_cmt.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 7a6d4c4c0feb..0ca8819acc4d 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -239,6 +239,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
 #define CMCNT 1 /* channel register */
 #define CMCOR 2 /* channel register */
 
+#define CMCLKE	0x1000	/* CLK Enable Register (R-Car Gen2) */
+
 static inline u32 sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
 {
 	if (ch->iostart)
@@ -856,6 +858,7 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 				unsigned int hwidx, bool clockevent,
 				bool clocksource, struct sh_cmt_device *cmt)
 {
+	u32 value;
 	int ret;
 
 	/* Skip unused channels. */
@@ -885,6 +888,11 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 		ch->iostart = cmt->mapbase + ch->hwidx * 0x100;
 		ch->ioctrl = ch->iostart + 0x10;
 		ch->timer_bit = 0;
+
+		/* Enable the clock supply to the channel */
+		value = ioread32(cmt->mapbase + CMCLKE);
+		value |= BIT(hwidx);
+		iowrite32(value, cmt->mapbase + CMCLKE);
 		break;
 	}
 
@@ -991,12 +999,10 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	else
 		cmt->rate = clk_get_rate(cmt->clk) / 8;
 
-	clk_disable(cmt->clk);
-
 	/* Map the memory resource(s). */
 	ret = sh_cmt_map_memory(cmt);
 	if (ret < 0)
-		goto err_clk_unprepare;
+		goto err_clk_disable;
 
 	/* Allocate and setup the channels. */
 	cmt->num_channels = hweight8(cmt->hw_channels);
@@ -1024,6 +1030,8 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 		mask &= ~(1 << hwidx);
 	}
 
+	clk_disable(cmt->clk);
+
 	platform_set_drvdata(pdev, cmt);
 
 	return 0;
@@ -1031,6 +1039,8 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 err_unmap:
 	kfree(cmt->channels);
 	iounmap(cmt->mapbase);
+err_clk_disable:
+	clk_disable(cmt->clk);
 err_clk_unprepare:
 	clk_unprepare(cmt->clk);
 err_clk_put:
-- 
2.35.1



