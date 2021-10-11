Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9B3428FE8
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhJKOC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238285AbhJKOAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6610161050;
        Mon, 11 Oct 2021 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960614;
        bh=8rv+dLDodlxCHV1xPtmKJextlAab2I7uYALBnhUtHyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsQDz8tDSAIz5R945Z6n7JJly84g0EUJiEXJbtJlwlGfvOT4CyNF8G+nXsXrHIfqN
         R2D+R+b3yDBTFF1emLzmIAegPBxWwlKFob9gckKZDbN0EJoAiogcjaIgsWFmKSji2z
         /BzzbUTbwGFSd64pqUZ0lFMCS02XEjAyuHEJX9ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Borislav Petkov <bp@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Peter Collingbourne <pcc@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dri-devel@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.14 024/151] fbdev: simplefb: fix Kconfig dependencies
Date:   Mon, 11 Oct 2021 15:44:56 +0200
Message-Id: <20211011134518.629623285@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit ec7cc3f74b4236860ce612656aa5be7936d1c594 upstream.

Configurations with both CONFIG_FB_SIMPLE=y and CONFIG_DRM_SIMPLEDRM=m
are allowed by Kconfig because the 'depends on !DRM_SIMPLEDRM' dependency
does not disallow FB_SIMPLE as long as SIMPLEDRM is not built-in. This
can however result in a build failure when cfb_fillrect() etc are then
also in loadable modules:

x86_64-linux-ld: drivers/video/fbdev/simplefb.o:(.rodata+0x1f8): undefined reference to `cfb_fillrect'
x86_64-linux-ld: drivers/video/fbdev/simplefb.o:(.rodata+0x200): undefined reference to `cfb_copyarea'
x86_64-linux-ld: drivers/video/fbdev/simplefb.o:(.rodata+0x208): undefined reference to `cfb_imageblit'

To work around this, change FB_SIMPLE to be a 'tristate' symbol,
which still allows both to be =m together, but not one of them to
be =y if the other one is =m. If a distro kernel picks this
configuration, it can be determined by local policy which of
the two modules gets loaded. The 'of_chosen' export is needed
as this is the first loadable module referencing it.

Alternatively, the Kconfig dependency could be changed to
'depends on DRM_SIMPLEDRM=n', which would forbid the configuration
with both drivers.

Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Acked-by: Rob Herring <robh@kernel.org> # for drivers/of/
Link: https://lore.kernel.org/all/20210721151839.2484245-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch> # fbdev support
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Borislav Petkov <bp@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # v5.14+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210928145243.1098064-1-arnd@kernel.org
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c           |    1 +
 drivers/video/fbdev/Kconfig |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -36,6 +36,7 @@ LIST_HEAD(aliases_lookup);
 struct device_node *of_root;
 EXPORT_SYMBOL(of_root);
 struct device_node *of_chosen;
+EXPORT_SYMBOL(of_chosen);
 struct device_node *of_aliases;
 struct device_node *of_stdout;
 static const char *of_stdout_options;
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2191,8 +2191,9 @@ config FB_HYPERV
 	  This framebuffer driver supports Microsoft Hyper-V Synthetic Video.
 
 config FB_SIMPLE
-	bool "Simple framebuffer support"
-	depends on (FB = y) && !DRM_SIMPLEDRM
+	tristate "Simple framebuffer support"
+	depends on FB
+	depends on !DRM_SIMPLEDRM
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT


