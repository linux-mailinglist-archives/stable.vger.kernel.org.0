Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2254A5B95
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 12:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbiBALxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 06:53:10 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52272 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbiBALxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 06:53:10 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1DDB31F380;
        Tue,  1 Feb 2022 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643716389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bKWdxJm1aizvOTawWPnEDJmR2Y7TBDt6ifomyzqcN3U=;
        b=JsVa7xOKinMdBQ2dLSWBEL70hxx2nhGvRYyqCUfe/9fC7amV1JPMNXcylqTjwsawYLDQkP
        Urj2fv2NpkEUZ/azXRTl7O29FPyouVgQF0oUnc9VDFHAd1Mz6s9CUnjNcs4XLUAmObnNzG
        HDg+Rk0TX3U6VNc5UNUqZUG/PWAmI9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643716389;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bKWdxJm1aizvOTawWPnEDJmR2Y7TBDt6ifomyzqcN3U=;
        b=gAOUiQr87aGh6xLZYWq+mBZu/X72SNXM/Foo/SLuFcNM02BXEufxp5jm7eU3NlT/SsUJE4
        sb81jD18lZqMh8BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E2F1913D67;
        Tue,  1 Feb 2022 11:53:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pUNKNiQf+WG5PQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 01 Feb 2022 11:53:08 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     daniel@ffwll.ch, airlied@linux.ie, mripard@kernel.org,
        maarten.lankhorst@linux.intel.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH v2] drm/fb-helper: Mark screen buffers in system memory with FB_VIRTFB
Date:   Tue,  1 Feb 2022 12:53:05 +0100
Message-Id: <20220201115305.9333-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mark screen buffers in system memory with FB_VIRTFB. Otherwise, fbdev
deferred I/O marks mmap'ed areas of system memory with VM_IO. (There's
an inverse relation ship between the two flags.)

For shadow buffers, also set the FB_READS_FAST hint.

v2:
	* updated commit description (Daniel)
	* added Fixes tag

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: d536540f304c ("drm/fb-helper: Add generic fbdev emulation .fb_probe function")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.19+
---
 drivers/gpu/drm/drm_fb_helper.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index ed43b987d306..f15127a32f7a 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2346,6 +2346,7 @@ static int drm_fb_helper_generic_probe(struct drm_fb_helper *fb_helper,
 	fbi->fbops = &drm_fbdev_fb_ops;
 	fbi->screen_size = sizes->surface_height * fb->pitches[0];
 	fbi->fix.smem_len = fbi->screen_size;
+	fbi->flags = FBINFO_DEFAULT;
 
 	drm_fb_helper_fill_info(fbi, fb_helper, sizes);
 
@@ -2353,19 +2354,21 @@ static int drm_fb_helper_generic_probe(struct drm_fb_helper *fb_helper,
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
-- 
2.34.1

