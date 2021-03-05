Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952FB32E5CC
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCEKK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:10:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhCEKKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 05:10:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A28264FF0;
        Fri,  5 Mar 2021 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614939017;
        bh=numFBoZsiwdaodgh4tuxwLAj1LphR17Vl45n1IwC8LI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MHJf//4hQ0OM73ZW/EZKJFKS5svi8wmXsYm1EKWN4c6YKQhyx4m4xer/P2MBpNOF+
         7npXAC+t01DAqhj93lwMF/Nzq59MxnV3ZfrU4vkC5pUQZlbgqIde0bTgFX+Bhw6aW1
         Bv8B5RhQ7yGzMxMDizZGB9+lLefRPNQ/mMZW/wVQ=
Date:   Fri, 5 Mar 2021 11:10:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
Message-ID: <YEIDhyz3TgSKR8xu@kroah.com>
References: <20210302192700.399054668@linuxfoundation.org>
 <CA+G9fYsA7U7rzd=yGYQ=uWViY3_dXc4iY_pC-DM1K3R+gac19g@mail.gmail.com>
 <175fac9c-ac3f-bd82-9e5d-2c2970cfc519@roeck-us.net>
 <CA+G9fYtkrAs=ASaVVu6-Lnck8A6Pt_LGODxnpTYouvppbw_rbQ@mail.gmail.com>
 <CAHk-=wgxLTur2G5mvYKCXE4DkUo90T2Dy3X526sqJgOCm0gzNA@mail.gmail.com>
 <CA+G9fYsUJvLbaqOFkxYZJxZkgay92vxjjoD69C0+tS5kthZmoQ@mail.gmail.com>
 <YEHxNECRwr4Z4ka2@kroah.com>
 <CA+G9fYv5+T4Z1-7QqyyUht5U8vOQyaQr3O+wOq5TLxS4E9Uu_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv5+T4Z1-7QqyyUht5U8vOQyaQr3O+wOq5TLxS4E9Uu_g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 03:32:14PM +0530, Naresh Kamboju wrote:
> On Fri, 5 Mar 2021 at 14:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Mar 05, 2021 at 01:39:46PM +0530, Naresh Kamboju wrote:
> > > On Fri, 5 Mar 2021 at 02:45, Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > On Thu, Mar 4, 2021 at 9:56 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > > >
> > > > > On Thu, 4 Mar 2021 at 01:34, Guenter Roeck <linux@roeck-us.net> wrote:
> > > > > >
> > > > > > Upstream has:
> > > > > >
> > > > > > e71a8d5cf4b4 tty: fix up iterate_tty_read() EOVERFLOW handling
> > > > > > ddc5fda74561 tty: fix up hung_up_tty_read() conversion
> > > > >
> > > > > I have applied these two patches and the reported problem did not solve.
> > > >
> > > > Hmm. Upstream has:
> > > >
> > > > *  3342ff2698e9 ("tty: protect tty_write from odd low-level tty disciplines")
> > > > *  a9cbbb80e3e7 ("tty: avoid using vfs_iocb_iter_write() for
> > > > redirected console writes")
> > > > *  17749851eb9c ("tty: fix up hung_up_tty_write() conversion")
> > > > G  e71a8d5cf4b4 ("tty: fix up iterate_tty_read() EOVERFLOW handling")
> > > > G  ddc5fda74561 ("tty: fix up hung_up_tty_read() conversion")
> > > >  * c7135bbe5af2 ("tty: fix up hung_up_tty_write() conversion")
> > > >   d7fe75cbc23c ("tty: teach the n_tty ICANON case about the new
> > > > "cookie continuations" too")
> > > >   15ea8ae8e03f ("tty: teach n_tty line discipline about the new
> > > > "cookie continuations"")
> > > >   64a69892afad ("tty: clean up legacy leftovers from n_tty line discipline")
> > > > *  9bb48c82aced ("tty: implement write_iter")
> > > > *  dd78b0c483e3 ("tty: implement read_iter")
> > > > *  3b830a9c34d5 ("tty: convert tty_ldisc_ops 'read()' function to take
> > > > a kernel pointer")
> > > >
> > > > Where those ones marked with '*' seem to be in v5.10.y, and the one
> > > > prefixed with 'G' are the ones Guenter mentioned.
> > > >
> > > > (We seem to have the "tty: fix up hung_up_tty_write() conversion"
> > > > commit twice. I'm not sure how that happened, but whatever).
> >
> > I merged it through two different branches by applying it from email,
> > one for 5.10-final and one for 5.11-rc1, sorry about that.
> >
> > > > But that still leaves three commits that don't seem to be in 5.10.y:
> > > >
> > > >   d7fe75cbc23c ("tty: teach the n_tty ICANON case about the new
> > > > "cookie continuations" too")
> > > >   15ea8ae8e03f ("tty: teach n_tty line discipline about the new
> > > > "cookie continuations"")
> > > >   64a69892afad ("tty: clean up legacy leftovers from n_tty line discipline")
> > > >
> > > > and they might fix what are otherwise short reads. Which is allowed by
> > > > POSIX, afaik, but ..
> > > >
> > > > Do those three commits fix your test-case?
> > >
> > > Yes.
> > > As per your suggestion I've added these three patches and tested
> > > and the reported test case PASS now [1].
> > >
> > > This means I have five extra patches on top of the stable v5.10.20 tag.
> > >
> > > $ git log --oneline
> > > 8c1c1de499af tty: teach the n_tty ICANON case about the new "cookie
> > > continuations" too
> > > 02aada164879 tty: teach n_tty line discipline about the new "cookie
> > > continuations"
> > > fb0df6b17897 tty: clean up legacy leftovers from n_tty line discipline
> > > 429f7fc84d6a tty: fix up iterate_tty_read() EOVERFLOW handling
> > > d0d54bca80a8 tty: fix up hung_up_tty_read() conversion
> > > 83be32b6c9e5 (tag: v5.10.20, origin/linux-5.10.y) Linux 5.10.20
> >
> > That last commit, "tty: fix up hung_up_tty_read() conversion" is already
> > in 5.10.20 as e018e57fd5c0 ("tty: fix up hung_up_tty_write()
> > conversion"), it came in at 5.10.11, so how did you apply it again?
> 
> It is easy to confuse between read() and write().
> tty: fix up hung_up_tty_read() conversion
> tty: fix up hung_up_tty_write() conversion
> 
> Write() was there but read() is a commit that has been cherry-picked.

Ugh, you are right.

Ok, I think I have things correct in the queue, if not, please let me
know.

greg k-h
