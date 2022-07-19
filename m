Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6451957A2D9
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 17:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbiGSPWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 11:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiGSPWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 11:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C0F564DE;
        Tue, 19 Jul 2022 08:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C036187E;
        Tue, 19 Jul 2022 15:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53442C341D1;
        Tue, 19 Jul 2022 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658244160;
        bh=ryGS06+LmqjSb5Ujquhch6JMs45p3hzZzQKwGwFq+Mw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kwTwWZRXEOAP9+Zn2/EvQLilsDUmiwGhrFw76PfCkjjxA1ce/Y3UxUXaA3qUDjLKg
         EHbPxEccFqGxk0N+C7ZOc3qMz93guM+Y3LHHeP39H3R0Y8bnaH9uge+k3QZUSQJQEP
         c9q2XbHmp8smHD8dDeasdV6ExPegMpMcHgXqXOEBM72OTQalcLIdJDvR6ipFI3TI0Q
         nJl99fVTE+V5JO1Aigb5e0jwwUrXh+TxUtWQsVjPBveSwKAsKXMsCdentkk2sETxmM
         dvggOos1C5YOKlLN5bOvo+Nc1yprTOtARE1gRykj7Y40MyTCU+afbg/2ajxuw/RxJp
         xxfdrd0mnyhMA==
Received: by mail-oi1-f174.google.com with SMTP id j70so7147598oih.10;
        Tue, 19 Jul 2022 08:22:40 -0700 (PDT)
X-Gm-Message-State: AJIora8L05pn30h+droXMlzQSa6SaoDdQg0+zjuhUxVOelt1N/KbCYw3
        MKWjnBAR+KMD1oVUKCzxVAUUzldi+BlxF/KtCsE=
X-Google-Smtp-Source: AGRyM1tZE+pdS/28PS9iGMb7jVOE2eBKi3Ed2B4gKTVTOmQ6rZ8oTR7X6Bh0PulzihjTPKCk+TlCHm8lwUZqMvdEOB4=
X-Received: by 2002:a05:6808:300b:b0:337:b697:b077 with SMTP id
 ay11-20020a056808300b00b00337b697b077mr16582790oib.126.1658244159437; Tue, 19
 Jul 2022 08:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220715194550.793957-1-cascardo@canonical.com>
 <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net> <YtWKK2ZLib1R7itI@zn.tnic>
 <CAHk-=wiWQOsxqE+tvZi_MjzGaqfG6Xo5AhbYXtiLWcKVVvbycQ@mail.gmail.com> <YtWqit2B3UYIWht1@zn.tnic>
In-Reply-To: <YtWqit2B3UYIWht1@zn.tnic>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 19 Jul 2022 17:22:28 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE128e76KWgRgHLM+WWHOzx_BJsWMw_2QgzbYTm3p9d-A@mail.gmail.com>
Message-ID: <CAMj1kXE128e76KWgRgHLM+WWHOzx_BJsWMw_2QgzbYTm3p9d-A@mail.gmail.com>
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
To:     Borislav Petkov <bp@suse.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jul 2022 at 20:46, Borislav Petkov <bp@suse.de> wrote:
>
> On Mon, Jul 18, 2022 at 11:34:02AM -0700, Linus Torvalds wrote:
> > Why would we have to protect the kernel from EFI?
>
> Yes, we cleared this up on IRC in the meantime.
>
> This was raised as a concern in case we don't trust EFI. But we cannot
> not (double negation on purpose) trust EFI because it can do whatever it
> likes anyway, "underneath" the OS.
>
> I'm keeping the UNTRAIN_RET-in-C diff in my patches/ folder, though - I
> get the feeling we might need it soon for something else.
>
> :-)
>

The code in question is a little trampoline that executes from the EFI
mixed mode 1:1 mapping of the kernel text, and never via the kernel
mapping, so we should just move it into .rodata instead (and fix up
the mixed mode virtual address map logic accordingly). I don't think
mapping the kernel text and rodata into the 1;1 EFI map is needed at
all, tbh, and the only thing we ever access via that mapping is that
little trampoline.

Something like

--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -176,7 +176,7 @@ virt_to_phys_or_null_size(void *va, unsigned long size)

 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
-       unsigned long pfn, text, pf, rodata;
+       unsigned long pfn, pf, rodata;
        struct page *page;
        unsigned npages;
        pgd_t *pgd = efi_mm.pgd;
@@ -222,7 +222,7 @@ int __init efi_setup_page_tables(unsigned long
pa_memmap, unsigned num_pages)
        /*
         * When making calls to the firmware everything needs to be 1:1
         * mapped and addressable with 32-bit pointers. Map the kernel
-        * text and allocate a new stack because we can't rely on the
+        * rodata and allocate a new stack because we can't rely on the
         * stack pointer being < 4GB.
         */
        if (!efi_is_mixed())
@@ -236,21 +236,11 @@ int __init efi_setup_page_tables(unsigned long
pa_memmap, unsigned num_pages)

        efi_mixed_mode_stack_pa = page_to_phys(page + 1); /* stack grows down */

-       npages = (_etext - _text) >> PAGE_SHIFT;
-       text = __pa(_text);
-       pfn = text >> PAGE_SHIFT;
-
-       pf = _PAGE_ENC;
-       if (kernel_map_pages_in_pgd(pgd, pfn, text, npages, pf)) {
-               pr_err("Failed to map kernel text 1:1\n");
-               return 1;
-       }
-
        npages = (__end_rodata - __start_rodata) >> PAGE_SHIFT;
        rodata = __pa(__start_rodata);
        pfn = rodata >> PAGE_SHIFT;

-       pf = _PAGE_NX | _PAGE_ENC;
+       pf = _PAGE_ENC;
        if (kernel_map_pages_in_pgd(pgd, pfn, rodata, npages, pf)) {
                pr_err("Failed to map kernel rodata 1:1\n");
                return 1;
diff --git a/arch/x86/platform/efi/efi_thunk_64.S
b/arch/x86/platform/efi/efi_thunk_64.S
index 854dd81804b7..d4ee75ebfad6 100644
--- a/arch/x86/platform/efi/efi_thunk_64.S
+++ b/arch/x86/platform/efi/efi_thunk_64.S
@@ -71,7 +71,9 @@ STACK_FRAME_NON_STANDARD __efi64_thunk
        pushq   $__KERNEL32_CS
        pushq   %rdi                    /* EFI runtime service address */
        lretq
+SYM_FUNC_END(__efi64_thunk)

+       .section ".rodata", "a"
 1:     movq    0x20(%rsp), %rsp
        pop     %rbx
        pop     %rbp
@@ -81,7 +83,6 @@ STACK_FRAME_NON_STANDARD __efi64_thunk
 2:     pushl   $__KERNEL_CS
        pushl   %ebp
        lret
-SYM_FUNC_END(__efi64_thunk)

        .bss
        .balign 8
