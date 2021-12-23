Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD44F47E1E6
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 12:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347820AbhLWLB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 06:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239611AbhLWLB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 06:01:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ABAC061401;
        Thu, 23 Dec 2021 03:01:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B197C61E25;
        Thu, 23 Dec 2021 11:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C84FC36AEA;
        Thu, 23 Dec 2021 11:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640257315;
        bh=NGVyI3dy77I78cr4z1j7vHEywOFocutRkeehzswXWLk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lthZXy50TuX9+j+hzMJo73bUnVklQD7rAf3FYFYOqhCZxW5l1xYJkds7C1EyIjLhJ
         8qWnI4zNIY4APZaELj8DJDFPWPKLVnqqkk49bMTz2VZhXOTScr3Xb+JL6co+ZgqFik
         b7K2QXkM0rYOmAfDyuPvpcGglNq5HUaVaNdsFi1RRblJskDCPj9QUUL2CVCuPDgeYy
         fOXwsUK+w9CaHOnsjlhD8omkoUD/oBVVaYQ7G6l2CJwJJWnCRDHbBv1GlJ/6+b4Nyx
         p1NOSkE0r37vLviaoI2DnvZB93SGzC/AvJjr2OEHlBXfdOQai4qV4tP04Yki+fs2Xv
         uIPrzQQMMct7g==
Received: by mail-wm1-f46.google.com with SMTP id f134-20020a1c1f8c000000b00345c05bc12dso3026446wmf.3;
        Thu, 23 Dec 2021 03:01:55 -0800 (PST)
X-Gm-Message-State: AOAM531EZH+spfxGiNQEiI9VrjOHae+bw3FXlPzp0SjbSBJk4SUreh9Q
        xXPDBuW6qemuBVu1R0olHtE4Bo4R/oyP5xEbE0E=
X-Google-Smtp-Source: ABdhPJwhmS7JMAKuJSRnPUT24qtFJoAEThMpHyhZkHfc01perLw2BVfzcCphvDUlO1AokBXUTnO1NKy0tpTuyhwzpFQ=
X-Received: by 2002:a1c:1f93:: with SMTP id f141mr1304483wmf.56.1640257313324;
 Thu, 23 Dec 2021 03:01:53 -0800 (PST)
MIME-Version: 1.0
References: <20211223101551.19991-1-lecopzer.chen@mediatek.com>
In-Reply-To: <20211223101551.19991-1-lecopzer.chen@mediatek.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 23 Dec 2021 12:01:41 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGL++stjcuryn8zVwMgH4F05mONoU3Kca9Ch8N2dW-_bg@mail.gmail.com>
Message-ID: <CAMj1kXGL++stjcuryn8zVwMgH4F05mONoU3Kca9Ch8N2dW-_bg@mail.gmail.com>
Subject: Re: [PATCH] ARM: module: fix MODULE_PLTS not work for KASAN
To:     Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Abbott Liu <liuwenliang@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>, yj.chiang@mediatek.com,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Dec 2021 at 11:16, Lecopzer Chen <lecopzer.chen@mediatek.com> wrote:
>
> When we run out of module space address with ko insertion,
> and with MODULE_PLTS, module would turn to try to find memory
> from VMALLOC address space.
>
> Unfortunately, with KASAN enabled, VMALLOC doesn't work without
> VMALLOC_KASAN which is unimplemented in ARM.
>
> hello: loading out-of-tree module taints kernel.
> 8<--- cut here ---
>  Unable to handle kernel paging request at virtual address bd300860
>  [bd300860] *pgd=41cf1811, *pte=41cf26df, *ppte=41cf265f
>  Internal error: Oops: 80f [#1] PREEMPT SMP ARM
>  Modules linked in: hello(O+)
>  CPU: 0 PID: 89 Comm: insmod Tainted: G           O      5.16.0-rc6+ #19
>  Hardware name: Generic DT based system
>  PC is at mmioset+0x30/0xa8
>  LR is at 0x0
>  pc : [<c077ed30>]    lr : [<00000000>]    psr: 20000013
>  sp : c451fc18  ip : bd300860  fp : c451fc2c
>  r10: f18042cc  r9 : f18042d0  r8 : 00000000
>  r7 : 00000001  r6 : 00000003  r5 : 01312d00  r4 : f1804300
>  r3 : 00000000  r2 : 00262560  r1 : 00000000  r0 : bd300860
>  Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>  Control: 10c5387d  Table: 43e9406a  DAC: 00000051
>  Register r0 information: non-paged memory
>  Register r1 information: NULL pointer
>  Register r2 information: non-paged memory
>  Register r3 information: NULL pointer
>  Register r4 information: 4887-page vmalloc region starting at 0xf1802000 allocated at load_module+0x14f4/0x32a8
>  Register r5 information: non-paged memory
>  Register r6 information: non-paged memory
>  Register r7 information: non-paged memory
>  Register r8 information: NULL pointer
>  Register r9 information: 4887-page vmalloc region starting at 0xf1802000 allocated at load_module+0x14f4/0x32a8
>  Register r10 information: 4887-page vmalloc region starting at 0xf1802000 allocated at load_module+0x14f4/0x32a8
>  Register r11 information: non-slab/vmalloc memory
>  Register r12 information: non-paged memory
>  Process insmod (pid: 89, stack limit = 0xc451c000)
>  Stack: (0xc451fc18 to 0xc4520000)
>  fc00:                                                       f18041f0 c04803a4
>  fc20: c451fc44 c451fc30 c048053c c0480358 f1804030 01312cff c451fc64 c451fc48
>  fc40: c047f330 c0480500 f18040c0 c1b52ccc 00000001 c5be7700 c451fc74 c451fc68
>  fc60: f1802098 c047f300 c451fcb4 c451fc78 c026106c f180208c c4880004 00000000
>  fc80: c451fcb4 bf001000 c044ff48 c451fec0 f18040c0 00000000 c1b54cc4 00000000
>  fca0: c451fdf0 f1804268 c451fe64 c451fcb8 c0264e88 c0260d48 ffff8000 00007fff
>  fcc0: f18040c0 c025cd00 c451fd14 00000003 0157f008 f1804258 f180425c f1804174
>  fce0: f1804154 f180424c f18041f0 f180414c f1804178 f18041c0 bf0025d4 188a3fa8
>  fd00: 0000009e f1804170 f2b18000 c451ff10 c0d92e40 f180416c c451feec 00000001
>  fd20: 00000000 c451fec8 c451fe20 c451fed0 f18040cc 00000000 f17ea000 c451fdc0
>  fd40: 41b58ab3 c1387729 c0261c28 c047fb5c c451fe2c c451fd60 c0525308 c048033c
>  fd60: 188a3fb4 c3ccb090 c451fe00 c3ccb080 00000000 00000000 00016920 00000000
>  fd80: c02d0388 c047f55c c02d0388 00000000 c451fddc c451fda0 c02d0388 00000000
>  fda0: 41b58ab3 c13a72d0 c0524ff0 c1705f48 c451fdfc c451fdc0 c02d0388 c047f55c
>  fdc0: 00016920 00000000 00000003 c1bb2384 c451fdfc c3ccb080 c1bb2384 00000000
>  fde0: 00000000 00000000 00000000 00000000 c451fe1c c451fe00 c04e9d70 c1705f48
>  fe00: c1b54cc4 c1bbc71c c3ccb080 00000000 c3ccb080 00000000 00000003 c451fec0
>  fe20: c451fe64 c451fe30 c0525918 c0524ffc c451feb0 c1705f48 00000000 c1b54cc4
>  fe40: b78a3fd0 c451ff60 00000000 0157f008 00000003 c451fec0 c451ffa4 c451fe68
>  fe60: c0265480 c0261c34 c451feb0 7fffffff 00000000 00000002 00000000 c4880000
>  fe80: 41b58ab3 c138777b c02652cc c04803ec 000a0000 c451ff00 ffffff9c b6ac9f60
>  fea0: c451fed4 c1705f48 c04a4a90 b78a3fdc f17ea000 ffffff9c b6ac9f60 c0100244
>  fec0: f17ea21a f17ea300 f17ea000 00016920 f1800240 f18000ac f17fb7dc 01316000
>  fee0: 013161b0 00002590 01316250 00000000 00000000 00000000 00002580 00000029
>  ff00: 0000002a 00000013 00000000 0000000c 00000000 00000000 0157f004 c451ffb0
>  ff20: c1719be0 aed6f410 c451ff74 c451ff38 c0c4103c c0c407d0 c451ff84 c451ff48
>  ff40: 00000805 c02c8658 c1604230 c1719c30 00000805 0157f004 00000005 c451ffb0
>  ff60: c1719be0 aed6f410 c451ffac c451ff78 c0122130 c1705f48 c451ffac 0157f008
>  ff80: 00000006 0000005f 0000017b c0100244 c4880000 0000017b 00000000 c451ffa8
>  ffa0: c0100060 c02652d8 0157f008 00000006 00000003 0157f008 00000000 b6ac9f60
>  ffc0: 0157f008 00000006 0000005f 0000017b 00000000 00000000 aed85f74 00000000
>  ffe0: b6ac9cd8 b6ac9cc8 00030200 aecf2d60 a0000010 00000003 00000000 00000000
>  Backtrace:
>  [<c048034c>] (kasan_poison) from [<c048053c>] (kasan_unpoison+0x48/0x5c)
>  [<c04804f4>] (kasan_unpoison) from [<c047f330>] (__asan_register_globals+0x3c/0x64)
>   r5:01312cff r4:f1804030
>  [<c047f2f4>] (__asan_register_globals) from [<f1802098>] (_sub_I_65535_1+0x18/0xf80 [hello])
>   r7:c5be7700 r6:00000001 r5:c1b52ccc r4:f18040c0
>  [<f1802080>] (_sub_I_65535_1 [hello]) from [<c026106c>] (do_init_module+0x330/0x72c)
>  [<c0260d3c>] (do_init_module) from [<c0264e88>] (load_module+0x3260/0x32a8)
>   r10:f1804268 r9:c451fdf0 r8:00000000 r7:c1b54cc4 r6:00000000 r5:f18040c0
>   r4:c451fec0
>  [<c0261c28>] (load_module) from [<c0265480>] (sys_finit_module+0x1b4/0x1e8)
>   r10:c451fec0 r9:00000003 r8:0157f008 r7:00000000 r6:c451ff60 r5:b78a3fd0
>   r4:c1b54cc4
>  [<c02652cc>] (sys_finit_module) from [<c0100060>] (ret_fast_syscall+0x0/0x1c)
>  Exception stack(0xc451ffa8 to 0xc451fff0)
>  ffa0:                   0157f008 00000006 00000003 0157f008 00000000 b6ac9f60
>  ffc0: 0157f008 00000006 0000005f 0000017b 00000000 00000000 aed85f74 00000000
>  ffe0: b6ac9cd8 b6ac9cc8 00030200 aecf2d60
>   r10:0000017b r9:c4880000 r8:c0100244 r7:0000017b r6:0000005f r5:00000006
>   r4:0157f008
>  Code: e92d4100 e1a08001 e1a0e003 e2522040 (a8ac410a)
>  ---[ end trace df6e12843197b6f5 ]---
>
> Cc: <stable@vger.kernel.org> # 5.10+
> Fixes: 421015713b306e47af9 ("ARM: 9017/2: Enable KASan for ARM")
> Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
> ---
>  arch/arm/kernel/module.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
> index beac45e89ba6..c818aba72f68 100644
> --- a/arch/arm/kernel/module.c
> +++ b/arch/arm/kernel/module.c
> @@ -46,7 +46,7 @@ void *module_alloc(unsigned long size)
>         p = __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
>                                 gfp_mask, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
>                                 __builtin_return_address(0));
> -       if (!IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || p)
> +       if (!IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || IS_ENABLED(CONFIG_KASAN) || p)


Hello Lecopzer,

This is not the right place to fix this. If module PLTs are
incompatible with KAsan, they should not be selectable in Kconfig at
the same time.

But ideally, we should implement KASAN_VMALLOC for ARM as well - we
also need this for the vmap'ed stacks.


>                 return p;
>         return __vmalloc_node_range(size, 1,  VMALLOC_START, VMALLOC_END,
>                                 GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
