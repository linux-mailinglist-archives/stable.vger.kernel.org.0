Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF1C361232
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 20:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhDOSgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 14:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhDOSgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 14:36:51 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CB7C061574;
        Thu, 15 Apr 2021 11:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:MIME-Version
        :Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+ozdJAHrKCbNr61OMEyduXyBZabavgrro2YmmDxy4mo=; b=Wdonrjmm3K+kii/7uHvDoH+ir8
        bRxQOpr3kv8CrbwKPw4A6OOwGZRsKs9KynCJqdVXCyHNy8TJd1guMqOJRllpQSE1kXBMOeHchwLyy
        94sTZdTluYVqnuwjhCEt8d1nwHYzMHBCC4sFFbTwoVox414X5HcLSsdL1MuukzfX+wMpmK7xXvxpU
        d0PNAzO+mYg4YummUPH+4WK9oAtLajuQ2VyCM8JxFXpxhOuk5P5V0N71FDaHce5J4HqZrAIo6SvYX
        6BPeS42kdbIwO+Z06BlpMi1gqZAPOn6gjA4tGZLV2b3mR+ybz3yblVT5URV16Xff/Ipdqs6BCzo3r
        U62lNT7A==;
Received: from [2601:1c0:6280:3f0::df68] (helo=smtpauth.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lX6qm-00H0k3-B5; Thu, 15 Apr 2021 18:36:24 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Xin Ji <xji@analogixsemi.com>, Sam Ravnborg <sam@ravnborg.org>,
        dri-devel@lists.freedesktop.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>, stable@vger.kernel.org
Subject: [PATCH -next] drm: bridge: fix ANX7625 use of mipi_dsi_() functions
Date:   Thu, 15 Apr 2021 11:36:19 -0700
Message-Id: <20210415183619.1431-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Analogix DRM ANX7625 bridge driver uses mips_dsi_() function
interfaces so it should select DRM_MIPI_DSI to prevent build errors.


ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!


Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Xin Ji <xji@analogixsemi.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/bridge/analogix/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20210414.orig/drivers/gpu/drm/bridge/analogix/Kconfig
+++ linux-next-20210414/drivers/gpu/drm/bridge/analogix/Kconfig
@@ -30,6 +30,7 @@ config DRM_ANALOGIX_ANX7625
 	tristate "Analogix Anx7625 MIPI to DP interface support"
 	depends on DRM
 	depends on OF
+	select DRM_MIPI_DSI
 	help
 	  ANX7625 is an ultra-low power 4K mobile HD transmitter
 	  designed for portable devices. It converts MIPI/DPI to
