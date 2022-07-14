Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C6A5749CA
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 11:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237906AbiGNJ5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 05:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiGNJ5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 05:57:08 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29F814C607;
        Thu, 14 Jul 2022 02:57:07 -0700 (PDT)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1oBvaj-0006rx-00; Thu, 14 Jul 2022 11:57:05 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 4A3C8C047F; Thu, 14 Jul 2022 11:54:40 +0200 (CEST)
Date:   Thu, 14 Jul 2022 11:54:40 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhuacai@loongson.cn>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, loongarch@lists.linux.dev,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huacai Chen <chenhuacai@gmail.com>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 1/3] MIPS: cpuinfo: Fix a warning for
 CONFIG_CPUMASK_OFFSTACK
Message-ID: <20220714095440.GA10086@alpha.franken.de>
References: <20220714084136.570176-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714084136.570176-1-chenhuacai@loongson.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 04:41:34PM +0800, Huacai Chen wrote:
> When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> cpu_max_bits_warn() generates a runtime warning similar as below while
> we show /proc/cpuinfo. Fix this by using nr_cpu_ids (the runtime limit)
> instead of NR_CPUS to iterate CPUs.
> 
> [    3.052463] ------------[ cut here ]------------
> [    3.059679] WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:108 show_cpuinfo+0x5e8/0x5f0
> [    3.070072] Modules linked in: efivarfs autofs4
> [    3.076257] CPU: 0 PID: 1 Comm: systemd Not tainted 5.19-rc5+ #1052
> [    3.084034] Hardware name: Loongson Loongson-3A4000-7A1000-1w-V0.1-CRB/Loongson-LS3A4000-7A1000-1w-EVB-V1.21, BIOS Loongson-UDK2018-V2.0.04082-beta7 04/27
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
> [    3.203941] [<98000000002086d8>] show_stack+0x38/0x14c
> [    3.210666] [<9800000000cf846c>] dump_stack_lvl+0x60/0x88
> [    3.217625] [<980000000023d268>] __warn+0xd0/0x100
> [    3.223958] [<9800000000cf3c90>] warn_slowpath_fmt+0x7c/0xcc
> [    3.231150] [<9800000000210220>] show_cpuinfo+0x5e8/0x5f0
> [    3.238080] [<98000000004f578c>] seq_read_iter+0x354/0x4b4
> [    3.245098] [<98000000004c2e90>] new_sync_read+0x17c/0x1c4
> [    3.252114] [<98000000004c5174>] vfs_read+0x138/0x1d0
> [    3.258694] [<98000000004c55f8>] ksys_read+0x70/0x100
> [    3.265265] [<9800000000cfde9c>] do_syscall+0x7c/0x94
> [    3.271820] [<9800000000202fe4>] handle_syscall+0xc4/0x160
> [    3.281824] ---[ end trace 8b484262b4b8c24c ]---
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  arch/mips/kernel/proc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
