Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355E84F25FD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbiDEHxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbiDEHwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:52:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2743919030;
        Tue,  5 Apr 2022 00:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3DE8615C3;
        Tue,  5 Apr 2022 07:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D97C34110;
        Tue,  5 Apr 2022 07:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144924;
        bh=IV/c1dNZq5Imz6GlTesiiw6Gbmo/NPg97KtelmdkllE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VP0JEGhXzFj5sXm+NOlf5YRK2c+kXwGPUMNrxZzzWxS81cPMuhF2LhG/C3pH8IEq+
         N6B/tbYGmOx9SmeUKOkXTpZMjytjqq2HuT3QfX7SbsA7mdlCVoMo5ao1ucSfP0wy5I
         PSOKFmvAJGlh+sZBo6NvoPi+AEXlLoAHJtq7bNy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.17 0186/1126] drm/fb-helper: Mark screen buffers in system memory with FBINFO_VIRTFB
Date:   Tue,  5 Apr 2022 09:15:33 +0200
Message-Id: <20220405070413.066504239@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit cd9f7f7ac5932129fe81b4c7559cfcb226ec7c5c upstream.

Mark screen buffers in system memory with FBINFO_VIRTFB. Otherwise, fbdev
deferred I/O marks mmap'ed areas of system memory with VM_IO. (There's an
inverse relationship between the two flags.)

For shadow buffers, also set the FBINFO_READS_FAST hint.

v3:
	* change FB_ to FBINFO_ in commit description
v2:
	* updated commit description (Daniel)
	* added Fixes tag

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: d536540f304c ("drm/fb-helper: Add generic fbdev emulation .fb_probe function")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.19+
Link: https://patchwork.freedesktop.org/patch/msgid/20220201115305.9333-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2346,6 +2346,7 @@ static int drm_fb_helper_generic_probe(s
 	fbi->fbops = &drm_fbdev_fb_ops;
 	fbi->screen_size = sizes->surface_height * fb->pitches[0];
 	fbi->fix.smem_len = fbi->screen_size;
+	fbi->flags = FBINFO_DEFAULT;
 
 	drm_fb_helper_fill_info(fbi, fb_helper, sizes);
 
@@ -2353,19 +2354,21 @@ static int drm_fb_helper_generic_probe(s
 		fbi->screen_buffer = vzalloc(fbi->screen_size);
 		if (!fbi->screen_buffer)
 			return -ENOMEM;
+		fbi->flags |= FBINFO_VIRTFB | FBINFO_READS_FAST;
 
 		fbi->fbdefio = &drm_fbdev_defio;
-
 		fb_deferred_io_init(fbi);
 	} else {
 		/* buffer is mapped for HW framebuffer */
 		ret = drm_client_buffer_vmap(fb_helper->buffer, &map);
 		if (ret)
 			return ret;
-		if (map.is_iomem)
+		if (map.is_iomem) {
 			fbi->screen_base = map.vaddr_iomem;
-		else
+		} else {
 			fbi->screen_buffer = map.vaddr;
+			fbi->flags |= FBINFO_VIRTFB;
+		}
 
 		/*
 		 * Shamelessly leak the physical address to user-space. As


