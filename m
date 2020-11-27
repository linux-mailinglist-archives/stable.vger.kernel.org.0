Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3096F2C6D3B
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 23:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgK0Wal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 17:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgK0Waa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 17:30:30 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2F9C0613D1;
        Fri, 27 Nov 2020 14:30:28 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id y9so5860035ilb.0;
        Fri, 27 Nov 2020 14:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/o9AB5sxFmB6P6+LlPx890WM9LW9SfDitLHJttzL1v4=;
        b=djRq0/yxMPI5MCFmd23Vg22J3XiZVe07Ouzsl7ZNOI2Bzc1L7Z9JjLUCjdvvoLC+vZ
         e9XNtcgKrHOMuQ7TftT3nsXC69V+9e1zk/Js7aRkvaK2cwVJ7Cw9DMmKQK3obv51u1Tj
         jkdyRnrZQ4SAN0y36BeskYrOUcuHbNOXxY63Dy1EYZcLnhSyr4pOtAE2DB5BZU308Gua
         dG9WWdG5kgbTmkFRZxerVb1WYb7NYcJuapb4CtJiZO3Rcrfjl+x1Cfjsmi3oW+jP1GVo
         LMLsZpQG0yJeJs94Xz2h9KBCUodN+p6qV2+9tpSgi/5Myv5/zZBkKifuw0Fn5Xy5sRh+
         MKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/o9AB5sxFmB6P6+LlPx890WM9LW9SfDitLHJttzL1v4=;
        b=DHP2dxMGqvPon3b3+6p/txQznrZYuvDyas7DNZeqkOi96xwRTpRdlxSC5nXzj7qjmn
         28SgLQT9iqHjCnW325lqBcRt7XJTrOoo+9/t/jexOTY/1fyZlaqj5dvVhvnCMUIL/024
         A8wFwo/kpupGKtTlmUIMf3dy7KdKzY3wXvWwYcKDev/4itrvtKOObMzxFADpaHxRvWiX
         Q+N3KBT9OtcWimbpEjI/EwBi/mBDXtEpWUx6WdjlSiFSRVQmvoOUoweU3TWcJ0/v6BCV
         v+3w138jVKMMtLktUvPYu0BzJwnip7Esk4yEhmdHTqEU1kXwCL5dikFNx7Xe6taFZgC3
         saQg==
X-Gm-Message-State: AOAM533+aDUO7QHobCiMGGN0PJHrCXNIXDQFmF1Rp5fOTTL0Wod7+5qA
        /GYdAph8S0F7x+RvjgtM3jYIogeK9DSDYBny3Q==
X-Google-Smtp-Source: ABdhPJxAlJ9It81MGT+VkGPXRpNlnP/iJGMirRASXeYvPtuv4puDTMuHyfUfaeTAiUkHBUYPw/rfcAZOxRTd4aBV8u4=
X-Received: by 2002:a92:c690:: with SMTP id o16mr8721220ilg.172.1606516227771;
 Fri, 27 Nov 2020 14:30:27 -0800 (PST)
MIME-Version: 1.0
References: <20201126155246.25961-1-jack@suse.cz> <CALCETrVaj6rnvqX2cxj3u++hg_XZD-Zo4iYUPTFDiwaO49xDrg@mail.gmail.com>
In-Reply-To: <CALCETrVaj6rnvqX2cxj3u++hg_XZD-Zo4iYUPTFDiwaO49xDrg@mail.gmail.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Fri, 27 Nov 2020 17:30:15 -0500
Message-ID: <CAMzpN2gADAWBoTgKEgepCHVKoqOw3T_D_W30Q2-vJtQpfn0jwg@mail.gmail.com>
Subject: Re: [PATCH] fanotify: Fix fanotify_mark() on 32-bit x86
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, linux-arch <linux-arch@vger.kernel.org>,
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

On Fri, Nov 27, 2020 at 1:13 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Thu, Nov 26, 2020 at 7:52 AM Jan Kara <jack@suse.cz> wrote:
> >
> > Commit converting syscalls taking 64-bit arguments to new scheme of compat
> > handlers omitted converting fanotify_mark(2) which then broke the
> > syscall for 32-bit x86 builds. Add missed conversion. It is somewhat
> > cumbersome since we need to keep the original compat handler for all the
> > other 32-bit archs.
> >
>
> This is stupendously ugly.  I'm not really sure how this is supposed
> to work on any 32-bit arch.  I'm also not sure whether we should
> expect the SYSCALL_DEFINE macros to figure this out by themselves.

It works on 32-bit arches because the compiler implicitly uses
consecutive input registers or stack slots for 64-bit arguments, and
some arches have alignment requirements that result in hidden padding.
x86-32 is different now because parameters are passed in via pt_regs,
and the 64-bit value has to explicitly be reassembled from the high
and low 32-bit values, just like in the compat case.

I think the simplest way to handle this is add a wrapper in
arch/x86/kernel/sys_ia32.c with the other fs syscalls that need 64-bit
args.  That keeps this mess out of general code.

--
Brian Gerst
