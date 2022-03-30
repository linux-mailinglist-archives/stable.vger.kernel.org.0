Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57914EC129
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344848AbiC3L4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345166AbiC3LyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B16280EF0;
        Wed, 30 Mar 2022 04:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55268B81C3B;
        Wed, 30 Mar 2022 11:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8EAC340F3;
        Wed, 30 Mar 2022 11:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641030;
        bh=xuNZMXifvmTGhpPgK2BkPkaKp82sCR/h9SV2ylyFzog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7EwThw31MihqabsUI7O1W8Cqu+SEUl2rl3hk5AsjXUoWkysK6E0Y9De41thhY2Kq
         y5FiBMBX3jBScLRLTkEHCgLQIN+EED4tcJiz1hz6BzJ0z1rGzFcCprifSzL/6eGlc/
         kh9LNTropGH17vavYphzo81cURRCzX5LNg1x5XWs/6MA2EZpmGS89WYBL/yqCJADtt
         zPy+D4hCgmNYGw0GugOFkIM1Yj7sLM0hqPT5SLL09DFbcPZH3owTDD6UE2jvUP+2t0
         4Xeg3q4jfSJ209W9noMe5/G6B+4N0QLrpEn4n8oPPnP7In6Zvp5Ht8Zs7afBbMj1xd
         KzWUqnGXhKrBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/50] video: fbdev: cirrusfb: check pixclock to avoid divide by zero
Date:   Wed, 30 Mar 2022 07:49:29 -0400
Message-Id: <20220330115005.1671090-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 93802abbbc72..3d47c347b897 100644
--- a/drivers/video/fbdev/cirrusfb.c
+++ b/drivers/video/fbdev/cirrusfb.c
@@ -469,7 +469,7 @@ static int cirrusfb_check_mclk(struct fb_info *info, long freq)
 	return 0;
 }
 
-static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
+static int cirrusfb_check_pixclock(struct fb_var_screeninfo *var,
 				   struct fb_info *info)
 {
 	long freq;
@@ -478,9 +478,7 @@ static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
 	unsigned maxclockidx = var->bits_per_pixel >> 3;
 
 	/* convert from ps to kHz */
-	freq = PICOS2KHZ(var->pixclock);
-
-	dev_dbg(info->device, "desired pixclock: %ld kHz\n", freq);
+	freq = PICOS2KHZ(var->pixclock ? : 1);
 
 	maxclock = cirrusfb_board_info[cinfo->btype].maxclock[maxclockidx];
 	cinfo->multiplexing = 0;
@@ -488,11 +486,13 @@ static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
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

