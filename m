Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8303F3EF1
	for <lists+stable@lfdr.de>; Sun, 22 Aug 2021 12:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhHVKP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Aug 2021 06:15:28 -0400
Received: from ixit.cz ([94.230.151.217]:40098 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233001AbhHVKP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Aug 2021 06:15:28 -0400
Received: from [192.168.1.138] (ixit.cz [94.230.151.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 9DF0B24A25;
        Sun, 22 Aug 2021 12:14:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1629627249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vg+z9DiBby1QOFNU1ZSCB5yaqgci1DJ2rhdtSFCniPE=;
        b=FasQY6UJGLv1iJbLVKgT0K5I3pYm3hgqiOeDmhELexqr8OgzDBGybYWZTiSAfODsYIBG9o
        rmOTbXJ+z+zadtmyMRyQ83zl82xVgGiJR0qYqL1pr3cSLj147xZBihuXakurnsR52Yg/YG
        QqoRHKXegyZSRS0C708mDjcnzp9liAM=
Date:   Sun, 22 Aug 2021 12:12:57 +0200
From:   David Heidelberg <david@ixit.cz>
Subject: Re: [PATCH] mfd: qcom-pm8xxx: Switch to nested IRQ handler
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org
Message-Id: <LDK8YQ.1PNQ32NS20UG3@ixit.cz>
In-Reply-To: <20210819154400.51932-1-linus.walleij@linaro.org>
References: <20210819154400.51932-1-linus.walleij@linaro.org>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

while on APQ8060 this patch solve the issue, on APQ8064 this patch 
behaves differently.

Before the patch, both devices (asus-flo and lg-mako) boots with 
warnings, but without crash.

After the patch, both devices fails at later stage of boot, so it seems 
it'll require different approach for APQ8064 based devices (or 
additional fix in different area).

David

WARNINGS:
...
[ 1.858756] pm8xxx_probe: PMIC revision 1: F3
[ 1.862644] pm8xxx_probe: PMIC revision 2: 0B
[ 1.867253] ------------[ cut here ]------------
[ 1.871399] WARNING: CPU: 2 PID: 1 at drivers/gpio/gpiolib.c:3185 
gpiochip_enable_irq+0xa4/0xa8
[ 1.876111] Modules linked in:
[ 1.884495] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 
5.14.0-rc1-next-20210716-postmarketos-qcom-apq8064+ #1
[ 1.887663] Hardware name: Generic DT based system
[ 1.897612] Backtrace:
[ 1.902200] [<c0e0338c>] (dump_backtrace) from [<c0e03750>] 
(show_stack+0x20/0x24)
[ 1.904593] r7:00000c71 r6:c06fc64c r5:60000093 r4:c11bc7c0
[ 1.912199] [<c0e03730>] (show_stack) from [<c0e06e04>] 
(dump_stack_lvl+0x48/0x54)
[ 1.918032] [<c0e06dbc>] (dump_stack_lvl) from [<c0e06e28>] 
(dump_stack+0x18/0x1c)
[ 1.925417] r5:00000009 r4:c11e82b4
[ 1.932933] [<c0e06e10>] (dump_stack) from [<c03219b4>] 
(__warn+0xfc/0x114)
[ 1.936687] [<c03218b8>] (__warn) from [<c0e03e0c>] 
(warn_slowpath_fmt+0x74/0xd0)
[ 1.943392] r7:c06fc64c r6:00000c71 r5:c11e82b4 r4:00000000
[ 1.951000] [<c0e03d9c>] (warn_slowpath_fmt) from [<c06fc64c>] 
(gpiochip_enable_irq+0xa4/0xa8)
[ 1.956769] r8:00000000 r7:00000001 r6:c27a7b18 r5:cf775c48 r4:c021a5f0
[ 1.965156] [<c06fc5a8>] (gpiochip_enable_irq) from [<c06fc6b8>] 
(gpiochip_irq_enable+0x28/0x38)
[ 1.972038] r5:cf775c48 r4:c27a7b18
[ 1.980765] [<c06fc690>] (gpiochip_irq_enable) from [<c0389df0>] 
(irq_enable+0x48/0x78)
[ 1.984361] r5:00000000 r4:c27a7b00
[ 1.992048] [<c0389da8>] (irq_enable) from [<c0389ea0>] 
(__irq_startup+0x80/0xbc)
[ 1.995903] r5:00000000 r4:c27a7b00
[ 2.003247] [<c0389e20>] (__irq_startup) from [<c0389fa0>] 
(irq_startup+0xc4/0x158)
[ 2.006933] r7:00000001 r6:00000001 r5:00000000 r4:c27a7b00
[ 2.014283] [<c0389edc>] (irq_startup) from [<c038a070>] 
(irq_activate_and_startup+0x3c/0x74)
[ 2.020226] r9:c27a7c40 r8:c25f5000 r7:c27a7b00 r6:00000001 r5:c27a7b00 
r4:00000000
[ 2.028622] [<c038a034>] (irq_activate_and_startup) from [<c038a174>] 
(__irq_do_set_handler+0xcc/0x1c0)
[ 2.036457] r7:c27a7b00 r6:c0383dfc r5:c08871c0 r4:00000001
[ 2.045533] [<c038a0a8>] (__irq_do_set_handler) from [<c038a39c>] 
(irq_set_chained_handler_and_data+0x60/0x98)
[ 2.051478] r7:c25f4a10 r6:c27a7c40 r5:c08871c0 r4:c27a7b00
[ 2.061243] [<c038a33c>] (irq_set_chained_handler_and_data) from 
[<c0887170>] (pm8xxx_probe+0x1fc/0x24c)
[ 2.067098] r6:0000003a r5:0000003a r4:c25f4a00
[ 2.076517] [<c0886f74>] (pm8xxx_probe) from [<c0859724>] 
(platform_probe+0x6c/0xc8)
[ 2.081161] r10:e8bea154 r9:e8bea140 r8:c155b9c8 r7:c155b9c8 
r6:c14ef834 r5:c25f4a10
[ 2.088870] r4:00000000
[ 2.096557] [<c08596b8>] (platform_probe) from [<c0856538>] 
(really_probe+0xe8/0x460)
[ 2.099210] r7:c155b9c8 r6:c14ef834 r5:00000000 r4:c25f4a10
[ 2.106904] [<c0856450>] (really_probe) from [<c0856960>] 
(__driver_probe_device+0xb0/0x22c)
[ 2.112669] r7:c25f4a10 r6:cf70dba4 r5:c14ef834 r4:c25f4a10
[ 2.121054] [<c08568b0>] (__driver_probe_device) from [<c0856b20>] 
(driver_probe_device+0x44/0xe0)
[ 2.126739] r9:e8bea140 r8:00000000 r7:c25f4a10 r6:cf70dba4 r5:c15ab484 
r4:c15ab480
[ 2.135479] [<c0856adc>] (driver_probe_device) from [<c0856f90>] 
(__device_attach_driver+0xb4/0x12c)
[ 2.143409] r9:e8bea140 r8:e8bea150 r7:c25f4a10 r6:cf70dba4 r5:c14ef834 
r4:00000001
[ 2.152493] [<c0856edc>] (__device_attach_driver) from [<c0854414>] 
(bus_for_each_drv+0x94/0xe4)
[ 2.160239] r7:c14edc10 r6:c0856edc r5:cf70dba4 r4:00000000
[ 2.168969] [<c0854380>] (bus_for_each_drv) from [<c0856398>] 
(__device_attach+0x104/0x19c)
[ 2.174643] r6:00000001 r5:c25f4a54 r4:c25f4a10
[ 2.182679] [<c0856294>] (__device_attach) from [<c08571ac>] 
(device_initial_probe+0x1c/0x20)
[ 2.187579] r6:c25f4a10 r5:c14ee1b8 r4:c25f4a10
[ 2.195960] [<c0857190>] (device_initial_probe) from [<c08553b4>] 
(bus_probe_device+0x94/0x9c)
[ 2.200676] [<c0855320>] (bus_probe_device) from [<c08529a8>] 
(device_add+0x3d8/0x8d4)
[ 2.209106] r7:c14edc10 r6:c2519a10 r5:00000000 r4:c25f4a10
[ 2.216974] [<c08525d0>] (device_add) from [<c0a5a21c>] 
(of_device_add+0x44/0x4c)
[ 2.222825] r10:c134b854 r9:00000001 r8:e8bea198 r7:c2519a10 
r6:00000000 r5:00000000
[ 2.230189] r4:c25f4a00
[ 2.237962] [<c0a5a1d8>] (of_device_add) from [<c0a5a998>] 
(of_platform_device_create_pdata+0xa0/0xc8)
[ 2.240610] [<c0a5a8f8>] (of_platform_device_create_pdata) from 
[<c0a5abd4>] (of_platform_bus_create+0x1f0/0x514)
[ 2.249748] r9:00000001 r8:c2519a10 r7:00000000 r6:00000000 r5:00000000 
r4:e8bea134
[ 2.260046] [<c0a5a9e4>] (of_platform_bus_create) from [<c0a5b0d0>] 
(of_platform_populate+0x98/0x128)
[ 2.267885] r10:c134b854 r9:00000001 r8:c2519a10 r7:00000000 
r6:00000000 r5:e8be9ff4
[ 2.276978] r4:e8bea134
[ 2.284751] [<c0a5b038>] (of_platform_populate) from [<c0a5b1ec>] 
(devm_of_platform_populate+0x60/0xa8)
[ 2.287418] r9:0000011b r8:c155b9c8 r7:e8be9ff4 r6:c2c1e8c0 r5:c2c1eac0 
r4:c2519a10
[ 2.296506] [<c0a5b18c>] (devm_of_platform_populate) from [<c0887c4c>] 
(ssbi_probe+0x138/0x16c)
[ 2.304507] r6:c2c1e8c0 r5:c2519a10 r4:ff8f9434
[ 2.312888] [<c0887b14>] (ssbi_probe) from [<c0859724>] 
(platform_probe+0x6c/0xc8)
[ 2.317785] r7:c155b9c8 r6:c14ef9bc r5:c2519a10 r4:00000000
[ 2.325132] [<c08596b8>] (platform_probe) from [<c0856538>] 
(really_probe+0xe8/0x460)
[ 2.330980] r7:c155b9c8 r6:c14ef9bc r5:00000000 r4:c2519a10
[ 2.338675] [<c0856450>] (really_probe) from [<c0856960>] 
(__driver_probe_device+0xb0/0x22c)
[ 2.344439] r7:c2519a10 r6:c14ef9bc r5:c14ef9bc r4:c2519a10
[ 2.352825] [<c08568b0>] (__driver_probe_device) from [<c0856b20>] 
(driver_probe_device+0x44/0xe0)
[ 2.358511] r9:0000011b r8:00000000 r7:c2519a10 r6:c14ef9bc r5:c15ab484 
r4:c15ab480
[ 2.367251] [<c0856adc>] (driver_probe_device) from [<c08570e4>] 
(__driver_attach+0xdc/0x188)
[ 2.375173] r9:0000011b r8:c134b834 r7:00000000 r6:c14ef9bc r5:c2519a10 
r4:00000000
[ 2.383570] [<c0857008>] (__driver_attach) from [<c0854308>] 
(bus_for_each_dev+0x88/0xd4)
[ 2.391399] r7:00000000 r6:c0857008 r5:c14ef9bc r4:00000000
[ 2.399438] [<c0854280>] (bus_for_each_dev) from [<c0855db4>] 
(driver_attach+0x2c/0x30)
[ 2.405198] r6:c14ee1b8 r5:c2c1e800 r4:c14ef9bc
[ 2.412888] [<c0855d88>] (driver_attach) from [<c0855684>] 
(bus_add_driver+0x180/0x21c)
[ 2.417773] [<c0855504>] (bus_add_driver) from [<c0857d4c>] 
(driver_register+0x84/0x118)
[ 2.425513] r7:00000000 r6:ffffe000 r5:c13277d4 r4:c14ef9bc
[ 2.433813] [<c0857cc8>] (driver_register) from [<c0859474>] 
(__platform_driver_register+0x2c/0x34)
[ 2.439488] r5:c13277d4 r4:c154fec0
[ 2.448211] [<c0859448>] (__platform_driver_register) from [<c13277f8>] 
(ssbi_driver_init+0x24/0x28)
[ 2.452071] [<c13277d4>] (ssbi_driver_init) from [<c030235c>] 
(do_one_initcall+0x68/0x2e0)
[ 2.461177] [<c03022f4>] (do_one_initcall) from [<c130146c>] 
(kernel_init_freeable+0x1e4/0x244)
[ 2.469267] r7:cf7ae400 r6:c12e406c r5:00000007 r4:c137d368
[ 2.477825] [<c1301288>] (kernel_init_freeable) from [<c0e0fb2c>] 
(kernel_init+0x20/0x138)
[ 2.483765] r10:00000000 r9:00000000 r8:00000000 r7:00000000 
r6:00000000 r5:c0e0fb0c
[ 2.491821] r4:00000000
[ 2.499683] [<c0e0fb0c>] (kernel_init) from [<c0300150>] 
(ret_from_fork+0x14/0x24)
[ 2.502320] Exception stack(0xcf70dfb0 to 0xcf70dff8)
[ 2.509699] dfa0: 00000000 00000000 00000000 00000000
[ 2.514859] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 
00000000 00000000
[ 2.523011] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[ 2.531138] r5:c0e0fb0c r4:00000000
[ 2.537546] ---[ end trace 5fd599260de6c23c ]---
...

CRASH:
...
[ 34.696050] Modules linked in:
[ 34.700724] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 
5.14.0-rc6-next-20210819-postmarketos-qcom-apq8064+ #1
[ 34.703868] Hardware name: Generic DT based system
[ 34.713834] PC is at 0x0
[ 34.718426] LR is at handle_nested_irq+0xd4/0x130
[ 34.721124] pc : [<00000000>] lr : [<c0388ac0>] psr: a0000113
[ 34.725728] sp : c1401cf0 ip : c1401ce0 fp : c1401d0c
[ 34.731801] r10: 00000020 r9 : 00000001 r8 : 00000004
[ 34.737009] r7 : c2cc116c r6 : c2cc1100 r5 : 00000000 r4 : c2d25340
[ 34.742221] r3 : 00000000 r2 : 00010001 r1 : c2d242c0 r0 : 0000004c
[ 34.748821] Flags: NzCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment 
none
[ 34.755334] Control: 10c5787d Table: 83aa006a DAC: 00000051
[ 34.762533] Register r0 information: non-paged memory
[ 34.768258] Register r1 information: slab kmalloc-128 start c2d24280 
pointer offset 64 size 128
[ 34.773306] Register r2 information: non-paged memory
[ 34.781801] Register r3 information: NULL pointer
[ 34.787007] Register r4 information: slab kmalloc-64 start c2d25340 
pointer offset 0 size 64
[ 34.791710] Register r5 information: NULL pointer
[ 34.800202] Register r6 information: slab kmalloc-256 start c2cc1100 
pointer offset 0 size 256
[ 34.804817] Register r7 information: slab kmalloc-256 start c2cc1100 
pointer offset 108 size 256
[ 34.813325] Register r8 information: non-paged memory
[ 34.822252] Register r9 information: non-paged memory
[ 34.827199] Register r10 information: non-paged memory
[ 34.832235] Register r11 information: non-slab/vmalloc memory
[ 34.837272] Register r12 information: non-slab/vmalloc memory
[ 34.843088] Process swapper/0 (pid: 0, stack limit = 0x0b7cc3ea)
[ 34.848820] Stack: (0xc1401cf0 to 0xc1402000)
[ 34.854902] 1ce0: 00000004 00000000 00000007 c271ce40
[ 34.859178] 1d00: c1401d64 c1401d10 c088caac c03889f8 c121acf8 
c121ad1c c121ad4c 00000001
[ 34.867337] 1d20: 00000000 00000002 00000010 00000080 0000004c 
c1406348 c1403d00 c2cb6e00
[ 34.875496] 1d40: c2cb826c 00000000 c1401db0 c1551760 c1551740 
0000003f c1401dac c1401d68
[ 34.883655] 1d60: c03837b0 c088c93c c1401dac c0e27320 c1550f2e 
c1406390 c2cb8200 c1400000
[ 34.891816] 1d80: 60000193 c2cb8200 c2cb826c c2cb826c 0000004a 
cf776048 c1406b54 cf776040
[ 34.899975] 1da0: c1401dcc c1401db0 c03839c8 c0383734 00000000 
c1406348 c2cb8200 c2cb826c
[ 34.908135] 1dc0: c1401dec c1401dd0 c0383a68 c0383994 c2cb8200 
c2cb826c 00000000 0000004a
[ 34.916296] 1de0: c1401e04 c1401df0 c0388bf8 c0383a2c cf77623c 
00000034 c1401e14 c1401e08
[ 34.924455] 1e00: c0382bd0 c0388b28 c1401e4c c1401e18 c06f82b4 
c0382ba0 c24a8c00 c24a8c18
[ 34.932614] 1e20: c1401e4c c1385388 00000000 c0219000 00000000 
00000030 c1401ea0 00000000
[ 34.940774] 1e40: c1401e74 c1401e50 c0382f84 c06f81dc c1406b54 
c14c194c ea002000 c1385394
[ 34.948934] 1e60: ea00200c c1401ea0 c1401e9c c1401e78 c03013f8 
c0382f04 c0309ab0 60000013
[ 34.957093] 1e80: ffffffff c1401ed4 c13858c0 c1400000 c1401efc 
c1401ea0 c0300b4c c030137c
[ 34.965253] 1ea0: 00011492 c11c12c0 00000000 c031af20 c1552480 
00000000 ffffe000 c14063d4
[ 34.973413] 1ec0: c13858c0 00000000 00000000 c1401efc c1401f00 
c1401ef0 c0309aac c0309ab0
[ 34.981573] 1ee0: 60000013 ffffffff 00000051 00000000 c1401f1c 
c1401f00 c0e271d8 c0309a74
[ 34.989733] 1f00: c1400000 00000000 c1406390 c14063d4 c1401f64 
c1401f20 c035d534 c0e27190
[ 34.997892] 1f20: 000000e2 e8bdc00b c1401f44 c1401f20 c0e1f098 
c1406348 c1401f64 000000e2
[ 35.006051] 1f40: c1417138 e8bdc00b 0000004c 00000000 c140d680 
c126d85c c1401f74 c1401f68
[ 35.014211] 1f60: c035d938 c035d310 c1401f8c c1401f78 c0e1f198 
c035d91c c1575068 00000001
[ 35.022373] 1f80: c1401f9c c1401f90 c1300ac8 c0e1f0c8 c1401ff4 
c1401fa0 c13011ec c1300abc
[ 35.030531] 1fa0: ffffffff ffffffff 00000000 c1300654 00000000 
c1406340 00000000 c134ba60
[ 35.038690] 1fc0: b30b0f2a c1406348 00000000 c1300330 00000051 
10c0387d 00001e7a 81d043d0
[ 35.046849] 1fe0: 511f06f0 10c5387d 00000000 c1401ff8 00000000 
c1300b68 00000000 00000000
[ 35.054990] Backtrace:
[ 35.063132] [<c03889ec>] (handle_nested_irq) from [<c088caac>] 
(pm8xxx_irq_handler+0x17c/0x284)
[ 35.065416] r7:c271ce40 r6:00000007 r5:00000000 r4:00000004
[ 35.074078] [<c088c930>] (pm8xxx_irq_handler) from [<c03837b0>] 
(__handle_irq_event_percpu+0x88/0x260)
[ 35.080000] r10:0000003f r9:c1551740 r8:c1551760 r7:c1401db0 
r6:00000000 r5:c2cb826c
[ 35.089105] r4:c2cb6e00
[ 35.096985] [<c0383728>] (__handle_irq_event_percpu) from [<c03839c8>] 
(handle_irq_event_percpu+0x40/0x98)
[ 35.099619] r10:cf776040 r9:c1406b54 r8:cf776048 r7:0000004a 
r6:c2cb826c r5:c2cb826c
[ 35.109070] r4:c2cb8200
[ 35.116949] [<c0383988>] (handle_irq_event_percpu) from [<c0383a68>] 
(handle_irq_event+0x48/0x6c)
[ 35.119577] r5:c2cb826c r4:c2cb8200
[ 35.128324] [<c0383a20>] (handle_irq_event) from [<c0388bf8>] 
(handle_level_irq+0xdc/0x158)
[ 35.131991] r7:0000004a r6:00000000 r5:c2cb826c r4:c2cb8200
[ 35.140049] [<c0388b1c>] (handle_level_irq) from [<c0382bd0>] 
(generic_handle_domain_irq+0x3c/0x4c)
[ 35.145968] r5:00000034 r4:cf77623c
[ 35.154714] [<c0382b94>] (generic_handle_domain_irq) from [<c06f82b4>] 
(msm_gpio_irq_handler+0xe4/0x15c)
[ 35.158554] [<c06f81d0>] (msm_gpio_irq_handler) from [<c0382f84>] 
(handle_domain_irq+0x8c/0xc0)
[ 35.168018] r10:00000000 r9:c1401ea0 r8:00000030 r7:00000000 
r6:c0219000 r5:00000000
[ 35.176431] r4:c1385388
[ 35.184397] [<c0382ef8>] (handle_domain_irq) from [<c03013f8>] 
(gic_handle_irq+0x88/0x9c)
[ 35.187028] r9:c1401ea0 r8:ea00200c r7:c1385394 r6:ea002000 
r5:c14c194c r4:c1406b54
[ 35.195093] [<c0301370>] (gic_handle_irq) from [<c0300b4c>] 
(__irq_svc+0x6c/0xa8)
[ 35.202905] Exception stack(0xc1401ea0 to 0xc1401ee8)
[ 35.210293] 1ea0: 00011492 c11c12c0 00000000 c031af20 c1552480 
00000000 ffffe000 c14063d4
[ 35.215339] 1ec0: c13858c0 00000000 00000000 c1401efc c1401f00 
c1401ef0 c0309aac c0309ab0
[ 35.223486] 1ee0: 60000013 ffffffff
[ 35.231630] r9:c1400000 r8:c13858c0 r7:c1401ed4 r6:ffffffff 
r5:60000013 r4:c0309ab0
[ 35.234936] [<c0309a68>] (arch_cpu_idle) from [<c0e271d8>] 
(default_idle_call+0x54/0x170)
[ 35.242925] [<c0e27184>] (default_idle_call) from [<c035d534>] 
(do_idle+0x230/0x2a4)
[ 35.251000] r7:c14063d4 r6:c1406390 r5:00000000 r4:c1400000
[ 35.258799] [<c035d304>] (do_idle) from [<c035d938>] 
(cpu_startup_entry+0x28/0x2c)
[ 35.264456] r10:c126d85c r9:c140d680 r8:00000000 r7:0000004c 
r6:e8bdc00b r5:c1417138
[ 35.271830] r4:000000e2
[ 35.279710] [<c035d910>] (cpu_startup_entry) from [<c0e1f198>] 
(rest_init+0xdc/0xe4)
[ 35.282333] [<c0e1f0bc>] (rest_init) from [<c1300ac8>] 
(arch_call_rest_init+0x18/0x1c)
[ 35.290063] r5:00000001 r4:c1575068
[ 35.297771] [<c1300ab0>] (arch_call_rest_init) from [<c13011ec>] 
(start_kernel+0x690/0x6e0)
[ 35.301519] [<c1300b5c>] (start_kernel) from [<00000000>] (0x0)
[ 35.309588] Code: bad PC value
[ 35.315485] ---[ end trace f4ac1999bcdb66d5 ]---
[ 35.328873] Kernel panic - not syncing: Fatal exception in interrupt
...
Best regards
David Heidelberg

On Thu, Aug 19 2021 at 17:44:00 +0200, Linus Walleij 
<linus.walleij@linaro.org> wrote:
> After facing problems when using the chained interrupt for handling
> the PM8xxx IRQs we solve the issue by simply requesting the IRQ
> from the producer (in this case the TLMM) as any other IRQ, and
> nesting any consumer IRQs.
> 
> Recently the driver is hanging during probe:
> [    1.646990] ssbi 500000.qcom,ssbi: SSBI controller type: 
> 'pmic-arbiter'
> [    1.650901] pm8xxx_probe: PMIC revision 1: E3
> [    1.655078] pm8xxx_probe: PMIC revision 2: 00
> (...)
> it just hangs after this.
> 
> I am unable to bisect down to what is causing this hang, but the
> patch fixes the problem.
> 
> After this patch the DragonBoard APQ8060 boots to prompt without
> problems.
> 
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: David Heidelberg <david@ixit.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/qcom-pm8xxx.c | 60 
> ++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/mfd/qcom-pm8xxx.c b/drivers/mfd/qcom-pm8xxx.c
> index acd172ddcbd6..223aed53aad8 100644
> --- a/drivers/mfd/qcom-pm8xxx.c
> +++ b/drivers/mfd/qcom-pm8xxx.c
> @@ -65,7 +65,7 @@
>  struct pm_irq_data {
>  	int num_irqs;
>  	struct irq_chip *irq_chip;
> -	void (*irq_handler)(struct irq_desc *desc);
> +	irqreturn_t (*irq_handler)(int irq, void *data);
>  };
> 
>  struct pm_irq_chip {
> @@ -140,7 +140,7 @@ static int pm8xxx_irq_block_handler(struct 
> pm_irq_chip *chip, int block)
>  		if (bits & (1 << i)) {
>  			pmirq = block * 8 + i;
>  			irq = irq_find_mapping(chip->irqdomain, pmirq);
> -			generic_handle_irq(irq);
> +			handle_nested_irq(irq);
>  		}
>  	}
>  	return 0;
> @@ -170,19 +170,16 @@ static int pm8xxx_irq_master_handler(struct 
> pm_irq_chip *chip, int master)
>  	return ret;
>  }
> 
> -static void pm8xxx_irq_handler(struct irq_desc *desc)
> +static irqreturn_t pm8xxx_irq_handler(int irq, void *data)
>  {
> -	struct pm_irq_chip *chip = irq_desc_get_handler_data(desc);
> -	struct irq_chip *irq_chip = irq_desc_get_chip(desc);
> +	struct pm_irq_chip *chip = data;
>  	unsigned int root;
>  	int	i, ret, masters = 0;
> 
> -	chained_irq_enter(irq_chip, desc);
> -
>  	ret = regmap_read(chip->regmap, SSBI_REG_ADDR_IRQ_ROOT, &root);
>  	if (ret) {
>  		pr_err("Can't read root status ret=%d\n", ret);
> -		return;
> +		return IRQ_NONE;
>  	}
> 
>  	/* on pm8xxx series masters start from bit 1 of the root */
> @@ -193,7 +190,7 @@ static void pm8xxx_irq_handler(struct irq_desc 
> *desc)
>  		if (masters & (1 << i))
>  			pm8xxx_irq_master_handler(chip, i);
> 
> -	chained_irq_exit(irq_chip, desc);
> +	return IRQ_HANDLED;
>  }
> 
>  static void pm8821_irq_block_handler(struct pm_irq_chip *chip,
> @@ -217,7 +214,7 @@ static void pm8821_irq_block_handler(struct 
> pm_irq_chip *chip,
>  		if (bits & BIT(i)) {
>  			pmirq = block * 8 + i;
>  			irq = irq_find_mapping(chip->irqdomain, pmirq);
> -			generic_handle_irq(irq);
> +			handle_nested_irq(irq);
>  		}
>  	}
>  }
> @@ -232,19 +229,17 @@ static inline void 
> pm8821_irq_master_handler(struct pm_irq_chip *chip,
>  			pm8821_irq_block_handler(chip, master, block);
>  }
> 
> -static void pm8821_irq_handler(struct irq_desc *desc)
> +static irqreturn_t pm8821_irq_handler(int irq, void *data)
>  {
> -	struct pm_irq_chip *chip = irq_desc_get_handler_data(desc);
> -	struct irq_chip *irq_chip = irq_desc_get_chip(desc);
> +	struct pm_irq_chip *chip = data;
>  	unsigned int master;
>  	int ret;
> 
> -	chained_irq_enter(irq_chip, desc);
>  	ret = regmap_read(chip->regmap,
>  			  PM8821_SSBI_REG_ADDR_IRQ_MASTER0, &master);
>  	if (ret) {
>  		pr_err("Failed to read master 0 ret=%d\n", ret);
> -		goto done;
> +		return IRQ_NONE;
>  	}
> 
>  	/* bits 1 through 7 marks the first 7 blocks in master 0 */
> @@ -253,19 +248,18 @@ static void pm8821_irq_handler(struct irq_desc 
> *desc)
> 
>  	/* bit 0 marks if master 1 contains any bits */
>  	if (!(master & BIT(0)))
> -		goto done;
> +		return IRQ_HANDLED;
> 
>  	ret = regmap_read(chip->regmap,
>  			  PM8821_SSBI_REG_ADDR_IRQ_MASTER1, &master);
>  	if (ret) {
>  		pr_err("Failed to read master 1 ret=%d\n", ret);
> -		goto done;
> +		return IRQ_NONE;
>  	}
> 
>  	pm8821_irq_master_handler(chip, 1, master);
> 
> -done:
> -	chained_irq_exit(irq_chip, desc);
> +	return IRQ_HANDLED;
>  }
> 
>  static void pm8xxx_irq_mask_ack(struct irq_data *d)
> @@ -516,15 +510,16 @@ MODULE_DEVICE_TABLE(of, pm8xxx_id_table);
>  static int pm8xxx_probe(struct platform_device *pdev)
>  {
>  	const struct pm_irq_data *data;
> +	struct device *dev = &pdev->dev;
>  	struct regmap *regmap;
>  	int irq, rc;
>  	unsigned int val;
>  	u32 rev;
>  	struct pm_irq_chip *chip;
> 
> -	data = of_device_get_match_data(&pdev->dev);
> +	data = of_device_get_match_data(dev);
>  	if (!data) {
> -		dev_err(&pdev->dev, "No matching driver data found\n");
> +		dev_err(dev, "No matching driver data found\n");
>  		return -EINVAL;
>  	}
> 
> @@ -532,7 +527,7 @@ static int pm8xxx_probe(struct platform_device 
> *pdev)
>  	if (irq < 0)
>  		return irq;
> 
> -	regmap = devm_regmap_init(&pdev->dev, NULL, pdev->dev.parent,
> +	regmap = devm_regmap_init(dev, NULL, pdev->dev.parent,
>  				  &ssbi_regmap_config);
>  	if (IS_ERR(regmap))
>  		return PTR_ERR(regmap);
> @@ -556,8 +551,7 @@ static int pm8xxx_probe(struct platform_device 
> *pdev)
>  	pr_info("PMIC revision 2: %02X\n", val);
>  	rev |= val << BITS_PER_BYTE;
> 
> -	chip = devm_kzalloc(&pdev->dev,
> -			    struct_size(chip, config, data->num_irqs),
> +	chip = devm_kzalloc(dev, struct_size(chip, config, data->num_irqs),
>  			    GFP_KERNEL);
>  	if (!chip)
>  		return -ENOMEM;
> @@ -569,21 +563,25 @@ static int pm8xxx_probe(struct platform_device 
> *pdev)
>  	chip->pm_irq_data = data;
>  	spin_lock_init(&chip->pm_irq_lock);
> 
> -	chip->irqdomain = irq_domain_add_linear(pdev->dev.of_node,
> +	chip->irqdomain = irq_domain_add_linear(dev->of_node,
>  						data->num_irqs,
>  						&pm8xxx_irq_domain_ops,
>  						chip);
>  	if (!chip->irqdomain)
>  		return -ENODEV;
> 
> -	irq_set_chained_handler_and_data(irq, data->irq_handler, chip);
> +	rc = devm_request_irq(dev, irq, data->irq_handler,
> +			      IRQF_SHARED, KBUILD_MODNAME, chip);
> +	if (rc) {
> +		dev_err(dev, "failed to request IRQ\n");
> +		return rc;
> +	}
> +
>  	irq_set_irq_wake(irq, 1);
> 
> -	rc = of_platform_populate(pdev->dev.of_node, NULL, NULL, 
> &pdev->dev);
> -	if (rc) {
> -		irq_set_chained_handler_and_data(irq, NULL, NULL);
> +	rc = of_platform_populate(pdev->dev.of_node, NULL, NULL, dev);
> +	if (rc)
>  		irq_domain_remove(chip->irqdomain);
> -	}
> 
>  	return rc;
>  }
> @@ -596,11 +594,9 @@ static int pm8xxx_remove_child(struct device 
> *dev, void *unused)
> 
>  static int pm8xxx_remove(struct platform_device *pdev)
>  {
> -	int irq = platform_get_irq(pdev, 0);
>  	struct pm_irq_chip *chip = platform_get_drvdata(pdev);
> 
>  	device_for_each_child(&pdev->dev, NULL, pm8xxx_remove_child);
> -	irq_set_chained_handler_and_data(irq, NULL, NULL);
>  	irq_domain_remove(chip->irqdomain);
> 
>  	return 0;
> --
> 2.31.1
> 


