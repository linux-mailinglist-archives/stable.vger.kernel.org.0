Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D71133976
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 04:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgAHDNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 22:13:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45740 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgAHDNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 22:13:34 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip1mU-003zkK-H9; Wed, 08 Jan 2020 03:13:14 +0000
Date:   Wed, 8 Jan 2020 03:13:14 +0000
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
Message-ID: <20200108031314.GE8904@ZenIV.linux.org.uk>
References: <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <20200101004324.GA11269@ZenIV.linux.org.uk>
 <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103014901.GC8904@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 01:49:01AM +0000, Al Viro wrote:

> It's a mess, again in mountpoint_last().  FWIW, at some point I proposed
> to have nd_jump_link() to fail with -ELOOP if the target was a symlink;
> Linus asked for reasons deeper than my dislike of the semantics, I looked
> around and hadn't spotted anything.  And there hadn't been at the time,
> but when four months later umount_lookup_last() went in I failed to look
> for that source of potential problems in it ;-/
> 
> I've looked at that area again now.  Aside of usual cursing at do_last()
> horrors (yes, its control flow is a horror; yes, it needs serious massage;
> no, it's not a good idea to get sidetracked into that right now), there
> are several fun questions:
> 	* d_manage() and d_automount().  We almost certainly don't
> want those for autofs on the final component of pathname in umount,
> including the trailing symlinks.  But do we want those on usual access
> via /proc/*/fd/*?  I.e. suppose somebody does open() (O_PATH or not)
> in autofs; do we want ->d_manage()/->d_automount() called when
> resolving /proc/self/fd/<whatever>/foo/bar?  We do not; is that
> correct from autofs point of view?  I suspect that refusing to
> do ->d_automount() is correct, but I don't understand ->d_manage()
> purpose well enough to tell.
> 	* I really hope that the weird "trailing / forces automount
> even in cases when we normally wouldn't trigger it" (stat /mnt/foo
> vs. stat /mnt/foo/) is not meant to extend to umount.  I'd like
> Ian's confirmation, though.
> 	* do we want ->d_manage() on following .. into overmounted
> directory?  Again, autofs question...

FWIW, I suspect that we want to do something along the following lines:

1) make build_open_flags() treat O_CREAT | O_EXCL as if there had been
O_NOFOLLOW in the mix.  Reason: if there is a trailing symlink, we want
to fail with EEXIST anyway.  Benefit: this fragment in do_last()
        error = follow_managed(&path, nd);
        if (unlikely(error < 0))
                return error;

        /*
         * create/update audit record if it already exists.
         */
        audit_inode(nd->name, path.dentry, 0);

        if (unlikely((open_flag & (O_EXCL | O_CREAT)) == (O_EXCL | O_CREAT))) {
                path_to_nameidata(&path, nd);
                return -EEXIST;
        }

        seq = 0;        /* out of RCU mode, so the value doesn't matter */
        inode = d_backing_inode(path.dentry);
finish_lookup:  
        error = step_into(nd, &path, 0, inode, seq);
        if (unlikely(error))
                return error;
can become
        error = follow_managed(&path, nd);
        if (unlikely(error < 0))
                return error;

        seq = 0;        /* out of RCU mode, so the value doesn't matter */
        inode = d_backing_inode(path.dentry);
finish_lookup:  
        error = step_into(nd, &path, 0, inode, seq);
        if (unlikely(error))
                return error;

        if (unlikely((open_flag & (O_EXCL | O_CREAT)) == (O_EXCL | O_CREAT))) {
		audit_inode(nd->name, nd->path.dentry, 0);
                return -EEXIST;
        }
Equivalent transformation, since the the only goto finish_lookup; is under
if (!(open_flag & O_CREAT)).  What it buys us is more regular structure
of follow_managed() callers.

2) make follow_managed() take &inode and &seq.  Look: follow_managed() never
returns 0 (we have
        if (ret == -EISDIR || !ret)
                ret = 1;
on the way to the only return in it) and the callers are
        err = follow_managed(path, nd);
        if (likely(err > 0))
                *inode = d_backing_inode(path->dentry);
        return err;
in lookup_fast(),
                err = follow_managed(&path, nd);
                if (unlikely(err < 0))
                        return err;

                seq = 0;        /* we are already out of RCU mode */
                inode = d_backing_inode(path.dentry);
in walk_component(),
                err = follow_managed(&path, nd);
                if (unlikely(err < 0))
                        return err;
                inode = d_backing_inode(path.dentry);
                seq = 0;
in handle_lookup_down() and (after the previous change)
        error = follow_managed(&path, nd);
        if (unlikely(error < 0))
                return error;

        seq = 0;        /* out of RCU mode, so the value doesn't matter */
        inode = d_backing_inode(path.dentry);
in do_last().  That's begging to fold those followups into follow_managed()
itself, doesn't it?  And having *seqp = 0; equivalent added in lookup_fast()
is not going to hurt the performance - in all callers it's an address of
local variable, right next to the one whose address is passed as inodep.
Which we'd just dirtied, and the cacheline is not going to have been shared
anyway.

Note that after that the arguments for follow_managed() become identical
to those for __follow_mount_rcu().  Which makes a lot of sense, since
the latter is RCU-mode counterpart of the former.

3) have the followup to failing __follow_mount_rcu() taken into it.
After (2) we have this in lookup_fast():

                *seqp = seq;
                status = d_revalidate(dentry, nd->flags);
                if (likely(status > 0)) {
                        /*
                         * Note: do negative dentry check after revalidation in
                         * case that drops it.
                         */
                        if (unlikely(negative))
                                return -ENOENT;
                        path->mnt = mnt;
                        path->dentry = dentry;
                        if (likely(__follow_mount_rcu(nd, path, inode, seqp)))
                                return 1;
                }
                if (unlazy_child(nd, dentry, seq))
                        return -ECHILD;
                if (unlikely(status == -ECHILD))
                        /* we'd been told to redo it in non-rcu mode */
                        status = d_revalidate(dentry, nd->flags);
        } else {   
		...
	}
        if (unlikely(status <= 0)) {
                if (!status)
                        d_invalidate(dentry);
                dput(dentry);
                return status;
        }

        path->mnt = mnt;
        path->dentry = dentry;
        return follow_managed(path, nd, inode, seqp);

Suppose __follow_mount_rcu() returns false; what follows is
                if (unlazy_child(nd, dentry, seq))
                        return -ECHILD;
seq here is equal to *seqp here, dentry - the value of path->dentry at the
time of __follow_mount_rcu() call.
                if (unlikely(status == -ECHILD))
			....
not taken - we know that status must have been positive
        if (unlikely(status <= 0)) {
		...
	}
ditto
        path->mnt = mnt;
        path->dentry = dentry;
        return follow_managed(path, nd, inode, seqp);
we return *path to original and call follow_managed().  IOW, we could bloody
well do all of that in the __follow_mount_rcu() itself, having it return 1
when the original would've returned true and doing that "revert *path,
call unlazy_child() and fall back to follow_mount_rcu() in case of success"
in cases when the original would've returned false.  The caller turns into
                        /*
                         * Note: do negative dentry check after revalidation in
                         * case that drops it.
                         */
                        if (unlikely(negative))
                                return -ENOENT;
                        path->mnt = mnt;
                        path->dentry = dentry;
                        return __follow_mount_rcu(nd, path, inode, seqp);

4) fold __follow_mount_rcu() into follow_managed(), using the latter both in
RCU and non-RCU cases.

5) take the calls of follow_managed() out of lookup_fast() into its callers.
That would be
        err = lookup_fast(nd, &path, &inode, &seq);
        if (unlikely(err <= 0)) {
                if (err < 0)
                        return err;
                path.dentry = lookup_slow(&nd->last, nd->path.dentry,
                                          nd->flags);
                if (IS_ERR(path.dentry))
                        return PTR_ERR(path.dentry);

                path.mnt = nd->path.mnt;
                err = follow_managed(&path, nd, &inode, &seq);
                if (unlikely(err < 0))
                        return err;
        }
turning into
        err = lookup_fast(nd, &path, &inode, &seq);
        if (unlikely(err <= 0)) {
                if (err < 0)
                        return err;
                path.dentry = lookup_slow(&nd->last, nd->path.dentry,
                                          nd->flags);
                if (IS_ERR(path.dentry))
                        return PTR_ERR(path.dentry);

                path.mnt = nd->path.mnt;
	}
	err = follow_managed(&path, nd, &inode, &seq);
        if (unlikely(err < 0))
		return err;
in walk_component() and
                error = lookup_fast(nd, &path, &inode, &seq);
                if (likely(error > 0))
                        goto finish_lookup;
...
        error = follow_managed(&path, nd, &inode, &seq);
        if (unlikely(error < 0))
                return error;
finish_lookup:  
turning into
                error = lookup_fast(nd, &path, &inode, &seq);
                if (likely(error > 0))
                        goto finish_lookup;
...
finish_lookup:
        error = follow_managed(&path, nd, &inode, &seq);
        if (unlikely(error < 0))
                return error;
in do_last().

6) after that we have 3 callers of step_into(); the ones in
walk_component() and in do_last() would be immediately preceded
by the calls of follow_managed().  The last one is in
mountpoint_last().  That's
        if (d_flags_negative(smp_load_acquire(&path.dentry->d_flags))) {
                dput(path.dentry);
                return -ENOENT;
        }
        path.mnt = nd->path.mnt;
        return step_into(nd, &path, 0, d_backing_inode(path.dentry), 0);
And that's where we are missing the mountpoint traversal in symlink case -
sure, the caller does follow_mount(), but it doesn't catch the case when
we have a symlink overmounted - we run into step_into() before that.
Note that smp_load_acquire + d_flags_negative is what we would've done
in follow_managed(), as well as getting d_backing_inode().  So here
we also have an open-coded bastardized variant of follow_managed().
The difference is, we don't want to trigger ->d_automount() and ->d_manage()
in that one.

And at that point the only call of follow_managed() *NOT* followed by
step_into() is in handle_lookup_down().  What it is followed by is
        path_to_nameidata(&path, nd);
        nd->inode = inode;
        nd->seq = seq;
And that's a piece of step_into():
        if (likely(!d_is_symlink(path->dentry)) ||
           !(flags & WALK_FOLLOW || nd->flags & LOOKUP_FOLLOW)) {
                /* not a symlink or should not follow */
                path_to_nameidata(path, nd);
                nd->inode = inode;
                nd->seq = seq;
                return 0;
        }
is the normal path through that sucker.  What's more, we are guaranteed
that this will _not_ be a symlink (it's the starting point of pathwalk,
and path_init() would've told us to sod off were it not a directory).

So if we manage to convert the damn thing in mountpoint_last() into
follow_managed(), we could fold follow_managed() into step_into().
Which suggests the way to do that - not that step_into() takes an
argument containing ORed WALK_... constants.  So we can simply add
WALK_NOAUTOMOUNT and put a check for it into
                if (flags & DCACHE_MANAGE_TRANSIT) {
and
                if (flags & DCACHE_NEED_AUTOMOUNT) {
bodies, so that they would be ignored if that's passed to
follow_mount()/step_into() hybrid.

At that point we have one primitive for moving into child, handling
both the mountpoint traversals and keeping track of symlinks.  Moreover,
there's a fairly strong argument for using it in case of .. as well.
As it is, if the parent is overmounted, we cross into whatever is
mounted on top of it.  And we ignore ->d_manage/->d_automount on
the damn thing.  Which is not an issue for anything other than
autofs (nobody else has ->d_manage() and nfs/afs/cifs automount
points don't have children) and for autofs we *want* those called;
that's not something likely to be encountered, but it's an impossible
setup (autofs direct mount set on an ancestor of somebody's current
directory) and autofs does count upon not walking into something
being set up by the daemon.

I'll put together such series and see how well does it work; it would
fix the idiocies in user_path_mountpoint_at() and make the pathwalk
machinery easier to follow - the boilerplate around mountpoint
crossing and symlink handling is demonstrably easy to get wrong.
If that works and doesn't cause observable slowdown, I'll put it
into -next, either stepping around the changes done by openat2()
series, or rebasing it on top of that.

Another interesting question is whether we want O_PATH open
to trigger automounts.  The thing is, we do *NOT* trigger them
(or traverse mountpoints) at the starting point of lookups.
I believe it's a mistake (and mine, at that), but I doubt that
there's anything that can be done about it at that point.
It's a user-visible behaviour and I can easily imagine
a custom /init that ends up relying upon it ;-/  mkdir /root,
mount the final root there, chdir /root, mount --move . /,
remove everything on initramfs using absolute pathnames
and chroot to "." to finish...  Traversing mounts at the
beginning of pathwalk would break the hell out of that,
potentially with root filesystem contents wiped out... ;-/

I wish we could change that, but I'm afraid that's cast
in stone by now (and had been for 20 years or so).  As it is,
we have an unpleasant side effect - O_PATH open does *NOT*
trigger automounts.  So if you do that to e.g. referral point
and try to do ...at() syscalls with that as the origin, you'll
get an unpleasant surprise - automount won't trigger at all.

I think the easiest way to handle that is to have O_PATH
turn LOOKUP_AUTOMOUNT, same as the normal open() does.  That's
trivial to do, but that changes user-visible behaviour.  OTOH,
with the current behaviour nobody can rely upon automount not
getting triggered by somebody else just as they are entering
their open(dir, O_PATH), so I think that's not a problem.

Linus, do you have any objections to such O_PATH semantics
change?

PS: I think I see how to untangle the control flow horrors
in do_last() with this massage done, but I'm not going there
until this is sorted out - by previous experience touching
the damn thing can easily turn into several weeks of digging
through the nfs/gfs2/etc. guts trying to verify something,
with a couple of detours into fixing something in there
found in process... ;-/
