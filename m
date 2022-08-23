Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8796C59D773
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349581AbiHWJ1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350382AbiHWJZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:25:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CD47645F;
        Tue, 23 Aug 2022 01:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97164B81BF8;
        Tue, 23 Aug 2022 08:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC50EC433C1;
        Tue, 23 Aug 2022 08:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243703;
        bh=FBzSE+qqafdeYuAtXm87bCElk3pUGrsMH2kRGcVhxpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYDINjpKRd+NgoLU2tPGdwhsqigk1LPeR4ZKON94gkDJTV6OERIrehJN5EAR7vu6H
         S/b6NSCayMrtD0mfSyRwFk/twhoXd8Rv56ImyVEoTPqvl5nODvKJCm2KBjHdpKB4S0
         Uz8M4uLMExdKvXn11Wjb3H5fOj0oSNRk47GYD+kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 360/365] video: fbdev: i740fb: Check the argument of i740_calc_vclk()
Date:   Tue, 23 Aug 2022 10:04:21 +0200
Message-Id: <20220823080133.360219688@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
index 09dd85553d4f..7f09a0daaaa2 100644
--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -400,7 +400,7 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
 	u32 xres, right, hslen, left, xtotal;
 	u32 yres, lower, vslen, upper, ytotal;
 	u32 vxres, xoffset, vyres, yoffset;
-	u32 bpp, base, dacspeed24, mem;
+	u32 bpp, base, dacspeed24, mem, freq;
 	u8 r7;
 	int i;
 
@@ -643,7 +643,12 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
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



