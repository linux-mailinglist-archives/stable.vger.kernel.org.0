Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5731F6164B0
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 15:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKBOPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 10:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKBOPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 10:15:43 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E1924F38
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 07:15:41 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z18so21667935edb.9
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 07:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7PYnB7xW2Wi33w4OvOPbxiAvVHx7kf/RZ/bLDiGg/bE=;
        b=lyGZjJw8emxz4I8SOPX27gIod982UVGqmJS5GMu08w3F2FaEiEPQeQncTFZBZxHiwR
         Odgib04ABhDWpw9F/KcpVWauZBSf5/pqx1AAASJj6j4fKdAgY37h2KZAbit+zFZPVSSp
         nWdZ/Rvj6JRPXCqeHqNyO98TXCd29fe0Ipdnwr06eSZbnyHGMq7PptK6jC2sEiPGXKdu
         YsJEqdenxZBh03G3EnqRAsckMX2hL334FVR0z72DZbMghb5lW4VAfGLy/gJzcsYvgMbD
         Op567n382pFq9Io20n5SLADuRvATSTTH1nCwO6GU2TnTg17CW4ySbAj4edq5VhYT2/4c
         cMjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7PYnB7xW2Wi33w4OvOPbxiAvVHx7kf/RZ/bLDiGg/bE=;
        b=hA7z0nMAPywsYsZyvP0wzbaafcBc8KMBVd1UvBjKH+D6xSpmTR7dz13CCnOJ1LdNzl
         Z+UcDLbc4sb2IUukzitq6pzksWfmF84H2KdXIQJQs5lXWZcxsCHilm3fc6i9DJyqVgqV
         vVP7iX89t3Ekkff9W5xy6SVjrUsERznwi2woOqOgsigQ0mVstJUIU742wgMHqdYuSpkq
         oyuMOBe3TY1Q1EilTpucNTd/vBXlQQWsbnO9u/hWyImvKTJUjWRCfWZ/zQbqp2pigbYm
         8NIlpeBYcnHlvlupVXdfP4Q1fXp/2/mGVmCfTgh+aphQJpVl31hQg7pJQFl+tQTUU6HS
         HAsQ==
X-Gm-Message-State: ACrzQf0+yEA7T3BoTTlwMFWM4obKLNKzNcuqmUvCDyuLDTiLM8f3ItSu
        oeBaUM7L2/P957PcQBVlmklOpvOjK4n2igEBGRYTxg==
X-Google-Smtp-Source: AMsMyM6CMF86OMHDnR7HQnsrniHgGl54WWSOkEJKKkIYK9favUb62WLbrcteXqTV7ZOulDDAmHkDgC2Y39SH/9be3GQ=
X-Received: by 2002:aa7:d996:0:b0:461:88b8:c581 with SMTP id
 u22-20020aa7d996000000b0046188b8c581mr24954621eds.111.1667398540334; Wed, 02
 Nov 2022 07:15:40 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Nov 2022 19:45:29 +0530
Message-ID: <CA+G9fYv5-og6kr8PgGCg-wYUK3PGCQmvbY1YYews5-C8XwxSww@mail.gmail.com>
Subject: KASAN / KUNIT: testing ran on qemu-arm and list of failures
To:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Gow <davidgow@google.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Vitor Massaru Iha <vitor@massaru.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a report to get a quick update on kasan on qemu-arm.

The KASAN / KUNIT testing ran on qemu-arm and the following test cases failed
and the kernel crashed.

Following tests failed,
    kasan_strings - FAILED
    vmalloc_oob - FAILED
    kasan_memchr - FAILED
    kasan - FAILED
    kasan_bitops_generic - FAILED

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Boot and test log:
[    0.000000] Linux version 6.0.7-rc1 (tuxmake@tuxmake)
(arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld
(GNU Binutils for Debian) 2.35.2) #1 SMP @1667356522
[    0.000000] CPU: ARMv7 Processor [410fd034] revision 4 (ARMv7), cr=10c5383d
...
[    0.000000] kasan: Mapping kernel virtual memory block:
c0000000-f0000000 at shadow: b7000000-bd000000
[    0.000000] kasan: Mapping kernel virtual memory block:
bfe00000-c0000000 at shadow: b6fc0000-b7000000
[    0.000000] kasan: Kernel address sanitizer initialized
...
[   81.058636]     ok 41 - kmem_cache_double_destroy
[   81.059932]     # kasan_memchr: EXPECTATION FAILED at lib/test_kasan.c:920
[   81.059932]     KASAN failure expected in \"kasan_ptr_result =
memchr(ptr, '1', size + 1)\", but none occurred
[   81.063106]     not ok 42 - kasan_memchr
...
[   81.221595]     # kasan_strings: EXPECTATION FAILED at lib/test_kasan.c:975
[   81.221595]     KASAN failure expected in \"kasan_ptr_result =
strchr(ptr, '1')\", but none occurred
[   81.223903]     # kasan_strings: EXPECTATION FAILED at lib/test_kasan.c:977
[   81.223903]     KASAN failure expected in \"kasan_ptr_result =
strrchr(ptr, '1')\", but none occurred
...
[  429.920201] Insufficient stack space to handle exception!
[  429.920232] Task stack:     [0xfa000000..0xfa004000]
[  429.925226] IRQ stack:      [0xf0808000..0xf080c000]
[  429.927424] Overflow stack: [0xc4190000..0xc4191000]
[  429.929785] Internal error: kernel stack overflow: 0 [#1] SMP ARM
[  429.933101] Modules linked in: usbtest pci_endpoint_test
pci_epf_test preemptirq_delay_test soc_utils_test(N) snd_soc_core
ac97_bus snd_pcm_dmaengine snd_pcm snd_timer snd soundcore cfg80211
bluetooth crc32_arm_ce sha2_arm_ce sha256_arm sha1_arm_ce sha1_arm
aes_arm_ce crypto_simd
[  429.946324] CPU: 1 PID: 3390 Comm: grep Tainted: G    B
N 6.0.7-rc1 #1
[  429.950389] Hardware name: Generic DT based system
[  429.952979] PC is at trace_hardirqs_off+0x0/0x16c
[  429.955349] LR is at __dabt_svc+0x48/0x80
...
[  902.927481] Insufficient stack space to handle exception!
[  902.927520] Task stack:     [0xfa138000..0xfa13c000]
[  902.932386] IRQ stack:      [0xf0800000..0xf0804000]
[  902.934770] Overflow stack: [0xc418f000..0xc4190000]
[  902.937770] Internal error: kernel stack overflow: 0 [#3] SMP ARM
[  902.941255] Modules linked in: usbtest pci_endpoint_test
pci_epf_test preemptirq_delay_test soc_utils_test(N) snd_soc_core
ac97_bus snd_pcm_dmaengine snd_pcm snd_timer snd soundcore cfg80211
bluetooth crc32_arm_ce sha2_arm_ce sha256_arm sha1_arm_ce sha1_arm
aes_arm_ce crypto_simd
[  902.954667] CPU: 0 PID: 3440 Comm: agetty Tainted: G    B D
 N 6.0.7-rc1 #1
[  902.959155] Hardware name: Generic DT based system
[  902.961688] PC is at trace_hardirqs_off+0x0/0x16c
[  902.964151] LR is at __dabt_svc+0x48/0x80
[  902.966393] pc : [<c04c98fc>]    lr : [<c0300b28>]    psr: 400c0193
[  902.969925] sp : fa138008  ip : 00000051  fp : fa13be74
[  902.973008] r10: c6175180  r9 : ce082c00  r8 : fa1380b8
[  902.976025] r7 : fa13803c  r6 : ffffffff  r5 : 200c0193  r4 : c05eb00c
[  902.979718] r3 : c1b29438  r2 : fa138054  r1 : be42701f  r0 : 00000051
[  902.983275] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment none
[  902.986903] Control: 10c5383d  Table: 498d806a  DAC: 00000051
[  902.989830] Register r0 information: non-paged memory
[  902.992732] Register r1 information: non-paged memory
[  902.995532] Register r2 information: 4-page vmalloc region starting
at 0xfa138000 allocated at kernel_clone+0xb0/0x53c
[  903.001090] Register r3 information: non-slab/vmalloc memory
[  903.004149] Register r4 information: non-slab/vmalloc memory
[  903.007262] Register r5 information: non-paged memory
[  903.010091] Register r6 information: non-paged memory
[  903.012782] Register r7 information: 4-page vmalloc region starting
at 0xfa138000 allocated at kernel_clone+0xb0/0x53c
[  903.018743] Register r8 information: 4-page vmalloc region starting
at 0xfa138000 allocated at kernel_clone+0xb0/0x53c
[  903.024227] Register r9 information: slab task_struct start
ce082c00 pointer offset 0
[  903.028265] Register r10 information: slab mm_struct start c6175180
pointer offset 0 size 168
[  903.033051] Register r11 information: 4-page vmalloc region
starting at 0xfa138000 allocated at kernel_clone+0xb0/0x53c
[  903.038677] Register r12 information: non-paged memory
[  903.041458] Process agetty (pid: 3440, stack limit = 0xa4d91b13)
...
[  905.331477]  trace_hardirqs_off from __dabt_svc+0x48/0x80
[  905.334275] Exception stack(0xfa138008 to 0xfa138050)
[  905.337192] 8000:                   fa1380f8 be42701f fa1380f8
00000003 be427035 fa1380b8
[  905.341804] 8020: c31192e0 00000005 fa1380b8 c3119330 c6175180
fa13be74 00000051 fa138054
[  905.346074] 8040: c1b29438 c05eb00c 200c0193 ffffffff
[  905.348746]  __dabt_svc from __asan_load4+0x30/0x88
[  905.351332]  __asan_load4 from do_translation_fault+0x34/0x124
[  905.354779]  do_translation_fault from do_DataAbort+0x54/0xf4
[  905.358091]  do_DataAbort from __dabt_svc+0x50/0x80
[  905.360842] Exception stack(0xfa1380b8 to 0xfa138100)

[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.6-241-g436175d0f780/testrun/12809413/suite/log-parser-test/test/check-kernel-bug/details/
[2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.6-241-g436175d0f780/testrun/12809413/suite/log-parser-test/test/check-kernel-bug/log

metadata:
  git_ref: linux-6.0.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: 436175d0f780af8302164b3102ecf0ff99f7a376
  git_describe: v6.0.6-241-g436175d0f780
  kernel_version: 6.0.7-rc1
  kernel-config: https://builds.tuxbuild.com/2GyMQxdakmLexUwkh1d3VjAfSgv/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/683032123
  artifact-location: https://builds.tuxbuild.com/2GyMQxdakmLexUwkh1d3VjAfSgv
  toolchain: gcc-10


--
Linaro LKFT
https://lkft.linaro.org
