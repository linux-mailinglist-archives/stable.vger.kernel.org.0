Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A90E37CB46
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbhELQfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241616AbhELQ1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F3FD61DF3;
        Wed, 12 May 2021 15:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834863;
        bh=WpcLTHjKv5NQ1sL3+0oPPHvyRL2/Ps9DXZuV7pQtd/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifgaPGlZ3a/dYJGcM1rfKEBVONhbnTuaz5q5J/S+SljRes+Rl5toVbaqzGQgxp/Sg
         AjrCFrBtzlR8s/OmRihSZCTR2kRzsL/yAnjJp0BvpTk/AvaVj54YyeXt3TZUr7ZPZ4
         vhxL8Ac+3E7E8KK3WhOx7LJQZMeOxLF8b0OzRokg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Robert Foss <robert.foss@linaro.org>,
        Xin Ji <xji@analogixsemi.com>, Sam Ravnborg <sam@ravnborg.org>,
        dri-devel@lists.freedesktop.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 5.12 078/677] drm: bridge: fix ANX7625 use of mipi_dsi_() functions
Date:   Wed, 12 May 2021 16:42:04 +0200
Message-Id: <20210512144839.823851124@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit ed01fca38717169fcb61bd45ad1c3750d9c40d59 upstream.

The Analogix DRM ANX7625 bridge driver uses mips_dsi_() function
interfaces so it should select DRM_MIPI_DSI to prevent build errors.

ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!

Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Cc: Xin Ji <xji@analogixsemi.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210415183619.1431-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/analogix/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/bridge/analogix/Kconfig
+++ b/drivers/gpu/drm/bridge/analogix/Kconfig
@@ -30,6 +30,7 @@ config DRM_ANALOGIX_ANX7625
 	tristate "Analogix Anx7625 MIPI to DP interface support"
 	depends on DRM
 	depends on OF
+	select DRM_MIPI_DSI
 	help
 	  ANX7625 is an ultra-low power 4K mobile HD transmitter
 	  designed for portable devices. It converts MIPI/DPI to


