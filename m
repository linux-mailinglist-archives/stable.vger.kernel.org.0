Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04BB24BCF
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 11:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfEUJix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 05:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:32840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfEUJiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 05:38:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ACE821479;
        Tue, 21 May 2019 09:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558431531;
        bh=DdIv1DA6LGbOnPVWvG4pWPp2UIabk717qQ4GREpPO/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G1Nqh8qCMqLn9yatKZMlXJDnUMNo+WOmLTpVYwILhkAac/0I7uFlZoP4NOcplcDrA
         6gu5XYwa2lLedMfBtgO2MjX638Z5nxlLBEB9yPJqw37CKaLM+iO7SSJ+HBykALE1lI
         1vYYJURYmXMGfIEE4nPcYSOyOmiCIf9qfzGdjXIE=
Date:   Tue, 21 May 2019 11:38:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Theodore Ts'o <tytso@mit.edu>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: ext4 regression (was Re: [PATCH 4.19 000/105] 4.19.45-stable review)
Message-ID: <20190521093849.GA9806@kroah.com>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520222342.wtsjx227c6qbkuua@xps.therub.org>
 <20190521085956.GC31445@kroah.com>
 <CA+G9fYvHmUimtwszwo=9fDQLn+MNh8Vq3UGPaPUdhH=dEKzqxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvHmUimtwszwo=9fDQLn+MNh8Vq3UGPaPUdhH=dEKzqxg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 02:58:58PM +0530, Naresh Kamboju wrote:
> On Tue, 21 May 2019 at 14:30, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, May 20, 2019 at 05:23:42PM -0500, Dan Rue wrote:
> > > On Mon, May 20, 2019 at 02:13:06PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.45 release.
> > > > There are 105 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed 22 May 2019 11:50:49 AM UTC.
> > > > Anything received after that time might be too late.
> > >
> > > We're seeing an ext4 issue previously reported at
> > > https://lore.kernel.org/lkml/20190514092054.GA6949@osiris.
> > >
> > > [ 1916.032087] EXT4-fs error (device sda): ext4_find_extent:909: inode #8: comm jbd2/sda-8: pblk 121667583 bad header/extent: invalid extent entries - magic f30a, entries 8, max 340(340), depth 0(0)
> > > [ 1916.073840] jbd2_journal_bmap: journal block not found at offset 4455 on sda-8
> > > [ 1916.081071] Aborting journal on device sda-8.
> > > [ 1916.348652] EXT4-fs error (device sda): ext4_journal_check_start:61: Detected aborted journal
> > > [ 1916.357222] EXT4-fs (sda): Remounting filesystem read-only
> > >
> > > This is seen on 4.19-rc, 5.0-rc, mainline, and next. We don't have data
> > > for 5.1-rc yet, which is presumably also affected in this RC round.
> > >
> > > We only see this on x86_64 and i386 devices - though our hardware setups
> > > vary so it could be coincidence.
> > >
> > > I have to run out now, but I'll come back and work on a reproducer and
> > > bisection later tonight and tomorrow.
> > >
> > > Here is an example test run; link goes to the spot in the ltp syscalls
> > > test where the disk goes into read-only mode.
> > > https://lkft.validation.linaro.org/scheduler/job/735468#L8081
> >
> > Odd, I keep hearing rumors of ext4 issues right now, but nothing
> > actually solid that I can point to.  Any help you can provide here would
> > be great.
> >
> 
> git bisect helped me to land on this commit,
> 
> # git bisect bad
> e8fd3c9a5415f9199e3fc5279e0f1dfcc0a80ab2 is the first bad commit
> commit e8fd3c9a5415f9199e3fc5279e0f1dfcc0a80ab2
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Apr 9 23:37:08 2019 -0400
> 
>     ext4: protect journal inode's blocks using block_validity
> 
>     commit 345c0dbf3a30872d9b204db96b5857cd00808cae upstream.
> 
>     Add the blocks which belong to the journal inode to block_validity's
>     system zone so attempts to deallocate or overwrite the journal due a
>     corrupted file system where the journal blocks are also claimed by
>     another inode.
> 
>     Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202879
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>     Cc: stable@kernel.org
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> :040000 040000 b8b6ce2577d60c65021e5cc1c3a38b32e0cbb2ff
> 747c67b159b33e4e1da414b1d33567a5da9ae125 M fs

Ah, many thanks for this bisection.

Ted, any ideas here?  Should I drop this from the stable trees, and you
revert it from Linus's?  Or something else?

Note, I do also have 170417c8c7bb ("ext4: fix block validity checks for
journal inodes using indirect blocks") in the trees, which was supposed
to fix the problem with this patch, am I missing another one as well?

(side note, it was mean not to mark 170417c8c7bb for stable, when the
patch it was fixing was marked for stable, I'm lucky I caught it...)

thanks,

greg k-h
