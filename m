Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131992155E2
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 12:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgGFKzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 06:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgGFKy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 06:54:59 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27907C061794
        for <stable@vger.kernel.org>; Mon,  6 Jul 2020 03:54:59 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e4so44748978ljn.4
        for <stable@vger.kernel.org>; Mon, 06 Jul 2020 03:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zX6V4Sju87ElYyPYAneZhyxDZsItYI/pSUWLHM5qsf0=;
        b=LehTXMZxIobef2KvJEW6RKLlUYhqCkaJ34566TZ0a3hutg6wBe5Og6Y41N8jsFNxfq
         WRFPS0XZS4IJeFjye19fx+vDVlpTwOQE0Kv00rPO2Ne4L1ITqhRKmgzlYmpS6ZT6IO+7
         gSHg2WOxp9ZKnPUC8nm4A573QAeauhtpVzAV3T7PxDTX6pNzZG0npQF0WbREd+OXBIyl
         MxAtWwcSXHBR5/MXKsb1nCjdRjs6mZVYQYZpgL4YB51dkRDSEN5RKCbkGmy6ep1X0h7o
         6VdoG6/qtNe71FffUAohTg5KC2huSPF40nk6crtMThJZZZDBj/tzzko+JTEKK1WGh1Nd
         VQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zX6V4Sju87ElYyPYAneZhyxDZsItYI/pSUWLHM5qsf0=;
        b=LnVHt86Y23bv/G5RLne4br08QACxSZ0B7c9dqtOKD68RyiC20r+pvnlQ8dkj0vEl2I
         /pWStrl4cqlC01496l+jt0UO3JF8ndyujN2QBp8vwG1/gwvP6LXmJm6Ax6gyqlILb0gw
         24P4W4/RO8Ee9lX+cswbWStKftx5H01GnF5QazadvrDXZ8NU50UUtjH8pj91a8gmAE7j
         oTygYHOs7YP5DQSK3Gyv/KFoklsnVGXiWMPgJgerWNe4irD0/DIMR/94GDPBmMV31Qvm
         W621hNG3K53CAkc73+I8musfFAr+FTE6CuC38dDd4I2HT2Iy62wYaU94dVg1jEQU2geT
         2LGw==
X-Gm-Message-State: AOAM5312vps/+vOSgfiqEdrmrs/yPcvyOL08EEnSU8aksTiyXXrku88O
        +1fdailHANP/OnRdjw7Ihwa5k+GCkt0uesLbNQhHNA==
X-Google-Smtp-Source: ABdhPJzNkmxdAUg4NK4lEuXQ7FnCnuSXDBPQzKbUIK3agei3/h3BmRXcqxE5LBnjc40f3eOSq4dlRAMBrsq2i1BaF+A=
X-Received: by 2002:a2e:7401:: with SMTP id p1mr3536094ljc.366.1594032897325;
 Mon, 06 Jul 2020 03:54:57 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 6 Jul 2020 16:24:45 +0530
Message-ID: <CA+G9fYsrGXd5survaX27kkfam1ZcJdMnzowvGdfy1xT4bGcfcA@mail.gmail.com>
Subject: WARNING: at kernel/kthread.c:819 kthread_queue_work - spi_start_queue
To:     linux-spi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Peng Ma <peng.ma@nxp.com>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While booting arm64 device dragonboard 410c the following kernel
warning noticed on
Linux version 5.8.0-rc3-next-20200706.

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git commit: 5680d14d59bddc8bcbc5badf00dbbd4374858497
  git describe: next-20200706
  kernel-config:
https://builds.tuxbuild.com/Glr-Ql1wbp3qN3cnHogyNA/kernel.config

Crash log while booting,

[    1.203300] loop: module loaded
[    1.204599] megasas: 07.714.04.00-rc1
[    1.211124] spi_qup 78b7000.spi: IN:block:16, fifo:64, OUT:block:16, fifo:64
[    1.211509] ------------[ cut here ]------------
[    1.217238] WARNING: CPU: 0 PID: 1 at kernel/kthread.c:819
kthread_queue_work+0x90/0xa0
[    1.221832] Modules linked in:
[    1.229554] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
5.8.0-rc3-next-20200706 #1
[    1.232683] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    1.240237] pstate: 40000085 (nZcv daIf -PAN -UAO BTYPE=--)
[    1.246918] pc : kthread_queue_work+0x90/0xa0
[    1.252211] lr : kthread_queue_work+0x2c/0xa0
[    1.256722] sp : ffff80001002ba50
[    1.261061] x29: ffff80001002ba50 x28: ffff00003b868000
[    1.264363] x27: ffff00003fcf63c0 x26: ffff00003b868680
[    1.269744] x25: ffff00003b868400 x24: ffff00003d116810
[    1.275039] x23: ffff800012025304 x22: ffff00003b8683bc
[    1.280335] x21: 0000000000000000 x20: ffff00003b8683f8
[    1.285630] x19: ffff00003b8683b8 x18: 0000000000000000
[    1.290925] x17: 0000000000000000 x16: ffff800011167420
[    1.296220] x15: ffff00000eb90480 x14: 0000000000000267
[    1.301515] x13: 0000000000000004 x12: 0000000000000000
[    1.306810] x11: 0000000000000000 x10: 0000000000000003
[    1.312105] x9 : ffff00003fcbac10 x8 : ffff00003fcba240
[    1.317400] x7 : ffff00003bc3c800 x6 : 0000000000000003
[    1.322696] x5 : 0000000000000000 x4 : 0000000000000000
[    1.327991] x3 : ffff00003b8683bc x2 : 0000000000000001
[    1.333285] x1 : 0000000000000000 x0 : 0000000000000000
[    1.338583] Call trace:
[    1.343875]  kthread_queue_work+0x90/0xa0
[    1.346050]  spi_start_queue+0x50/0x78
[    1.350213]  spi_register_controller+0x458/0x820
[    1.353860]  devm_spi_register_controller+0x44/0xa0
[    1.358638]  spi_qup_probe+0x5d8/0x638
[    1.363235]  platform_drv_probe+0x54/0xa8
[    1.367053]  really_probe+0xd8/0x320
[    1.371133]  driver_probe_device+0x58/0xb8
[    1.374779]  device_driver_attach+0x74/0x80
[    1.378685]  __driver_attach+0x58/0xe0
[    1.382766]  bus_for_each_dev+0x70/0xc0
[    1.386583]  driver_attach+0x24/0x30
[    1.390317]  bus_add_driver+0x14c/0x1f0
[    1.394137]  driver_register+0x64/0x120
[    1.397696]  __platform_driver_register+0x48/0x58
[    1.401519]  spi_qup_driver_init+0x1c/0x28
[    1.406378]  do_one_initcall+0x54/0x1a0
[    1.410372]  kernel_init_freeable+0x1d4/0x254
[    1.414106]  kernel_init+0x14/0x110
[    1.418616]  ret_from_fork+0x10/0x34
[    1.421918] ---[ end trace 4b59f327623c9e10 ]---
[    1.426526] spi_qup 78b9000.spi: IN:block:16, fifo:64, OUT:block:16, fifo:64
[    1.430721] ------------[ cut here ]------------
[    1.437374] WARNING: CPU: 0 PID: 1 at kernel/kthread.c:819
kthread_queue_work+0x90/0xa0
[    1.441971] Modules linked in:
[    1.449694] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
  5.8.0-rc3-next-20200706 #1
[    1.452823] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    1.461765] pstate: 40000085 (nZcv daIf -PAN -UAO BTYPE=--)
[    1.468444] pc : kthread_queue_work+0x90/0xa0
[    1.473738] lr : kthread_queue_work+0x2c/0xa0
[    1.478250] sp : ffff80001002ba50
[    1.482588] x29: ffff80001002ba50 x28: ffff00003b868800
[    1.485889] x27: ffff00003fcf7020 x26: ffff00003b868e80
[    1.491273] x25: ffff00003b868c00 x24: ffff00003d116c10
[    1.496566] x23: ffff80001202d304 x22: ffff00003b868bbc
[    1.501862] x21: 0000000000000000 x20: ffff00003b868bf8
[    1.507157] x19: ffff00003b868bb8 x18: 0000000000000000
[    1.512452] x17: 0000000000000000 x16: ffff800011167420
[    1.517748] x15: 00000000b123f581 x14: 0000000000000287
[    1.523043] x13: 0000000000000004 x12: 0000000000000000
[    1.528337] x11: 0000000000000000 x10: 0000000000000003
[    1.533634] x9 : ffff00003fcbac10 x8 : ffff00003fcba240
[    1.538928] x7 : ffff00003bc3d640 x6 : 0000000000000003
[    1.544223] x5 : 0000000000000000 x4 : 0000000000000000
[    1.549519] x3 : ffff00003b868bbc x2 : 0000000000000001
[    1.554813] x1 : 0000000000000000 x0 : 0000000000000000
[    1.560109] Call trace:
[    1.565403]  kthread_queue_work+0x90/0xa0
[    1.567577]  spi_start_queue+0x50/0x78
[    1.571742]  spi_register_controller+0x458/0x820
[    1.575387]  devm_spi_register_controller+0x44/0xa0
[    1.580165]  spi_qup_probe+0x5d8/0x638
[    1.584762]  platform_drv_probe+0x54/0xa8
[    1.588581]  really_probe+0xd8/0x320
[    1.592660]  driver_probe_device+0x58/0xb8
[    1.596306]  device_driver_attach+0x74/0x80
[    1.600212]  __driver_attach+0x58/0xe0
[    1.604294]  bus_for_each_dev+0x70/0xc0
[    1.608112]  driver_attach+0x24/0x30
[    1.611845]  bus_add_driver+0x14c/0x1f0
[    1.615665]  driver_register+0x64/0x120
[    1.619224]  __platform_driver_register+0x48/0x58
[    1.623046]  spi_qup_driver_init+0x1c/0x28
[    1.627905]  do_one_initcall+0x54/0x1a0
[    1.631899]  kernel_init_freeable+0x1d4/0x254
[    1.635632]  kernel_init+0x14/0x110
[    1.640144]  ret_from_fork+0x10/0x34
[    1.643442] ---[ end trace 4b59f327623c9e11 ]---

https://lkft.validation.linaro.org/scheduler/job/1542222#L3733

-- 
Linaro LKFT
https://lkft.linaro.org
