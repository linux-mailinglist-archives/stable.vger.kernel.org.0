Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62604D846F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241265AbiCNMYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243943AbiCNMVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AEE13D04;
        Mon, 14 Mar 2022 05:18:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2285660C70;
        Mon, 14 Mar 2022 12:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704ADC340E9;
        Mon, 14 Mar 2022 12:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260333;
        bh=GHcjVNVFmexWPprva3YoZ+5Onj0yOw5uwvJRTbQR+mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXKRYkl5ejURaVosBp08IKiEnQ7NcsOrUcSpivWicz7eRPkap7ZHKOruOYBer6BsB
         v+T7jfHrlJn3/e/ZkdPVCy74s9nzQvtNE5uJVc4qPYcFUwceEB47VNgn2f2o4qXdv7
         7aKYUMCbh9D6SJqenfWUKR04aaR/wbou5O4zSSD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Lyude Paul <lyude@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.16 118/121] drm/panel: Select DRM_DP_HELPER for DRM_PANEL_EDP
Date:   Mon, 14 Mar 2022 12:55:01 +0100
Message-Id: <20220314112747.405722135@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 3755d35ee1d2454b20b8a1e20d790e56201678a4 upstream.

As reported in [1], DRM_PANEL_EDP depends on DRM_DP_HELPER. Select
the option to fix the build failure. The error message is shown
below.

  arm-linux-gnueabihf-ld: drivers/gpu/drm/panel/panel-edp.o: in function
    `panel_edp_probe': panel-edp.c:(.text+0xb74): undefined reference to
    `drm_panel_dp_aux_backlight'
  make[1]: *** [/builds/linux/Makefile:1222: vmlinux] Error 1

The issue has been reported before, when DisplayPort helpers were
hidden behind the option CONFIG_DRM_KMS_HELPER. [2]

v2:
	* fix and expand commit description (Arnd)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 9d6366e743f3 ("drm: fb_helper: improve CONFIG_FB dependency")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://lore.kernel.org/dri-devel/CA+G9fYvN0NyaVkRQmA1O6rX7H8PPaZrUAD7=RDy33QY9rUU-9g@mail.gmail.com/ # [1]
Link: https://lore.kernel.org/all/20211117062704.14671-1-rdunlap@infradead.org/ # [2]
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: dri-devel@lists.freedesktop.org
Link: https://patchwork.freedesktop.org/patch/msgid/20220203093922.20754-1-tzimmermann@suse.de
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -95,6 +95,7 @@ config DRM_PANEL_EDP
 	depends on PM
 	select VIDEOMODE_HELPERS
 	select DRM_DP_AUX_BUS
+	select DRM_DP_HELPER
 	help
 	  DRM panel driver for dumb eDP panels that need at most a regulator and
 	  a GPIO to be powered up. Optionally a backlight can be attached so


