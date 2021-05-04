Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D3937296B
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 13:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhEDLHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 07:07:53 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:33665 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhEDLHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 07:07:51 -0400
Received: by mail-ot1-f48.google.com with SMTP id 92-20020a9d02e50000b029028fcc3d2c9eso7879966otl.0;
        Tue, 04 May 2021 04:06:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=feL9T4jl3IbJLdBOVhRIlFY3Lt+mZxSA1JhW2LC57dk=;
        b=WuLMMqXQcFjZQWn48jf73nDpxKMeesvUjUllLUdj8D/MMuYeIyl/DmiHkOgcLb11By
         CMWgD9tj9rPnnKGr2wYG5gBO8H2SEuLwlL+C/V+eStIg7nB+UITGn7F1be0Sf8LOOnE3
         nTQgFPc5r4T1iPhd7JXK/AnqOY32UIntEZtRk7TFVQ/OeuwgwCQZZj4wn7oDFjKh/x2A
         t3w9/Nl3cjb2EgZXXHr40RQbmDsrjsqdAamzLnMZm1Uod6qJNDQd3fZndF9NNzWvG7xZ
         gpSp9Vgw28e43trGdP5xXDnlS5MsiCJq9eL1AYVH7P8jzp4jIMRiuDx3KgOANEs8pghU
         HtiA==
X-Gm-Message-State: AOAM532Pazc5GnFIwCEcuDx5/JDfC63546mfRS0ORVRth2v503vYkhPd
        GXo2QyPpEPDRh+qm4rI59fOQkgT2bOyMP2DoLKQ=
X-Google-Smtp-Source: ABdhPJzDF5CpAVV+d4Q0JkCWxEImC8Fcg2fSzyA5tKIzqGa38UxMVngHphbc1wzWfW42BNOv8IsjCfndEd32+9+b0Fw=
X-Received: by 2002:a05:6830:2458:: with SMTP id x24mr19584535otr.206.1620126416384;
 Tue, 04 May 2021 04:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <ccb59e5f-c585-d5d2-034c-a96aba407b5b@oracle.com>
In-Reply-To: <ccb59e5f-c585-d5d2-034c-a96aba407b5b@oracle.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 4 May 2021 13:06:49 +0200
Message-ID: <CAJZ5v0g5Z26stgS_ppy-e9an-FWOqW6wx1HNK+TEuC2Zc4oFnA@mail.gmail.com>
Subject: Re: 5.4.y, 4.14.y, 4.19.y [PATCH] ACPI: x86: Call acpi_boot_table_init()
 after acpi_table_upgrade()
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dhaval Giani <dhaval.giani@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stable <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86 Maintainers <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 9:03 PM George Kennedy
<george.kennedy@oracle.com> wrote:
>
> commit 6998a8800d73116187aad542391ce3b2dd0f9e30 upstream.
>
> Upstream commit 6998a8800d73116187aad542391ce3b2dd0f9e30 along with
> upstream commit 1a1c130ab7575498eed5bcf7220037ae09cd1f8a (ACPI: tables:
> x86: Reserve memory occupied by ACPI tables) fixes the following issue.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> Mounting an iSCSI volume during boot causes the following crash with a
> KASAN enabled kernel:
>
> [   17.239703] iscsi: registered transport (iser)
> [   17.241038] OPA Virtual Network Driver - v1.0
> [   17.242833] iBFT detected.
> [   17.243593]
> ==================================================================
> [   17.243615] BUG: KASAN: use-after-free in ibft_init+0x134/0xab7
> [   17.243615] Read of size 4 at addr ffff8880be451004 by task swapper/0/1
> [   17.243615]
> [   17.243615] CPU: 2 PID: 1 Comm: swapper/0 Not tainted
> 4.19.190-rc1-1bd8f1c #1
> [   17.243615] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 0.0.0 02/06/2015
> [   17.243615] Call Trace:
> [   17.243615]  dump_stack+0xb3/0xf0
> [   17.243615]  ? ibft_init+0x134/0xab7
> [   17.243615]  print_address_description+0x71/0x239
> [   17.243615]  ? ibft_init+0x134/0xab7
> [   17.243615]  kasan_report.cold.6+0x242/0x2fe
> [   17.243615]  __asan_report_load_n_noabort+0x14/0x20
> [   17.243615]  ibft_init+0x134/0xab7
> [   17.243615]  ? dcdrbu_init+0x1e6/0x225
> [   17.243615]  ? ibft_check_initiator_for+0x14a/0x14a
> [   17.243615]  ? ibft_check_initiator_for+0x14a/0x14a
> [   17.243615]  do_one_initcall+0xb6/0x3a0
> [   17.243615]  ? perf_trace_initcall_level+0x430/0x430
> [   17.243615]  ? kasan_unpoison_shadow+0x35/0x50
> [   17.243615]  kernel_init_freeable+0x54d/0x64d
> [   17.243615]  ? start_kernel+0x7e9/0x7e9
> [   17.243615]  ? __switch_to_asm+0x41/0x70
> [   17.243615]  ? kasan_check_read+0x11/0x20
> [   17.243615]  ? rest_init+0xdc/0xdc
> [   17.243615]  kernel_init+0x16/0x180
> [   17.243615]  ? rest_init+0xdc/0xdc
> [   17.243615]  ret_from_fork+0x35/0x40
> [   17.243615]
> [   17.243615] The buggy address belongs to the page:
> [   17.243615] page:ffffea0002f91440 count:0 mapcount:0
> mapping:0000000000000000 index:0x1
> [   17.243615] flags: 0xfffffc0000000()
> [   17.243615] raw: 000fffffc0000000 ffffea0002df9708 ffffea0002f91408
> 0000000000000000
> [   17.243615] raw: 0000000000000001 0000000000000000 00000000ffffffff
> 0000000000000000
> [   17.243615] page dumped because: kasan: bad access detected
> [   17.243615]
> [   17.243615] Memory state around the buggy address:
> [   17.243615]  ffff8880be450f00: ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff
> [   17.243615]  ffff8880be450f80: ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff
> [   17.243615] >ffff8880be451000: ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff
> [   17.243615]                    ^
> [   17.243615]  ffff8880be451080: ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff
> [   17.243615]  ffff8880be451100: ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff
> [   17.243615]
> ==================================================================
>
>
> Patch
>
> commit 6998a8800d73116187aad542391ce3b2dd0f9e30
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Tue Apr 13 16:01:00 2021 +0200
>
>      ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()
>
>      Commit 1a1c130ab757 ("ACPI: tables: x86: Reserve memory occupied by
>      ACPI tables") attempted to address an issue with reserving the memory
>      occupied by ACPI tables, but it broke the initrd-based table override
>      mechanism relied on by multiple users.
>
>      To restore the initrd-based ACPI table override functionality, move
>      the acpi_boot_table_init() invocation in setup_arch() on x86 after
>      the acpi_table_upgrade() one.
>
>      Fixes: 1a1c130ab757 ("ACPI: tables: x86: Reserve memory occupied by
> ACPI tables")
>      Reported-by: Hans de Goede <hdegoede@redhat.com>
>      Tested-by: Hans de Goede <hdegoede@redhat.com>
>      Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 5ecd69a..ccab6cf 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1045,9 +1045,6 @@ void __init setup_arch(char **cmdline_p)
>
>       cleanup_highmap();
>
> -    /* Look for ACPI tables and reserve memory occupied by them. */
> -    acpi_boot_table_init();
> -
>       memblock_set_current_limit(ISA_END_ADDRESS);
>       e820__memblock_setup();
>
> @@ -1132,6 +1129,8 @@ void __init setup_arch(char **cmdline_p)
>       reserve_initrd();
>
>       acpi_table_upgrade();
> +    /* Look for ACPI tables and reserve memory occupied by them. */
> +    acpi_boot_table_init();
>
>       vsmp_init();
>
> Thank you,
> George
