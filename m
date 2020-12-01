Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4982C997F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgLAIay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:30:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:34848 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgLAIay (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:30:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9BC77AF45;
        Tue,  1 Dec 2020 08:30:11 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 55D931E131B; Tue,  1 Dec 2020 09:30:07 +0100 (CET)
Date:   Tue, 1 Dec 2020 09:30:07 +0100
From:   Jan Kara <jack@suse.cz>
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
Subject: Re: [PATCH] fanotify: Fix fanotify_mark() on 32-bit x86
Message-ID: <20201201083007.GA24488@quack2.suse.cz>
References: <20201126155246.25961-1-jack@suse.cz>
 <CALCETrVaj6rnvqX2cxj3u++hg_XZD-Zo4iYUPTFDiwaO49xDrg@mail.gmail.com>
 <CAMzpN2gADAWBoTgKEgepCHVKoqOw3T_D_W30Q2-vJtQpfn0jwg@mail.gmail.com>
 <CALCETrXS8e9BRcpmSYqE5_Cvrt96wUOWK_P2bFWUkD2BozPNbg@mail.gmail.com>
 <CAMzpN2gkNnqnT3hS4jaHTphO+KdZmC=9Hi4tXk3RV9C-EcwtLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMzpN2gkNnqnT3hS4jaHTphO+KdZmC=9Hi4tXk3RV9C-EcwtLQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 30-11-20 17:21:08, Brian Gerst wrote:
> On Fri, Nov 27, 2020 at 7:36 PM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Fri, Nov 27, 2020 at 2:30 PM Brian Gerst <brgerst@gmail.com> wrote:
> > >
> > > On Fri, Nov 27, 2020 at 1:13 PM Andy Lutomirski <luto@kernel.org> wrote:
> > > >
> > > > On Thu, Nov 26, 2020 at 7:52 AM Jan Kara <jack@suse.cz> wrote:
> > > > >
> > > > > Commit converting syscalls taking 64-bit arguments to new scheme of compat
> > > > > handlers omitted converting fanotify_mark(2) which then broke the
> > > > > syscall for 32-bit x86 builds. Add missed conversion. It is somewhat
> > > > > cumbersome since we need to keep the original compat handler for all the
> > > > > other 32-bit archs.
> > > > >
> > > >
> > > > This is stupendously ugly.  I'm not really sure how this is supposed
> > > > to work on any 32-bit arch.  I'm also not sure whether we should
> > > > expect the SYSCALL_DEFINE macros to figure this out by themselves.
> > >
> > > It works on 32-bit arches because the compiler implicitly uses
> > > consecutive input registers or stack slots for 64-bit arguments, and
> > > some arches have alignment requirements that result in hidden padding.
> > > x86-32 is different now because parameters are passed in via pt_regs,
> > > and the 64-bit value has to explicitly be reassembled from the high
> > > and low 32-bit values, just like in the compat case.
> > >
> >
> > That was my guess.
> >
> > > I think the simplest way to handle this is add a wrapper in
> > > arch/x86/kernel/sys_ia32.c with the other fs syscalls that need 64-bit
> > > args.  That keeps this mess out of general code.
> >
> >
> > Want to send a patch?
> 
> I settled on doing something along the same line as Jan, but in a more
> generic way that lays the groundwork for converting more of these
> arch-specific compat wrappers to a generic wrapper.

Cool, thanks for looking into this!

> Patch coming soon.

Looking forward to it :)

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
