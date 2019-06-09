Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D8F3AB18
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 20:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbfFISOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 14:14:42 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52616 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbfFISOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 14:14:42 -0400
Received: by mail-it1-f194.google.com with SMTP id l21so10016857ita.2
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 11:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QrmQgtot4PqjL1wSqJXodQ8ktBGYcHqGra4eQTyGZms=;
        b=nh5GGNE9CurE7rgpy3Nl9hGwop7f2Ae1DmdxJrS+vTvyLlLzxwV2vu6FpBrshO1AlQ
         B8MMMyYnTK+zdb+YytKX/FNRPgp3GkqrDj7KY0j2ifpJMeK+sxJ+UvLofcKMCysWrKh5
         gERxQUjZgW/Yngk7i1UPiREMntaTUT97hBCmn+I1riD1yXsXcr63TGtPpTXpCxdxzA23
         bilS+RoyIWu0YpdLiUqxqDtTLmkYH77PKVuUigpWP4WImdhXxbK9boLNkGrJA45FL9dS
         SbuR+N+vHZFQHASBN6Kl6ZSQYqfFx8sxsdMIIHtoYwrN7EhMdb9/2W8hEZN6kmh91C4w
         zyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QrmQgtot4PqjL1wSqJXodQ8ktBGYcHqGra4eQTyGZms=;
        b=PXFXhHJnX5c0NWT2ceckOvCJvn4N52BG0xVW5oMLJ1/WmenZJwPd8I96fMatL4xlXv
         qok7WqOotSLC9XRL1NKQi20WXfSxItbb9sX0eylWf/9eaAFx9QsCYbS75NXzbpMfhgFq
         Fjxu+MKNHHQ0bnHoE2N66GPeeQXk0xoAzbhob1QAl3rIbWksAffgAMVBvzz2zD9cliSg
         ywsLdH0dosaKjvO1X7Zhrb9VQucWeHk+Efwo1wDJdd6ZFpfe5OaQsywKazPqwSWzW5+B
         IsmDgHuQt69EJKzkXhZZdoi8/ySEobXk/GwsjWZgC/qG5SITC1wCVo3eWOXSnw7zVzo5
         VPsw==
X-Gm-Message-State: APjAAAU1fRW1vEsUZ2ShnzQEZrkoFzkFuWfjGhMExCbOaJ5OaSm7XyJ1
        q44CkSVmd/gDKtE9Ewfw6Im+2Dibab2NYKOgobBhDA==
X-Google-Smtp-Source: APXvYqyFGP0qOizcA9JeXKig2+nJD1y8SyNKskyZ+G1ya+nOEgNb+KQ+pVayfS4flXjeA98DrQnt9ingi8qkn41chyg=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr42380530jar.2.1560104081538;
 Sun, 09 Jun 2019 11:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190608114232.8731-1-sashal@kernel.org> <20190608114232.8731-17-sashal@kernel.org>
In-Reply-To: <20190608114232.8731-17-sashal@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 9 Jun 2019 20:14:29 +0200
Message-ID: <CAKv+Gu9ZJ42=NJWDX4+DgkMWaSEakNw-yYiUtsUE48D-V6=7-w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 17/49] efi/x86/Add missing error handling to
 old_memmap 1:1 mapping code
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Bradford <robert.bradford@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 8 Jun 2019 at 13:43, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Gen Zhang <blackgod016574@gmail.com>
>
> [ Upstream commit 4e78921ba4dd0aca1cc89168f45039add4183f8e ]
>
> The old_memmap flow in efi_call_phys_prolog() performs numerous memory
> allocations, and either does not check for failure at all, or it does
> but fails to propagate it back to the caller, which may end up calling
> into the firmware with an incomplete 1:1 mapping.
>
> So let's fix this by returning NULL from efi_call_phys_prolog() on
> memory allocation failures only, and by handling this condition in the
> caller. Also, clean up any half baked sets of page tables that we may
> have created before returning with a NULL return value.
>
> Note that any failure at this level will trigger a panic() two levels
> up, so none of this makes a huge difference, but it is a nice cleanup
> nonetheless.
>
> [ardb: update commit log, add efi_call_phys_epilog() call on error path]
>
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rob Bradford <robert.bradford@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-efi@vger.kernel.org
> Link: http://lkml.kernel.org/r/20190525112559.7917-2-ard.biesheuvel@linaro.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This was already discussed in the thread that proposed this patch for
stable: please don't queue this right now, the patches are more likely
to harm than hurt, and they certainly don't fix a security
vulnerability, as has been claimed.


> ---
>  arch/x86/platform/efi/efi.c    | 2 ++
>  arch/x86/platform/efi/efi_64.c | 9 ++++++---
>  2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 9061babfbc83..353019d4e6c9 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -86,6 +86,8 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
>         pgd_t *save_pgd;
>
>         save_pgd = efi_call_phys_prolog();
> +       if (!save_pgd)
> +               return EFI_ABORTED;
>
>         /* Disable interrupts around EFI calls: */
>         local_irq_save(flags);
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index ee5d08f25ce4..dfc809b31c7c 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -84,13 +84,15 @@ pgd_t * __init efi_call_phys_prolog(void)
>
>         if (!efi_enabled(EFI_OLD_MEMMAP)) {
>                 efi_switch_mm(&efi_mm);
> -               return NULL;
> +               return efi_mm.pgd;
>         }
>
>         early_code_mapping_set_exec(1);
>
>         n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
>         save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
> +       if (!save_pgd)
> +               return NULL;
>
>         /*
>          * Build 1:1 identity mapping for efi=old_map usage. Note that
> @@ -138,10 +140,11 @@ pgd_t * __init efi_call_phys_prolog(void)
>                 pgd_offset_k(pgd * PGDIR_SIZE)->pgd &= ~_PAGE_NX;
>         }
>
> -out:
>         __flush_tlb_all();
> -
>         return save_pgd;
> +out:
> +       efi_call_phys_epilog(save_pgd);
> +       return NULL;
>  }
>
>  void __init efi_call_phys_epilog(pgd_t *save_pgd)
> --
> 2.20.1
>
