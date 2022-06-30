Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BEB561D50
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbiF3OG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiF3OGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:06:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3F14507B;
        Thu, 30 Jun 2022 06:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 875F3B82AEE;
        Thu, 30 Jun 2022 13:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03C2C34115;
        Thu, 30 Jun 2022 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597243;
        bh=P8wgigXF/dPAJ0DvVhyrXIGDLXoNGiFI2i0TY4IRoeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkCo4VVpwa020p1hXsfEnSvGJHaHPSR+xOOLm6ZdoaBim/267mHSpizLbNipNDhPD
         uAJOcrUg98V6L0R53LpwvJhIrCCuZ/CN08ZtDWyXZrPO/3k9jqerK5dnb+4ktwIswH
         4MMx7AZP3xT1eIMw7NOxk7qaKvlQN6ibGd7N+xD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.10 02/12] drm: remove drm_fb_helper_modinit
Date:   Thu, 30 Jun 2022 15:47:07 +0200
Message-Id: <20220630133230.753964438@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
References: <20220630133230.676254336@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit bf22c9ec39da90ce866d5f625d616f28bc733dc1 upstream.

drm_fb_helper_modinit has a lot of boilerplate for what is not very
simple functionality.  Just open code it in the only caller using
IS_ENABLED and IS_MODULE, and skip the find_module check as a
request_module is harmless if the module is already loaded (and not
other caller has this find_module check either).

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_crtc_helper_internal.h |   10 ----------
 drivers/gpu/drm/drm_fb_helper.c            |   21 ---------------------
 drivers/gpu/drm/drm_kms_helper_common.c    |   23 +++++++++++------------
 3 files changed, 11 insertions(+), 43 deletions(-)

--- a/drivers/gpu/drm/drm_crtc_helper_internal.h
+++ b/drivers/gpu/drm/drm_crtc_helper_internal.h
@@ -32,16 +32,6 @@
 #include <drm/drm_encoder.h>
 #include <drm/drm_modes.h>
 
-/* drm_fb_helper.c */
-#ifdef CONFIG_DRM_FBDEV_EMULATION
-int drm_fb_helper_modinit(void);
-#else
-static inline int drm_fb_helper_modinit(void)
-{
-	return 0;
-}
-#endif
-
 /* drm_dp_aux_dev.c */
 #ifdef CONFIG_DRM_DP_AUX_CHARDEV
 int drm_dp_aux_dev_init(void);
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2271,24 +2271,3 @@ void drm_fbdev_generic_setup(struct drm_
 	drm_client_register(&fb_helper->client);
 }
 EXPORT_SYMBOL(drm_fbdev_generic_setup);
-
-/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
- * but the module doesn't depend on any fb console symbols.  At least
- * attempt to load fbcon to avoid leaving the system without a usable console.
- */
-int __init drm_fb_helper_modinit(void)
-{
-#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EXPERT)
-	const char name[] = "fbcon";
-	struct module *fbcon;
-
-	mutex_lock(&module_mutex);
-	fbcon = find_module(name);
-	mutex_unlock(&module_mutex);
-
-	if (!fbcon)
-		request_module_nowait(name);
-#endif
-	return 0;
-}
-EXPORT_SYMBOL(drm_fb_helper_modinit);
--- a/drivers/gpu/drm/drm_kms_helper_common.c
+++ b/drivers/gpu/drm/drm_kms_helper_common.c
@@ -64,19 +64,18 @@ MODULE_PARM_DESC(edid_firmware,
 
 static int __init drm_kms_helper_init(void)
 {
-	int ret;
+	/*
+	 * The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
+	 * but the module doesn't depend on any fb console symbols.  At least
+	 * attempt to load fbcon to avoid leaving the system without a usable
+	 * console.
+	 */
+	if (IS_ENABLED(CONFIG_DRM_FBDEV_EMULATION) &&
+	    IS_MODULE(CONFIG_FRAMEBUFFER_CONSOLE) &&
+	    !IS_ENABLED(CONFIG_EXPERT))
+		request_module_nowait("fbcon");
 
-	/* Call init functions from specific kms helpers here */
-	ret = drm_fb_helper_modinit();
-	if (ret < 0)
-		goto out;
-
-	ret = drm_dp_aux_dev_init();
-	if (ret < 0)
-		goto out;
-
-out:
-	return ret;
+	return drm_dp_aux_dev_init();
 }
 
 static void __exit drm_kms_helper_exit(void)


