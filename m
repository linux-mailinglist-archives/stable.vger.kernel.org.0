Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D4043CD49
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 17:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbhJ0PRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 11:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242685AbhJ0PRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 11:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCA2760FBF;
        Wed, 27 Oct 2021 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635347687;
        bh=d/hO+irUkRPAzOGdj54F3ss4yD7w6tan9uDNj2qHGIU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LnZpW/y7ZHNV2FSyWuS7JHO3QFfij5w3RLDLVKOON6tOCd+MufZc0b5YfFwuM1wqc
         BPKnxbmuopGdep3xmltXh/wM80r6X5rMipCh2dA+RUB9BswkVAREurb8ulMtNpbZCo
         1s7QTdjiNabd2gKYl7KNwwZHJF6smwDEBNCBg8TSbJMjK1oxwQCvPyxoxVZVrgQihl
         IPVzlcD9hyv7MxpCllAxpD7m/gCAQrq6eGdkQ6V9tQ0YNL3+KnFMpjJtZ/VsT23tIS
         +cOTOzMnXI4OUIDIygDLmAAgCHmXFgYW4CXqvFQbDub/DgUxNkE5fgeFtLynpowwGJ
         x1Ac2xpTBlvcw==
Received: by mail-oi1-f172.google.com with SMTP id q124so3881744oig.3;
        Wed, 27 Oct 2021 08:14:47 -0700 (PDT)
X-Gm-Message-State: AOAM531knRuUH23akYraNx7d5zD3nII8z4+SpMrk1zST3AbsurZKIC5J
        0peZJQFb414LVcA2+J3fj4Bje0YM9PkFakJ14mE=
X-Google-Smtp-Source: ABdhPJy9+vxFPsaLhxqGQzcobHUkMTWm501K6OCqjdgv4SmHSPBbSKIhFJ1CAnqbinO45Kdc680JobcJmsOS4WQU6bU=
X-Received: by 2002:a05:6808:1805:: with SMTP id bh5mr3986936oib.47.1635347687082;
 Wed, 27 Oct 2021 08:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
 <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com>
In-Reply-To: <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 27 Oct 2021 17:14:35 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
Message-ID: <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
Subject: Re: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as encrypted
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Oct 2021 at 17:11, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 10/22/21 12:02 PM, Tom Lendacky wrote:
> > Reserving memory using efi_mem_reserve() calls into the x86
> > efi_arch_mem_reserve() function. This function will insert a new EFI
> > memory descriptor into the EFI memory map representing the area of
> > memory to be reserved and marking it as EFI runtime memory.
> >
> > As part of adding this new entry, a new EFI memory map is allocated and
> > mapped. The mapping is where a problem can occur. This new EFI memory map
> > is mapped using early_memremap(). If the allocated memory comes from an
> > area that is marked as EFI_BOOT_SERVICES_DATA memory in the current EFI
> > memory map, then it will be mapped unencrypted (see memremap_is_efi_data()
> > and the call to efi_mem_type()).
> >
> > However, during replacement of the old EFI memory map with the new EFI
> > memory map, efi_mem_type() is disabled, resulting in the new EFI memory
> > map always being mapped encrypted in efi.memmap. This will cause a kernel
> > crash later in the boot.
> >
> > Since it is known that the new EFI memory map will always be mapped
> > encrypted when efi_memmap_install() is called, explicitly map the new EFI
> > memory map as encrypted (using early_memremap_prot()) when inserting the
> > new memory map entry.
> >
> > Cc: <stable@vger.kernel.org> # 4.14.x
> > Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>
> Ard, are you going to take this through the EFI tree or does it need to go
> through another tree?
>

I could take it, but since it will ultimately go through -tip anyway,
perhaps better if they just take it directly? (This will change after
the next -rc1 though)

Boris?
