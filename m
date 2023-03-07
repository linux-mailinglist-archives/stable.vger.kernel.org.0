Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776D56AF4F1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbjCGTVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbjCGTVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:21:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CE8BF8C3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:04:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BA916150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6244AC433D2;
        Tue,  7 Mar 2023 19:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215897;
        bh=emg819r2kMwEZsyl4SA5006jFEWR/3Ykm3TlnPT4MJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orJhpwtziXdn6VtCN8nGSbfQCYhQxncOjRD4ejF+vxBhpzbs+BFCIqbmXAglTDKy5
         Pa/jXMa91WTHgxYVgYRoAx/JyVUQ9gNOur1hp4xvJ7aG0pzwlhqJJf7T3LpBH6lw7B
         tlw0o1oGdWXYlgREyxebn+tFZ7IcY5+77xap3GPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/567] Revert "fbcon: dont lose the console font across generic->chip driver switch"
Date:   Tue,  7 Mar 2023 18:02:26 +0100
Message-Id: <20230307165923.627720529@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index d90d807c67561..b6712655ec1f0 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -989,7 +989,7 @@ static const char *fbcon_startup(void)
 	set_blitting_type(vc, info);
 
 	/* Setup default font */
-	if (!p->fontdata && !vc->vc_font.data) {
+	if (!p->fontdata) {
 		if (!fontname[0] || !(font = find_font(fontname)))
 			font = get_default_font(info->var.xres,
 						info->var.yres,
@@ -999,8 +999,6 @@ static const char *fbcon_startup(void)
 		vc->vc_font.height = font->height;
 		vc->vc_font.data = (void *)(p->fontdata = font->data);
 		vc->vc_font.charcount = font->charcount;
-	} else {
-		p->fontdata = vc->vc_font.data;
 	}
 
 	cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
@@ -1167,9 +1165,9 @@ static void fbcon_init(struct vc_data *vc, int init)
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
@@ -1183,8 +1181,8 @@ static void fbcon_deinit(struct vc_data *vc)
 	struct fb_info *info;
 	struct fbcon_ops *ops;
 	int idx;
-	bool free_font = true;
 
+	fbcon_free_font(p);
 	idx = con2fb_map[vc->vc_num];
 
 	if (idx == -1)
@@ -1195,8 +1193,6 @@ static void fbcon_deinit(struct vc_data *vc)
 	if (!info)
 		goto finished;
 
-	if (info->flags & FBINFO_MISC_FIRMWARE)
-		free_font = false;
 	ops = info->fbcon_par;
 
 	if (!ops)
@@ -1208,9 +1204,8 @@ static void fbcon_deinit(struct vc_data *vc)
 	ops->flags &= ~FBCON_FLAGS_INIT;
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



