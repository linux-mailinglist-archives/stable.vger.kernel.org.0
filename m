Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B921B63A2B3
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 09:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiK1ITz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 03:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiK1ITx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 03:19:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71C31180E;
        Mon, 28 Nov 2022 00:18:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8142460FE7;
        Mon, 28 Nov 2022 08:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA40C43470;
        Mon, 28 Nov 2022 08:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669623533;
        bh=8fvSqyC5O7kIfnW0Kyq33j5dit6Z5CFYOeb+1myKFss=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jylfX3gRUDIRl78mcgXqXQ3hPGGqN6r0iGnar94bW6COLNIN6I5XdxgDk8oM0qrAx
         Lnj4SrwhzfbRP8ECsTg4ZihP4FG0a+32QTIQkutFWb28sv9POIo3dh0oBr1P/SLeP4
         bHtXKOfipeUdemaf8YGKIS4BGWaavB79/qMzHuZFH7TUUeEauWUAzs630Ti/k7BIUN
         xia+PHCdapvTeDHldeCe2YRouwErxoTAB8/KUSPJ1VL+HzoIlzgKF/xMocoNCDCcKR
         4wET1oBSGtjids0dhr7OEVaj/vzerKnjmZJGYwmXezKDBd2ezLEm60iNjRlSW4DTLj
         Fki0XgEHYWcQA==
Received: by mail-ej1-f54.google.com with SMTP id b2so7509576eja.7;
        Mon, 28 Nov 2022 00:18:53 -0800 (PST)
X-Gm-Message-State: ANoB5plSl4h59le3ccIgzzM8Hw0/JiEQoZzGrNrg968nUC/QFNS6PjQ5
        y9ae2CAtbo2yaRASQO+2WuKU2AWVEge2je4ygkc=
X-Google-Smtp-Source: AA0mqf4+1cmRwSticidoMDLfF2SOB4WXxmURJljOM3sqd+ULavDUaLn5tkZ9YGNeduJcF2Uo7T2lIG95LDpRA7MUUBA=
X-Received: by 2002:a17:907:9856:b0:780:8144:a41f with SMTP id
 jj22-20020a170907985600b007808144a41fmr43519094ejc.189.1669623532033; Mon, 28
 Nov 2022 00:18:52 -0800 (PST)
MIME-Version: 1.0
References: <20220714084136.570176-1-chenhuacai@loongson.cn>
 <20220714084136.570176-3-chenhuacai@loongson.cn> <CAAhV-H7uF85UHfbS+-sMcXbB=q3UO0Z8rO=poNQbEtaipi4PHQ@mail.gmail.com>
In-Reply-To: <CAAhV-H7uF85UHfbS+-sMcXbB=q3UO0Z8rO=poNQbEtaipi4PHQ@mail.gmail.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Mon, 28 Nov 2022 16:18:40 +0800
X-Gmail-Original-Message-ID: <CAJF2gTT82uNmjfDcMrSodssZWsMSrN_476s03QCv__kmQH-6GQ@mail.gmail.com>
Message-ID: <CAJF2gTT82uNmjfDcMrSodssZWsMSrN_476s03QCv__kmQH-6GQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] SH: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     Huacai Chen <chenhuacai@gmail.com>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, loongarch@lists.linux.dev,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 28, 2022 at 2:25 PM Huacai Chen <chenhuacai@gmail.com> wrote:
>
> ping?
Who can test?

>
> On Thu, Jul 14, 2022 at 4:42 PM Huacai Chen <chenhuacai@loongson.cn> wrote:
> >
> > When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> > cpu_max_bits_warn() generates a runtime warning similar as below while
> > we show /proc/cpuinfo. Fix this by using nr_cpu_ids (the runtime limit)
> > instead of NR_CPUS to iterate CPUs.
> >
> > [    3.052463] ------------[ cut here ]------------
> > [    3.059679] WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:108 show_cpuinfo+0x5e8/0x5f0
> > [    3.070072] Modules linked in: efivarfs autofs4
> > [    3.076257] CPU: 0 PID: 1 Comm: systemd Not tainted 5.19-rc5+ #1052
> > [    3.099465] Stack : 9000000100157b08 9000000000f18530 9000000000cf846c 9000000100154000
> > [    3.109127]         9000000100157a50 0000000000000000 9000000100157a58 9000000000ef7430
> > [    3.118774]         90000001001578e8 0000000000000040 0000000000000020 ffffffffffffffff
> > [    3.128412]         0000000000aaaaaa 1ab25f00eec96a37 900000010021de80 900000000101c890
> > [    3.138056]         0000000000000000 0000000000000000 0000000000000000 0000000000aaaaaa
> > [    3.147711]         ffff8000339dc220 0000000000000001 0000000006ab4000 0000000000000000
> > [    3.157364]         900000000101c998 0000000000000004 9000000000ef7430 0000000000000000
> > [    3.167012]         0000000000000009 000000000000006c 0000000000000000 0000000000000000
> > [    3.176641]         9000000000d3de08 9000000001639390 90000000002086d8 00007ffff0080286
> > [    3.186260]         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1c
> > [    3.195868]         ...
> > [    3.199917] Call Trace:
> > [    3.203941] [<90000000002086d8>] show_stack+0x38/0x14c
> > [    3.210666] [<9000000000cf846c>] dump_stack_lvl+0x60/0x88
> > [    3.217625] [<900000000023d268>] __warn+0xd0/0x100
> > [    3.223958] [<9000000000cf3c90>] warn_slowpath_fmt+0x7c/0xcc
> > [    3.231150] [<9000000000210220>] show_cpuinfo+0x5e8/0x5f0
> > [    3.238080] [<90000000004f578c>] seq_read_iter+0x354/0x4b4
> > [    3.245098] [<90000000004c2e90>] new_sync_read+0x17c/0x1c4
> > [    3.252114] [<90000000004c5174>] vfs_read+0x138/0x1d0
> > [    3.258694] [<90000000004c55f8>] ksys_read+0x70/0x100
> > [    3.265265] [<9000000000cfde9c>] do_syscall+0x7c/0x94
> > [    3.271820] [<9000000000202fe4>] handle_syscall+0xc4/0x160
> > [    3.281824] ---[ end trace 8b484262b4b8c24c ]---
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> >  arch/sh/kernel/cpu/proc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/sh/kernel/cpu/proc.c b/arch/sh/kernel/cpu/proc.c
> > index a306bcd6b341..5f6d0e827bae 100644
> > --- a/arch/sh/kernel/cpu/proc.c
> > +++ b/arch/sh/kernel/cpu/proc.c
> > @@ -132,7 +132,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
> >
> >  static void *c_start(struct seq_file *m, loff_t *pos)
> >  {
> > -       return *pos < NR_CPUS ? cpu_data + *pos : NULL;
> > +       return *pos < nr_cpu_ids ? cpu_data + *pos : NULL;
> >  }
> >  static void *c_next(struct seq_file *m, void *v, loff_t *pos)
> >  {
> > --
> > 2.31.1
> >



-- 
Best Regards
 Guo Ren
