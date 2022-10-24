Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E456D60A720
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbiJXMsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbiJXMpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:45:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F7758B46;
        Mon, 24 Oct 2022 05:10:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D9966128E;
        Mon, 24 Oct 2022 12:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87ED6C433D7;
        Mon, 24 Oct 2022 12:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613406;
        bh=FW2NvzB1JvQFsKGrSBo35+KBXe7fSEbV76DQZwXfYnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djZmvVh+OUwK9MZgvhOEqgePV3IJUPxUI7JlKVdWLQ5XmmEgFXdGiH8ulbtpLFmRV
         XOGrfxYPpg6+yzqiuIfveHmJ2Bobe75jrJgWdMHO6FGoJ5B9gfWYXJ3wIoUw/Qe1Ar
         YKN/an5ekYgQis4E+PfsN20i+3yMwktWDr0+4CVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Dillon Min <dillon.minfei@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/255] drm: fix drm_mipi_dbi build errors
Date:   Mon, 24 Oct 2022 13:30:04 +0200
Message-Id: <20221024113005.616180416@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit eb7de496451bd969e203f02f66585131228ba4ae ]

drm_mipi_dbi needs lots of DRM_KMS_HELPER support, so select
that Kconfig symbol like it is done is most other uses, and
the way that it was before MIPS_DBI was moved from tinydrm
to its core location.

Fixes these build errors:

ld: drivers/gpu/drm/drm_mipi_dbi.o: in function `mipi_dbi_buf_copy':
drivers/gpu/drm/drm_mipi_dbi.c:205: undefined reference to `drm_gem_fb_get_obj'
ld: drivers/gpu/drm/drm_mipi_dbi.c:211: undefined reference to `drm_gem_fb_begin_cpu_access'
ld: drivers/gpu/drm/drm_mipi_dbi.c:215: undefined reference to `drm_gem_fb_vmap'
ld: drivers/gpu/drm/drm_mipi_dbi.c:222: undefined reference to `drm_fb_swab'
ld: drivers/gpu/drm/drm_mipi_dbi.c:224: undefined reference to `drm_fb_memcpy'
ld: drivers/gpu/drm/drm_mipi_dbi.c:227: undefined reference to `drm_fb_xrgb8888_to_rgb565'
ld: drivers/gpu/drm/drm_mipi_dbi.c:235: undefined reference to `drm_gem_fb_vunmap'
ld: drivers/gpu/drm/drm_mipi_dbi.c:237: undefined reference to `drm_gem_fb_end_cpu_access'
ld: drivers/gpu/drm/drm_mipi_dbi.o: in function `mipi_dbi_dev_init_with_formats':
ld: drivers/gpu/drm/drm_mipi_dbi.o:/X64/../drivers/gpu/drm/drm_mipi_dbi.c:469: undefined reference to `drm_gem_fb_create_with_dirty'

Fixes: 174102f4de23 ("drm/tinydrm: Move mipi-dbi")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Dillon Min <dillon.minfei@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220823004243.11596-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 649f17dfcf45..fc6c4f81985e 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -27,6 +27,7 @@ menuconfig DRM
 config DRM_MIPI_DBI
 	tristate
 	depends on DRM
+	select DRM_KMS_HELPER
 
 config DRM_MIPI_DSI
 	bool
-- 
2.35.1



