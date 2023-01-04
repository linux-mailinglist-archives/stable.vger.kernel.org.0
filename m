Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B82665D9E1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjADQch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbjADQcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:32:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD0D1BE93;
        Wed,  4 Jan 2023 08:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D2D0B817AE;
        Wed,  4 Jan 2023 16:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17DDC433F1;
        Wed,  4 Jan 2023 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672849952;
        bh=7GyKVirKg9OeuaFHmIbNmJUmPfZFsfFyXfVupInFmWg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MKohCkUP+lPP0tIZI+HMEdHB75Enptwm3yD7VOueyCrV1TprCp+ruW9Ru0VU9n5/0
         j1L/z99DAspyEofXfqWmlM6JHseRLs6OTRrJv8IrNQVAkV8P/IkIn2MBfesOKZKcWG
         R6EFuTzIV/kWw9AoGQdi+jEgWhGRmNxGrObr1KqUvZSDgn7QOaLw5eYyg8eSqln7Sg
         t4Aw21emenuIHgxp2GHNRbjWUCfdf/nvJ8PeD7G27YG0WiVrQ0HOuL9VNyDLqRMKR9
         fSIMdOSTmenpuJR7wGQqih2am0/7fUI1qpzAEIA/VTof1wvEhs95+MF2DkhU9iSyQV
         1u6RFwblDo9fw==
Received: by mail-lj1-f174.google.com with SMTP id e13so33409240ljn.0;
        Wed, 04 Jan 2023 08:32:31 -0800 (PST)
X-Gm-Message-State: AFqh2ko1iokkvYjJ5v+IK25c2BYl4wUZrTfGMkWi+qr/0ny5NvW0c/pM
        rs+6DzCRBgkIvXplemQBkf4zaTKqatqMYMsKZpY=
X-Google-Smtp-Source: AMrXdXu8o8iikS0HZPeLCiQPZbgUNEs7UFS90MYfLNB82PTZKIi3/wxA7dnftEuiD1oTZxMZoLtXF6y6A22p/+uduS4=
X-Received: by 2002:a2e:a99b:0:b0:27f:b833:cf6d with SMTP id
 x27-20020a2ea99b000000b0027fb833cf6dmr2988898ljq.291.1672849949950; Wed, 04
 Jan 2023 08:32:29 -0800 (PST)
MIME-Version: 1.0
References: <20221205201210.463781-1-ardb@kernel.org> <20221205201210.463781-2-ardb@kernel.org>
 <Y7VXg5MCRyAJFmus@google.com> <CAMj1kXEYDHuRmUPvdMVj1H1fLoOKcr+qG6NDpufxwJa57jsWdg@mail.gmail.com>
 <Y7WloqaytMnC8ZIC@FVFF77S0Q05N> <CAMj1kXEaX_3yFT_GFruXbQj9gfDShH4arPjTQBqokKAGusi_Fw@mail.gmail.com>
 <Y7WpsPDF+7fux8l3@FVFF77S0Q05N>
In-Reply-To: <Y7WpsPDF+7fux8l3@FVFF77S0Q05N>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 4 Jan 2023 17:32:18 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGQW5Nj81rjDu_bGM6M3tWUaFwgBSxpCWbgJ+JBUPuJJw@mail.gmail.com>
Message-ID: <CAMj1kXGQW5Nj81rjDu_bGM6M3tWUaFwgBSxpCWbgJ+JBUPuJJw@mail.gmail.com>
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

On Wed, 4 Jan 2023 at 17:30, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Wed, Jan 04, 2023 at 05:15:34PM +0100, Ard Biesheuvel wrote:
> > On Wed, 4 Jan 2023 at 17:13, Mark Rutland <mark.rutland@arm.com> wrote:
> > >
> > > On Wed, Jan 04, 2023 at 02:56:19PM +0100, Ard Biesheuvel wrote:
> > > > On Wed, 4 Jan 2023 at 11:40, Lee Jones <lee@kernel.org> wrote:
> > > > >
> > > > > On Mon, 05 Dec 2022, Ard Biesheuvel wrote:
> > > > >
> > > > > > With the introduction of PRMT in the ACPI subsystem, the EFI rts
> > > > > > workqueue is no longer the only caller of efi_call_virt_pointer() in the
> > > > > > kernel. This means the EFI runtime services lock is no longer sufficient
> > > > > > to manage concurrent calls into firmware, but also that firmware calls
> > > > > > may occur that are not marshalled via the workqueue mechanism, but
> > > > > > originate directly from the caller context.
> > > > > >
> > > > > > For added robustness, and to ensure that the runtime services have 8 KiB
> > > > > > of stack space available as per the EFI spec, introduce a spinlock
> > > > > > protected EFI runtime stack of 8 KiB, where the spinlock also ensures
> > > > > > serialization between the EFI rts workqueue (which itself serializes EFI
> > > > > > runtime calls) and other callers of efi_call_virt_pointer().
> > > > > >
> > > > > > While at it, use the stack pivot to avoid reloading the shadow call
> > > > > > stack pointer from the ordinary stack, as doing so could produce a
> > > > > > gadget to defeat it.
> > > > > >
> > > > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > > ---
> > > > > >  arch/arm64/include/asm/efi.h       |  3 +++
> > > > > >  arch/arm64/kernel/efi-rt-wrapper.S | 13 +++++++++-
> > > > > >  arch/arm64/kernel/efi.c            | 25 ++++++++++++++++++++
> > > > > >  3 files changed, 40 insertions(+), 1 deletion(-)
> > > > >
> > > > > Could we have this in Stable please?
> > > > >
> > > > > Upstream commit: ff7a167961d1b ("arm64: efi: Execute runtime services from a dedicated stack")
> > > > >
> > > > > Ard, do we need Patch 2 as well, or can this be applied on its own?
> > > > >
> > > >
> > > > Thanks for the reminder.
> > > >
> > > > Only patch #1 is needed. It should be applied to v5.10 and later.
> > >
> > > Hold on, why did this go into mainline when I had an outstanding comment w.r.t.
> > > the stack unwinder?
> > >
> > > From your last reply to me there I was expecting a respin with that fixed.
> > >
> >
> > Apologies for the confusion.
> >
> > I have a patch for this queued up, but AIUI, that cannot be merged all
> > the way back to v5.10, so these need to remain separate changes in any
> > case.
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c2530a04a73e6b75ed71ed14d09d7b42d6300013
>
> Ah, ok, thanks for the pointer!
>
> I'm a little uneasy here, still.
>
> By backporting this we're also backporting the new breakage of the stack
> unwinder, and the minimal change for backports would be to add the lock and not
> the new stack (which was added for additinoal robustness, not to fix the bug
> the lock fixes).
>
> I do appreciate that the additional stack is likely more useful than the
> occasional diagnostic output from the kernel, but it does seem like this has
> traded off one bug for another, and I'm just a little annoyed because I pointed
> that out before the first pull request was made.
>
> I do know that this isn't malicious, and I'm not trying to start a fight, but
> now we have to consider whether we want/need to backport a stack unwinder fix
> to account for this, and we hadn't had that discussion before.
>

In that case, let's drop these backports for the time being, and
collaborate on a solution that works for all of us.

Greg, could you please drop these again? Thanks.
