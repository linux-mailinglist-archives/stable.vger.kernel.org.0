Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABF3649FBA
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiLLNOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiLLNN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:13:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E6FE55
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:13:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EADB61049
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795BAC43392;
        Mon, 12 Dec 2022 13:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850836;
        bh=3XCvpEUAde9L5rOVYJiM7GSuh5V/A6GXuarnYLuqMH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNj6jmxniaSbJud3xlzpViuhY8bStQ9zYPRPIJHAWcrbruibC/c6EdakdVEn/itgT
         nVmB/3ROPpFKae1a38rSvS+338be3DFhYxQrnh2daVLCRSkZj2XU+htC9r47122P8f
         CVq+GlLx+PD1Msv7N7JJ4Qru/lbkE6DAsIE3AtG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/106] fbcon: Use kzalloc() in fbcon_prepare_logo()
Date:   Mon, 12 Dec 2022 14:09:26 +0100
Message-Id: <20221212130925.870385694@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit a6a00d7e8ffd78d1cdb7a43f1278f081038c638f ]

A kernel built with syzbot's config file reported that

  scr_memcpyw(q, save, array3_size(logo_lines, new_cols, 2))

causes uninitialized "save" to be copied.

  ----------
  [drm] Initialized vgem 1.0.0 20120112 for vgem on minor 0
  [drm] Initialized vkms 1.0.0 20180514 for vkms on minor 1
  Console: switching to colour frame buffer device 128x48
  =====================================================
  BUG: KMSAN: uninit-value in do_update_region+0x4b8/0xba0
   do_update_region+0x4b8/0xba0
   update_region+0x40d/0x840
   fbcon_switch+0x3364/0x35e0
   redraw_screen+0xae3/0x18a0
   do_bind_con_driver+0x1cb3/0x1df0
   do_take_over_console+0x11cb/0x13f0
   fbcon_fb_registered+0xacc/0xfd0
   register_framebuffer+0x1179/0x1320
   __drm_fb_helper_initial_config_and_unlock+0x23ad/0x2b40
   drm_fbdev_client_hotplug+0xbea/0xda0
   drm_fbdev_generic_setup+0x65e/0x9d0
   vkms_init+0x9f3/0xc76
   (...snipped...)

  Uninit was stored to memory at:
   fbcon_prepare_logo+0x143b/0x1940
   fbcon_init+0x2c1b/0x31c0
   visual_init+0x3e7/0x820
   do_bind_con_driver+0x14a4/0x1df0
   do_take_over_console+0x11cb/0x13f0
   fbcon_fb_registered+0xacc/0xfd0
   register_framebuffer+0x1179/0x1320
   __drm_fb_helper_initial_config_and_unlock+0x23ad/0x2b40
   drm_fbdev_client_hotplug+0xbea/0xda0
   drm_fbdev_generic_setup+0x65e/0x9d0
   vkms_init+0x9f3/0xc76
   (...snipped...)

  Uninit was created at:
   __kmem_cache_alloc_node+0xb69/0x1020
   __kmalloc+0x379/0x680
   fbcon_prepare_logo+0x704/0x1940
   fbcon_init+0x2c1b/0x31c0
   visual_init+0x3e7/0x820
   do_bind_con_driver+0x14a4/0x1df0
   do_take_over_console+0x11cb/0x13f0
   fbcon_fb_registered+0xacc/0xfd0
   register_framebuffer+0x1179/0x1320
   __drm_fb_helper_initial_config_and_unlock+0x23ad/0x2b40
   drm_fbdev_client_hotplug+0xbea/0xda0
   drm_fbdev_generic_setup+0x65e/0x9d0
   vkms_init+0x9f3/0xc76
   (...snipped...)

  CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc4-00356-g8f2975c2bb4c #924
  Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
  ----------

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/cad03d25-0ea0-32c4-8173-fd1895314bce@I-love.SAKURA.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 2618d3beef64..27828435dd4f 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -609,7 +609,7 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 		if (scr_readw(r) != vc->vc_video_erase_char)
 			break;
 	if (r != q && new_rows >= rows + logo_lines) {
-		save = kmalloc(array3_size(logo_lines, new_cols, 2),
+		save = kzalloc(array3_size(logo_lines, new_cols, 2),
 			       GFP_KERNEL);
 		if (save) {
 			int i = cols < new_cols ? cols : new_cols;
-- 
2.35.1



