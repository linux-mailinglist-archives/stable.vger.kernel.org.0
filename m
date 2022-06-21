Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576B5552E2B
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347043AbiFUJXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348386AbiFUJX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:23:29 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E11C12AC7
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 02:23:26 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id o7so26171721eja.1
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 02:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qbELiqSLi85gsXapGdgiJUKeJb9b+cPRqwhQW05UAmo=;
        b=BVIknWOzy9OfMg74xsppNXa17MwFOE+D9Fj27bJXoyUth58xfg9KodHm04UlOO9xhW
         /TH7tDNvGlWCWpUnEcH8rSxH3qhqew0rU4TzuXDGJz6HNPeXTrgxKY2vbA8KrMHdlHMe
         kWKGlgPnc4tCxAnoBr4a52JHR00+TvWQqdHQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qbELiqSLi85gsXapGdgiJUKeJb9b+cPRqwhQW05UAmo=;
        b=4slGABoh9Fm7EMPPcPnMG1e2b221lzfhj8g3AH+RqTXc4WutJhzPu0vIib1w2kz8eX
         8xnpHrUmhvfSby5SfAALEtYJtVcQZQlWf/E+tmPT3XUIyZ3OIySB+g6vAmV51EY8orrU
         DJzSX2S/YQmgpuQVZkrLeS/iULa/w71RlBv5RVIaUzOFY+9o3GYz3puQvGmIr1TwwlIt
         5Dyp4BHBV8Z11Xh9qPYVviBpZbIxTuX4D4zK9HzEAyIcW1YlYbOLhdYrLFyYC0Pi4U0E
         uxljxIXi6gT9a5pSUbS+LtPtfwmmayGEqKLp/6fk47tPumoOdRyZfWEKHXdbYVHfyD5l
         SRJQ==
X-Gm-Message-State: AJIora9j+BoqrQkrJM1DJMNgTl5qrY35lUjeRKED4xsi7MZed4yyv9+I
        SW6Izs6Kph9+hs3pEzGO9u2jkg==
X-Google-Smtp-Source: AGRyM1udVaIakTEaLx4Ctjy5hGH2giADFLC4SvB92taoK75hx+Fxs14kFmdAGkjk2Hn1lXkUccPp2A==
X-Received: by 2002:a17:907:7202:b0:722:e4d6:2e17 with SMTP id dr2-20020a170907720200b00722e4d62e17mr2060261ejc.434.1655803405056;
        Tue, 21 Jun 2022 02:23:25 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id k10-20020a17090632ca00b00722e7919835sm215924ejk.111.2022.06.21.02.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:23:24 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     security@kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Daniel Stone <daniels@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        openeuler-security@openeuler.org, guodaxing@huawei.com,
        Weigang <weigang12@huawei.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] drm/fb-helper: Make set_var validation stricter
Date:   Tue, 21 Jun 2022 11:23:19 +0200
Message-Id: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The drm fbdev emulation does not forward mode changes to the driver,
and hence all changes where rejected in 865afb11949e ("drm/fb-helper:
reject any changes to the fbdev").

Unfortunately this resulted in bugs on multiple monitor systems with
different resolutions. In that case the fbdev emulation code sizes the
underlying framebuffer for the largest screen (which dictates
x/yres_virtual), but adjust the fbdev x/yres to match the smallest
resolution. The above mentioned patch failed to realize that, and
errornously validated x/yres against the fb dimensions.

This was fixed by just dropping the validation for too small sizes,
which restored vt switching with 12ffed96d436 ("drm/fb-helper: Allow
var->x/yres(_virtual) < fb->width/height again").

But this also restored all kinds of validation issues and their
fallout in the notoriously buggy fbcon code for too small sizes. Since
no one is volunteering to really make fbcon and vc/vt fully robust
against these math issues make sure this barn door is closed for good
again.

Since it's a bit tricky to remember the x/yres we picked across both
the newer generic fbdev emulation and the older code with more driver
involvement, we simply check that it doesn't change. This relies on
drm_fb_helper_fill_var() having done things correctly, and nothing
having trampled it yet.

Note that this leaves all the other fbdev drivers out in the rain.
Given that distros have finally started to move away from those
completely for real I think that's good enough. The code it spaghetti
enough that I do not feel confident to even review fixes for it.

What might help fbdev is doing something similar to what was done in
a49145acfb97 ("fbmem: add margin check to fb_check_caps()") and ensure
x/yres_virtual aren't too small, for some value of "too small". Maybe
checking that they're at least x/yres makes sense?

Fixes: 12ffed96d436 ("drm/fb-helper: Allow var->x/yres(_virtual) < fb->width/height again")
Cc: Michel Dänzer <michel.daenzer@amd.com>
Cc: Daniel Stone <daniels@collabora.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v4.11+
Cc: Helge Deller <deller@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: openeuler-security@openeuler.org
Cc: guodaxing@huawei.com
Cc: Weigang (Jimmy) <weigang12@huawei.com>
Reported-by: Weigang (Jimmy) <weigang12@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
Note: Weigang asked for this to stay under embargo until it's all
review and tested.
-Daniel
---
 drivers/gpu/drm/drm_fb_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 695997ae2a7c..5664a177a404 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1355,8 +1355,8 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
 	 * to KMS, hence fail if different settings are requested.
 	 */
 	if (var->bits_per_pixel > fb->format->cpp[0] * 8 ||
-	    var->xres > fb->width || var->yres > fb->height ||
-	    var->xres_virtual > fb->width || var->yres_virtual > fb->height) {
+	    var->xres != info->var.xres || var->yres != info->var.yres ||
+	    var->xres_virtual != fb->width || var->yres_virtual != fb->height) {
 		drm_dbg_kms(dev, "fb requested width/height/bpp can't fit in current fb "
 			  "request %dx%d-%d (virtual %dx%d) > %dx%d-%d\n",
 			  var->xres, var->yres, var->bits_per_pixel,
-- 
2.36.0

