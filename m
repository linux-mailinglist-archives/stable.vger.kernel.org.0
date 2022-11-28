Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A88B63A128
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 07:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiK1GZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 01:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiK1GZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 01:25:51 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF97013F69;
        Sun, 27 Nov 2022 22:25:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id vp12so21980754ejc.8;
        Sun, 27 Nov 2022 22:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pvyc/Y0je10m+7tKkRhVqd7F/6Fh4vGa48vpfH3+st0=;
        b=SAZCqecAkk0r0Y7XYYioVUReAKI7cldklslyoKC2u3/eT+YgwS/UZ+yF+5XWNeGBBG
         GK149C5V2arMKregXiTnTXUTFidEipqHeRYifxpO8SbJkBn/i7Z5J/Gwcel8pfPNYvRa
         iRbeMlyT27y6hnPmOboeewmAT08sqKhZIHEAU/oTka6/vGeVSkUuPjjnx8aJc1snEDTh
         tQt8NkbPIHl21DRLISyLuhz9qqP6FGG/SopDIljpzC4DNzRmJZbBMW2T07s99MRFjITm
         sA3Z9lOXgNO4NDY+HyYcOr02OEyXTjHNlFC8vQMcik/2UFL8JoSJZU+YLPEw2qWLWc93
         z2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pvyc/Y0je10m+7tKkRhVqd7F/6Fh4vGa48vpfH3+st0=;
        b=IgXEzIUjDt7dvy9AdYltXNCMhHQr6sHw9X4IBcYJQVh/UYIHaxua2KFOLluqYXsizP
         6E3DQkWBPoNAv1F9TxG1gm9/eWNx2lBNJRdz10ZrXL8rNfi1FEc7FTYhi6aaFKDGDbhy
         V7hnhI9/bVFfBcifGzNGZ3IXMBZhVQXHafKK/FeWSdBwt5M67cUT0x7iSVayY/8pvCu7
         Qcte6CJS+lfS71oTfMEBIol5s8TfT6qaVnumViht8xLFXWgxTRRl17B5lus6N1tFWLA0
         FSsIrnVzGKv2cDiCba/yrNZtTD7Es19TsrELmHyo2Um/gEDfaAHmVoDCDtxIeGsgPGo4
         LbkQ==
X-Gm-Message-State: ANoB5plK4mobtl3WQ8qobXySiorMAOoCa1pudhza6ibWBjilJGGH4HbB
        y+i+sArojYSzNk1sb5RD8rvzLcTFis5mV92gq94=
X-Google-Smtp-Source: AA0mqf6zot371VpUgBCAP8yNRVW1ahi1kcEA//7QaEtGvMJx3biCW7dxrRUBQ+M/DR3wb4e6UgTQSje1IdyE0y9/Tq8=
X-Received: by 2002:a17:906:cc8f:b0:78b:8ce7:fe3c with SMTP id
 oq15-20020a170906cc8f00b0078b8ce7fe3cmr41762439ejb.557.1669616748770; Sun, 27
 Nov 2022 22:25:48 -0800 (PST)
MIME-Version: 1.0
References: <20220714084136.570176-1-chenhuacai@loongson.cn> <20220714084136.570176-3-chenhuacai@loongson.cn>
In-Reply-To: <20220714084136.570176-3-chenhuacai@loongson.cn>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Mon, 28 Nov 2022 14:25:35 +0800
Message-ID: <CAAhV-H7uF85UHfbS+-sMcXbB=q3UO0Z8rO=poNQbEtaipi4PHQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] SH: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     Huacai Chen <chenhuacai@loongson.cn>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, loongarch@lists.linux.dev,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ping?

On Thu, Jul 14, 2022 at 4:42 PM Huacai Chen <chenhuacai@loongson.cn> wrote:
>
> When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> cpu_max_bits_warn() generates a runtime warning similar as below while
> we show /proc/cpuinfo. Fix this by using nr_cpu_ids (the runtime limit)
> instead of NR_CPUS to iterate CPUs.
>
> [    3.052463] ------------[ cut here ]------------
> [    3.059679] WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:108 show_cpuinfo+0x5e8/0x5f0
> [    3.070072] Modules linked in: efivarfs autofs4
> [    3.076257] CPU: 0 PID: 1 Comm: systemd Not tainted 5.19-rc5+ #1052
> [    3.099465] Stack : 9000000100157b08 9000000000f18530 9000000000cf846c 9000000100154000
> [    3.109127]         9000000100157a50 0000000000000000 9000000100157a58 9000000000ef7430
> [    3.118774]         90000001001578e8 0000000000000040 0000000000000020 ffffffffffffffff
> [    3.128412]         0000000000aaaaaa 1ab25f00eec96a37 900000010021de80 900000000101c890
> [    3.138056]         0000000000000000 0000000000000000 0000000000000000 0000000000aaaaaa
> [    3.147711]         ffff8000339dc220 0000000000000001 0000000006ab4000 0000000000000000
> [    3.157364]         900000000101c998 0000000000000004 9000000000ef7430 0000000000000000
> [    3.167012]         0000000000000009 000000000000006c 0000000000000000 0000000000000000
> [    3.176641]         9000000000d3de08 9000000001639390 90000000002086d8 00007ffff0080286
> [    3.186260]         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1c
> [    3.195868]         ...
> [    3.199917] Call Trace:
> [    3.203941] [<90000000002086d8>] show_stack+0x38/0x14c
> [    3.210666] [<9000000000cf846c>] dump_stack_lvl+0x60/0x88
> [    3.217625] [<900000000023d268>] __warn+0xd0/0x100
> [    3.223958] [<9000000000cf3c90>] warn_slowpath_fmt+0x7c/0xcc
> [    3.231150] [<9000000000210220>] show_cpuinfo+0x5e8/0x5f0
> [    3.238080] [<90000000004f578c>] seq_read_iter+0x354/0x4b4
> [    3.245098] [<90000000004c2e90>] new_sync_read+0x17c/0x1c4
> [    3.252114] [<90000000004c5174>] vfs_read+0x138/0x1d0
> [    3.258694] [<90000000004c55f8>] ksys_read+0x70/0x100
> [    3.265265] [<9000000000cfde9c>] do_syscall+0x7c/0x94
> [    3.271820] [<9000000000202fe4>] handle_syscall+0xc4/0x160
> [    3.281824] ---[ end trace 8b484262b4b8c24c ]---
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  arch/sh/kernel/cpu/proc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/sh/kernel/cpu/proc.c b/arch/sh/kernel/cpu/proc.c
> index a306bcd6b341..5f6d0e827bae 100644
> --- a/arch/sh/kernel/cpu/proc.c
> +++ b/arch/sh/kernel/cpu/proc.c
> @@ -132,7 +132,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>
>  static void *c_start(struct seq_file *m, loff_t *pos)
>  {
> -       return *pos < NR_CPUS ? cpu_data + *pos : NULL;
> +       return *pos < nr_cpu_ids ? cpu_data + *pos : NULL;
>  }
>  static void *c_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> --
> 2.31.1
>
