Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5495946D2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbiHOXCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245104AbiHOXAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E89D78215;
        Mon, 15 Aug 2022 12:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B120460FD8;
        Mon, 15 Aug 2022 19:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F89CC433C1;
        Mon, 15 Aug 2022 19:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593453;
        bh=fsOMfTvKS1OwyHIHiFZi4yp3lzMzwBLEDwhB4KCaDkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtMXy5dvCtwB66Jtf0ziuNaLAdCCzOwNn+VYi1PfZMEvFgp0BewYruWazUeGClJZx
         +7zmz+3m0Jp2HyJhr5969z3gVZfQ47wsojd3kydmt1O8ZCaswOYt5e8exl2+hn4KIN
         byMHTMRpNcmJvybI3EUukqwmqN22ssO2ACyUI97I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0948/1095] video: fbdev: arkfb: Fix a divide-by-zero bug in ark_set_pixclock()
Date:   Mon, 15 Aug 2022 20:05:47 +0200
Message-Id: <20220815180508.344597258@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit 2f1c4523f7a3aaabe7e53d3ebd378292947e95c8 ]

Since the user can control the arguments of the ioctl() from the user
space, under special arguments that may result in a divide-by-zero bug
in:
  drivers/video/fbdev/arkfb.c:784: ark_set_pixclock(info, (hdiv * info->var.pixclock) / hmul);
with hdiv=1, pixclock=1 and hmul=2 you end up with (1*1)/2 = (int) 0.
and then in:
  drivers/video/fbdev/arkfb.c:504: rv = dac_set_freq(par->dac, 0, 1000000000 / pixclock);
we'll get a division-by-zero.

The following log can reveal it:

divide error: 0000 [#1] PREEMPT SMP KASAN PTI
RIP: 0010:ark_set_pixclock drivers/video/fbdev/arkfb.c:504 [inline]
RIP: 0010:arkfb_set_par+0x10fc/0x24c0 drivers/video/fbdev/arkfb.c:784
Call Trace:
 fb_set_var+0x604/0xeb0 drivers/video/fbdev/core/fbmem.c:1034
 do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1110
 fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1189

Fix this by checking the argument of ark_set_pixclock() first.

Fixes: 681e14730c73 ("arkfb: new framebuffer driver for ARK Logic cards")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/arkfb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/arkfb.c b/drivers/video/fbdev/arkfb.c
index eb3e47c58c5f..ed76ddc7df3d 100644
--- a/drivers/video/fbdev/arkfb.c
+++ b/drivers/video/fbdev/arkfb.c
@@ -781,7 +781,12 @@ static int arkfb_set_par(struct fb_info *info)
 		return -EINVAL;
 	}
 
-	ark_set_pixclock(info, (hdiv * info->var.pixclock) / hmul);
+	value = (hdiv * info->var.pixclock) / hmul;
+	if (!value) {
+		fb_dbg(info, "invalid pixclock\n");
+		value = 1;
+	}
+	ark_set_pixclock(info, value);
 	svga_set_timings(par->state.vgabase, &ark_timing_regs, &(info->var), hmul, hdiv,
 			 (info->var.vmode & FB_VMODE_DOUBLE)     ? 2 : 1,
 			 (info->var.vmode & FB_VMODE_INTERLACED) ? 2 : 1,
-- 
2.35.1



