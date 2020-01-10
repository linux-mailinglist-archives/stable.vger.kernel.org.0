Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB87A136603
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 05:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgAJEPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 23:15:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51464 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731174AbgAJEPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 23:15:39 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iplhj-005Fwg-IZ; Fri, 10 Jan 2020 04:15:23 +0000
Date:   Fri, 10 Jan 2020 04:15:23 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Aleksa Sarai <cyphar@cyphar.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200110041523.GK8904@ZenIV.linux.org.uk>
References: <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200108213444.GF8904@ZenIV.linux.org.uk>
 <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 09, 2020 at 04:08:16PM -0800, Linus Torvalds wrote:
> On Wed, Jan 8, 2020 at 1:34 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > The point is, we'd never followed mounts on /proc/self/cwd et.al.
> > I hadn't checked 2.0, but 2.1.100 ('97, before any changes from me)
> > is that way.
> 
> Hmm. If that's the case, maybe they should be marked implicitly as
> O_PATH when opened?

I thought you wanted O_PATH as starting point to have mounts traversed?
Confused...

> > Actually, scratch that - 2.0 behaves the same way
> > (mountpoint crossing is done in iget() there; is that Minix influence
> > or straight from the Lions' book?)
> 
> I don't think I ever had access to Lions' - I've _seen_ a printout of
> it later, and obviously maybe others did,
> 
> More likely it's from Maurice Bach: the Design of the Unix Operating
> System. I'm pretty sure that's where a lot of the FS layer stuff came
> from.  Certainly the bad old buffer head interfaces, and quite likely
> the iget() stuff too.
>
> > 0.10: forward traversal in iget(), back traversal in fs/namei.c:find_entry()
> 
> Whee, you _really_ went back in time.
> 
> So I did too.
> 
> And looking at that code in iget(), I doubt it came from anywhere.
> Christ. It's just looping over a fixed-size array, both when finding
> the inode, and finding the superblock.
> 
> Cute, but unbelievably stupid. It was a more innocent time.
> 
> In other words, I think you can chalk it up to just me, because
> blaming anybody else for that garbage would be very very unfair indeed
> ;)

See https://minnie.tuhs.org/cgi-bin/utree.pl?file=V7/usr/sys/sys/iget.c
Exactly the same algorithm, complete with linear searches over those
fixed-sized array.

<grabs Bach> Right, he simply transcribes v7 iget().

So I suspect that you are right - your variant of iget was pretty much
one-to-one implementation of Bach's description of v7 iget.

Your namei wasn't - Bach has 'if the entry points to root and you are
in the root and name is "..", find mount table entry (by device number),
drop your directory inode, grab the inode of mountpount and restart
the search for ".." in there', which gives back traversals to arbitrary
depth.  And v7 namei() (as Bach mentions) uses iget() for starting point
as well as for each component.  You kept pointers instead, which is where
the other difference has come from (no mount traversal at the starting
point)...

Actually, I've misread your code in 0.10 - it does unlimited forward
traversals; it's back traversals that go only one level.  The forward
ones got limited to one level in 0.95, but then mount-over-root had
been banned all along.  I'd read the pre-dcache variant of iget(),
seen it go pretty much all the way back to beginning and hadn't
sorted out the 0.12 -> 0.95 transition...

> > How would your proposal deal with access("/proc/self/fd/42/foo", MAY_READ)
> > vs. faccessat(42, "foo", MAY_READ)?
> 
> I think that in a perfect world, the O_PATH'ness of '42' would be the
> deciding factor. Wouldn't those be the best and most consistent
> semantics?
> 
> And then 'cwd'/'root' always have the O_PATH behavior.

See above - unless I'm misparsing you, you wanted mount traversals in the
starting point if it's ...at() with O_PATH fd.  With O_PATH open() not
doing them.

For cwd and root the situation is opposite - we do NOT traverse mounts
for those.  And that's really too late to change.

> > The latter would trigger automount,
> > the former would not...  Or would you extend that to "traverse mounts
> > upon following procfs links, if the file in question had been opened with
> > O_PATH"?
> 
> Exactly.
> 
> But you know what? I do not believe this is all that important, and I
> doubt it will matter to anybody.

FWIW, digging through the automount-related parts of that stuff has
caught several fun issues.  One (and I'm rather embarrassed by it)
should've been caught back in commit 8aef18845266 (VFS: Fix vfsmount
overput on simultaneous automount).  To quote the commit message:
    The problem is that lock_mount() drops the caller's reference to the
    mountpoint's vfsmount in the case where it finds something already mounted on
    the mountpoint as it transits to the mounted filesystem and replaces path->mnt
    with the new mountpoint vfsmount.
    
    During a pathwalk, however, we don't take a reference on the vfsmount if it is
    the same as the one in the nameidata struct, but do_add_mount() doesn't know
    this.
At which point I should've gone "what the fuck?" - lock_mount() does, indeed,
drop path->mnt in this situation and replaces it with the whatever's come to
cover it.  For mount(2) that's the right thing to do - we _want_ to mount
on top of whatever we have at the mountpoint.  For automounts we very much
don't want that - it's either "mount right on top of the automount trigger"
or discard whatever we'd been about to mount and walk into whatever's got
mounted there (presumably the same thing triggered by another process).
We kinda-sorta get that effect, but in a very convoluted way: do_add_mount()
will refuse to mount something on top of itself -
        /* Refuse the same filesystem on the same mount point */
        err = -EBUSY;
        if (path->mnt->mnt_sb == newmnt->mnt.mnt_sb &&
            path->mnt->mnt_root == path->dentry)
                goto unlock;
which will end up with -EBUSY returned (and recognized by follow_automount()).

First of all, that's unreliable.  If somebody not only has triggered that
automount, but managed to _mount_ something else on top (for example,
has triggered it by lookup of mountpoint-to-be in mount(2)), we'll end
up not triggering that check.  In which case we'll get something like
nfs referral point under nfs automounted there under tmpfs from explicit
overmount under same nfs mount we'd automounted there - identical to what's
been buried under tmpfs.  It's hard to hit, but not impossibly so.

What's more, the whole solution is a kludge - the root of problem is
that lock_mount() is the wrong thing to do in case of finish_automount().
We don't want to go into whatever's overmounting us there, both for
the reasons above *and* because it's a PITA for the caller.  So the
right solution is
	* lift lock_mount() call from do_add_mount() into its callers
(all 2 of them); while we are at it, lift unlock_mount() as well
(makes for simpler failure exits in do_add_mount()).
	* replace the call of lock_mount() in finish_automount()
with variant that doesn't do "unlock, walk deeper and retry locking",
returning ERR_PTR(-EBUSY) in such case.
	* get rid of the kludge introduced in that commit.  Better
yet, don't bother with traversing into the covering mount in case
of success - let the caller of follow_automount() do that.  Which
eliminates the need to pass need_mntput to the sucker and suggests
an even better solution - have this analogue of lock_mount()
return NULL instead of ERR_PTR(-EBUSY) and treat it in finish_automount()
as "OK, discard what we wanted to mount and return 0".  That gets
rid of the entire
        err = finish_automount(mnt, path);
        switch (err) {
        case -EBUSY:
                /* Someone else made a mount here whilst we were busy */
                return 0;
        case 0:
                path_put(path);
                path->mnt = mnt;
                path->dentry = dget(mnt->mnt_root);
                return 0;
        default:
                return err;
        }
chunk in follow_automount() - it would just be
	return finish_automount(mnt, path);

Another thing (in the same area) is not a bug per se, but...
after the call of ->d_automount() we have this:
        if (IS_ERR(mnt)) {
                /*
                 * The filesystem is allowed to return -EISDIR here to indicate
                 * it doesn't want to automount.  For instance, autofs would do
                 * this so that its userspace daemon can mount on this dentry.
                 *
                 * However, we can only permit this if it's a terminal point in
                 * the path being looked up; if it wasn't then the remainder of
                 * the path is inaccessible and we should say so.
                 */
                if (PTR_ERR(mnt) == -EISDIR && (nd->flags & LOOKUP_PARENT))
                        return -EREMOTE;
                return PTR_ERR(mnt);
	}
Except that not a single instance of ->d_automount() has ever returned
-EISDIR.  Certainly not autofs one, despite the what the comment says.
That chunk has come from dhowells, back when the whole mount trap series
had been merged.  After talking that thing over (fun: trying to figure
out what had been intended nearly 9 years ago, when people involved are
in UK, US east coast and AU west coast respectively.  The only way it
could suck more would've been if I were on the west coast - then all
timezone deltas would be 8-hour ones)...  looks like it's a rudiment
of plans that got superseded during the series development, nobody
quite remembers exact details.  Conclusion: it's not even dead, it's
stillborn; bury it.

Unfortunately, there are other interesting questions related to
autofs-specific bits (->d_manage()) and the timezone-related fun
is, of course, still there.  I hope to sort that out today or
tomorrow, at least enough to do a reasonable set of backportable
fixes to put in front of follow_managed()/step_into() queue.
Oh, well...
