Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1FF554961
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353684AbiFVIeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 04:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350684AbiFVIeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 04:34:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268B32622;
        Wed, 22 Jun 2022 01:34:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D881F1FAFD;
        Wed, 22 Jun 2022 08:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655886854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=O1EOyoPBau9TPG/tVZpTYxGahQsskO0hXdQhQeaV5ZI=;
        b=1kKI8CIouoYNcAsmKhFEPHTiHTc35Pgsbv2AwOxKjg2kYZxS3dqdHBIqk05LAqEqqxMNzV
        fAz9GtRquUOjc4/HpiZ3BObBLPqdQCWMF/sLaA7tZp6Egw1p9sfeLm41zknuJl5rx7HJvP
        MN8zfd6PNdyGYOV6ZF2a34FO3BlhGkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655886854;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=O1EOyoPBau9TPG/tVZpTYxGahQsskO0hXdQhQeaV5ZI=;
        b=F9hRTr2toRP77B+V7zp51+ilujZVnD4qUBoSIEyoLokkg8Z35pgLer5jFa3VUDZBALY0Ye
        JrYKpI/kDjAgFUDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A05C6134A9;
        Wed, 22 Jun 2022 08:34:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dCEvJgbUsmIPDAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 22 Jun 2022 08:34:14 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     drawat.floss@gmail.com, airlied@linux.ie, daniel@ffwll.ch
Cc:     linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jani.nikula@linux.intel.com, ville.syrjala@linux.intel.com,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] drm/hyperv-drm: Include framebuffer and EDID headers
Date:   Wed, 22 Jun 2022 10:34:13 +0200
Message-Id: <20220622083413.12573-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a number of compile errors by including the correct header
files. Examples are shown below.

  ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c: In function 'hyperv_blit_to_vram_rect':
  ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c:25:48: error: invalid use of undefined type 'struct drm_framebuffer'
   25 |         struct hyperv_drm_device *hv = to_hv(fb->dev);
      |                                                ^~

  ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c: In function 'hyperv_connector_get_modes':
  ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c:59:17: error: implicit declaration of function 'drm_add_modes_noedid' [-Werror=implicit-function-declaration]
   59 |         count = drm_add_modes_noedid(connector,
      |                 ^~~~~~~~~~~~~~~~~~~~

  ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c:62:9: error: implicit declaration of function 'drm_set_preferred_mode'; did you mean 'drm_mm_reserve_node'? [-Werror=implicit-function-declaration]
   62 |         drm_set_preferred_mode(connector, hv->preferred_width,
      |         ^~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 76c56a5affeb ("drm/hyperv: Add DRM driver for hyperv synthetic video device")
Cc: Deepak Rawat <drawat.floss@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: linux-hyperv@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.14+
---
 drivers/gpu/drm/hyperv/hyperv_drm_modeset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c b/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c
index 27f4fcb058f9..b8e64dd8d3a6 100644
--- a/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c
@@ -7,9 +7,11 @@
 
 #include <drm/drm_damage_helper.h>
 #include <drm/drm_drv.h>
+#include <drm/drm_edid.h>
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_format_helper.h>
 #include <drm/drm_fourcc.h>
+#include <drm/drm_framebuffer.h>
 #include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_gem_shmem_helper.h>
-- 
2.36.1

