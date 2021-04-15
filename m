Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC27F361236
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 20:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhDOShL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 14:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhDOShL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 14:37:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A65C061574;
        Thu, 15 Apr 2021 11:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:MIME-Version
        :Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=IaCRoKAqEtl3CLtnztHtdjbvOkO6tttpieuRpGwomT8=; b=kKFRxM7p95YppixJHIw3Km2p/D
        X1EchgueKzGGiQGCESXxHtenlwuZs7mN2/6DJLeiKEibvasLjDm3C8uaoplW4kUse0nknXPsrv9q0
        rybJSFFY1kPOQ0BnJMJ1DW7jOczk28mc6qeaXajbLoJcIYcnz2hla0XzlfJDcHyyN4EcaCX/ONl4s
        AYbyA3qPoHXgmyAJ0JBlUXth3Ulx0Ka7Aq/kPaKDEwfgAomIoW+CLh/vmoa0uSjhsdxHe4Oe4ehBz
        TI/P75j0VMTEp2XgdCq2zlNPJnRBHD7Jk9SoAWPAZmLtD+189B7UEN2lPtKJy6MwTep/QqnE64lCw
        66EpNtMw==;
Received: from [2601:1c0:6280:3f0::df68] (helo=smtpauth.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lX6r6-00H0oz-FC; Thu, 15 Apr 2021 18:36:45 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH -next] drm: bridge: fix LONTIUM use of mipi_dsi_() functions
Date:   Thu, 15 Apr 2021 11:36:39 -0700
Message-Id: <20210415183639.1487-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Lontium DRM bridge drivers use mipi_dsi_() function interfaces so
they need to select DRM_MIPI_DSI to prevent build errors.

ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/lontium-lt9611uxc.ko] undefined!
ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge/lontium-lt9611uxc.ko] undefined!
ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge/lontium-lt9611uxc.ko] undefined!
ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/lontium-lt9611uxc.ko] undefined!
ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/lontium-lt9611uxc.ko] undefined!
ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/lontium-lt9611.ko] undefined!
ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge/lontium-lt9611.ko] undefined!
ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge/lontium-lt9611.ko] undefined!
ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/lontium-lt9611.ko] undefined!
ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/lontium-lt9611.ko] undefined!
WARNING: modpost: suppressed 5 unresolved symbol warnings because there were too many)

Fixes: 23278bf54afe ("drm/bridge: Introduce LT9611 DSI to HDMI bridge")
Fixes: 0cbbd5b1a012 ("drm: bridge: add support for lontium LT9611UXC bridge")
Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Adrien Grassein <adrien.grassein@gmail.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/bridge/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20210414.orig/drivers/gpu/drm/bridge/Kconfig
+++ linux-next-20210414/drivers/gpu/drm/bridge/Kconfig
@@ -66,6 +66,7 @@ config DRM_LONTIUM_LT8912B
 	depends on OF
 	select DRM_PANEL_BRIDGE
 	select DRM_KMS_HELPER
+	select DRM_MIPI_DSI
 	select REGMAP_I2C
 	help
 	  Driver for Lontium LT8912B DSI to HDMI bridge
@@ -81,6 +82,7 @@ config DRM_LONTIUM_LT9611
 	depends on OF
 	select DRM_PANEL_BRIDGE
 	select DRM_KMS_HELPER
+	select DRM_MIPI_DSI
 	select REGMAP_I2C
 	help
 	  Driver for Lontium LT9611 DSI to HDMI bridge
@@ -94,6 +96,7 @@ config DRM_LONTIUM_LT9611UXC
 	depends on OF
 	select DRM_PANEL_BRIDGE
 	select DRM_KMS_HELPER
+	select DRM_MIPI_DSI
 	select REGMAP_I2C
 	help
 	  Driver for Lontium LT9611UXC DSI to HDMI bridge
