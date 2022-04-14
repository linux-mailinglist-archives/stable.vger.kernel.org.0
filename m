Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E82A501515
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244567AbiDNNem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245715AbiDNN3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:29:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E39AFAE7;
        Thu, 14 Apr 2022 06:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B342B82983;
        Thu, 14 Apr 2022 13:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96230C385A9;
        Thu, 14 Apr 2022 13:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942627;
        bh=gTMrMCC1RQkVhABduM/2Eg06saCccssHNFDPRbEfmG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnsDGy6TH5Lk5vRLu22On+ON5KWZCIR1Kh0XVS4bPCV29UjO5C3hmHfGwco3t2NRy
         uABg2hNF58XDyMcZo1qVRaP2vJir1rtajR7NmPyVTPdixujoMqjN6LqRG8befFoz8e
         jwCXQbIRWAV8oVIfvgdmb6NC+bJvh30zlNDmuIr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 204/338] video: fbdev: cirrusfb: check pixclock to avoid divide by zero
Date:   Thu, 14 Apr 2022 15:11:47 +0200
Message-Id: <20220414110844.699774428@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 5c6f402bdcf9e7239c6bc7087eda71ac99b31379 ]

Do a sanity check on pixclock value to avoid divide by zero.

If the pixclock value is zero, the cirrusfb driver will round up
pixclock to get the derived frequency as close to maxclock as
possible.

Syzkaller reported a divide error in cirrusfb_check_pixclock.

divide error: 0000 [#1] SMP KASAN PTI
CPU: 0 PID: 14938 Comm: cirrusfb_test Not tainted 5.15.0-rc6 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2
RIP: 0010:cirrusfb_check_var+0x6f1/0x1260

Call Trace:
 fb_set_var+0x398/0xf90
 do_fb_ioctl+0x4b8/0x6f0
 fb_ioctl+0xeb/0x130
 __x64_sys_ioctl+0x19d/0x220
 do_syscall_64+0x3a/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/cirrusfb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/cirrusfb.c b/drivers/video/fbdev/cirrusfb.c
index b3be06dd2908..72358d187023 100644
--- a/drivers/video/fbdev/cirrusfb.c
+++ b/drivers/video/fbdev/cirrusfb.c
@@ -470,7 +470,7 @@ static int cirrusfb_check_mclk(struct fb_info *info, long freq)
 	return 0;
 }
 
-static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
+static int cirrusfb_check_pixclock(struct fb_var_screeninfo *var,
 				   struct fb_info *info)
 {
 	long freq;
@@ -479,9 +479,7 @@ static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
 	unsigned maxclockidx = var->bits_per_pixel >> 3;
 
 	/* convert from ps to kHz */
-	freq = PICOS2KHZ(var->pixclock);
-
-	dev_dbg(info->device, "desired pixclock: %ld kHz\n", freq);
+	freq = PICOS2KHZ(var->pixclock ? : 1);
 
 	maxclock = cirrusfb_board_info[cinfo->btype].maxclock[maxclockidx];
 	cinfo->multiplexing = 0;
@@ -489,11 +487,13 @@ static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
 	/* If the frequency is greater than we can support, we might be able
 	 * to use multiplexing for the video mode */
 	if (freq > maxclock) {
-		dev_err(info->device,
-			"Frequency greater than maxclock (%ld kHz)\n",
-			maxclock);
-		return -EINVAL;
+		var->pixclock = KHZ2PICOS(maxclock);
+
+		while ((freq = PICOS2KHZ(var->pixclock)) > maxclock)
+			var->pixclock++;
 	}
+	dev_dbg(info->device, "desired pixclock: %ld kHz\n", freq);
+
 	/*
 	 * Additional constraint: 8bpp uses DAC clock doubling to allow maximum
 	 * pixel clock
-- 
2.34.1



