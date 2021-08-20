Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754A53F313B
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 18:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbhHTQLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 12:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbhHTQLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 12:11:43 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F22C08EB27;
        Fri, 20 Aug 2021 09:04:51 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8A63A95D; Fri, 20 Aug 2021 18:04:47 +0200 (CEST)
Date:   Fri, 20 Aug 2021 18:04:18 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Ard Biesheuvel' <ardb@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Message-ID: <YR/SgrOiBLs53SJ5@8bytes.org>
References: <20210820073429.19457-1-joro@8bytes.org>
 <e43eb0d137164270bf16258e6d11879e@AcuMS.aculab.com>
 <YR9tSuLyX8QHV5Pv@8bytes.org>
 <f68a175362984e4abbb0a1da2004c936@AcuMS.aculab.com>
 <YR+Bxgq4aIo1DI8j@8bytes.org>
 <CAMj1kXHj12FQn_488V_9k9k_LE51K=7n3sS9QnN9gkhBgzw-Kw@mail.gmail.com>
 <cdd7869a14ad4021acfacffa3918981c@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdd7869a14ad4021acfacffa3918981c@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 03:46:11PM +0000, David Laight wrote:
> So load a temporary IDT so that you can detect invalid instructions
> and restore the UEFI IDT immediately afterwards?

Going forward with SEV-SNP, the IDT is not only needed for special
instructions, but also to detect when the hypervisor is doing fishy
things with the guests memory, which could happen at _any_ instruction
boundary.

> I'm guessing the GDT is changed in order to access all of physical
> memory (well enough to load the kernel).

The kernels GDT is needed to switch from 32-bit protected mode to long
mode, where it calls ExitBootServices().

I think the reason is to avoid compiling a 64-bit and a 32-bit EFI
library into the decompressor stub. With a 32-bit library the kernel
could call ExitBootServices() right away before it jumps to startup_32.
But it only has the 64-bit library, so it has to switch to long-mode
first before it make subsequent EFI calls.

> Could that be done using the LDT?
> It is unlikely that the UEFI cares about that?

Well, I guess it could work via the LDT too, but the current GDT
switching code if proven to work on exiting BIOSes and I'd rather not
change it to something less proven when there is no serious problem with
it.

> Is this 32bit non-paged code?
> Running that with a physical memory offset made my head hurt.

Yes, 32-bit EFI launches the kernel in 32-bit protected mode, paging
disabled. I think that it also has to use a flat segmentation model
without offsets. But someone who knows the EFI spec better than me can
correct me here :)

Regards,

	Joerg
