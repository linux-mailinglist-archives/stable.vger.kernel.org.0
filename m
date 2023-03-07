Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2F36AEBAB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjCGRrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbjCGRrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:47:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9DB265B1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:42:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FA61B819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF513C433D2;
        Tue,  7 Mar 2023 17:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210926;
        bh=8JL3bT9i44hJKKcT8evIpzAZ9F3lTIfuymCR/s290UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2vZNZ9eYkD68UWqnGV/fWvdldx13xcs/mCZR/CkBbb/+URwktiDywUG4r79cUSo7
         IyK+YFrMi/D6r9/Y8QLOIftxf/CUOjtMmZOyzqGtolUn10PKuVRqU8A2Yd0sCC10hc
         ckG3yRdUi7TnRb3HusP+DbuPqEcm2/LZXN3wCDI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0699/1001] Revert "fbcon: dont lose the console font across generic->chip driver switch"
Date:   Tue,  7 Mar 2023 17:57:51 +0100
Message-Id: <20230307170051.956904310@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.39.2



