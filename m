Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214E0577BF
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfF0Ah6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728732AbfF0Ah6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:37:58 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F3F321851;
        Thu, 27 Jun 2019 00:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595878;
        bh=+KAzXoiKqVwsHORXic7F0Z6Vd4ppiILYVJjYGJmp9dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVIuzR3GPBjkxGS+5FcVUrQ4SEOV3P3+LihAUwobzzXV+uiOffMb3DqgJUSXvEKN7
         0oaFzhJ0G4Sow0llrKzUl+QneFbg2iqcom5DHzMn31bUyp25KQiL6N7pd6OQKTrZp5
         R+wTF8w7maNClXkycDFn1H/4whVu2rIDl79X7TWU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Thomas Hellstrom <thellstrom@vmware.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 33/60] drm/vmwgfx: fix a warning due to missing dma_parms
Date:   Wed, 26 Jun 2019 20:35:48 -0400
Message-Id: <20190627003616.20767-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 39916897cd815a0ee07ba1f6820cf88a63e459fc ]

Booting up with DMA_API_DEBUG_SG=y generates a warning due to the driver
forgot to set dma_parms appropriately. Set it just after vmw_dma_masks()
in vmw_driver_load().

DMA-API: vmwgfx 0000:00:0f.0: mapping sg segment longer than device
claims to support [len=2097152] [max=65536]
WARNING: CPU: 2 PID: 261 at kernel/dma/debug.c:1232
debug_dma_map_sg+0x360/0x480
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop
Reference Platform, BIOS 6.00 04/13/2018
RIP: 0010:debug_dma_map_sg+0x360/0x480
Call Trace:
 vmw_ttm_map_dma+0x3b1/0x5b0 [vmwgfx]
 vmw_bo_map_dma+0x25/0x30 [vmwgfx]
 vmw_otables_setup+0x2a8/0x750 [vmwgfx]
 vmw_request_device_late+0x78/0xc0 [vmwgfx]
 vmw_request_device+0xee/0x4e0 [vmwgfx]
 vmw_driver_load.cold+0x757/0xd84 [vmwgfx]
 drm_dev_register+0x1ff/0x340 [drm]
 drm_get_pci_dev+0x110/0x290 [drm]
 vmw_probe+0x15/0x20 [vmwgfx]
 local_pci_probe+0x7a/0xc0
 pci_device_probe+0x1b9/0x290
 really_probe+0x1b5/0x630
 driver_probe_device+0xa3/0x1a0
 device_driver_attach+0x94/0xa0
 __driver_attach+0xdd/0x1c0
 bus_for_each_dev+0xfe/0x150
 driver_attach+0x2d/0x40
 bus_add_driver+0x290/0x350
 driver_register+0xdc/0x1d0
 __pci_register_driver+0xda/0xf0
 vmwgfx_init+0x34/0x1000 [vmwgfx]
 do_one_initcall+0xe5/0x40a
 do_init_module+0x10f/0x3a0
 load_module+0x16a5/0x1a40
 __se_sys_finit_module+0x183/0x1c0
 __x64_sys_finit_module+0x43/0x50
 do_syscall_64+0xc8/0x606
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: fb1d9738ca05 ("drm/vmwgfx: Add DRM driver for VMware Virtual GPU")
Co-developed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 82ae68716696..05a800807c26 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -789,6 +789,9 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (unlikely(ret != 0))
 		goto out_err0;
 
+	dma_set_max_seg_size(dev->dev, min_t(unsigned int, U32_MAX & PAGE_MASK,
+					     SCATTERLIST_MAX_SEGMENT));
+
 	if (dev_priv->capabilities & SVGA_CAP_GMR2) {
 		DRM_INFO("Max GMR ids is %u\n",
 			 (unsigned)dev_priv->max_gmr_ids);
-- 
2.20.1

