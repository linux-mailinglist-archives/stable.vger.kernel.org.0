Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBC84EC29F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344236AbiC3MAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245370AbiC3Lzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D207B2BB00;
        Wed, 30 Mar 2022 04:53:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 446C26160D;
        Wed, 30 Mar 2022 11:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BBCC340EE;
        Wed, 30 Mar 2022 11:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641222;
        bh=UP9e9gsCvpQLamVYFCRkh0oVzvViqaYxYreqodC0wR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxBOnbBBaLUu+IPkUFAHDiKwnLaeTDFSLONgYXkZPhrBq6CK0qj4n4QFXOizMlEIU
         fvp/FjpDjI0iksEcAI69fgjsG0h3ZULlou7mJ9tCTqnF1j5Cc4gCQpDePMZudqZWb8
         ZaRnW2K4fOkkQ7qaCLRTlv5S4z3Ik+dN1ZRU79lWeytIPF3w7pYgKPvAydJmiwRWhl
         rB4ep0wuQRl9dNsZuJAHagh98/xcrXhKFBAecUA3aYfl17XqLXsNJgkiVD4rdmY/M4
         zGHgZr1wEOp9pPqTlwXTFZC3PwUQ0qMY/9IND79miWzn5r9Eh+gLDkg1P/o7JLj3WX
         zqlY+UWB1kNKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/20] video: fbdev: cirrusfb: check pixclock to avoid divide by zero
Date:   Wed, 30 Mar 2022 07:53:19 -0400
Message-Id: <20220330115336.1672930-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115336.1672930-1-sashal@kernel.org>
References: <20220330115336.1672930-1-sashal@kernel.org>
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

