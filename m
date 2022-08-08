Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CAA58C540
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 11:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241807AbiHHJFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 05:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242305AbiHHJFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 05:05:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DEB5F7D;
        Mon,  8 Aug 2022 02:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 265B7B80E23;
        Mon,  8 Aug 2022 09:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CBCC433B5;
        Mon,  8 Aug 2022 09:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659949542;
        bh=RF2SdFIhiwPt4oBrxuDbmq4YNTT8ezhy81qSFOfRSR0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I4gm/aQJNOKr21N37R7xiYbDrqodgQpzQvM3gSb5YF/pGv7fhCzbU/GL7pcv1B6ex
         zkPpipAf/vxaMemxWD5I2280ebRiqcZmsleHstk+kx6Fh94am6ioLKyj0wOqxcQa3F
         6pmB9yJO/TWW6uuFOOnMb+F8JvRRsTOa/TuolfJzIIJUgja/gslVzZOan+YJVxMy4D
         xIFAMsGLQDkc8GgzsrQ6KrxrK14LEYg9upChTra0PpDfaEOW0s/gfFcCCD4jmmMhwX
         N8QRVV4QoDpk+QCxjOX/EMSVYIwUDGO7jXoosPg+8nWXZ110Rb9u6KkaOI04IBsBIK
         +qAGea8C0ADkg==
Received: by mail-wr1-f53.google.com with SMTP id j7so10135658wrh.3;
        Mon, 08 Aug 2022 02:05:42 -0700 (PDT)
X-Gm-Message-State: ACgBeo1fA6qu47VmyXS2LiRAz9WAySUO3xyuXTyYrKav5hOWQcdrkL7x
        o9LkmfgY+sNDe6SCEofQUOkwSWClHlzjRLh92lA=
X-Google-Smtp-Source: AA6agR4uUL+3rQokRXnRPEMK6ddnOvaYlrfUQaDx5aomBrbujlWHGbCcPLCVkRY4fWtOlV0x29vElgkSmtHZEo2e8vk=
X-Received: by 2002:adf:d238:0:b0:21e:c972:7505 with SMTP id
 k24-20020adfd238000000b0021ec9727505mr11188772wrh.536.1659949541120; Mon, 08
 Aug 2022 02:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220808013118.313965-1-sashal@kernel.org> <20220808013118.313965-5-sashal@kernel.org>
In-Reply-To: <20220808013118.313965-5-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 8 Aug 2022 11:05:29 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGaOeDtFKCXwKo5Dt9DJneyS5fjnmoZZBmYeDZfYG6GiA@mail.gmail.com>
Message-ID: <CAMj1kXGaOeDtFKCXwKo5Dt9DJneyS5fjnmoZZBmYeDZfYG6GiA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.19 05/58] arm64: kernel: drop unnecessary PoC
 cache clean+invalidate
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>, catalin.marinas@arm.com,
        bp@suse.de, Jason@zx2c4.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 8 Aug 2022 at 03:31, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> [ Upstream commit 2e945851e26836c0f2d34be3763ddf55870e49fe ]
>
> Some early boot code runs before the virtual placement of the kernel is
> finalized, and we used to go back to the very start and recreate the ID
> map along with the page tables describing the virtual kernel mapping,
> and this involved setting some global variables with the caches off.
>
> In order to ensure that global state created by the KASLR code is not
> corrupted by the cache invalidation that occurs in that case, we needed
> to clean those global variables to the PoC explicitly.
>
> This is no longer needed now that the ID map is created only once (and
> the associated global variable updates are no longer repeated). So drop
> the cache maintenance that is no longer necessary.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Link: https://lore.kernel.org/r/20220624150651.1358849-9-ardb@kernel.org
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

NAK

This patch *must* *not* be backported. It will break the boot.

And again, *please* stop spamming people with broken backports like this.

Can you explain why it is justified to use a bot to generate hundreds
of patches, and leave it to overloaded maintainers to spot the ones
that are broken? Is it because your time is more valuable than mine?

I have already asked (and you have already agreed) to disregard all
patches authored by me from this broken-by-design process. But here we
are, with yet another set of broken patches queued up all the way back
to v5.15.

So please, don't use AUTOSEL on *any* patch that was authored by me. I
understand the concept of a -stable kernel. I known what cc:stable
means. I know that a fixes: tag means. I don't need help from your
bot, it is only causing grief.

Thanks,
Ard.


> ---
>  arch/arm64/kernel/kaslr.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
> index 418b2bba1521..d5542666182f 100644
> --- a/arch/arm64/kernel/kaslr.c
> +++ b/arch/arm64/kernel/kaslr.c
> @@ -13,7 +13,6 @@
>  #include <linux/pgtable.h>
>  #include <linux/random.h>
>
> -#include <asm/cacheflush.h>
>  #include <asm/fixmap.h>
>  #include <asm/kernel-pgtable.h>
>  #include <asm/memory.h>
> @@ -72,9 +71,6 @@ u64 __init kaslr_early_init(void)
>          * we end up running with module randomization disabled.
>          */
>         module_alloc_base = (u64)_etext - MODULES_VSIZE;
> -       dcache_clean_inval_poc((unsigned long)&module_alloc_base,
> -                           (unsigned long)&module_alloc_base +
> -                                   sizeof(module_alloc_base));
>
>         /*
>          * Try to map the FDT early. If this fails, we simply bail,
> @@ -174,13 +170,6 @@ u64 __init kaslr_early_init(void)
>         module_alloc_base += (module_range * (seed & ((1 << 21) - 1))) >> 21;
>         module_alloc_base &= PAGE_MASK;
>
> -       dcache_clean_inval_poc((unsigned long)&module_alloc_base,
> -                           (unsigned long)&module_alloc_base +
> -                                   sizeof(module_alloc_base));
> -       dcache_clean_inval_poc((unsigned long)&memstart_offset_seed,
> -                           (unsigned long)&memstart_offset_seed +
> -                                   sizeof(memstart_offset_seed));
> -
>         return offset;
>  }
>
> --
> 2.35.1
>
