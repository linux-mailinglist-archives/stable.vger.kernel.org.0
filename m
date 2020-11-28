Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108BA2C6DFD
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 01:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgK1Ail (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 19:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729677AbgK1Ag6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 19:36:58 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C83672224B
        for <stable@vger.kernel.org>; Sat, 28 Nov 2020 00:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606523800;
        bh=rlndTyZ07ltlrWHTqYBWYToR6dBHNbYRn2Phd8hj/mU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PgCGztmP82ygA1ZsSzxJ9a1GMWL3KxVVbaqgVpZRu4UprXuSXgSBiPfJQ5y5bvyI7
         F6LsIl5VQzjrVSGbaCyzWfq47gwl3WwPPbHzBXigJnwqnw+855mvFGIGjZ0ubDAJFT
         AYFDu+IPGTUGjMykmu4T5mxs3enNs2QrcoU08Lck=
Received: by mail-wr1-f50.google.com with SMTP id 23so7227076wrc.8
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 16:36:39 -0800 (PST)
X-Gm-Message-State: AOAM530gVXNcQ88mrkqzhCEOZCjHN9TCgZxexDtHIYF3auLo2c3B82cg
        MkYckzpC9uxMfsautx1o5vtehIqtefwZnpi19N1+TQ==
X-Google-Smtp-Source: ABdhPJyHzaToMneHQIlE/CQuox4gGtAV1aibN/c+MmVJ3U1vZACyFpmgVNo/aQXl4esq+dTc1TYGAfgXUmiUr2S50zM=
X-Received: by 2002:a5d:5482:: with SMTP id h2mr13958810wrv.18.1606523798379;
 Fri, 27 Nov 2020 16:36:38 -0800 (PST)
MIME-Version: 1.0
References: <20201126155246.25961-1-jack@suse.cz> <CALCETrVaj6rnvqX2cxj3u++hg_XZD-Zo4iYUPTFDiwaO49xDrg@mail.gmail.com>
 <CAMzpN2gADAWBoTgKEgepCHVKoqOw3T_D_W30Q2-vJtQpfn0jwg@mail.gmail.com>
In-Reply-To: <CAMzpN2gADAWBoTgKEgepCHVKoqOw3T_D_W30Q2-vJtQpfn0jwg@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 27 Nov 2020 16:36:24 -0800
X-Gmail-Original-Message-ID: <CALCETrXS8e9BRcpmSYqE5_Cvrt96wUOWK_P2bFWUkD2BozPNbg@mail.gmail.com>
Message-ID: <CALCETrXS8e9BRcpmSYqE5_Cvrt96wUOWK_P2bFWUkD2BozPNbg@mail.gmail.com>
Subject: Re: [PATCH] fanotify: Fix fanotify_mark() on 32-bit x86
To:     Brian Gerst <brgerst@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-arch <linux-arch@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 2:30 PM Brian Gerst <brgerst@gmail.com> wrote:
>
> On Fri, Nov 27, 2020 at 1:13 PM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Thu, Nov 26, 2020 at 7:52 AM Jan Kara <jack@suse.cz> wrote:
> > >
> > > Commit converting syscalls taking 64-bit arguments to new scheme of compat
> > > handlers omitted converting fanotify_mark(2) which then broke the
> > > syscall for 32-bit x86 builds. Add missed conversion. It is somewhat
> > > cumbersome since we need to keep the original compat handler for all the
> > > other 32-bit archs.
> > >
> >
> > This is stupendously ugly.  I'm not really sure how this is supposed
> > to work on any 32-bit arch.  I'm also not sure whether we should
> > expect the SYSCALL_DEFINE macros to figure this out by themselves.
>
> It works on 32-bit arches because the compiler implicitly uses
> consecutive input registers or stack slots for 64-bit arguments, and
> some arches have alignment requirements that result in hidden padding.
> x86-32 is different now because parameters are passed in via pt_regs,
> and the 64-bit value has to explicitly be reassembled from the high
> and low 32-bit values, just like in the compat case.
>

That was my guess.

> I think the simplest way to handle this is add a wrapper in
> arch/x86/kernel/sys_ia32.c with the other fs syscalls that need 64-bit
> args.  That keeps this mess out of general code.


Want to send a patch?

I also wonder if there's a straightforward way to statically check
this.  Maybe the syscall wrapper macros could be rigged up to avoid
emitting the ia32 stubs if there is a u64 or s64 arg, so the build
would fail if someone tries to stick one in the syscall tables.  I
tried to do this, but I got a bit lost in the macro maze and my
attempt didn't work.

--Andy
