Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A2238FD2E
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 10:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhEYIx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 04:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhEYIx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 04:53:26 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6BEC061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 01:51:57 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id y76so20342164oia.6
        for <stable@vger.kernel.org>; Tue, 25 May 2021 01:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ToFLxqOf83HeFVD2xsbBx9SMeRlXjpSYMbMVCYxyS/Q=;
        b=QEJnHdSK0xfzOCCWTk8svsTkGjqYPrBMkTCQDLtL+AnA6ZhDiO3B266diZ/SZGNjRz
         45hnmWSkJF4oVGdxhhAdn1VJ16OM2z/quxKoRFzBMLeycOQjjxalbUxeRDT12Wxi/lI6
         qLdTg4KY/pfvGFFmzA6syNOFB534frebeFZPeQbNGpvUimgmdX4KHuT+KNeFJuDPTql9
         vZS4KLLUdg/GrsMi8xmdny+ATt+usvZ3m5PMiDL5f7YeOLlN8t8Sd2214buXT0pXtXiu
         kn3anWfcT7VU6Fe7nTxNHuc5fIX/OkFQg3K3kx6xAJpv0nOoTZiD66KrNflPlAV2ii/i
         SEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ToFLxqOf83HeFVD2xsbBx9SMeRlXjpSYMbMVCYxyS/Q=;
        b=F+L66lQF14u/aa5qXa2TanJDW474o1nore6rVLGCZ5iFslC6VV9j+tEet+SsVw435Y
         5KUP/a9ZWKnSV88c09s2Ph1+/kRFsCz5YUB+Ukb9VkvxI/n0/el6HYMS9nPoAhEZDP52
         SPsDzpf+FJ53HlfVS0z6NJLjtd24RffRSO5kMPiYXZ7mq6muQCCqUi3Nt+hlWFnCjCWQ
         TBz6srQcINVwslLBvXuC7qTTY6cj/hY6hTm4+rnJqIXD9owWN/JZwLpCg/glw7xpE5vO
         isI+7vel0/GstURfezZb2o2v5OBMWGCp+C3HJ2OS5eZr+p2E4RYnU3WeIDx1wp/Uw3q4
         mq2w==
X-Gm-Message-State: AOAM5318sHfoa0CAcFGr2B4+cuaMM8g0BcEpJDtY9IE7XOkaq2J71BOK
        gP+6voF1QXApuhOZJcQ3HboaxoCLvPpaU2FUwVrMeA==
X-Google-Smtp-Source: ABdhPJyU5SdzuOkMfcrRpbbKu1s22AvryE6xYuX6N6cgM+bBADYrQYatw5XNbJ5C74lFSLX+tIPYLcsw0C7c68vwHCk=
X-Received: by 2002:a05:6808:144f:: with SMTP id x15mr13374298oiv.172.1621932716817;
 Tue, 25 May 2021 01:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210525104551.2ec37f77@xhacker.debian>
In-Reply-To: <20210525104551.2ec37f77@xhacker.debian>
From:   Marco Elver <elver@google.com>
Date:   Tue, 25 May 2021 10:51:45 +0200
Message-ID: <CANpmjNOsEdTNsS0he-9AGCYrhX7RvgaB0p841CMyFW-puC6odg@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: mm: don't use CON and BLK mapping if KFENCE is enabled
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Potapenko <glider@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 May 2021 at 04:46, Jisheng Zhang <Jisheng.Zhang@synaptics.com> wrote:
> When we added KFENCE support for arm64, we intended that it would
> force the entire linear map to be mapped at page granularity, but we
> only enforced this in arch_add_memory() and not in map_mem(), so
> memory mapped at boot time can be mapped at a larger granularity.
>
> When booting a kernel with KFENCE=y and RODATA_FULL=n, this results in
> the following WARNING at boot:
>
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at mm/memory.c:2462 apply_to_pmd_range+0xec/0x190
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc1+ #10
> [    0.000000] Hardware name: linux,dummy-virt (DT)
> [    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO BTYPE=--)
> [    0.000000] pc : apply_to_pmd_range+0xec/0x190
> [    0.000000] lr : __apply_to_page_range+0x94/0x170
> [    0.000000] sp : ffffffc010573e20
> [    0.000000] x29: ffffffc010573e20 x28: ffffff801f400000 x27: ffffff801f401000
> [    0.000000] x26: 0000000000000001 x25: ffffff801f400fff x24: ffffffc010573f28
> [    0.000000] x23: ffffffc01002b710 x22: ffffffc0105fa450 x21: ffffffc010573ee4
> [    0.000000] x20: ffffff801fffb7d0 x19: ffffff801f401000 x18: 00000000fffffffe
> [    0.000000] x17: 000000000000003f x16: 000000000000000a x15: ffffffc01060b940
> [    0.000000] x14: 0000000000000000 x13: 0098968000000000 x12: 0000000098968000
> [    0.000000] x11: 0000000000000000 x10: 0000000098968000 x9 : 0000000000000001
> [    0.000000] x8 : 0000000000000000 x7 : ffffffc010573ee4 x6 : 0000000000000001
> [    0.000000] x5 : ffffffc010573f28 x4 : ffffffc01002b710 x3 : 0000000040000000
> [    0.000000] x2 : ffffff801f5fffff x1 : 0000000000000001 x0 : 007800005f400705
> [    0.000000] Call trace:
> [    0.000000]  apply_to_pmd_range+0xec/0x190
> [    0.000000]  __apply_to_page_range+0x94/0x170
> [    0.000000]  apply_to_page_range+0x10/0x20
> [    0.000000]  __change_memory_common+0x50/0xdc
> [    0.000000]  set_memory_valid+0x30/0x40
> [    0.000000]  kfence_init_pool+0x9c/0x16c
> [    0.000000]  kfence_init+0x20/0x98
> [    0.000000]  start_kernel+0x284/0x3f8
>
> Fixes: 840b23986344 ("arm64, kfence: enable KFENCE for ARM64")
> Cc: <stable@vger.kernel.org> # 5.12.x
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Marco Elver <elver@google.com>

Tested-by: Marco Elver <elver@google.com>

Thank you.

> ---
> Since v1:
>  - improve commit msg as Mark suggested
>  - add "Cc: stable@vger.kernel.org"
>  - collect Mark and Marco's Acks
>
>  arch/arm64/mm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 6dd9369e3ea0..89b66ef43a0f 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -515,7 +515,8 @@ static void __init map_mem(pgd_t *pgdp)
>          */
>         BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end));
>
> -       if (rodata_full || crash_mem_map || debug_pagealloc_enabled())
> +       if (rodata_full || crash_mem_map || debug_pagealloc_enabled() ||
> +           IS_ENABLED(CONFIG_KFENCE))
>                 flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>
>         /*
> --
> 2.31.0
>
