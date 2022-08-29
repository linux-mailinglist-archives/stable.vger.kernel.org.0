Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3A35A506F
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 17:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiH2Pqj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Aug 2022 11:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiH2Pqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 11:46:36 -0400
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52E984EEF;
        Mon, 29 Aug 2022 08:46:35 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-3321c2a8d4cso206007717b3.5;
        Mon, 29 Aug 2022 08:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=iIupB/8WTEbrKaG6hdRiHVNDQDnZuR0WvzZljSZ7SxQ=;
        b=H6gU6pwjlk4jJV8rfXylK63JlAMJtqcQQfgWrtUz5r6dTFqPAAAoejDfLGyS74xNrH
         fpJ4gpKqYCpbAFkSPMQluNJ1dQEVHWpnZomdAmzJwk6Rzz+Ab3E6hjePW4+XVhlJHHcR
         /AqciO+3w2qvqMb+oEHfebiTXsHMdGJUE6D9kq1RUJ2SpooctlOEFzhWeyDNTsrJ5mz5
         Xr1s9PctRf+Fl/k/9v624uL7FxWrQRF1AnZ1a1XllWI/vvVIpPszfZwHvU++4Lxy0rgM
         GqvLsN6zkHnC43gE+yVWdMQVKwbGyivQWG1iiwQEzvRyrpuUzsX8jLQXL+A0swHJZMPc
         hjrA==
X-Gm-Message-State: ACgBeo0ZIAn+Gmzq4JSQGd9bgD/4ZUUH8c4jCPDi66nNm4j0wbo5elG3
        CY9D+JhAmnYD6wnMeXC/nPrW2Iz5KGJvQDVOC6nqhbViFRY=
X-Google-Smtp-Source: AA6agR419oimNbv6KBdv0jHPlvJux01UYC53bFvSwZrpqm0Tqu/7O4Ckv9xHpBvGinBSUBkTwBZcUwKIsO6qGO7Ol0A=
X-Received: by 2002:a25:8d02:0:b0:696:42f8:fa6f with SMTP id
 n2-20020a258d02000000b0069642f8fa6fmr7970920ybl.365.1661787994841; Mon, 29
 Aug 2022 08:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9pQ5v5afkcCXtCYc1PLKKbnQJp=mc9gtdF+DBvFbKDPYw@mail.gmail.com>
 <20220829152827.2726-1-Jason@zx2c4.com>
In-Reply-To: <20220829152827.2726-1-Jason@zx2c4.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 29 Aug 2022 17:46:22 +0200
Message-ID: <CAJZ5v0js78b3qZXoxgXEwG7g0a7n_ALnEYjjzBGaQW7q4_ceCA@mail.gmail.com>
Subject: Re: [PATCH] power: supply: avoid nullptr deref in __power_supply_is_system_supplied
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CC: linux-pm (where the power supply subsystem is developed)

On Mon, Aug 29, 2022 at 5:28 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Fix the following OOPS:
>
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0010 [#1] PREEMPT SMP
> CPU: 14 PID: 1156 Comm: upowerd Tainted: G S   U             6.0.0-rc1+ #366
> Hardware name: LENOVO 20Y5CTO1WW/20Y5CTO1WW, BIOS N40ET36W (1.18 ) 07/19/2022
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffff88815350bd08 EFLAGS: 00010212
> RAX: ffff88810207d620 RBX: ffff88815350bd7c RCX: 000000000000394e
> RDX: ffff88815350bd10 RSI: 0000000000000004 RDI: ffff888111722c00
> RBP: ffff88815350bd68 R08: ffff8881187a8af8 R09: ffff8881187a8af8
> R10: 0000000000000000 R11: 000000000000005f R12: ffffffff8162d0b0
> R13: ffff88810159a038 R14: ffffffff823b3768 R15: ffff88810159a000
> FS:  00007fd1f0958140(0000) GS:ffff88901f780000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 0000000152c7a004 CR4: 0000000000770ee0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  __power_supply_is_system_supplied+0x26/0x40
>  class_for_each_device+0xa5/0xd0
>  ? acpi_battery_get_state+0x4e/0x1f0
>  power_supply_is_system_supplied+0x26/0x40
>  acpi_battery_get_property+0x301/0x310
>  power_supply_show_property+0xa5/0x1d0
>  dev_attr_show+0x10/0x30
>  sysfs_kf_seq_show+0x78/0xc0
>  seq_read_iter+0xfd/0x3e0
>  vfs_read+0x1cb/0x290
>  ksys_read+0x4e/0xc0
>  do_syscall_64+0x2b/0x50
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7fd1f0bed70c
> Code: ec 28 48 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 39 a4 f8 ff 41 89 c0 48 8b 54 24 18 48 8b 74 24 10 8b 7c 24 08 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 34 44 89 c7 48 89 44 24 08 e8 8f a4 f8 ff 48
> RSP: 002b:00007ffc8d3f27e0 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd1f0bed70c
> RDX: 0000000000001000 RSI: 000055957d534850 RDI: 000000000000000c
> RBP: 000055957d50b1d0 R08: 0000000000000000 R09: 0000000000001000
> R10: 000000000000006f R11: 0000000000000246 R12: 00007ffc8d3f2910
> R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000000c
>  </TASK>
>
> CR2: 0000000000000000
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffff88815350bd08 EFLAGS: 00010212
> RAX: ffff88810207d620 RBX: ffff88815350bd7c RCX: 000000000000394e
> RDX: ffff88815350bd10 RSI: 0000000000000004 RDI: ffff888111722c00
> RBP: ffff88815350bd68 R08: ffff8881187a8af8 R09: ffff8881187a8af8
> R10: 0000000000000000 R11: 000000000000005f R12: ffffffff8162d0b0
> R13: ffff88810159a038 R14: ffffffff823b3768 R15: ffff88810159a000
> FS:  00007fd1f0958140(0000) GS:ffff88901f780000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 0000000152c7a004 CR4: 0000000000770ee0
>
> The disassembly of the top function in the stack trace is:
>
> .text:0000000000000000 __power_supply_is_system_supplied proc near
> .text:0000000000000000                                         ; DATA XREF: power_supply_is_system_supplied+12↓o
> .text:0000000000000000
> .text:0000000000000000 var_8           = qword ptr -8
> .text:0000000000000000
> .text:0000000000000000                 sub     rsp, 8
> .text:0000000000000004                 mov     rdi, [rdi+78h]
> .text:0000000000000008                 inc     dword ptr [rsi]
> .text:000000000000000A                 mov     [rsp+8+var_8], 0
> .text:0000000000000012                 mov     rax, [rdi]
> .text:0000000000000015                 cmp     dword ptr [rax+8], 1
> .text:0000000000000019                 jz      short loc_2A
> .text:000000000000001B                 mov     rdx, rsp
> .text:000000000000001E                 mov     esi, 4
> .text:0000000000000023                 call    qword ptr [rax+30h]
> .text:0000000000000026                 test    eax, eax
> .text:0000000000000028                 jz      short loc_31
> .text:000000000000002A
> .text:000000000000002A loc_2A:                                 ; CODE XREF: __power_supply_is_system_supplied+19↑j
> .text:000000000000002A                 xor     eax, eax
> .text:000000000000002C                 add     rsp, 8
> .text:0000000000000030                 retn
> .text:0000000000000031 ; ---------------------------------------------------------------------------
> .text:0000000000000031
> .text:0000000000000031 loc_31:                                 ; CODE XREF: __power_supply_is_system_supplied+28↑j
> .text:0000000000000031                 mov     eax, dword ptr [rsp+8+var_8]
> .text:0000000000000034                 add     rsp, 8
> .text:0000000000000038                 retn
> .text:0000000000000038 __power_supply_is_system_supplied endp
>
> So presumably `call    qword ptr [rax+30h]` is jumping to NULL.
>
> Cc: stable@vger.kernel.org
> Cc: Rafael J. Wysocki <rafael@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

> ---
>  drivers/power/supply/power_supply_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
> index 4b5fb172fa99..aa4c97f11588 100644
> --- a/drivers/power/supply/power_supply_core.c
> +++ b/drivers/power/supply/power_supply_core.c
> @@ -349,7 +349,7 @@ static int __power_supply_is_system_supplied(struct device *dev, void *data)
>         unsigned int *count = data;
>
>         (*count)++;
> -       if (psy->desc->type != POWER_SUPPLY_TYPE_BATTERY)
> +       if (psy->desc->type != POWER_SUPPLY_TYPE_BATTERY && psy->desc->get_property)
>                 if (!psy->desc->get_property(psy, POWER_SUPPLY_PROP_ONLINE,
>                                         &ret))
>                         return ret.intval;
> --
> 2.37.2
>
