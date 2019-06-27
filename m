Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194755784B
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfF0Adv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbfF0Adv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:51 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99BE820815;
        Thu, 27 Jun 2019 00:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595630;
        bh=2HnljJcrp9yIxZ7wXhV5RWq2hMisxr1ZxRC6CJ0Jwr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zl1otm/P37Hj2G3hhdgbBBiMNBgLZBL+/KR7UQui6JbXSlIQX3suF1lotzuLq5ma6
         wC4ax/3NJMCAYCDGKvxN073jXCq1wWkCg2atg6a8amggVapDV72fXIS7PkTE419wvJ
         9p9vVDvk2vudpz73WwIM0wUEwvecmF2/PheJbmlc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 60/95] ARM: davinci: da8xx: specify dma_coherent_mask for lcdc
Date:   Wed, 26 Jun 2019 20:29:45 -0400
Message-Id: <20190627003021.19867-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 68f2515bb31a664ba3e2bc1eb78dd9f529b10067 ]

The lcdc device is missing the dma_coherent_mask definition causing the
following warning on da850-evm:

da8xx_lcdc da8xx_lcdc.0: found Sharp_LK043T1DG01 panel
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at kernel/dma/mapping.c:247 dma_alloc_attrs+0xc8/0x110
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 5.2.0-rc3-00077-g16d72dd4891f #18
Hardware name: DaVinci DA850/OMAP-L138/AM18x EVM
[<c000fce8>] (unwind_backtrace) from [<c000d900>] (show_stack+0x10/0x14)
[<c000d900>] (show_stack) from [<c001a4f8>] (__warn+0xec/0x114)
[<c001a4f8>] (__warn) from [<c001a634>] (warn_slowpath_null+0x3c/0x48)
[<c001a634>] (warn_slowpath_null) from [<c0065860>] (dma_alloc_attrs+0xc8/0x110)
[<c0065860>] (dma_alloc_attrs) from [<c02820f8>] (fb_probe+0x228/0x5a8)
[<c02820f8>] (fb_probe) from [<c02d3e9c>] (platform_drv_probe+0x48/0x9c)
[<c02d3e9c>] (platform_drv_probe) from [<c02d221c>] (really_probe+0x1d8/0x2d4)
[<c02d221c>] (really_probe) from [<c02d2474>] (driver_probe_device+0x5c/0x168)
[<c02d2474>] (driver_probe_device) from [<c02d2728>] (device_driver_attach+0x58/0x60)
[<c02d2728>] (device_driver_attach) from [<c02d27b0>] (__driver_attach+0x80/0xbc)
[<c02d27b0>] (__driver_attach) from [<c02d047c>] (bus_for_each_dev+0x64/0xb4)
[<c02d047c>] (bus_for_each_dev) from [<c02d1590>] (bus_add_driver+0xe4/0x1d8)
[<c02d1590>] (bus_add_driver) from [<c02d301c>] (driver_register+0x78/0x10c)
[<c02d301c>] (driver_register) from [<c000a5c0>] (do_one_initcall+0x48/0x1bc)
[<c000a5c0>] (do_one_initcall) from [<c05cae6c>] (kernel_init_freeable+0x10c/0x1d8)
[<c05cae6c>] (kernel_init_freeable) from [<c048a000>] (kernel_init+0x8/0xf4)
[<c048a000>] (kernel_init) from [<c00090e0>] (ret_from_fork+0x14/0x34)
Exception stack(0xc6837fb0 to 0xc6837ff8)
7fa0:                                     00000000 00000000 00000000 00000000
7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
7fe0: 00000000 00000000 00000000 00000000 00000013 00000000
---[ end trace 8a8073511be81dd2 ]---

Add a 32-bit mask to the platform device's definition.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/devices-da8xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index b8dc674e06bc..261240913b45 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -686,6 +686,9 @@ static struct platform_device da8xx_lcdc_device = {
 	.id		= 0,
 	.num_resources	= ARRAY_SIZE(da8xx_lcdc_resources),
 	.resource	= da8xx_lcdc_resources,
+	.dev		= {
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	}
 };
 
 int __init da8xx_register_lcdc(struct da8xx_lcdc_platform_data *pdata)
-- 
2.20.1

