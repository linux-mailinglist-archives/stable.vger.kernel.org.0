Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292A766C511
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjAPQBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjAPQBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A8F144B3
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616F961042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73075C433F0;
        Mon, 16 Jan 2023 16:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884866;
        bh=ymIKUcksCwdzcj78heCYpDcfUmvwrtLWGr6lhRR7mv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szL1FjKJx7izKFeanswvymvO2DRtDLeCvcDok2GepRvZIJyZz+7Clt+DzmZnQpuRN
         CLwo0mWIL25LaUmfGkEUbCbvy/KhKhIoJg1/H6LHNUnCa+pFU7pgc4zXSrwnA+/ULW
         Fzj7N78JJOpeGJxXMlZWgWm8ujndMgGTbI3RTNbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/183] drm/vmwgfx: Write the driver id registers
Date:   Mon, 16 Jan 2023 16:51:04 +0100
Message-Id: <20230116154809.321246455@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit 7f4c33778686cc2d34cb4ef65b4265eea874c159 ]

Driver id registers are a new mechanism in the svga device to hint to the
device which driver is running. This should not change device behavior
in any way, but might be convenient to work-around specific bugs
in guest drivers.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221022040236.616490-2-zack@kde.org
Stable-dep-of: a309c7194e8a ("drm/vmwgfx: Remove rcu locks from user resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 43 +++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index d7bd5eb1d3ac..45028e25d490 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -25,10 +25,13 @@
  *
  **************************************************************************/
 
-#include <linux/dma-mapping.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/cc_platform.h>
+
+#include "vmwgfx_drv.h"
+
+#include "vmwgfx_devcaps.h"
+#include "vmwgfx_mksstat.h"
+#include "vmwgfx_binding.h"
+#include "ttm_object.h"
 
 #include <drm/drm_aperture.h>
 #include <drm/drm_drv.h>
@@ -41,11 +44,11 @@
 #include <drm/ttm/ttm_placement.h>
 #include <generated/utsrelease.h>
 
-#include "ttm_object.h"
-#include "vmwgfx_binding.h"
-#include "vmwgfx_devcaps.h"
-#include "vmwgfx_drv.h"
-#include "vmwgfx_mksstat.h"
+#include <linux/cc_platform.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/version.h>
 
 #define VMWGFX_DRIVER_DESC "Linux drm driver for VMware graphics devices"
 
@@ -806,6 +809,27 @@ static int vmw_detect_version(struct vmw_private *dev)
 	return 0;
 }
 
+static void vmw_write_driver_id(struct vmw_private *dev)
+{
+	if ((dev->capabilities2 & SVGA_CAP2_DX2) != 0) {
+		vmw_write(dev,  SVGA_REG_GUEST_DRIVER_ID,
+			  SVGA_REG_GUEST_DRIVER_ID_LINUX);
+
+		vmw_write(dev, SVGA_REG_GUEST_DRIVER_VERSION1,
+			  LINUX_VERSION_MAJOR << 24 |
+			  LINUX_VERSION_PATCHLEVEL << 16 |
+			  LINUX_VERSION_SUBLEVEL);
+		vmw_write(dev, SVGA_REG_GUEST_DRIVER_VERSION2,
+			  VMWGFX_DRIVER_MAJOR << 24 |
+			  VMWGFX_DRIVER_MINOR << 16 |
+			  VMWGFX_DRIVER_PATCHLEVEL);
+		vmw_write(dev, SVGA_REG_GUEST_DRIVER_VERSION3, 0);
+
+		vmw_write(dev, SVGA_REG_GUEST_DRIVER_ID,
+			  SVGA_REG_GUEST_DRIVER_ID_SUBMIT);
+	}
+}
+
 static int vmw_driver_load(struct vmw_private *dev_priv, u32 pci_id)
 {
 	int ret;
@@ -1091,6 +1115,7 @@ static int vmw_driver_load(struct vmw_private *dev_priv, u32 pci_id)
 	vmw_host_printf("vmwgfx: Module Version: %d.%d.%d (kernel: %s)",
 			VMWGFX_DRIVER_MAJOR, VMWGFX_DRIVER_MINOR,
 			VMWGFX_DRIVER_PATCHLEVEL, UTS_RELEASE);
+	vmw_write_driver_id(dev_priv);
 
 	if (dev_priv->enable_fb) {
 		vmw_fifo_resource_inc(dev_priv);
-- 
2.35.1



