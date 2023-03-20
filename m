Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FD46C0E7D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCTKRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjCTKRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:17:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44E51114B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E536B80DE0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D06C433D2;
        Mon, 20 Mar 2023 10:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679307424;
        bh=9xDneswuB60sDfy6KNv9puAc90MjHDIu6L4qTI+1zHU=;
        h=Subject:To:Cc:From:Date:From;
        b=iNPghetG4WXTK3h8VBU35y7yGdmGZnfOAGLaQ+T9bNhZ9XAfcy7hGYoKmXiT0tFib
         2tS7N63MIAF3xoll01+o1T3M6xSicH8WWh/OZXmmOKlcUOUgwJGBzok8G1uyFYixRR
         Lx3asA526yaZA0mmPMJqHoYDkOY9AG56LxPPADd4=
Subject: FAILED: patch "[PATCH] drm/sun4i: fix missing component unbind on bind errors" failed to apply to 5.10-stable tree
To:     johan+linaro@kernel.org, maxime@cerno.tech, mripard@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 11:17:01 +0100
Message-ID: <167930742148207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x c22f2ff8724b49dce2ae797e9fbf4bc0fa91112f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930742148207@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

c22f2ff8724b ("drm/sun4i: fix missing component unbind on bind errors")
6848c291a54f ("drm/aperture: Convert drivers to aperture interfaces")
dc739820ff90 ("drm/ast: fix memory leak when unload the driver")
31856c8c1ce4 ("drm/vmwgfx: Remove stealth mode")
840462e6872d ("drm/vmwgfx: Remove references to struct drm_device.pdev")
5bbacc2e7ab1 ("drm/virtgpu: Remove references to struct drm_device.pdev")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c22f2ff8724b49dce2ae797e9fbf4bc0fa91112f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 11:32:42 +0100
Subject: [PATCH] drm/sun4i: fix missing component unbind on bind errors

Make sure to unbind all subcomponents when binding the aggregate device
fails.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Cc: stable@vger.kernel.org      # 4.7
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230306103242.4775-1-johan+linaro@kernel.org

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index cc94efbbf2d4..d6c741716167 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -95,12 +95,12 @@ static int sun4i_drv_bind(struct device *dev)
 	/* drm_vblank_init calls kcalloc, which can fail */
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	/* Remove early framebuffers (ie. simplefb) */
 	ret = drm_aperture_remove_framebuffers(false, &sun4i_drv_driver);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	sun4i_framebuffer_init(drm);
 
@@ -119,6 +119,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 finish_poll:
 	drm_kms_helper_poll_fini(drm);
+unbind_all:
+	component_unbind_all(dev, NULL);
 cleanup_mode_config:
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);

