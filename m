Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0ED324B649
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgHTKej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:34:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731373AbgHTKTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:19:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC76220658;
        Thu, 20 Aug 2020 10:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918760;
        bh=JY4XSyu5huTAjev1Hm12MGMkSiL6EWPi6kG+wtJBmR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hpb+bXQtDcld4GwdNkSqJ1aqEtXCR4t5/ug93wCHA6piFUcfgBVVvLhqYRlnSgQKd
         oqO3ZWjxseTe1gra8P6KGjQbCwKwHG+YX0TZoLIA4zvf5Sg73RcX9rPNOpTBw2QdZ+
         sQNxXR1QysU6rM2m8zCnCPxw0Jjb2LN3m93Z5564=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 056/149] gpio: fix oops resulting from calling of_get_named_gpio(NULL, ...)
Date:   Thu, 20 Aug 2020 11:22:13 +0200
Message-Id: <20200820092128.443578217@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

This happens for the spi-imx driver when running a dt-enabled kernel on
a non-dt machine on Linux 4.0. Among the still supported stable versions
only 4.4 and 4.9 are affected. (However the spi-imx driver doesn't call
of_get_named_gpio() since v4.8-rc1 (commit b36581df7e78 ("spi: imx:
Using existing properties for chipselects")) any more, but the problem
might still affect other users of of_get_named_gpio().)

In 4.14-rc1 this problem is gone with
commit 7eb6ce2f2723 ("gpio: Convert to using %pOF instead of
full_name"). This commit however doesn't seem sensible to backport as it
depends on ce4fecf1fe15 ("vsprintf: Add %p extension "%pOF" for device
tree") which doesn't trivially apply to v4.4.

[    1.649453] Unable to handle kernel NULL pointer dereference at virtual address 0000000c
[    1.659270] pgd = c0004000
[    1.662036] [0000000c] *pgd=00000000
[    1.665919] Internal error: Oops - BUG: 5 [#1] PREEMPT ARM
[    1.671438] Modules linked in:
[    1.674552] CPU: 0 PID: 1 Comm: swapper Not tainted 4.0.0 #1
[    1.680235] Hardware name: Eckelmann ECU01
[    1.684361] task: c7840000 ti: c7842000 task.ti: c7842000
[    1.689821] PC is at of_get_named_gpiod_flags+0xac/0xe0
[    1.695104] LR is at of_find_property+0x38/0x7c
[    1.699674] pc : [<c025db2c>]    lr : [<c03c5f54>]    psr: a0000013
[    1.699674] sp : c7843cc8  ip : c7843c38  fp : c7843d3c
[    1.711183] r10: c7884dc0  r9 : c7a8de10  r8 : 00000000
[    1.716434] r7 : 00000000  r6 : 00000000  r5 : c065ef50  r4 : fffffffe
[    1.722986] r3 : 00000000  r2 : 00000000  r1 : c065ef50  r0 : fffffffe
[    1.729541] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    1.736879] Control: 0005317f  Table: 80004000  DAC: 00000017
[    1.742652] Process swapper (pid: 1, stack limit = 0xc7842190)
[    1.748510] Stack: (0xc7843cc8 to 0xc7844000)
[    1.752906] 3cc0:                   c7843cd4 c003ccec 00000000 00000000 00000000 00000000
[    1.761125] 3ce0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    1.769345] 3d00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 fffffdfb
[    1.777566] 3d20: 00000000 c78b4e10 c7a8dc00 000001ff c7843d4c c7843d40 c025db70 c025da90
[    1.785788] 3d40: c7843dcc c7843d50 c02f8938 c025db70 c7843d74 c7843d60 c79bc3c0 c79bc320
[    1.794007] 3d60: c78bb140 c065476c c7a8de10 00000000 c78b4e10 c78b4e00 00000004 00000001
[    1.802227] 3d80: c06d25d4 00000000 c7843dbc c7843d98 c0115a68 c0112538 00000001 c78b4e10
[    1.810448] 3da0: c78b4e18 ffffffed c78b4e10 fffffdfb c070bc80 00000000 c06d25d4 00000000
[    1.818669] 3dc0: c7843dec c7843dd0 c02a0670 c02f8828 c78b4e10 c073fcb0 00000000 c070bc80
[    1.826890] 3de0: c7843e14 c7843df0 c029f064 c02a0630 00000000 c78b4e10 c070bc80 c78b4e44
[    1.835110] 3e00: 00000000 c06c8cac c7843e34 c7843e18 c029f204 c029ef70 c029f170 00000000
[    1.843332] 3e20: c070bc80 c029f170 c7843e5c c7843e38 c029d6f4 c029f180 c785c1cc c7873c30
[    1.851553] 3e40: c0235728 c070bc80 c7ab9720 c0701e20 c7843e6c c7843e60 c029eb74 c029d6a4
[    1.859774] 3e60: c7843e94 c7843e70 c029e7f4 c029eb64 c065f390 c7843e80 c070bc80 c06f0718
[    1.867998] 3e80: c7ab8d60 c06b1528 c7843eac c7843e98 c029f810 c029e728 c06f0718 c06f0718
[    1.876220] 3ea0: c7843ebc c7843eb0 c02a04dc c029f7ac c7843ecc c7843ec0 c06c8cc4 c02a049c
[    1.884443] 3ec0: c7843f4c c7843ed0 c00089dc c06c8cbc c0109ec0 c0109d18 c780ac00 00000001
[    1.892665] 3ee0: c7843f00 c7843ef0 c06b1544 c0238a24 c7ffca48 c054c854 c7843f4c c7843f08
[    1.900886] 3f00: c002e7f4 c06b1538 c003d0e0 00000006 00000006 c06af1a4 00000000 c066ccb4
[    1.909107] 3f20: c7843f4c c06ea994 00000006 c071ff20 c06b1528 c06d25e0 c06d25d4 0000008f
[    1.917327] 3f40: c7843f94 c7843f50 c06b1e6c c0008964 00000006 00000006 c06b1528 dfe48a08
[    1.925547] 3f60: 33f73660 3fd760c5 0b5d4bfd 00000000 c0527ef0 00000000 00000000 00000000
[    1.933768] 3f80: 00000000 00000000 c7843fac c7843f98 c0527f00 c06b1d00 c7842000 00000000
[    1.941988] 3fa0: 00000000 c7843fb0 c0009798 c0527f00 00000000 00000000 00000000 00000000
[    1.950206] 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    1.958424] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000 b3cf731f fe6afeef
[    1.966617] Backtrace:
[    1.969150] [<c025da80>] (of_get_named_gpiod_flags) from [<c025db70>] (of_get_named_gpio_flags+0x10/0x24)
[    1.978744]  r7:000001ff r6:c7a8dc00 r5:c78b4e10 r4:00000000
[    1.984548] [<c025db60>] (of_get_named_gpio_flags) from [<c02f8938>] (spi_imx_probe+0x120/0x67c)
[    1.993390] [<c02f8818>] (spi_imx_probe) from [<c02a0670>] (platform_drv_probe+0x50/0xac)
[    2.001589]  r10:00000000 r9:c06d25d4 r8:00000000 r7:c070bc80 r6:fffffdfb r5:c78b4e10
[    2.009549]  r4:ffffffed
[    2.012144] [<c02a0620>] (platform_drv_probe) from [<c029f064>] (driver_probe_device+0x104/0x210)
[    2.021040]  r7:c070bc80 r6:00000000 r5:c073fcb0 r4:c78b4e10
[    2.026822] [<c029ef60>] (driver_probe_device) from [<c029f204>] (__driver_attach+0x94/0x98)
[    2.035282]  r8:c06c8cac r7:00000000 r6:c78b4e44 r5:c070bc80 r4:c78b4e10 r3:00000000
[    2.043191] [<c029f170>] (__driver_attach) from [<c029d6f4>] (bus_for_each_dev+0x60/0x90)
[    2.051394]  r6:c029f170 r5:c070bc80 r4:00000000 r3:c029f170
[    2.057185] [<c029d694>] (bus_for_each_dev) from [<c029eb74>] (driver_attach+0x20/0x28)
[    2.065212]  r6:c0701e20 r5:c7ab9720 r4:c070bc80
[    2.069931] [<c029eb54>] (driver_attach) from [<c029e7f4>] (bus_add_driver+0xdc/0x1dc)
[    2.077894] [<c029e718>] (bus_add_driver) from [<c029f810>] (driver_register+0x74/0xec)
[    2.085919]  r7:c06b1528 r6:c7ab8d60 r5:c06f0718 r4:c070bc80
[    2.091705] [<c029f79c>] (driver_register) from [<c02a04dc>] (__platform_driver_register+0x50/0x64)
[    2.100774]  r5:c06f0718 r4:c06f0718
[    2.104437] [<c02a048c>] (__platform_driver_register) from [<c06c8cc4>] (spi_imx_driver_init+0x18/0x20)
[    2.113884] [<c06c8cac>] (spi_imx_driver_init) from [<c00089dc>] (do_one_initcall+0x88/0x1b0)
[    2.122459] [<c0008954>] (do_one_initcall) from [<c06b1e6c>] (kernel_init_freeable+0x17c/0x248)
[    2.131182]  r10:0000008f r9:c06d25d4 r8:c06d25e0 r7:c06b1528 r6:c071ff20 r5:00000006
[    2.139141]  r4:c06ea994
[    2.141751] [<c06b1cf0>] (kernel_init_freeable) from [<c0527f00>] (kernel_init+0x10/0xec)
[    2.149955]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0527ef0
[    2.157909]  r4:00000000
[    2.160508] [<c0527ef0>] (kernel_init) from [<c0009798>] (ret_from_fork+0x14/0x3c)
[    2.168099]  r4:00000000 r3:c7842000
[    2.171755] Code: eb0b2dc2 e51b0020 e24bd01c e89da8f0 (e597300c)

Cc: stable@vger.kernel.org # v4.4.x, v4.9.x
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 5fe34a9df3e6b..179ad7c35ae33 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -91,7 +91,7 @@ struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 					 &gg_data.gpiospec);
 	if (ret) {
 		pr_debug("%s: can't parse '%s' property of node '%s[%d]'\n",
-			__func__, propname, np->full_name, index);
+			__func__, propname, np ? np->full_name : NULL, index);
 		return ERR_PTR(ret);
 	}
 
-- 
2.25.1



