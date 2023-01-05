Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA1B65ED2E
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbjAENhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjAENhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:37:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7778232E9B;
        Thu,  5 Jan 2023 05:37:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED17BB81AD5;
        Thu,  5 Jan 2023 13:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B301C433F2;
        Thu,  5 Jan 2023 13:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672925853;
        bh=iRnVicVj4NzKZDdUr+nLGHjwYq7F1E9fzhvTI6ADrBk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=epA0MAzC0nn1lpZM6aUqwNQ6Xk/kkae8lQFXJDFcCTR0yzOLGlQ297XkqRMC6trop
         rstRanwmfRD2aIPy4MHojViIwgvqGOXee1KcRri1slrIKqSPbVk0SUCfHUqldfxwsx
         F+pRFn2UoQgoXjRhQLfPA2ScsCIWTCiaTqpmhSm85WPTb4cISh0kFN+zD4sP6M5wf7
         xQcP14g9Nlij/LVWKlDD9890PhUDdOa47lt3g1OOQO+gPzzyBIETtn82bHAmmpHa/3
         4JHqmva9fY7jqpGFw7ARiUZ3+x8lsXtm059ul/xv2DPQ1g471i+TBiTAIyq/sZHoO5
         yo67fxZzoHyag==
Received: by mail-lf1-f49.google.com with SMTP id bq39so47247102lfb.0;
        Thu, 05 Jan 2023 05:37:33 -0800 (PST)
X-Gm-Message-State: AFqh2krQTLGLzFtLGGk8LoirFiLRExpZuxg6Mw2v8G7bhASDpq8USdiB
        Li4Tmu8E0hWYbdYqJ2y5sH+b+1cNbt/CzAwKdIc=
X-Google-Smtp-Source: AMrXdXuU3Ja0msBcR5+dO7nvJZU80jl0cEkmXZyBb4VA1HcyeNZ0KXBf9+j6L8SbWJo6Vt6B9/bLufl+ECrzsHncGdU=
X-Received: by 2002:ac2:5dfa:0:b0:4b7:3a0:45d2 with SMTP id
 z26-20020ac25dfa000000b004b703a045d2mr2690266lfq.228.1672925851596; Thu, 05
 Jan 2023 05:37:31 -0800 (PST)
MIME-Version: 1.0
References: <20221205201210.463781-1-ardb@kernel.org> <20221205201210.463781-2-ardb@kernel.org>
 <Y7VXg5MCRyAJFmus@google.com> <CAMj1kXEYDHuRmUPvdMVj1H1fLoOKcr+qG6NDpufxwJa57jsWdg@mail.gmail.com>
 <Y7WloqaytMnC8ZIC@FVFF77S0Q05N> <CAMj1kXEaX_3yFT_GFruXbQj9gfDShH4arPjTQBqokKAGusi_Fw@mail.gmail.com>
 <Y7WpsPDF+7fux8l3@FVFF77S0Q05N> <CAMj1kXGQW5Nj81rjDu_bGM6M3tWUaFwgBSxpCWbgJ+JBUPuJJw@mail.gmail.com>
 <Y7bI/EN7GfTYkuT+@FVFF77S0Q05N>
In-Reply-To: <Y7bI/EN7GfTYkuT+@FVFF77S0Q05N>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 5 Jan 2023 14:37:20 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHKYucfDnk1iU32ye9K8FG=VgNGU+KTW0OJ06he4xMf6A@mail.gmail.com>
Message-ID: <CAMj1kXHKYucfDnk1iU32ye9K8FG=VgNGU+KTW0OJ06he4xMf6A@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: efi: Execute runtime services from a dedicated stack
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Lee Jones <lee@kernel.org>, stable@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, catalin.marinas@arm.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Jan 2023 at 13:56, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Wed, Jan 04, 2023 at 05:32:18PM +0100, Ard Biesheuvel wrote:
> > On Wed, 4 Jan 2023 at 17:30, Mark Rutland <mark.rutland@arm.com> wrote:
> > >
> > > On Wed, Jan 04, 2023 at 05:15:34PM +0100, Ard Biesheuvel wrote:
> > > > On Wed, 4 Jan 2023 at 17:13, Mark Rutland <mark.rutland@arm.com> wrote:
> > > > >
> > > > > On Wed, Jan 04, 2023 at 02:56:19PM +0100, Ard Biesheuvel wrote:
> > > > > > On Wed, 4 Jan 2023 at 11:40, Lee Jones <lee@kernel.org> wrote:
> > > > > > >
> > > > > > > On Mon, 05 Dec 2022, Ard Biesheuvel wrote:
> > > > > > >
> > > > > > > > With the introduction of PRMT in the ACPI subsystem, the EFI rts
> > > > > > > > workqueue is no longer the only caller of efi_call_virt_pointer() in the
> > > > > > > > kernel. This means the EFI runtime services lock is no longer sufficient
> > > > > > > > to manage concurrent calls into firmware, but also that firmware calls
> > > > > > > > may occur that are not marshalled via the workqueue mechanism, but
> > > > > > > > originate directly from the caller context.
> > > > > > > >
> > > > > > > > For added robustness, and to ensure that the runtime services have 8 KiB
> > > > > > > > of stack space available as per the EFI spec, introduce a spinlock
> > > > > > > > protected EFI runtime stack of 8 KiB, where the spinlock also ensures
> > > > > > > > serialization between the EFI rts workqueue (which itself serializes EFI
> > > > > > > > runtime calls) and other callers of efi_call_virt_pointer().
> > > > > > > >
> > > > > > > > While at it, use the stack pivot to avoid reloading the shadow call
> > > > > > > > stack pointer from the ordinary stack, as doing so could produce a
> > > > > > > > gadget to defeat it.
> > > > > > > >
> > > > > > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > > > > ---
> > > > > > > >  arch/arm64/include/asm/efi.h       |  3 +++
> > > > > > > >  arch/arm64/kernel/efi-rt-wrapper.S | 13 +++++++++-
> > > > > > > >  arch/arm64/kernel/efi.c            | 25 ++++++++++++++++++++
> > > > > > > >  3 files changed, 40 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > Could we have this in Stable please?
> > > > > > >
> > > > > > > Upstream commit: ff7a167961d1b ("arm64: efi: Execute runtime services from a dedicated stack")
> > > > > > >
> > > > > > > Ard, do we need Patch 2 as well, or can this be applied on its own?
> > > > > > >
> > > > > >
> > > > > > Thanks for the reminder.
> > > > > >
> > > > > > Only patch #1 is needed. It should be applied to v5.10 and later.
> > > > >
> > > > > Hold on, why did this go into mainline when I had an outstanding comment w.r.t.
> > > > > the stack unwinder?
> > > > >
> > > > > From your last reply to me there I was expecting a respin with that fixed.
> > > > >
> > > >
> > > > Apologies for the confusion.
> > > >
> > > > I have a patch for this queued up, but AIUI, that cannot be merged all
> > > > the way back to v5.10, so these need to remain separate changes in any
> > > > case.
> > > >
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c2530a04a73e6b75ed71ed14d09d7b42d6300013
> > >
> > > Ah, ok, thanks for the pointer!
> > >
> > > I'm a little uneasy here, still.
> > >
> > > By backporting this we're also backporting the new breakage of the stack
> > > unwinder, and the minimal change for backports would be to add the lock and not
> > > the new stack (which was added for additinoal robustness, not to fix the bug
> > > the lock fixes).
> > >
> > > I do appreciate that the additional stack is likely more useful than the
> > > occasional diagnostic output from the kernel, but it does seem like this has
> > > traded off one bug for another, and I'm just a little annoyed because I pointed
> > > that out before the first pull request was made.
> > >
> > > I do know that this isn't malicious, and I'm not trying to start a fight, but
> > > now we have to consider whether we want/need to backport a stack unwinder fix
> > > to account for this, and we hadn't had that discussion before.
> >
> > In that case, let's drop these backports for the time being, and
> > collaborate on a solution that works for all of us.
>
> Thanks!
>
> IIUC our options here are:
>
> 1) Create a cut-down patch for stable that just adds the new lock but leaves
>    out the new stack.
>

The lock by itself does nothing useful - it is only needed because
there is now a single stack that is shared by all callers of EFI
runtime code. The existing ones are serialized already, but ACPI may
invoke efi_call_virt_pointer() as well, which is why the additional
spinlock is required for completeness. However, that ACPI feature is
relatively recent (and I am not aware of any arm64 systems that
actually implement it in their firmware)

>    I may be missing a reason why that's insufficient or painful.
>

The reason for the backport is that it also allows us to stash the
shadow call stack pointer elsewhere, as storing it on the normal stack
as we do currently defeats the purpose.

> 2) Backport this *but* also backport the follow-up fixes from your other series:
>    https://lore.kernel.org/r/20230104174433.1259428-1-ardb@kernel.org
>
>    Above you mentioned something about v5.10, was that just to say that some
>    manual backporting was required, or that there was a structural problem that
>    would require more invasive changes / prerequisites?
>

This is when the shadow call stack was introduced. Apologies for not
making this clearer in the commit log.

> 3) Something else?
>
> My preference would be (1), but if we are encountering issue with stack size on
> stable kernels, then I'd be happy to help with manual backporting effort for
> (2), as long as we backported all the relevant bits in one go.
>
> Does that make sense, and does that sound reasonable to you?
>

What I had in mind (but did not communicate clearly) is to backport
the patch that introduces the new stack to v5.10 and later, and to
backport the patch that adds the stacktrace declaration as well, but
separately (and probably not all the way back to v5.10)
