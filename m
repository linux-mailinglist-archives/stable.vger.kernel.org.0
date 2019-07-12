Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40BB166E81
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfGLM10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfGLM10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:27:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E8C521670;
        Fri, 12 Jul 2019 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934444;
        bh=kS6jlmcfOV62aSYlSuRPkwC/U2Uh1K3KCN3XX9LHkoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TV4RC2AorHVPYJVltdPFcQkZ8uwe1+o7tGzUkbIvzzmGUHODhZsale56Wf3Y6YIHb
         pZ6NFCQ4u8rCjioZklsyG9KI0XNbnh8iCJ6Nf3CMJ4RqraSld+VEs6K+RBjT5JXOAA
         0ae+YL9HJlmiAzLKhPpVpMWRtkb5T94os7PJ2dBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sekhar Nori <nsekhar@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 056/138] ARM: davinci: da8xx: specify dma_coherent_mask for lcdc
Date:   Fri, 12 Jul 2019 14:18:40 +0200
Message-Id: <20190712121630.821511892@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



