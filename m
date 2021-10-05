Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2875421F39
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 09:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJEHFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 03:05:48 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45140 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJEHFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 03:05:48 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 344091FE37;
        Tue,  5 Oct 2021 07:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633417437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hcrx3ePp251FBiwXmbCqaDo7jNPxyHRwok9KZypNiBs=;
        b=JH2x3XIqtNu3I4HAKCg51sdgp8DYrbrvj4rCt1X36Jh1E2INn8tMjEbR3lspD8TdMMQ2j8
        1wzMRKmiwwlfsq3AQZNwStzx59iYWKoTMHcyNmBsdGqoAL2+8Wx8FXHwmvGlaVvvT8YV55
        9Zsi4Z2bIwxqmwctOB2U8/3JR84TSYg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633417437;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hcrx3ePp251FBiwXmbCqaDo7jNPxyHRwok9KZypNiBs=;
        b=ZkoPgewj4qzzt84dwxpD7DUPypE7aEs2JyBf9Z2MxVaqflX8QAU7BI839E0AibldoihmQR
        j3gBBeCJnMkAaZBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E30F6133A7;
        Tue,  5 Oct 2021 07:03:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wSliNtz4W2EGPwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 05 Oct 2021 07:03:56 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     daniel@ffwll.ch, airlied@linux.ie, mripard@kernel.org,
        maarten.lankhorst@linux.intel.com, kernel@amanoeldawod.com,
        dirty.ice.hu@gmail.com, michael+lkml@stapelberg.ch,
        ville.syrjala@linux.intel.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>, stable@vger.kernel.org
Subject: [PATCH v2] drm/fbdev: Clamp fbdev surface size if too large
Date:   Tue,  5 Oct 2021 09:03:55 +0200
Message-Id: <20211005070355.7680-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clamp the fbdev surface size of the available maximumi height to avoid
failing to init console emulation. An example error is shown below.

  bad framebuffer height 2304, should be >= 768 && <= 768
  [drm] Initialized simpledrm 1.0.0 20200625 for simple-framebuffer.0 on minor 0
  simple-framebuffer simple-framebuffer.0: [drm] *ERROR* fbdev: Failed to setup generic emulation (ret=-22)

This is especially a problem with drivers that have very small screen
sizes and cannot over-allocate at all.

v2:
	* reduce warning level (Ville)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Reported-by: Amanoel Dawod <kernel@amanoeldawod.com>
Reported-by: Zoltán Kővágó <dirty.ice.hu@gmail.com>
Reported-by: Michael Stapelberg <michael+lkml@stapelberg.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.14+
---
 drivers/gpu/drm/drm_fb_helper.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 6860223f0068..3b5661cf6c2b 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1508,6 +1508,7 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 {
 	struct drm_client_dev *client = &fb_helper->client;
 	struct drm_device *dev = fb_helper->dev;
+	struct drm_mode_config *config = &dev->mode_config;
 	int ret = 0;
 	int crtc_count = 0;
 	struct drm_connector_list_iter conn_iter;
@@ -1665,6 +1666,11 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 	/* Handle our overallocation */
 	sizes.surface_height *= drm_fbdev_overalloc;
 	sizes.surface_height /= 100;
+	if (sizes.surface_height > config->max_height) {
+		drm_dbg_kms(dev, "Fbdev over-allocation too large; clamping height to %d\n",
+			    config->max_height);
+		sizes.surface_height = config->max_height;
+	}
 
 	/* push down into drivers */
 	ret = (*fb_helper->funcs->fb_probe)(fb_helper, &sizes);
-- 
2.33.0

