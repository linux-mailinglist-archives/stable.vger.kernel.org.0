Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35F86E62D5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjDRMft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjDRMfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:35:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEB5D338;
        Tue, 18 Apr 2023 05:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9685863228;
        Tue, 18 Apr 2023 12:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883EEC433EF;
        Tue, 18 Apr 2023 12:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821346;
        bh=h7FEIe8ca7zvfq0mrRQUgHsit2vQHJj7yXRHnFW3K+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLTNZVj6LfvEzuM32WH5Ybdio4XXNO52JO4/0FuGU94DC3Eqda5+ES3VPGiyJ4iOD
         E2tgN10/htk7rd3GL26xhLns+yev5hZlgyEdZXjBzkRqz14Qiq9rIz3RUtAF68g7Cz
         vMV7qs6Fnu3sO/T304qu77shnzUsxgZn2dxpYcFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Javier Martinez Canillas <javierm@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>, shlomo@fastmail.com,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qiujun Huang <hqjagain@gmail.com>,
        Peter Rosin <peda@axentia.se>, linux-fbdev@vger.kernel.org,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Shigeru Yoshida <syoshida@redhat.com>
Subject: [PATCH 5.10 063/124] fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace
Date:   Tue, 18 Apr 2023 14:21:22 +0200
Message-Id: <20230418120312.152461472@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 6fd33a3333c7916689b8f051a185defe4dd515b0 upstream.

This is an oversight from dc5bdb68b5b3 ("drm/fb-helper: Fix vt
restore") - I failed to realize that nasty userspace could set this.

It's not pretty to mix up kernel-internal and userspace uapi flags
like this, but since the entire fb_var_screeninfo structure is uapi
we'd need to either add a new parameter to the ->fb_set_par callback
and fb_set_par() function, which has a _lot_ of users. Or some other
fairly ugly side-channel int fb_info. Neither is a pretty prospect.

Instead just correct the issue at hand by filtering out this
kernel-internal flag in the ioctl handling code.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Fixes: dc5bdb68b5b3 ("drm/fb-helper: Fix vt restore")
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: shlomo@fastmail.com
Cc: Michel Dänzer <michel@daenzer.net>
Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.7+
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Qiujun Huang <hqjagain@gmail.com>
Cc: Peter Rosin <peda@axentia.se>
Cc: linux-fbdev@vger.kernel.org
Cc: Helge Deller <deller@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Shigeru Yoshida <syoshida@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230404193934.472457-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1117,6 +1117,8 @@ static long do_fb_ioctl(struct fb_info *
 	case FBIOPUT_VSCREENINFO:
 		if (copy_from_user(&var, argp, sizeof(var)))
 			return -EFAULT;
+		/* only for kernel-internal use */
+		var.activate &= ~FB_ACTIVATE_KD_TEXT;
 		console_lock();
 		lock_fb_info(info);
 		ret = fbcon_modechange_possible(info, &var);


