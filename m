Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B87561BE4
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbiF3NtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbiF3Nsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:48:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D004C13F19;
        Thu, 30 Jun 2022 06:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 692546201C;
        Thu, 30 Jun 2022 13:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759AEC3411E;
        Thu, 30 Jun 2022 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596911;
        bh=khRUTUfXCKl/PswhSf/yoKKIjB0qm7w5Mw7R/p3FbUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSkADiilkflBrZMenK9M9UcvNMtLjQ0MPp78l3RkMbCS5NlMKGtcLldx0mzdKXcc4
         q25sCH7W0+2qAl5cprZm+vwym2Dfeq+VOs8jtf7YF5nmR0gONHvmkNE6bO4vEe+K2/
         jt57xylaHp2PyzD3b4mBQWnQ5GaHSqD86y6CJWKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.9 25/29] drm: remove drm_fb_helper_modinit
Date:   Thu, 30 Jun 2022 15:46:25 +0200
Message-Id: <20220630133231.943773683@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
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
@@ -28,16 +28,6 @@
 
 #include <drm/drm_dp_helper.h>
 
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
@@ -2324,24 +2324,3 @@ int drm_fb_helper_hotplug_event(struct d
 	return 0;
 }
 EXPORT_SYMBOL(drm_fb_helper_hotplug_event);
-
-/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
- * but the module doesn't depend on any fb console symbols.  At least
- * attempt to load fbcon to avoid leaving the system without a usable console.
- */
-int __init drm_fb_helper_modinit(void)
-{
-#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EXPERT)
-	const char *name = "fbcon";
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
@@ -36,19 +36,18 @@ MODULE_LICENSE("GPL and additional right
 
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


