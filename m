Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C27505634
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242237AbiDRNck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244837AbiDRNa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253661EC53;
        Mon, 18 Apr 2022 05:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B72B96115A;
        Mon, 18 Apr 2022 12:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE010C385A1;
        Mon, 18 Apr 2022 12:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286547;
        bh=UP9e9gsCvpQLamVYFCRkh0oVzvViqaYxYreqodC0wR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ceororhFpDAbTnXmEkNi783n5HI6S2Nze1fdsZdqW9jA8Te7Fha8DvSDHkRlKh9lw
         ZvGDpiBYPLNA8t5SfjsW9/CUxuo5k82Y6KfFY6UBTyWFJEZdbDkz57/31KDXl7DhOW
         eV15ZS0omnsfA309R4qp7dGAA/bBQC/1H8+D2q6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Kennedy <george.kennedy@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 167/284] video: fbdev: cirrusfb: check pixclock to avoid divide by zero
Date:   Mon, 18 Apr 2022 14:12:28 +0200
Message-Id: <20220418121216.492959391@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d992aa5eb3f0..a8f4967de798 100644
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



