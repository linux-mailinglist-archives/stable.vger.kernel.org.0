Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE22E28C84F
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 07:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732466AbgJMFkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 01:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732465AbgJMFkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 01:40:00 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1E6C0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 22:40:00 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id q202so11535544iod.9
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 22:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=lLlLxwkindstiYsgvq+V7GmdTNy38p3JDCqEl0KcOr8=;
        b=rHsvzCf5Jp5VOs+we6Z62o5+FCur52EuKR+FpHxwiLs/i3l6cF9iasGGqOsHmlW8V7
         m9+KPP/rapjvL0GxgzPyiJXTSpPIJDuNBSlcUWsgRugrTCw0z0rk0Ee5RG+2P7dup1O3
         Lrh6mh1MhFW1r2eqQtuc+CwDPi0EJgpcVmu8jannOMO+lazwmZyDymmZynILRErJlpWS
         L0XC1SHb6cEnln+ESu4PcLzxKS1JjDYbfim/ysoDL/02wbeFLJREjtOlD2UzjoDeY7Nz
         NC7sChOI1c1s70zp0eWSs32pyvGX/nOxIswba0CacCIEMANDtOFy1d3W1m9aiHN7uph1
         narw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=lLlLxwkindstiYsgvq+V7GmdTNy38p3JDCqEl0KcOr8=;
        b=eqOKAZ7ERCyODPqIlEum95dkU5RDzGM5obdOFGyNdkBH12rfvjp8c/+hIo8bI/kCat
         HGZOmsCYt8FEkhf0HMTz4iEdfmccgVb7uy38s8piIepMeBLlhVoFtc8clXe6MxO4FYzY
         QLbaKvAObWiTDuy8yzqcHxbc0srHwzWquuYfnzyrWhWQJiUrXD6XiWqbPTsTceBptrt5
         +nHv8CX2m05fgb6qS74+wmOgWY6fXoWuuKfBxwfFx2LsH211H68MaBfVKAtji/RJ+y77
         /wAAtYxjYIS1076Aaczq/CS/MCopBah8kv6moiE3w0fHT7xcU2FEybwrNTTcIijD6zlq
         4Zng==
X-Gm-Message-State: AOAM532xfi/up0bRpNmW3dVUTANDuKMrchVp686EJxEwK5ACzUHVSMSu
        LbZcziJLhXWFwBdeg0OTuBYrzOnrTZHd+k9TJ68zBhrPFTv4q4lF
X-Google-Smtp-Source: ABdhPJzOV9138OHri1Ki3sW6fp7w1zEtAJ6O/1xOx5+oJewYel3HpO+fIdFwQ8rsHEoc5+2Te3VmgCsJXd4N9wt4acE=
X-Received: by 2002:a6b:b208:: with SMTP id b8mr19303340iof.36.1602567599467;
 Mon, 12 Oct 2020 22:39:59 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Oct 2020 11:09:47 +0530
Message-ID: <CA+G9fYtwycbC+Hf9aP5Br8wq7cKWVqjhcGusn2DbJaNauGC3Og@mail.gmail.com>
Subject: WARNING: kernel/irq/chip.c:242 __irq_startup+0xa8/0xb0
To:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On stable rc  5.8.15 the following kernel warning was noticed once
while boot and this is hard to reproduce.

metadata:
  git branch: linux-5.8.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: f4ed6fb8f1680de812daf362f28342e6bf19fdcc
  git describe: v5.8.14-125-gf4ed6fb8f168
  make_kernelversion: 5.8.15-rc1
  kernel-config:
https://builds.tuxbuild.com/5nFtomB9FDlQVjafKdyR9A/kernel.config

warning log:
----------------
[   43.512935] ------------[ cut here ]------------
[   43.517563] WARNING: CPU: 0 PID: 424 at kernel/irq/chip.c:242
__irq_startup+0xa8/0xb0
[   43.517564] Modules linked in: caam error crct10dif_ce ina2xx lm90
qoriq_thermal fuse
[   43.533218] CPU: 0 PID: 424 Comm: (agetty) Not tainted 5.8.15-rc1 #1
[   43.533219] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
[   43.533223] pstate: 60000085 (nZCv daIf -PAN -UAO BTYPE=--)
[   43.533225] pc : __irq_startup+0xa8/0xb0
[   43.533229] lr : irq_startup+0x64/0x140
[   43.559218] sp : ffff800010b838c0
[   43.559219] x29: ffff800010b838c0 x28: ffff0082cd3bab00
[   43.559222] x27: ffffb8c772ed8ec0 x26: 0000000000020902
[   43.573133] x25: ffffb8c771d39e68 x24: ffffb8c771d39b08
[   43.573135] x23: 0000000000000000 x22: 0000000000000001
[   43.573138] x21: 0000000000000001 x20: ffff0082edf42c40
[   43.573140] x19: ffff0082ede29200 x18: 0000000000000001
[   43.573142] x17: 0000000000000000 x16: 0000000000000000
[   43.573145] x15: ffff0082edf430c0 x14: ffff800010bf5000
[   43.573147] x13: ffff800010bed000 x12: ffff800010be9000
[   43.573149] x11: 0000000000000040 x10: ffffb8c772cdb940
[   43.573153] x9 : ffffb8c770b7fe0c x8 : ffff0082ee000270
[   43.620866] x7 : 0000000000000000 x6 : ffffb8c772cbaa08
[   43.620869] x5 : ffffb8c772cba000 x4 : 0000000000000504
[   43.620871] x3 : ffff0082ede29200 x2 : 0000000003032004
[   43.636780] x1 : 0000000003032004 x0 : ffff0082ede29258
[   43.636783] Call trace:
[   43.636786]  __irq_startup+0xa8/0xb0
[   43.636789]  irq_startup+0x64/0x140
[   43.651569]  __enable_irq+0x78/0x88
[   43.651571]  enable_irq+0x54/0xa8
[   43.651577]  serial8250_do_startup+0x670/0x718
[   43.662791]  serial8250_startup+0x30/0x40
[   43.666793]  uart_startup.part.0+0x12c/0x2e0
[   43.671055]  uart_port_activate+0x68/0xa0
[   43.675058]  tty_port_open+0x98/0x250
[   43.678712]  uart_open+0x24/0x38
[   43.681932]  tty_open+0x100/0x480
[   43.685240]  chrdev_open+0xac/0x1a8
[   43.688721]  do_dentry_open+0x130/0x3d0
[   43.692548]  vfs_open+0x34/0x40
[   43.695681]  path_openat+0x888/0xde8
[   43.699247]  do_filp_open+0x80/0x108
[   43.702814]  do_sys_openat2+0x1ec/0x2a8
[   43.706642]  do_sys_open+0x60/0xa8
[   43.710035]  __arm64_sys_openat+0x2c/0x38
[   43.714037]  el0_svc_common.constprop.0+0x7c/0x198
[   43.718820]  do_el0_svc+0x2c/0x98
[   43.722128]  el0_sync_handler+0x9c/0x1b8
[   43.726041]  el0_sync+0x158/0x180
[   43.729347] ---[ end trace 434ed7c8787a1d1f ]---

full log,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.8.y/build/v5.8.14-125-gf4ed6fb8f168/testrun/3297947/suite/linux-log-parser/test/check-kernel-warning-93863/log


-- 
Linaro LKFT
https://lkft.linaro.org
