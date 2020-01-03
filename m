Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C3312F2C1
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 02:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgACBtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 20:49:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48834 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgACBtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 20:49:17 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1inC5F-000pFy-EG; Fri, 03 Jan 2020 01:49:01 +0000
Date:   Fri, 3 Jan 2020 01:49:01 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200103014901.GC8904@ZenIV.linux.org.uk>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <20200101004324.GA11269@ZenIV.linux.org.uk>
 <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 02:59:20PM +1100, Aleksa Sarai wrote:
> On 2020-01-01, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Thu, Jan 02, 2020 at 01:44:07AM +1100, Aleksa Sarai wrote:
> > 
> > > Thanks, this fixes the issue for me (and also fixes another reproducer I
> > > found -- mounting a symlink on top of itself then trying to umount it).
> > > 
> > > Reported-by: Aleksa Sarai <cyphar@cyphar.com>
> > > Tested-by: Aleksa Sarai <cyphar@cyphar.com>
> > 
> > Pushed into #fixes.
> 
> Thanks. One other thing I noticed is that umount applies to the
> underlying symlink rather than the mountpoint on top. So, for example
> (using the same scripts I posted in the thread):
> 
>   # ln -s /tmp/foo link
>   # ./mount_to_symlink /etc/passwd link
>   # umount -l link # will attempt to unmount "/tmp/foo"
> 
> Is that intentional?

It's a mess, again in mountpoint_last().  FWIW, at some point I proposed
to have nd_jump_link() to fail with -ELOOP if the target was a symlink;
Linus asked for reasons deeper than my dislike of the semantics, I looked
around and hadn't spotted anything.  And there hadn't been at the time,
but when four months later umount_lookup_last() went in I failed to look
for that source of potential problems in it ;-/

I've looked at that area again now.  Aside of usual cursing at do_last()
horrors (yes, its control flow is a horror; yes, it needs serious massage;
no, it's not a good idea to get sidetracked into that right now), there
are several fun questions:
	* d_manage() and d_automount().  We almost certainly don't
want those for autofs on the final component of pathname in umount,
including the trailing symlinks.  But do we want those on usual access
via /proc/*/fd/*?  I.e. suppose somebody does open() (O_PATH or not)
in autofs; do we want ->d_manage()/->d_automount() called when
resolving /proc/self/fd/<whatever>/foo/bar?  We do not; is that
correct from autofs point of view?  I suspect that refusing to
do ->d_automount() is correct, but I don't understand ->d_manage()
purpose well enough to tell.
	* I really hope that the weird "trailing / forces automount
even in cases when we normally wouldn't trigger it" (stat /mnt/foo
vs. stat /mnt/foo/) is not meant to extend to umount.  I'd like
Ian's confirmation, though.
	* do we want ->d_manage() on following .. into overmounted
directory?  Again, autofs question...

	The minimal fix to mountpoint_last() would be to have
follow_mount() done in LAST_NORM case.  However, I'd like to understand
(and hopefully regularize) the rules for follow_mount()/follow_managed().
Additional scary question is nfsd iterplay with automount.  For nfs4
exports it's potentially interesting...

	Ian, could you comment on the autofs questions above?
I'd rather avoid doing changes in that area without your input -
it's subtle and breakage in automount-related behaviour can be
mysterious as hell.
