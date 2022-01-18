Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349C3492AA7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346472AbiARQMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:12:18 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41856 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346926AbiARQKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:10:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A513CE1A33;
        Tue, 18 Jan 2022 16:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9E9C00446;
        Tue, 18 Jan 2022 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522243;
        bh=r8FlrmrI35vVyw0pyT1BmGPRhUYFl0eRGJhsRoVy3tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyQG8L0pfxYUD3Nwt72VUEqp2ZGvL6gxkr76ZB7/1Tb1pdpub/IQTp/qIyz1X+u6F
         hueYZigw46BfOMQ1aMCwk3k4pgPTdOvpvseArx97UrWihQJ3DbhHtLpxwZeEM/z9K7
         rtgqDB152ssTbsNwBt9hmwKxHTNHwFDQ7e4xISc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kris Karas <bugs-a21@moonlit-rail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.16 15/28] video: vga16fb: Only probe for EGA and VGA 16 color graphic cards
Date:   Tue, 18 Jan 2022 17:06:10 +0100
Message-Id: <20220118160452.910949312@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

commit 0499f419b76f94ede08304aad5851144813ac55c upstream.

The vga16fb framebuffer driver only supports Enhanced Graphics Adapter
(EGA) and Video Graphics Array (VGA) 16 color graphic cards.

But it doesn't check if the adapter is one of those or if a VGA16 mode
is used. This means that the driver will be probed even if a VESA BIOS
Extensions (VBE) or Graphics Output Protocol (GOP) interface is used.

This issue has been present for a long time but it was only exposed by
commit d391c5827107 ("drivers/firmware: move x86 Generic System
Framebuffers support") since the platform device registration to match
the {vesa,efi}fb drivers is done later as a consequence of that change.

All non-x86 architectures though treat orig_video_isVGA as a boolean so
only do the supported video mode check for x86 and not for other arches.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215001
Fixes: d391c5827107 ("drivers/firmware: move x86 Generic System Framebuffers support")
Reported-by: Kris Karas <bugs-a21@moonlit-rail.com>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Kris Karas <bugs-a21@moonlit-rail.com>
Acked-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220110095625.278836-3-javierm@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/vga16fb.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/video/fbdev/vga16fb.c
+++ b/drivers/video/fbdev/vga16fb.c
@@ -184,6 +184,25 @@ static inline void setindex(int index)
 	vga_io_w(VGA_GFX_I, index);
 }
 
+/* Check if the video mode is supported by the driver */
+static inline int check_mode_supported(void)
+{
+	/* non-x86 architectures treat orig_video_isVGA as a boolean flag */
+#if defined(CONFIG_X86)
+	/* only EGA and VGA in 16 color graphic mode are supported */
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EGAC &&
+	    screen_info.orig_video_isVGA != VIDEO_TYPE_VGAC)
+		return -ENODEV;
+
+	if (screen_info.orig_video_mode != 0x0D &&	/* 320x200/4 (EGA) */
+	    screen_info.orig_video_mode != 0x0E &&	/* 640x200/4 (EGA) */
+	    screen_info.orig_video_mode != 0x10 &&	/* 640x350/4 (EGA) */
+	    screen_info.orig_video_mode != 0x12)	/* 640x480/4 (VGA) */
+		return -ENODEV;
+#endif
+	return 0;
+}
+
 static void vga16fb_pan_var(struct fb_info *info, 
 			    struct fb_var_screeninfo *var)
 {
@@ -1422,6 +1441,11 @@ static int __init vga16fb_init(void)
 
 	vga16fb_setup(option);
 #endif
+
+	ret = check_mode_supported();
+	if (ret)
+		return ret;
+
 	ret = platform_driver_register(&vga16fb_driver);
 
 	if (!ret) {


