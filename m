Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F5351F7F3
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiEIJWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiEIIsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:48:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB64BAE261;
        Mon,  9 May 2022 01:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5838D614B0;
        Mon,  9 May 2022 08:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD05C385A8;
        Mon,  9 May 2022 08:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652085899;
        bh=jbrH4/qpfA9AmXv1qKe8PiTNy6NOxj0RKjG7cces7nQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TQYtfq4g3nnuFdk0cK9T+WkWsvsnuaestgpk3iEgBR++lx5uMpntKGbuJDVcb5lAm
         R+xdjPD0UIE+wE3qC/D2deGoTxywI/DYhD0WQNmqGKoXXhUlqV6OcKuPEYplpJrnpR
         RnKceLhufuU83HeMOBV/ONAfTPd3iFEDk8OSlc40=
Date:   Mon, 9 May 2022 10:43:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-acpi@vger.kernel.org, stable@vger.kernel.org,
        rafael@kernel.org, linux-kernel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 5.4] ACPICA: Always create namespace nodes using
 acpi_ns_create_node()
Message-ID: <YnjUSERLzEFLZpBv@kroah.com>
References: <YnPmDlf3KD9ckpM1@zx2c4.com>
 <20220505150140.159449-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505150140.159449-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 05, 2022 at 05:01:40PM +0200, Jason A. Donenfeld wrote:
> From: Vegard Nossum <vegard.nossum@oracle.com>
> 
> commit 25928deeb1e4e2cdae1dccff349320c6841eb5f8 upstream.
> 
> ACPICA commit 29da9a2a3f5b2c60420893e5c6309a0586d7a329
> 
> ACPI is allocating an object using kmalloc(), but then frees it
> using kmem_cache_free(<"Acpi-Namespace" kmem_cache>).
> 
> This is wrong and can lead to boot failures manifesting like this:
> 
>     hpet0: 3 comparators, 64-bit 100.000000 MHz counter
>     clocksource: Switched to clocksource tsc-early
>     BUG: unable to handle page fault for address: 000000003ffe0018
>     #PF: supervisor read access in kernel mode
>     #PF: error_code(0x0000) - not-present page
>     PGD 0 P4D 0
>     Oops: 0000 [#1] SMP PTI
>     CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0+ #211
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> Ubuntu-1.8.2-1ubuntu1 04/01/2014
>     RIP: 0010:kmem_cache_alloc+0x70/0x1d0
>     Code: 00 00 4c 8b 45 00 65 49 8b 50 08 65 4c 03 05 6f cc e7 7e 4d 8b
> 20 4d 85 e4 0f 84 3d 01 00 00 8b 45 20 48 8b 7d 00 48 8d 4a 01 <49> 8b
>    1c 04 4c 89 e0 65 48 0f c7 0f 0f 94 c0 84 c0 74 c5 8b 45 20
>     RSP: 0000:ffffc90000013df8 EFLAGS: 00010206
>     RAX: 0000000000000018 RBX: ffffffff81c49200 RCX: 0000000000000002
>     RDX: 0000000000000001 RSI: 0000000000000dc0 RDI: 000000000002b300
>     RBP: ffff88803e403d00 R08: ffff88803ec2b300 R09: 0000000000000001
>     R10: 0000000000000dc0 R11: 0000000000000006 R12: 000000003ffe0000
>     R13: ffffffff8110a583 R14: 0000000000000dc0 R15: ffffffff81c49a80
>     FS:  0000000000000000(0000) GS:ffff88803ec00000(0000)
> knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 000000003ffe0018 CR3: 0000000001c0a001 CR4: 00000000003606f0
>     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>     DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>     Call Trace:
>      __trace_define_field+0x33/0xa0
>      event_trace_init+0xeb/0x2b4
>      tracer_init_tracefs+0x60/0x195
>      ? register_tracer+0x1e7/0x1e7
>      do_one_initcall+0x74/0x160
>      kernel_init_freeable+0x190/0x1f0
>      ? rest_init+0x9a/0x9a
>      kernel_init+0x5/0xf6
>      ret_from_fork+0x35/0x40
>     CR2: 000000003ffe0018
>     ---[ end trace 707efa023f2ee960 ]---
>     RIP: 0010:kmem_cache_alloc+0x70/0x1d0
> 
> Bisection leads to unrelated changes in slab; Vlastimil Babka
> suggests an unrelated layout or slab merge change merely exposed
> the underlying bug.
> 
> Link: https://lore.kernel.org/lkml/4dc93ff8-f86e-f4c9-ebeb-6d3153a78d03@oracle.com/
> Link: https://lore.kernel.org/r/a1461e21-c744-767d-6dfc-6641fd3e3ce2@siemens.com
> Link: https://github.com/acpica/acpica/commit/29da9a2a
> Fixes: f79c8e4136ea ("ACPICA: Namespace: simplify creation of the initial/default namespace")
> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> Diagnosed-by: Vlastimil Babka <vbabka@suse.cz>
> Diagnosed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
> Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> Greg/Rafael - tihs was marked as 5.10, but 5.4 crashes without it. So
> maybe it was mistagged? Will let you guys decide. -Jason

Makes sense, now queued up, thanks.

greg k-h
