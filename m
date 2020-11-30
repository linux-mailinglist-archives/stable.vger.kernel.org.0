Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEFA2C90E4
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 23:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgK3WWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 17:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbgK3WWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 17:22:00 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C44C0613CF;
        Mon, 30 Nov 2020 14:21:20 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id x15so12963128ilq.1;
        Mon, 30 Nov 2020 14:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D1Ha7vRV9nbOHPM4HMdUKEIihDTBwTSbMBbTV7hrVUI=;
        b=j+CWilT1FBY6fMM8ajfbaA+07dZlElLPFHU1/04IJ7sn788bbTuQAzgcca2pxx21Rb
         SOwcGuhgzpr+fIpnt3+ScpdottCpVtVJS/l0fJDcY75qhGr9yHZztwDCXJrWaubPKuoU
         +rbOwZFQxdEIe0UkB+VlRZnE7S7PSYHfCXJVMDtLluJ+uWkfSqQAXCAPo9MAu8VsCxQc
         EK3kkCP27xhQX9D7jMuV/WPb6Fx7ZbytA6L9D+Dn/Trm1NlbhT9U25hpHR1+d9eXi0aP
         gTd19weVNs7ffk+nPo19gH1QwrRzj9h0QRDVSPCPy1BW7fkY/WCzP3w+X0JvZpfwWa7w
         DE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D1Ha7vRV9nbOHPM4HMdUKEIihDTBwTSbMBbTV7hrVUI=;
        b=Qb73CK9+8bm9h8UG2SBa2Qk7hk37HmedwU4PBunkKuCt+f6qjBnwsOjN5apXoUAxSx
         iW4hwfz/YUkNpkGZ9ivS5eW7VqeHhl24K8yT+8JELS0+l7CFU+DnBg0EW/XjcjuaLg5l
         zj3L6lHax1LPmDZC7pnDCge0nAO+25mFFDaw7AzWXeT2fDCkXhsYObK32YHI9vEmBx/U
         GYwktO+sVp9q2HSX3ccj15ihnHvppOP1wMmtk2yzi++dTlaD/4PFMWlQi5LbaXM1qvCg
         iLxwnXSgb0dx73jRb6YKZ/kfXgw0yyqgUom0WCeRsKALK979Fmg0Wssxb1UHnzHBCLIw
         2KWw==
X-Gm-Message-State: AOAM532JYXm/az02HaCdFNo28iLu1+yiDnPm8gjJWj1IpAoXlMMXSPMS
        0mv0d2smFHIci0q2iGqlrW6v3JD3GRHs0UXSCw==
X-Google-Smtp-Source: ABdhPJzQyDinxFmY7Qof9roEYRhRR7LsD+Vvl/77JXQu3t8Itz1DUfq/AeLqCIizcLtgMuYQhS5IdB8P89i1Ib8YOu4=
X-Received: by 2002:a05:6e02:603:: with SMTP id t3mr20342033ils.11.1606774879479;
 Mon, 30 Nov 2020 14:21:19 -0800 (PST)
MIME-Version: 1.0
References: <20201126155246.25961-1-jack@suse.cz> <CALCETrVaj6rnvqX2cxj3u++hg_XZD-Zo4iYUPTFDiwaO49xDrg@mail.gmail.com>
 <CAMzpN2gADAWBoTgKEgepCHVKoqOw3T_D_W30Q2-vJtQpfn0jwg@mail.gmail.com> <CALCETrXS8e9BRcpmSYqE5_Cvrt96wUOWK_P2bFWUkD2BozPNbg@mail.gmail.com>
In-Reply-To: <CALCETrXS8e9BRcpmSYqE5_Cvrt96wUOWK_P2bFWUkD2BozPNbg@mail.gmail.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Mon, 30 Nov 2020 17:21:08 -0500
Message-ID: <CAMzpN2gkNnqnT3hS4jaHTphO+KdZmC=9Hi4tXk3RV9C-EcwtLQ@mail.gmail.com>
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

On Fri, Nov 27, 2020 at 7:36 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Fri, Nov 27, 2020 at 2:30 PM Brian Gerst <brgerst@gmail.com> wrote:
> >
> > On Fri, Nov 27, 2020 at 1:13 PM Andy Lutomirski <luto@kernel.org> wrote:
> > >
> > > On Thu, Nov 26, 2020 at 7:52 AM Jan Kara <jack@suse.cz> wrote:
> > > >
> > > > Commit converting syscalls taking 64-bit arguments to new scheme of compat
> > > > handlers omitted converting fanotify_mark(2) which then broke the
> > > > syscall for 32-bit x86 builds. Add missed conversion. It is somewhat
> > > > cumbersome since we need to keep the original compat handler for all the
> > > > other 32-bit archs.
> > > >
> > >
> > > This is stupendously ugly.  I'm not really sure how this is supposed
> > > to work on any 32-bit arch.  I'm also not sure whether we should
> > > expect the SYSCALL_DEFINE macros to figure this out by themselves.
> >
> > It works on 32-bit arches because the compiler implicitly uses
> > consecutive input registers or stack slots for 64-bit arguments, and
> > some arches have alignment requirements that result in hidden padding.
> > x86-32 is different now because parameters are passed in via pt_regs,
> > and the 64-bit value has to explicitly be reassembled from the high
> > and low 32-bit values, just like in the compat case.
> >
>
> That was my guess.
>
> > I think the simplest way to handle this is add a wrapper in
> > arch/x86/kernel/sys_ia32.c with the other fs syscalls that need 64-bit
> > args.  That keeps this mess out of general code.
>
>
> Want to send a patch?

I settled on doing something along the same line as Jan, but in a more
generic way that lays the groundwork for converting more of these
arch-specific compat wrappers to a generic wrapper.

Patch coming soon.

--
Brian Gerst
