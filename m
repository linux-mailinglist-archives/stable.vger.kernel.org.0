Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CF049D323
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 21:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiAZUIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 15:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiAZUIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 15:08:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D89C06161C;
        Wed, 26 Jan 2022 12:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pBGfaiXr2odCJuv3v+l1X6S49qybF/E8gAqwCt/alyg=; b=bNRb4JYQwKcMtQW4Tp/TU3w8I3
        ly428vCW5JXET+V4u8AZVpNtDZjpRwugtd+nAEOdPmuqUFnVWqY1CPYdfc2qsGiDhRG0SjZDO7TXK
        Cjp/6ymK1ZruwOxLunpKfJhpV6nBgy791QPhu1OEJttaSO0kneif6k0bKzjAKHIYy7fYOIMwu0e2T
        D6ZRShV6NoPQdis8j8oZ+X9d4yGQ98iRcCsBrQ3/NkD4wfXwxsvf6b8+V0BjSZVhe+XAaOCCqS/KT
        347nnhtJbKi1omhIJ/dgkzXcy36MhVCMaYNF+2NK1vIpBbZLk32/qxevmbbwH9/jH6RCCAE3knupR
        M0BxGzmg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nCoaU-004PLG-HV; Wed, 26 Jan 2022 20:08:14 +0000
Date:   Wed, 26 Jan 2022 20:08:14 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jann Horn <jannh@google.com>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] fs/binfmt_elf: Add padding NULL when argc == 0
Message-ID: <YfGqLnE9wNieTsAg@casper.infradead.org>
References: <20220126175747.3270945-1-keescook@chromium.org>
 <CAG48ez3hN8+zNCmLVP0yU0A5op6BAS+A-rs05aiLm4RQvzzBpg@mail.gmail.com>
 <a89bb47f-677f-4ce7-fd-d3893fe0abbd@dereferenced.org>
 <CAG48ez3iEUDbM03axYSjWOSW+zt-khgzf8CfX1DHmf_6QZap6Q@mail.gmail.com>
 <202201261157.9C3D3C36@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202201261157.9C3D3C36@keescook>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 11:58:39AM -0800, Kees Cook wrote:
> On Wed, Jan 26, 2022 at 08:50:39PM +0100, Jann Horn wrote:
> > On Wed, Jan 26, 2022 at 7:42 PM Ariadne Conill <ariadne@dereferenced.org> wrote:
> > > On Wed, 26 Jan 2022, Jann Horn wrote:
> > > > On Wed, Jan 26, 2022 at 6:58 PM Kees Cook <keescook@chromium.org> wrote:
> > > >> Quoting Ariadne Conill:
> > > >>
> > > >> "In several other operating systems, it is a hard requirement that the
> > > >> first argument to execve(2) be the name of a program, thus prohibiting
> > > >> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
> > > >> but it is not an explicit requirement[1]:
> > > >>
> > > >>     The argument arg0 should point to a filename string that is
> > > >>     associated with the process being started by one of the exec
> > > >>     functions.
> > > >> ...
> > > >> Interestingly, Michael Kerrisk opened an issue about this in 2008[2],
> > > >> but there was no consensus to support fixing this issue then.
> > > >> Hopefully now that CVE-2021-4034 shows practical exploitative use[3]
> > > >> of this bug in a shellcode, we can reconsider."
> > > >>
> > > >> An examination of existing[4] users of execve(..., NULL, NULL) shows
> > > >> mostly test code, or example rootkit code. While rejecting a NULL argv
> > > >> would be preferred, it looks like the main cause of userspace confusion
> > > >> is an assumption that argc >= 1, and buggy programs may skip argv[0]
> > > >> when iterating. To protect against userspace bugs of this nature, insert
> > > >> an extra NULL pointer in argv when argc == 0, so that argv[1] != envp[0].
> > > >>
> > > >> Note that this is only done in the argc == 0 case because some userspace
> > > >> programs expect to find envp at exactly argv[argc]. The overlap of these
> > > >> two misguided assumptions is believed to be zero.
> > > >
> > > > Will this result in the executed program being told that argc==0 but
> > > > having an extra NULL pointer on the stack?
> > > > If so, I believe this breaks the x86-64 ABI documented at
> > > > https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf - page 29,
> > > > figure 3.9 describes the layout of the initial process stack.
> > >
> > > I'm presently compiling a kernel with the patch to see if it works or not.
> > >
> > > > Actually, does this even work? Can a program still properly access its
> > > > environment variables when invoked with argc==0 with this patch
> > > > applied? AFAIU the way userspace locates envv on x86-64 is by
> > > > calculating 8*(argc+1)?
> > >
> > > In the other thread, it was suggested that perhaps we should set up an
> > > argv of {"", NULL}.  In that case, it seems like it would be safe to claim
> > > argc == 1.
> > >
> > > What do you think?
> > 
> > Sounds good to me, since that's something that could also happen
> > normally if userspace calls execve(..., {"", NULL}, ...).
> > 
> > (I'd like it even better if we could just bail out with an error code,
> > but I guess the risk of breakage might be too high with that
> > approach?)
> 
> We can't mutate argc; it'll turn at least some userspace into an
> infinite loop:
> https://sources.debian.org/src/valgrind/1:3.18.1-1/none/tests/execve.c/?hl=22#L22

How does that become an infinite loop?  We obviously wouldn't mutate
argc in the caller, just the callee.

Also, there's a version of this where we only mutate argc if we're
executing a setuid program, which would remove the privilege
escalation part of things.
