Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1DE23AFF1
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 00:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgHCWGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 18:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbgHCWGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 18:06:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C4BC06174A
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 15:06:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c10so596399pjn.1
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 15:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j0yp0NbFk1BjbaXmV0xOpZBsc0vdosH6qIpBX1oEU+8=;
        b=RT06J95wbl/z9RHYp6gw0wftwtVr0DYAxf3T6wVkANZyhatKAqKMRXjQGCrdowE4aK
         BP7ct2gRm5TjxJodWLZ7P//unWnKsCngn8YZaTQ3UDTnfL//M5JQVaGmVHme8sjY/HN0
         xKwkUsjVZioLvo2kkacLV+UPZBUCiYzjnpFkckkeEvmj35KV/UkvyTVKURiV69XidcKn
         hueXISwyXzc/5aswJQksO5iNSJkQCBegWyIV2VS4uBSNhwiX/j6M5WTZVa7D888x7kmf
         hBg6+SPoj6MH9XYIJ2TgwGS3vXUXD+alOhjVkrXLdBbdvd5KuyiPuFyXt3SEj32fVgSi
         V+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j0yp0NbFk1BjbaXmV0xOpZBsc0vdosH6qIpBX1oEU+8=;
        b=FiAX4NTCdDhlv646wH08ZWzXYdAHS4DhqppMRgxFIaDkcfZnmfKr2B7VY1rmg5/qXj
         XzJF6+8Pp5EswDOaEUSrUi5GCDvK6OUDzAmvLrgrMOzv9C+VB4hHBEN0ttgICliUAkYc
         LyRTzCyYVVOrUgB6qAUgdu/cBr+IPtRb11kaLuueg543ORbLsT9L9FCq8FH65JSgkXw2
         X2neH06e2VRGFf346k4nFSsFZNamr4m/vnLAaf/U1UYEpQwkMkbYoYsczt/zAov0Ax4x
         39ECvNKqYGjosLE4ln79OVnPXpuEniClBKpLv/p77oPOiFNS6p4ENxJgYMfwLI3Y33n5
         CRlw==
X-Gm-Message-State: AOAM5303VUMYLyTXJHQadtTXr3kC/wYXQv0AQGCILGR+Yq7jX527Urwl
        74OGfOX+Ht3HYBvmSv47lr91VmRZaUygHidIGO/w4w==
X-Google-Smtp-Source: ABdhPJykFREY81Y6/5cJ5cu6kgpKwUJzCiIN9Q7xASYZLDjCtQAXf5stcXj8BhAYsC8hzIDcgzb923Unk3KXAHLprEo=
X-Received: by 2002:a17:902:cb91:: with SMTP id d17mr16201957ply.223.1596492413065;
 Mon, 03 Aug 2020 15:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200730180340.1724137-1-ndesaulniers@google.com>
 <20200801103805.GD3046974@kroah.com> <CAKwvOdnDGCVLU-MrJweLOuVaCGuqhQxKtVJxbCN1R_xK8NFo3Q@mail.gmail.com>
In-Reply-To: <CAKwvOdnDGCVLU-MrJweLOuVaCGuqhQxKtVJxbCN1R_xK8NFo3Q@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 3 Aug 2020 15:06:41 -0700
Message-ID: <CAKwvOdmEGYbMu=tWYYQeVVPk80o-dOugsMBRXrGwOG8DyM_ePQ@mail.gmail.com>
Subject: Re: [PATCH 4.14.y] ARM: 8702/1: head-common.S: Clear lr before
 jumping to start_kernel()
To:     Greg KH <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Miles Chen <miles.chen@mediatek.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nicolas Pitre <nico@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 3, 2020 at 2:54 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Sat, Aug 1, 2020 at 3:38 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jul 30, 2020 at 11:03:40AM -0700, Nick Desaulniers wrote:
> > > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > >
> > > commit 59b6359dd92d18f5dc04b14a4c926fa08ab66f7c upstream.
> > >
> > > If CONFIG_DEBUG_LOCK_ALLOC=y, the kernel log is spammed with a few
> > > hundred identical messages:
> > >
> > >     unwind: Unknown symbol address c0800300
> > >     unwind: Index not found c0800300
> > >
> > > c0800300 is the return address from the last subroutine call (to
> > > __memzero()) in __mmap_switched().  Apparently having this address in
> > > the link register confuses the unwinder.
> > >
> > > To fix this, reset the link register to zero before jumping to
> > > start_kernel().
> > >
> > > Fixes: 9520b1a1b5f7a348 ("ARM: head-common.S: speed up startup code")
> > > Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > Acked-by: Nicolas Pitre <nico@linaro.org>
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > > ---
> > > Looks like this first landed in v4.15-rc1.  Without this, we can't tell
> > > during an unwind initiated from start_kernel() when to stop unwinding,
> > > which for the clang specific implementation of the arm frame pointer
> > > unwinder leads to dereferencing a garbage value, triggering an exception
> > > which has no fixup, triggering a panic, triggering an unwind, triggering
> > > an infinite loop that prevents booting. I have more patches to send
> > > upstream to make the unwinder more resilient, but it's ambiguous as to
> > > when to stop unwinding without this patch.
> >
> > Note, the "Fixes:" tag points at something in 4.15, not 4.14, so are you
> > _SURE_ this is needed in 4.14.y?
>
> It's a fair question, sorry I didn't notice and pre-emptively address.
>
> Yes.  Prior to 59b6359dd92d, the value in the link register (LR) was
> garbage left over from the calls to __memzero added in 9520b1a1b5f7.
> I suspect that after a `ret` instruction, the value in LR really

Sorry, rereading that `ret` is not an instruction on ARM; I may have
confused the assembler macro defined in
arch/arm/include/asm/assembler.h used in __turn_mmu_on to call into
__mmap_switched with being an actual instruction.  Maybe `I suspect
that after returning from a called frame, the value in LR really
shouldn't be used again.` would have been more precise.

> shouldn't be used again.
>
> Having garbage in LR when chasing frame pointers from an unwind
> started in start_kernel() makes it appear that there are further
> frames to unwind, hence the error noted in the commit message of
> 59b6359dd92d.
>
> Prior to 9520b1a1b5f7, the value in the LR was still garbage (so the
> Fixes tag referencing 9520b1a1b5f7 isn't super precise; it references
> the latest change that noticeably changed the value of LR, but it was
> still previously undefined what its last value was set to).  In fact,
> digging up the original suggestion from Ard regarding 59b6359dd92d:
> https://lore.kernel.org/linux-arm-kernel/CAKv+Gu8BSnn3XhUALM-CfPqw2zNxovvup4uHf1F4qYZZ5oVUaA@mail.gmail.com/
>
> > I don't think the patch itself is to blame here, it simply triggers an
> > existing issue in the unwinder (if my analysis is correct, of course)
>
> and yet 9520b1a1b5f7 was still cited in the Fixes tag of 59b6359dd92d.
> (I agree with Ard's analysis).  Yes, "c0800300 is the return address
> from the last subroutine call (to __memzero()) in __mmap_switched()"
> is correct, but I'd have argued this was broken even before
> 59b6359dd92d (which is Ard's point).  Forgive me if I'm
> misinterpreting your analysis, Ard.  Maybe that Fixes tag was the
> simplest to avoid backports to stable which would have had conflicts
> due to 9520b1a1b5f7 being a dependency?
>
> Looking at the callers of __mmap_switched, it's hard to tell who would
> have set the last value of LR, as there's divergent implementations
> based on whether or not there's MMU support.  I don't think it matters
> though, and that unwinding via frame pointer on ARM out of a path in
> start_kernel() was broken until 59b6359dd92d.  I suspect a combination
> of the frame pointer unwinder not being as popular on ARM (vs
> CONFIG_UNWINDER_ARM) and the lack of needing to unwind from
> start_kernel() (since unwinding occurs for exceptional cases like
> WARN_ON or panics) as sources that may have helped to keep this bug
> latent for a while.
>
> Here's the lore thread on 9520b1a1b5f7 FWIW, but there's nothing of
> interest there IMO.
> https://lore.kernel.org/linux-arm-kernel/1507044184-27152-1-git-send-email-geert+renesas@glider.be/
> --
> Thanks,
> ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
