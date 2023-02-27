Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A8B6A3784
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjB0CKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjB0CJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0567E18171;
        Sun, 26 Feb 2023 18:08:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55702B80CBD;
        Mon, 27 Feb 2023 02:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E549C433D2;
        Mon, 27 Feb 2023 02:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463555;
        bh=LUt1Js+1pEh1ZGmXeDicpjAGXUgNgNZx3wDyKOwqHFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkMWbhyBLQHDx1Qou6TCJAiO+63yAg9Rxk2IbYiJLdZYY9Qa8Ua1WZFZpA1H5TFrV
         AHDUx1qf5zkrWn+Ziy2fEgCuz0xdfXhA2skEeJhgqxGVMlJYtp6hN9UJ7cC9U81HhN
         iAlu76QthH3rtGZ5UluZty/VnsZTwnpn5zb+MU/AHuGvQ9MjYVgM/fWw8ZUknAajC4
         JB0h6mYEc866+IBdAF0U3DctAHnIKdAUsPlPucP/9vCem5hwE+0r2TufDkBjRyqio/
         wq4NaYNYpfjPvlX/EAMK9NqyIj0sVAmjdtkkjBVs28hteD4czLIQmJIdvQ1k9RmsGa
         RBnJcpQRFizNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>, daniel@ffwll.ch,
        deller@gmx.de, sam@ravnborg.org, geert+renesas@glider.be,
        samuel.thibault@ens-lyon.org, penguin-kernel@I-love.SAKURA.ne.jp,
        syoshida@redhat.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 14/58] Revert "fbcon: don't lose the console font across generic->chip driver switch"
Date:   Sun, 26 Feb 2023 21:04:12 -0500
Message-Id: <20230227020457.1048737-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 12d5796d55f9fd9e4b621003127c99e176665064 ]

This reverts commit ae1287865f5361fa138d4d3b1b6277908b54eac9.

Always free the console font when deinitializing the framebuffer
console. Subsequent framebuffer consoles will then use the default
font. Rely on userspace to load any user-configured font for these
consoles.

Commit ae1287865f53 ("fbcon: don't lose the console font across
generic->chip driver switch") was introduced to work around losing
the font during graphics-device handover. [1][2] It kept a dangling
pointer with the font data between loading the two consoles, which is
fairly adventurous hack. It also never covered cases when the other
consoles, such as VGA text mode, where involved.

The problem has meanwhile been solved in userspace. Systemd comes
with a udev rule that re-installs the configured font when a console
comes up. [3] So the kernel workaround can be removed.

This also removes one of the two special cases triggered by setting
FBINFO_MISC_FIRMWARE in an fbdev driver.

Tested during device handover from efifb and simpledrm to radeon. Udev
reloads the configured console font for the new driver's terminal.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=892340 # 1
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1074624 # 2
Link: https://cgit.freedesktop.org/systemd/systemd/tree/src/vconsole/90-vconsole.rules.in?h=v222 # 3
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221219160516.23436-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 1b14c21af2b74..2bc8baa90c0f2 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -958,7 +958,7 @@ static const char *fbcon_startup(void)
 	set_blitting_type(vc, info);
 
 	/* Setup default font */
-	if (!p->fontdata && !vc->vc_font.data) {
+	if (!p->fontdata) {
 		if (!fontname[0] || !(font = find_font(fontname)))
 			font = get_default_font(info->var.xres,
 						info->var.yres,
@@ -968,8 +968,6 @@ static const char *fbcon_startup(void)
 		vc->vc_font.height = font->height;
 		vc->vc_font.data = (void *)(p->fontdata = font->data);
 		vc->vc_font.charcount = font->charcount;
-	} else {
-		p->fontdata = vc->vc_font.data;
 	}
 
 	cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
@@ -1135,9 +1133,9 @@ static void fbcon_init(struct vc_data *vc, int init)
 	ops->p = &fb_display[fg_console];
 }
 
-static void fbcon_free_font(struct fbcon_display *p, bool freefont)
+static void fbcon_free_font(struct fbcon_display *p)
 {
-	if (freefont && p->userfont && p->fontdata && (--REFCOUNT(p->fontdata) == 0))
+	if (p->userfont && p->fontdata && (--REFCOUNT(p->fontdata) == 0))
 		kfree(p->fontdata - FONT_EXTRA_WORDS * sizeof(int));
 	p->fontdata = NULL;
 	p->userfont = 0;
@@ -1172,8 +1170,8 @@ static void fbcon_deinit(struct vc_data *vc)
 	struct fb_info *info;
 	struct fbcon_ops *ops;
 	int idx;
-	bool free_font = true;
 
+	fbcon_free_font(p);
 	idx = con2fb_map[vc->vc_num];
 
 	if (idx == -1)
@@ -1184,8 +1182,6 @@ static void fbcon_deinit(struct vc_data *vc)
 	if (!info)
 		goto finished;
 
-	if (info->flags & FBINFO_MISC_FIRMWARE)
-		free_font = false;
 	ops = info->fbcon_par;
 
 	if (!ops)
@@ -1197,9 +1193,8 @@ static void fbcon_deinit(struct vc_data *vc)
 	ops->initialized = false;
 finished:
 
-	fbcon_free_font(p, free_font);
-	if (free_font)
-		vc->vc_font.data = NULL;
+	fbcon_free_font(p);
+	vc->vc_font.data = NULL;
 
 	if (vc->vc_hi_font_mask && vc->vc_screenbuf)
 		set_vc_hi_font(vc, false);
-- 
2.39.0

