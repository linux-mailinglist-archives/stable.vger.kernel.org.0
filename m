Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD5D56FA32
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiGKJPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiGKJOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:14:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ADA3204E;
        Mon, 11 Jul 2022 02:10:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3968B80E79;
        Mon, 11 Jul 2022 09:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F89C34115;
        Mon, 11 Jul 2022 09:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530602;
        bh=lDnrGg8XCrWs/U/ZDqKOXJWJ3M8ICXOK/64L4R+o3h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOPbot7d6CBUC5M2rKKN2/QaMuSgdChoqvYjgzUIHXf7H7nisId7U50mdg0J2qTGi
         f53d3taAv0OWhNSAS3G/aci0MwH8rplQoKhCCftdvJH1roBk6EedaTbmn1nKGcl47S
         FoZrAC1PkorKpIlAiSgPhaBnGFABm63he84+GLgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5.4 12/38] fbcon: Prevent that screen size is smaller than font size
Date:   Mon, 11 Jul 2022 11:06:54 +0200
Message-Id: <20220711090539.090838502@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream.

We need to prevent that users configure a screen size which is smaller than the
currently selected font size. Otherwise rendering chars on the screen will
access memory outside the graphics memory region.

This patch adds a new function fbcon_modechange_possible() which
implements this check and which later may be extended with other checks
if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
for a too small screen size.

Signed-off-by: Helge Deller <deller@gmx.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |   28 ++++++++++++++++++++++++++++
 drivers/video/fbdev/core/fbmem.c |    4 +++-
 include/linux/fbcon.h            |    4 ++++
 3 files changed, 35 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2761,6 +2761,34 @@ void fbcon_update_vcs(struct fb_info *in
 }
 EXPORT_SYMBOL(fbcon_update_vcs);
 
+/* let fbcon check if it supports a new screen resolution */
+int fbcon_modechange_possible(struct fb_info *info, struct fb_var_screeninfo *var)
+{
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct vc_data *vc;
+	unsigned int i;
+
+	WARN_CONSOLE_UNLOCKED();
+
+	if (!ops)
+		return 0;
+
+	/* prevent setting a screen size which is smaller than font size */
+	for (i = first_fb_vc; i <= last_fb_vc; i++) {
+		vc = vc_cons[i].d;
+		if (!vc || vc->vc_mode != KD_TEXT ||
+			   registered_fb[con2fb_map[i]] != info)
+			continue;
+
+		if (vc->vc_font.width  > FBCON_SWAP(var->rotate, var->xres, var->yres) ||
+		    vc->vc_font.height > FBCON_SWAP(var->rotate, var->yres, var->xres))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fbcon_modechange_possible);
+
 int fbcon_mode_deleted(struct fb_info *info,
 		       struct fb_videomode *mode)
 {
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1114,7 +1114,9 @@ static long do_fb_ioctl(struct fb_info *
 			return -EFAULT;
 		console_lock();
 		lock_fb_info(info);
-		ret = fb_set_var(info, &var);
+		ret = fbcon_modechange_possible(info, &var);
+		if (!ret)
+			ret = fb_set_var(info, &var);
 		if (!ret)
 			fbcon_update_vcs(info, var.activate & FB_ACTIVATE_ALL);
 		unlock_fb_info(info);
--- a/include/linux/fbcon.h
+++ b/include/linux/fbcon.h
@@ -15,6 +15,8 @@ void fbcon_new_modelist(struct fb_info *
 void fbcon_get_requirement(struct fb_info *info,
 			   struct fb_blit_caps *caps);
 void fbcon_fb_blanked(struct fb_info *info, int blank);
+int  fbcon_modechange_possible(struct fb_info *info,
+			       struct fb_var_screeninfo *var);
 void fbcon_update_vcs(struct fb_info *info, bool all);
 void fbcon_remap_all(struct fb_info *info);
 int fbcon_set_con2fb_map_ioctl(void __user *argp);
@@ -33,6 +35,8 @@ static inline void fbcon_new_modelist(st
 static inline void fbcon_get_requirement(struct fb_info *info,
 					 struct fb_blit_caps *caps) {}
 static inline void fbcon_fb_blanked(struct fb_info *info, int blank) {}
+static inline int  fbcon_modechange_possible(struct fb_info *info,
+				struct fb_var_screeninfo *var) { return 0; }
 static inline void fbcon_update_vcs(struct fb_info *info, bool all) {}
 static inline void fbcon_remap_all(struct fb_info *info) {}
 static inline int fbcon_set_con2fb_map_ioctl(void __user *argp) { return 0; }


