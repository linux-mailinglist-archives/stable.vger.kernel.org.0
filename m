Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC2B2408CC
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgHJPZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbgHJPZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5D0C20855;
        Mon, 10 Aug 2020 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073111;
        bh=YSH/bpx9+Ia/FvcIrMSyFTGULwWNGzSoizt2cetwk30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dv2KR7rJO0Wr/W5TzRBh6zDxcqkJME3R5/iNDY9MvGisY37q1C+uQHaACXDqiuqwE
         PAXH7j8tLw1eKQ1Vq6FkKuRRppbplixjlgEg72wfCRgzKwv+lpTyzy0MycGqwPV3yt
         xHM+RT8Q0YtVpRt0WTtZUw1jN384XahM4mfBT2Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        kernel test robot <lkp@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 40/79] drm/drm_fb_helper: fix fbdev with sparc64
Date:   Mon, 10 Aug 2020 17:20:59 +0200
Message-Id: <20200810151814.251818975@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

[ Upstream commit 2a1658bf922ffd9b7907e270a7d9cdc9643fc45d ]

Recent kernels have been reported to panic using the bochs_drm
framebuffer under qemu-system-sparc64 which was bisected to
commit 7a0483ac4ffc ("drm/bochs: switch to generic drm fbdev emulation").

The backtrace indicates that the shadow framebuffer copy in
drm_fb_helper_dirty_blit_real() is trying to access the real
framebuffer using a virtual address rather than use an IO access
typically implemented using a physical (ASI_PHYS) access on SPARC.

The fix is to replace the memcpy with memcpy_toio() from io.h.

memcpy_toio() uses writeb() where the original fbdev code
used sbus_memcpy_toio(). The latter uses sbus_writeb().

The difference between writeb() and sbus_memcpy_toio() is
that writeb() writes bytes in little-endian, where sbus_writeb() writes
bytes in big-endian. As endian does not matter for byte writes they are
the same. So we can safely use memcpy_toio() here.

Note that this only fixes bochs, in general fbdev helpers still have
issues with mixing up system memory and __iomem space. Fixing that will
require a lot more work.

v3:
  - Improved changelog (Daniel)
  - Added FIXME to fbdev_use_iomem (Daniel)

v2:
  - Added missing __iomem cast (kernel test robot)
  - Made changelog readable and fix typos (Mark)
  - Add flag to select iomem - and set it in the bochs driver

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200709193016.291267-1-sam@ravnborg.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200725191012.GA434957@ravnborg.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bochs/bochs_kms.c |  1 +
 drivers/gpu/drm/drm_fb_helper.c   |  6 +++++-
 include/drm/drm_mode_config.h     | 12 ++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bochs/bochs_kms.c b/drivers/gpu/drm/bochs/bochs_kms.c
index 8066d7d370d5b..200d55fa97656 100644
--- a/drivers/gpu/drm/bochs/bochs_kms.c
+++ b/drivers/gpu/drm/bochs/bochs_kms.c
@@ -143,6 +143,7 @@ int bochs_kms_init(struct bochs_device *bochs)
 	bochs->dev->mode_config.preferred_depth = 24;
 	bochs->dev->mode_config.prefer_shadow = 0;
 	bochs->dev->mode_config.prefer_shadow_fbdev = 1;
+	bochs->dev->mode_config.fbdev_use_iomem = true;
 	bochs->dev->mode_config.quirk_addfb_prefer_host_byte_order = true;
 
 	bochs->dev->mode_config.funcs = &bochs_mode_funcs;
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index c7be39a00d437..4dd12a069474a 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -399,7 +399,11 @@ static void drm_fb_helper_dirty_blit_real(struct drm_fb_helper *fb_helper,
 	unsigned int y;
 
 	for (y = clip->y1; y < clip->y2; y++) {
-		memcpy(dst, src, len);
+		if (!fb_helper->dev->mode_config.fbdev_use_iomem)
+			memcpy(dst, src, len);
+		else
+			memcpy_toio((void __iomem *)dst, src, len);
+
 		src += fb->pitches[0];
 		dst += fb->pitches[0];
 	}
diff --git a/include/drm/drm_mode_config.h b/include/drm/drm_mode_config.h
index 3bcbe30339f04..198b9d0600081 100644
--- a/include/drm/drm_mode_config.h
+++ b/include/drm/drm_mode_config.h
@@ -865,6 +865,18 @@ struct drm_mode_config {
 	 */
 	bool prefer_shadow_fbdev;
 
+	/**
+	 * @fbdev_use_iomem:
+	 *
+	 * Set to true if framebuffer reside in iomem.
+	 * When set to true memcpy_toio() is used when copying the framebuffer in
+	 * drm_fb_helper.drm_fb_helper_dirty_blit_real().
+	 *
+	 * FIXME: This should be replaced with a per-mapping is_iomem
+	 * flag (like ttm does), and then used everywhere in fbdev code.
+	 */
+	bool fbdev_use_iomem;
+
 	/**
 	 * @quirk_addfb_prefer_xbgr_30bpp:
 	 *
-- 
2.25.1



