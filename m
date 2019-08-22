Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E686999F1
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390502AbfHVRIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390499AbfHVRIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:46 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C72D23426;
        Thu, 22 Aug 2019 17:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493725;
        bh=ZKAkj2PBDzbgmpcPQyxVaFn971P85QAkn1irCUYBn+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9XtDx2udrSsUooTPm60zQfDbCzA272c6hh+t6iWMiEc3DWcKJTR8wF+IpZLWwXWC
         CfjLclt4+RicsHVlg1ShaF8tqJSCnlViaMzZCtlEBGbe9gAcqfo6twbKdt3Yodqxwf
         zkakVROZ+qaExBgQ0cRuwgSkyKoxe97Rs08VARtI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 057/135] drm/bridge: lvds-encoder: Fix build error while CONFIG_DRM_KMS_HELPER=m
Date:   Thu, 22 Aug 2019 13:06:53 -0400
Message-Id: <20190822170811.13303-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit f4cc743a98136df3c3763050a0e8223b52d9a960 ]

If DRM_LVDS_ENCODER=y but CONFIG_DRM_KMS_HELPER=m,
build fails:

drivers/gpu/drm/bridge/lvds-encoder.o: In function `lvds_encoder_probe':
lvds-encoder.c:(.text+0x155): undefined reference to `devm_drm_panel_bridge_add'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: dbb58bfd9ae6 ("drm/bridge: Fix lvds-encoder since the panel_bridge rework.")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190729071216.27488-1-yuehaibing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index ee777469293a4..cc62603b87c59 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -48,6 +48,7 @@ config DRM_DUMB_VGA_DAC
 config DRM_LVDS_ENCODER
 	tristate "Transparent parallel to LVDS encoder support"
 	depends on OF
+	select DRM_KMS_HELPER
 	select DRM_PANEL_BRIDGE
 	help
 	  Support for transparent parallel to LVDS encoders that don't require
-- 
2.20.1

