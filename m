Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C921CBFF4
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 18:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390133AbfJDQCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 12:02:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47784 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389131AbfJDQCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 12:02:24 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iGQ27-0006Xd-Tl; Fri, 04 Oct 2019 16:02:20 +0000
Date:   Fri, 4 Oct 2019 17:02:19 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Varad Gautam <vrd@amazon.de>, stable@vger.kernel.org,
        Jan Glauber <jglauber@marvell.com>
Subject: Re: [PATCH] devpts: Fix NULL pointer dereference in dcache_readdir()
Message-ID: <20191004160219.GI26530@ZenIV.linux.org.uk>
References: <20191004140503.9817-1-christian.brauner@ubuntu.com>
 <20191004142748.GG26530@ZenIV.linux.org.uk>
 <20191004143301.kfzcut6a6z5owfee@wittgenstein>
 <20191004151058.GH26530@ZenIV.linux.org.uk>
 <20191004152526.adgg3a7u7jylfk4a@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004152526.adgg3a7u7jylfk4a@wittgenstein>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 05:25:28PM +0200, Christian Brauner wrote:
> On Fri, Oct 04, 2019 at 04:10:58PM +0100, Al Viro wrote:
> > On Fri, Oct 04, 2019 at 04:33:02PM +0200, Christian Brauner wrote:
> > > On Fri, Oct 04, 2019 at 03:27:48PM +0100, Al Viro wrote:
> > > > On Fri, Oct 04, 2019 at 04:05:03PM +0200, Christian Brauner wrote:
> > > > > From: Will Deacon <will@kernel.org>
> > > > > 
> > > > > Closing /dev/pts/ptmx removes the corresponding pty under /dev/pts/
> > > > > without synchronizing against concurrent path walkers. This can lead to
> > > > > 'dcache_readdir()' tripping over a 'struct dentry' with a NULL 'd_inode'
> > > > > field:
> > > > 
> > > > FWIW, vfs.git#fixes (or #next.dcache) ought to deal with that one.
> > > 
> > > Is it feasible to backport your changes? Or do we want to merge the one
> > > here first and backport?
> > 
> > I'm not sure.  The whole pile is backportable, all right (and the first commit
> 
> Ok. So here's what I propose: we'll merge this one as it seems an
> obvious fix to the problem and can easily be backported to stable
> kernels.
> Then you'll land your generic workaround alleviating callers from
> holding inode_lock(). Then I'll send a patch to remove the inode_lock()
> from devpts for master.
> If we see that your fix is fine to backport and has no performance
> impacts that you find unacceptable we backport it.

There's more than one bug here.
	* fucked up lockless traversals.  Affect anything that uses dcache_readdir()
	* devpts (and selinuxfs, while we are at it) running afoul of (implicit)
assumption by dcache_readdir() - that stuff won't get removed from under it
	* (possibly) cifs hitting the same on eviction by memory pressure alone
(no locked inodes anywhere in sight).  Possibly == if cifs IPC$ share happens to
show up non-empty (e.g. due to server playing silly buggers).
	* (possibly) cifs hitting *another* lovely issue - lookup in one subdirectory
of IPC$ root finding an alias for another subdirectory of said root, triggering
d_move() of dentry of the latter.  IF the name happens to be long enough to be
externally allocated and if dcache_readdir() on root is currently copying it to
userland, Bad Things(tm) will happen.  That one almost certainly depends upon the
server playing silly buggers and might or might not be possible.  I'm not familiar
enough with CIFS to tell.

The first 3 are dealt with by the first commit in that pile; the last one is
not.  devpts patch of yours would deal with a part of the second bug.
Performance regression comes with fixing the first one, which is also
quite real.  There might be a way to avoid that performance hit,
but it will be harder to backport.

FWIW, some discussion of that fun went in a thread shortly before the merge
window - look for "Possible FS race condition between iterate_dir and
d_alloc_parallel" on fsdevel.  Some of that went off-list, though...
