Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9271F66E42F
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 17:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjAQQ4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 11:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjAQQ4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 11:56:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631D6442C3;
        Tue, 17 Jan 2023 08:56:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A62D6CE1901;
        Tue, 17 Jan 2023 16:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4217DC433EF;
        Tue, 17 Jan 2023 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673974586;
        bh=awCNWH6g7iC9TQ3N6frBiPrp8RzZqPKgyt/xKy5+Jiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pj0stw7n9lbjyENNQ49z3XXqSi6KW8hjJYhTOhOEG18HH4QeclSR/dCoed+6xqQ6z
         cce5s7CFNM8lWJNW68bDzuW9sDaXpSGi/eSHWROOL3AKQaWPhkeZy2OKUEYCcHoiCh
         ZFis46o88QvIFxhytSD2zIHRUPNVki625AEO4k46WGwRpXqmMYY9QSXnbe7lkC3Ek7
         vBJp/4an4PKB3pOKqqTRrF6UqYSACaunit1bJDEUciDG0/p4WsjFpOet7KrleoCek9
         3FiHywENR3rlfqHNQ+ToO9eX6/q2RKyy2mdDRgCW3fhsougclBTebEM+GQdvuRBOPL
         qUkACBdRK66Vw==
Date:   Tue, 17 Jan 2023 16:56:19 +0000
From:   Lee Jones <lee@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, catalin.marinas@arm.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] arm64: efi: Execute runtime services from a
 dedicated stack
Message-ID: <Y8bTM3cbL3x9nhKa@google.com>
References: <20221205201210.463781-1-ardb@kernel.org>
 <20221205201210.463781-2-ardb@kernel.org>
 <Y7VXg5MCRyAJFmus@google.com>
 <CAMj1kXEYDHuRmUPvdMVj1H1fLoOKcr+qG6NDpufxwJa57jsWdg@mail.gmail.com>
 <Y7WloqaytMnC8ZIC@FVFF77S0Q05N>
 <CAMj1kXEaX_3yFT_GFruXbQj9gfDShH4arPjTQBqokKAGusi_Fw@mail.gmail.com>
 <Y7WpsPDF+7fux8l3@FVFF77S0Q05N>
 <CAMj1kXGQW5Nj81rjDu_bGM6M3tWUaFwgBSxpCWbgJ+JBUPuJJw@mail.gmail.com>
 <Y7awzMZs51t2/34D@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y7awzMZs51t2/34D@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 05 Jan 2023, Greg KH wrote:

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
> > >
> > 
> > In that case, let's drop these backports for the time being, and
> > collaborate on a solution that works for all of us.
> > 
> > Greg, could you please drop these again? Thanks.
> 
> Dropped now from all queues, thanks.

Now in Mainline as:

  18bba1843fc7f efi: rt-wrapper: Add missing include
  ff7a167961d1b arm64: efi: Execute runtime services from a dedicated stack

Would you be kind enough to re-collect them please?

Thank you.

-- 
Lee Jones [李琼斯]
