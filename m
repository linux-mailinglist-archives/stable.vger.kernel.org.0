Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3233347525
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 10:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhCXJzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 05:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235231AbhCXJza (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 05:55:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8714B619FF;
        Wed, 24 Mar 2021 09:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616579730;
        bh=18uKbCpAadpjBgK+Ca0IQSHXhABhrG/iV9tFw88sKhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ye9LfB9hmX5e3A2Dxo1PVutttAPwXEVmUluZhUooCFY+ruAi/o6htRwseVSzmhIWe
         nItxfMwe/n6xzsOEDOGImsmA+/scsdT2QpS2n8I4mNJ1t8O5Jk6tACDUlB86gHxycK
         tFl8n7b/Nqp8DIzwl34A4w06HaQdR7uK7KdckwzA=
Date:   Wed, 24 Mar 2021 10:55:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] scripts: stable: add script to validate backports
Message-ID: <YFsMj3kL5Rl/Dc5R@kroah.com>
References: <20210316213136.1866983-1-ndesaulniers@google.com>
 <YFnyHaVyvgYl/qWg@kroah.com>
 <CAKwvOd=9HwLcTD8GaMsbEWiTPfZ+fj=vgFOefqBxDYkFiv_6YQ@mail.gmail.com>
 <YFo78StZ6Tq82hHJ@kroah.com>
 <CAKwvOdmL4cF7ConV8841BX+Pey571KDWM8CBt8NnYY47vJ_Gfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmL4cF7ConV8841BX+Pey571KDWM8CBt8NnYY47vJ_Gfg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 23, 2021 at 01:28:38PM -0700, Nick Desaulniers wrote:
> On Tue, Mar 23, 2021 at 12:05 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > The only time git gets involved is when we do a -rc release or when we
> > do a "real" release, and then we use 'git quiltimport' on the whole
> > stack.
> >
> > Here's a script that I use (much too slow, I know), for checking this
> > type of thing and I try to remember to run it before every cycle of -rc
> > releases:
> >         https://github.com/gregkh/commit_tree/blob/master/find_fixes_in_queue
> >
> > It's a hack, and picks up more things than is really needed, but I would
> > rather it error on that side than the other.
> 
> Yes, my script is similar.  Looks like yours also runs on a git tree.
> 
> I noticed that id_fixed_in runs `git grep -l --threads=3 <sha>` to
> find fixes; that's neat, I didn't know about `--threads=`.  I tried it
> with ae46578b963f manually:
> 
> $ git grep -l --threads=3 ae46578b963f
> $
> 
> Should it have found a7889c6320b9 and 773e0c402534?  Perhaps `git log
> --grep=<sha>` should be used instead?  I thought `git grep` only greps
> files in the archive, not commit history?

Yes, it does only grep the files in the archive.

But look closer at the archive that this script lives in :)

This archive is a "blown up" copy of the Linux kernel tree, with one
file per commit.  The name of the file is the commit id, and the content
of the file is the changelog of the commit itself.

So it's a hack that I use to be able to simply search the changelogs of
all commits to find out if they have a "Fixes:" tag with a specific
commit id in it.

So in your example above, in the repo I run it and get:

~/linux/stable/commit_tree $ git grep -l --threads=3 ae46578b963f
changes/5.2/773e0c40253443e0ce5491cb0e414b62f7cc45ed
ids/5.2

Which shows me that in commit 773e0c402534 ("afs: Fix
afs_xattr_get_yfs() to not try freeing an error value") in the kernel
tree, it has a "Fixes:" tag that references "ae46578b963f".

It also shows me that commit ae46578b963f was contained in the 5.2
kernel release, as I use the "ids/" subdirectory here for other fast
lookups (it's a tiny bit faster than 'git describe --contains').

I don't know how your script is walking through all possible commits to
see if they are fixing a specific one, maybe I should look and see if
it's doing it better than my "git tree/directory as a database hack"
does :)

thanks,

greg k-h
