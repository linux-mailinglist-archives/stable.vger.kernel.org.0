Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FC378FF6
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 16:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241881AbhEJN5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242960AbhEJNxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 09:53:49 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1336BC06137E;
        Mon, 10 May 2021 06:33:27 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 10so13751250pfl.1;
        Mon, 10 May 2021 06:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KXKAAx7CLKZeMl7TpKKmKCAcmvO/BVIrKGp8RbmnYl4=;
        b=CNSZK/Cinvl8bScaoPMZT4drw0OIphHipTKR4GsQk9OwP5Boy0WFaPP2no815SiFav
         ZJD85u8udlrqYDxEVvJf4p6R9koLDGkQswNrQFoTnDf6G3hJWPpMJuTZclp7HGfpqmbf
         UzrUpFCOqxNAU8zb2qD45tjBue+d+UheMCNdjRVnGthrb9YCSz1IVBU879DUdpDW/QvJ
         1w+noTjxr/L7Hsoau9oqGBSbP58w0wbgYhhEFEtFRZseC2L0DegCczSGGoVIA6uxvlUL
         EhJFZVilpUZS8DZNT4aCnbvW94+7qjuyT70hy/yKnWlxzjKqduphmelVl89l7m/ckltq
         pSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KXKAAx7CLKZeMl7TpKKmKCAcmvO/BVIrKGp8RbmnYl4=;
        b=dwSesHdUjHKupMhAljuVGarSwgDtRsMmGm4tcAvvF2pYM/yzKo27OSrLkrMf1ej/7m
         VH2yyTfCyIt2/7zqMethaulvIuf4RDPoMAB9eEdWqNWXDFcS1FjB9IRBvl8eEPYbYOL7
         /z+kJ4TEyIKTw/yyP/psFdZgr991OJWSu0NxhCu5aY0GiiBptzCywH9bZumpqfEvQBO6
         8kztVyno9wyim+I+X6JxKvW6JJr8FkdIXz/jT8PLfPlgDlDDMWRHJ/0R7s66MFlaPnjU
         nXeRpGwf8m/tRhdBxgW4ik5jIUu6PtWejpRR1oArspGJ7Ls0XardlGskvUYFuMN9fIhq
         XgNg==
X-Gm-Message-State: AOAM530VUNttRxL6GJvV5Xv0psSUpTmxdDPus1FYlhvWVMCj72G2upuy
        KnIkLIeQj3ddEXif1hLCHqYp62kNcS4=
X-Google-Smtp-Source: ABdhPJzc2Zel/3nvTwKMN44cVHNoEyqNpKn793SdY/mTZkl8/DFrtvzmEKYdGeMflsrOwdO6pypBCA==
X-Received: by 2002:a62:e704:0:b029:2c4:b81e:d1a7 with SMTP id s4-20020a62e7040000b02902c4b81ed1a7mr2414098pfh.31.1620653606116;
        Mon, 10 May 2021 06:33:26 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w127sm7906564pfw.4.2021.05.10.06.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:33:25 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH stable 5.4 v2 0/4] ARM FDT relocation backports
Date:   Mon, 10 May 2021 06:33:17 -0700
Message-Id: <20210510133321.1790243-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

These patches were not marked with a Fixes: tag but they do fix booting
ARM 32-bit platforms that have specific FDT placement and would cause
boot failures like these:

[    0.000000] 8<--- cut here ---
[    0.000000] Unable to handle kernel paging request at virtual address
ffa14000
[    0.000000] pgd = (ptrval)
[    0.000000] [ffa14000] *pgd=80000040007003, *pmd=00000000
[    0.000000] Internal error: Oops: 206 [#1] SMP ARM
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.4.85-1.0 #1
[    0.000000] Hardware name: Broadcom STB (Flattened Device Tree)
[    0.000000] PC is at fdt_check_header+0xc/0x21c
[    0.000000] LR is at __unflatten_device_tree+0x7c/0x2f8
[    0.000000] pc : [<c0d30e44>]    lr : [<c0a6c0fc>]    psr: 600000d3
[    0.000000] sp : c1401eac  ip : c1401ec8  fp : c1401ec4
[    0.000000] r10: 00000000  r9 : c150523c  r8 : 00000000
[    0.000000] r7 : c124eab4  r6 : ffa14000  r5 : 00000000  r4 :
c14ba920
[    0.000000] r3 : 00000000  r2 : c150523c  r1 : 00000000  r0 :
ffa14000
[    0.000000] Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM
Segment user
[    0.000000] Control: 30c5383d  Table: 40003000  DAC: fffffffd
[    0.000000] Process swapper (pid: 0, stack limit = 0x(ptrval))
[    0.000000] Stack: (0xc1401eac to 0xc1402000)
[    0.000000] 1ea0:                            c14ba920 00000000
ffa14000 c1401ef4 c1401ec8
[    0.000000] 1ec0: c0a6c0fc c0d30e44 c124eab4 c124eab4 00000000
c14ebfc0 c140e5b8 00000000
[    0.000000] 1ee0: 00000001 c126f5a0 c1401f14 c1401ef8 c1250064
c0a6c08c 00000000 c1401f08
[    0.000000] 1f00: c022ddac c140ce80 c1401f9c c1401f18 c120506c
c125002c 00000000 00000000
[    0.000000] 1f20: 00000000 00000000 ffffffff c1401f94 c1401f6c
c1406308 3fffffff 00000001
[    0.000000] 1f40: 00000000 00000001 c1432b58 c14ca180 c1213ca4
c1406308 c1406300 30c0387d
[    0.000000] 1f60: c1401f8c c1401f70 c028e0ec 00000000 c1401f94
c1406308 c1406300 30c0387d
[    0.000000] 1f80: 00000000 7fa14000 420f1000 30c5387d c1401ff4
c1401fa0 c1200c98 c120467c
[    0.000000] 1fa0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 c127fa44
[    0.000000] 1fc0: 00000000 00000000 00000000 c1200330 00000000
30c0387d ffffffff 7fa14000
[    0.000000] 1fe0: 420f1000 30c5387d 00000000 c1401ff8 00000000
c1200c28 00000000 00000000
[    0.000000] Backtrace:
[    0.000000] [<c0d30e38>] (fdt_check_header) from [<c0a6c0fc>]
(__unflatten_device_tree+0x7c/0x2f8)
[    0.000000]  r6:ffa14000 r5:00000000 r4:c14ba920
[    0.000000] [<c0a6c080>] (__unflatten_device_tree) from [<c1250064>]
(unflatten_device_tree+0x44/0x54)
[    0.000000]  r10:c126f5a0 r9:00000001 r8:00000000 r7:c140e5b8
r6:c14ebfc0 r5:00000000
[    0.000000]  r4:c124eab4 r3:c124eab4
[    0.000000] [<c1250020>] (unflatten_device_tree) from [<c120506c>]
(setup_arch+0x9fc/0xc84)
[    0.000000]  r4:c140ce80
[    0.000000] [<c1204670>] (setup_arch) from [<c1200c98>]
(start_kernel+0x7c/0x540)
[    0.000000]  r10:30c5387d r9:420f1000 r8:7fa14000 r7:00000000
r6:30c0387d r5:c1406300
[    0.000000]  r4:c1406308
[    0.000000] [<c1200c1c>] (start_kernel) from [<00000000>] (0x0)
[    0.000000]  r10:30c5387d r9:420f1000 r8:7fa14000 r7:ffffffff
r6:30c0387d r5:00000000
[    0.000000]  r4:c1200330
[    0.000000] Code: e89da800 e1a0c00d e92dd870 e24cb004 (e5d03000)
[    0.000000] random: get_random_bytes called from
print_oops_end_marker+0x50/0x58 with crng_init=0
[    0.000000] ---[ end trace f34b4929828506c1 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle
task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill
the idle task! ]---

Changes in v2:

- include "ARM: 9027/1: head.S: explicitly map DT even if it lives in
  the first physical section" as suggested by Ard.

Ard Biesheuvel (4):
  ARM: 9011/1: centralize phys-to-virt conversion of DT/ATAGS address
  ARM: 9012/1: move device tree mapping out of linear region
  ARM: 9020/1: mm: use correct section size macro to describe the FDT
    virtual address
  ARM: 9027/1: head.S: explicitly map DT even if it lives in the first
    physical section

 Documentation/arm/memory.rst  |  7 ++++++-
 arch/arm/include/asm/fixmap.h |  2 +-
 arch/arm/include/asm/memory.h |  5 +++++
 arch/arm/include/asm/prom.h   |  4 ++--
 arch/arm/kernel/atags.h       |  4 ++--
 arch/arm/kernel/atags_parse.c |  6 +++---
 arch/arm/kernel/devtree.c     |  6 +++---
 arch/arm/kernel/head.S        |  9 ++++-----
 arch/arm/kernel/setup.c       | 19 ++++++++++++++-----
 arch/arm/mm/init.c            |  1 -
 arch/arm/mm/mmu.c             | 20 ++++++++++++++------
 arch/arm/mm/pv-fixup-asm.S    |  4 ++--
 12 files changed, 56 insertions(+), 31 deletions(-)

-- 
2.25.1

