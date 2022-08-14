Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D010592556
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243247AbiHNQkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243118AbiHNQjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:39:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FAD13F13;
        Sun, 14 Aug 2022 09:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3D7160FBE;
        Sun, 14 Aug 2022 16:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318A3C433D6;
        Sun, 14 Aug 2022 16:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494596;
        bh=BG1IryY/JpKplKDyYH7hpVvg67ZthQH8oyEbqAqfFfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AePX59s2OIY3o67XhI6VmcjfskIOU/JFlKoUbLnvjVhoHBSrRt3tdLp6yXgCPou6e
         e5LB0olUlCBf1GA8jvP7/0W8K3XdVB65ykT7aUzOBL1QTs0Gt+tWx9KgWyvVj5Y3sm
         mN3Mlk4f/7o1ic8jWdioMpXT/pkmHkoJBkkgZ+Qon4cVDKHk+wSeAZZA4JOOhf6pi7
         8ucEr7mz+2aN9N1zHsLWrFtHtIRB0udILDZXBZa/lqJa3zGZ8WdLCIWxW/7/HYEZBq
         nsCF3ke7OhfoeSKmvoMNSF5lSQbcIR41lju80cLO4sehnpLI4zP7UiVWjmXzgibcfQ
         Sj9PXwwYokbAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, linux@zary.sk,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 13/14] video: fbdev: i740fb: Check the argument of i740_calc_vclk()
Date:   Sun, 14 Aug 2022 12:29:19 -0400
Message-Id: <20220814162922.2398723-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162922.2398723-1-sashal@kernel.org>
References: <20220814162922.2398723-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 40bf722f8064f50200b8c4f8946cd625b441dda9 ]

Since the user can control the arguments of the ioctl() from the user
space, under special arguments that may result in a divide-by-zero bug.

If the user provides an improper 'pixclock' value that makes the argumet
of i740_calc_vclk() less than 'I740_RFREQ_FIX', it will cause a
divide-by-zero bug in:
    drivers/video/fbdev/i740fb.c:353 p_best = min(15, ilog2(I740_MAX_VCO_FREQ / (freq / I740_RFREQ_FIX)));

The following log can reveal it:

divide error: 0000 [#1] PREEMPT SMP KASAN PTI
RIP: 0010:i740_calc_vclk drivers/video/fbdev/i740fb.c:353 [inline]
RIP: 0010:i740fb_decode_var drivers/video/fbdev/i740fb.c:646 [inline]
RIP: 0010:i740fb_set_par+0x163f/0x3b70 drivers/video/fbdev/i740fb.c:742
Call Trace:
 fb_set_var+0x604/0xeb0 drivers/video/fbdev/core/fbmem.c:1034
 do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1110
 fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1189

Fix this by checking the argument of i740_calc_vclk() first.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/i740fb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/i740fb.c b/drivers/video/fbdev/i740fb.c
index f6d7b04d6dff..bdbafff4529f 100644
--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -399,7 +399,7 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
 	u32 xres, right, hslen, left, xtotal;
 	u32 yres, lower, vslen, upper, ytotal;
 	u32 vxres, xoffset, vyres, yoffset;
-	u32 bpp, base, dacspeed24, mem;
+	u32 bpp, base, dacspeed24, mem, freq;
 	u8 r7;
 	int i;
 
@@ -642,7 +642,12 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
 	par->atc[VGA_ATC_OVERSCAN] = 0;
 
 	/* Calculate VCLK that most closely matches the requested dot clock */
-	i740_calc_vclk((((u32)1e9) / var->pixclock) * (u32)(1e3), par);
+	freq = (((u32)1e9) / var->pixclock) * (u32)(1e3);
+	if (freq < I740_RFREQ_FIX) {
+		fb_dbg(info, "invalid pixclock\n");
+		freq = I740_RFREQ_FIX;
+	}
+	i740_calc_vclk(freq, par);
 
 	/* Since we program the clocks ourselves, always use VCLK2. */
 	par->misc |= 0x0C;
-- 
2.35.1

