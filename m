Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC4138858
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 22:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbgALVeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 16:34:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40248 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbgALVeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jan 2020 16:34:06 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iqkro-006qzE-Fy; Sun, 12 Jan 2020 21:33:52 +0000
Date:   Sun, 12 Jan 2020 21:33:52 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Ian Kent <raven@themaw.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200112213352.GP8904@ZenIV.linux.org.uk>
References: <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200108213444.GF8904@ZenIV.linux.org.uk>
 <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
 <20200110041523.GK8904@ZenIV.linux.org.uk>
 <979cf680b0fbdce515293a3449d564690cde6a3f.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <979cf680b0fbdce515293a3449d564690cde6a3f.camel@themaw.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 10, 2020 at 02:20:55PM +0800, Ian Kent wrote:

> Yeah, autofs ->d_automount() doesn't return -EISDIR, by the time
> we get there it's not relevant any more, so that check looks
> redundant. I'm not aware of any other fs automount implementation
> that needs that EISDIR pass-thru function.
> 
> I didn't notice it at the time of the merge, sorry about that.
> 
> While we're at it that:
>    if (!path->dentry->d_op || !path->dentry->d_op->d_automount)
>        return -EREMOTE;
> 
> at the top of follow_automount() isn't going to be be relevant
> for autofs because ->d_automount() really must always be defined
> for it.
> 
> But, at the time of the merge, I didn't object to it because
> there were (are) other file systems that use the VFS automount
> function which may accidentally not define the method.

OK...

> > Unfortunately, there are other interesting questions related to
> > autofs-specific bits (->d_manage()) and the timezone-related fun
> > is, of course, still there.  I hope to sort that out today or
> > tomorrow, at least enough to do a reasonable set of backportable
> > fixes to put in front of follow_managed()/step_into() queue.
> > Oh, well...
> 
> Yeah, I know it slows you down but I kink-off like having a chance

Nice typo, that ;-)

> to look at what's going and think about your questions before trying
> to answer them, rather than replying prematurely, as I usually do ...
> 
> It's been a bit of a busy day so far but I'm getting to look into
> the questions you've asked.

Here's a bit more of those (I might've missed some of your replies on
IRC; my apologies if that's the case):

1) AFAICS, -EISDIR from ->d_manage() actually means "don't even try
->d_automount() here".  If its effect can be delayed until the decision
to call ->d_automount(), the things seem to get simpler.  Is it ever
returned in situation when the sucker _is_ overmounted?

2) can autofs_d_automount() ever be called for a daemon?  Looks like it
shouldn't be...

3) is _anything_ besides root directory ever created in direct autofs
superblocks by anyone?  If not, why does autofs_lookup() even bother to
do anything there?  IOW, why not have it return ERR_PTR(-ENOENT) immediately
for direct ones?  Or am I missing something and it is, in fact, possible
to have the daemon create something in those?

4) Symlinks look like they should qualify for parent being non-empty;
at least autofs_d_manage() seems to think so (simple_empty() use).
So shouldn't we remove the trap from its parent on symlink/restore on
unlink if parent gets empty?  For version 4 or earlier, that is.  Or is
it simply that daemon only creates symlinks in root directory?


Anyway, intermediate state of the series is in #work.namei right now,
and some _very_ interesting possibilities open up.  It definitely
needs more massage around __follow_mount_rcu() (as it is, the
fastpath in there is still too twisted).  Said that
	* call graph is less convoluted
	* follow_managed() calls are folded into step_into().  Interface:
int step_into(nd, flags, dentry, inode, seq), with inode/seq used only
if we are in RCU mode.
	* ".." still doesn't use that; it probably ought to.
	* lookup_fast() doesn't take path - nd, &inode, &seq and returns dentry
	* lookup_open() and fs/namei.c:atomic_open() get similar treatment
- don't take path, return dentry.
	* calls of follow_managed()/step_into() combination returning 1
are always followed by get_link(), and very shortly, at that.  So much
that we can realistically merge pick_link() (in the end of
step_into()) with get_link().  That merge is NOT done in this branch yet.

The last one promises to get rid of a rather unpleasant group of calling
conventions.  Right now we have several functions (step_into()/
walk_component()/lookup_last()/do_last()) with the following calling
conventions:
	-E...	=> error
	0	=> non-symlink or symlink not followed; nd->path points to it
	1	=> picked a symlink to follow; its mount/dentry/seq has been
pushed on nd->stack[]; its inode is stashed into nd->link_inode for
subsequent get_link() to pick.  nd->path is left unchanged.

That way all of those become
	ERR_PTR(-E...)	=> error
	NULL		=> non-symlink, symlink not followed or a pure
jump (bare "/" or procfs ones); nd->path points to where we end up
        string		=> symlink being followed; the sucker's pushed
to stack, initial jump (if any) has been handled and the string returned
is what we need to traverse.

IMO it's less arbitrary that way.  More importantly, the separation between
step_into() committing to symlink traversal and (inevitably following)
get_link() is gone - it's one operation after that change.  No nd->link_inode
either - it's only needed to carry the information from pick_link() to the
next get_link().

Loops turn into
	while (!(err = link_path_walk(nd, s)) &&
	       (s = lookup_last(nd)) != NULL)
		;
and
	while (!(err = link_path_walk(nd, s)) &&
	       (s = do_last(nd, file, op)) != NULL)
		;

trailing_symlink() goes away (folded into pick_link()/get_link() combo,
conditional upon nd->depth at the entry).  And in link_path_walk() we'll
have
                if (unlikely(!*name)) {
                        /* pathname body, done */
                        if (!nd->depth)
                                return 0;
                        name = nd->stack[nd->depth - 1].name;
                        /* trailing symlink, done */
                        if (!name)
                                return 0;
                        /* last component of nested symlink */
                        s = walk_component(nd, WALK_FOLLOW);
                } else {
                        /* not the last component */
                        s = walk_component(nd, WALK_FOLLOW | WALK_MORE);
                }
                if (s) {
                        if (IS_ERR(s))
                                return PTR_ERR(s);
			/* a symlink to follow */
			nd->stack[nd->depth - 1].name = name;
                        name = s;
                        continue;
                }

Anyway, before I try that one I'm going to fold path_openat2() into
that series - that step is definitely going to require some massage
there; it's too close to get_link() changes done in Aleksa's series.

If we do that, we get a single primitive for "here's the result of
lookup; traverse mounts and either move into the result or, if
it's a symlink that needs to be traversed, start the symlink
traversal - jump into the base position for it (if needed) and
return the pathname that needs to be handled".  As it is, mainline
has that logics spread over about a dozen locations...

Diffstat at the moment:
 fs/autofs/dev-ioctl.c |   6 +-
 fs/internal.h         |   1 -
 fs/namei.c            | 460 ++++++++++++++------------------------------------
 fs/namespace.c        |  97 +++++++----
 fs/nfs/nfstrace.h     |   2 -
 fs/open.c             |   4 +-
 include/linux/namei.h |   3 +-
 7 files changed, 197 insertions(+), 376 deletions(-)

In the current form the sucker appears to work (so far - about 30%
into the usual xfstests run) without visible slowdowns...
