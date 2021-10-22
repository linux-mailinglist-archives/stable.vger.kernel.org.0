Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CB943794B
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 16:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhJVOvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 10:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233269AbhJVOvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Oct 2021 10:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4D9861213;
        Fri, 22 Oct 2021 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634914123;
        bh=D7YiPLV5BWiABRuEJr1caIsL8j1JOmX/Rlc+/V7Zfbg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sHa0yAkhFeH0wZLIgP+ZI7JoVDO5tgcdXSeghzQbQK7n/dxfo66MH/BjWZ/GwXYsY
         1lmUGj33d6m9ZyKJVNRgOnfGQf6661uVPXTNjyiQVYf2SEd27wMupbpxE5k1cNCRpM
         Y7TGbObewe6NQWRkG0jIaqgVqtC6/OyDZcfm2mUoRVAe6k8KDCEsK8TLhu0x5e9V1T
         FZLL09ifW1DG2+8UYL7E9psr+jwEKpcegXa58VLfO9xnwswOxplLAXtGgmLgW5fSFr
         8ELzw3slNSG/FZEpwOCBZtuoxL1qo3u6UCLPNYi3DMe4PCTM2GBqA7Bf4muiaG2gcg
         N136D/QBNtSLQ==
Received: by mail-oi1-f169.google.com with SMTP id v77so5329881oie.1;
        Fri, 22 Oct 2021 07:48:43 -0700 (PDT)
X-Gm-Message-State: AOAM530FzKiqbAFhZAcm+0Y5Kh40LEFcrBIquFq8dAmAW//06pwQdR0l
        JzAGEUch7G6/YKkutBhKiWvdu8rqA6nFDzYeQFE=
X-Google-Smtp-Source: ABdhPJypGAKfqCWEfb5UwFvo4wdFO3IfTvhmWl1YbhLQa54b43BdKPBALNvuxXcnPQLKw9/L9/PCjOHfhxdGtFJefWc=
X-Received: by 2002:aca:4bc4:: with SMTP id y187mr92315oia.174.1634914123022;
 Fri, 22 Oct 2021 07:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <ebf1eb2940405438a09d51d121ec0d02c8755558.1634752931.git.thomas.lendacky@amd.com>
 <9d9ca009-93c5-acc3-7445-d514c7878478@amd.com>
In-Reply-To: <9d9ca009-93c5-acc3-7445-d514c7878478@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 22 Oct 2021 16:48:31 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEDPwORj=oeQJ66FVD6WMjpxWiXX1Y317izHzRH1c1ncw@mail.gmail.com>
Message-ID: <CAMj1kXEDPwORj=oeQJ66FVD6WMjpxWiXX1Y317izHzRH1c1ncw@mail.gmail.com>
Subject: Re: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 21 Oct 2021 at 15:21, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 10/20/21 1:02 PM, Tom Lendacky wrote:
> > Reserving memory using efi_mem_reserve() calls into the x86
> > efi_arch_mem_reserve() function. This function will insert a new EFI
> > memory descriptor into the EFI memory map representing the area of
> > memory to be reserved and marking it as EFI runtime memory. As part
> > of adding this new entry, a new EFI memory map is allocated and mapped.
> > The mapping is where a problem can occur. This new memory map is mapped
> > using early_memremap() and generally mapped encrypted, unless the new
> > memory for the mapping happens to come from an area of memory that is
> > marked as EFI_BOOT_SERVICES_DATA memory.

This bit already sounds dodgy to me. At runtime, anything provided by
the firmware that needs to be mapped unencrypted should be
identifiable as such, regardless of the memory type. So why is there a
special case for BS data?

> > In this case, the new memory will
> > be mapped unencrypted. However, during replacement of the old memory map,
> > efi_mem_type() is disabled, so the new memory map will now be long-term
> > mapped encrypted (in efi.memmap), resulting in the map containing invalid
> > data and causing the kernel boot to crash.
> >
> > Since it is known that the area will be mapped encrypted going forward,
> > explicitly map the new memory map as encrypted using early_memremap_prot().
> >
> > Cc: <stable@vger.kernel.org> # 4.14.x
> > Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > ---
> >   arch/x86/platform/efi/quirks.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> > index b15ebfe40a73..b0b848d6933a 100644
> > --- a/arch/x86/platform/efi/quirks.c
> > +++ b/arch/x86/platform/efi/quirks.c
> > @@ -277,7 +277,8 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
> >               return;
> >       }
> >
> > -     new = early_memremap(data.phys_map, data.size);
> > +     new = early_memremap_prot(data.phys_map, data.size,
> > +                               pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
>
> I should really have a comment above this as to why this version of the
> early_memremap is being used.
>
> Let me add that (and maybe work on the commit message a bit) and submit a
> v2. But I'll hold off for a bit in case any discussion comes about.
>

For the [backported] change itself (with the comment added)

Acked-by: Ard Biesheuvel <ardb@kernel.org>

but I'd still like to understand if we can improve the situation with BS data.
