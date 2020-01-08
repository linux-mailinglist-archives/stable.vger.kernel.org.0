Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6528B134EF5
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 22:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgAHVey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 16:34:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58476 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgAHVey (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 16:34:54 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipIyS-004SKI-15; Wed, 08 Jan 2020 21:34:44 +0000
Date:   Wed, 8 Jan 2020 21:34:44 +0000
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
Message-ID: <20200108213444.GF8904@ZenIV.linux.org.uk>
References: <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <20200101004324.GA11269@ZenIV.linux.org.uk>
 <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 07:54:02PM -0800, Linus Torvalds wrote:

> > Another interesting question is whether we want O_PATH open
> > to trigger automounts.
> 
> It does sound like they shouldn't, but as you say:
> 
> >     The thing is, we do *NOT* trigger them
> > (or traverse mountpoints) at the starting point of lookups.
> > I believe it's a mistake (and mine, at that), but I doubt that
> > there's anything that can be done about it at that point.
> > It's a user-visible behaviour [..]
> 
> Hmm. I wonder how set in stone that is. We may have two decades of
> history of not doing it at start point of lookups, but we do *not*
> have two decades of history of O_PATH.
> 
> So what I think we agree would be sane behavior would be for O_PATH
> opens to not trigger automounts (unless there's a slash at the end,
> whatever), but _do_ add the mount-point traversal to the beginning of
> lookups.
> 
> But only do it for the actual O_PATH fd case, not the cwd/root/non-O_PATH case.
> 
> That way we maintain original behavior: if somebody overmounts your
> cwd, you still see the pre-mount directory on lookups, because your
> cwd is "under" the mount.
> 
> But if you open a file with O_PATH, and somebody does a mount
> _afterwards_, the openat() will see that later mount and/or do the
> automount.
> 
> Don't you think that would be the more sane/obvious semantics of how
> O_PATH should work?

Maybe, but... note that we do not (and AFAICS never had) follow mounts
on /proc/self/cwd, /proc/self/fd/42, etc.  And there are very good
reasons for that.  First of all, if your stdin is from /tmp/foo,
you'd better get that file when you open /dev/stdin, even if somebody
has done mount --bind /tmp/bar /tmp/foo; another issue is with
the use of stat("/proc/self/fd/42", &buf) - it should be an equivalent
of fstat(42, &buf), even if somebody has overmounted that.  BTW, for
similar reason after
	link(".", "foo");
	fd = open("foo", O_PATH);	// return 42
we really should (and do) have resolution of /proc/self/fd/42 stop at
foo, not .   Reason: consistency of stat() behaviour...

The point is, we'd never followed mounts on /proc/self/cwd et.al.
I hadn't checked 2.0, but 2.1.100 ('97, before any changes from me)
is that way.  Actually, scratch that - 2.0 behaves the same way
(mountpoint crossing is done in iget() there; is that Minix influence
or straight from the Lions' book?)

Hmm...  Looking through the history, we have

(for reference) v7: mount traversal in iget()
(forward) and namei() (back); due to the way it's done, forward
traversal happens
	* at starting point
	* after any component (. and .. included)
	* on results of forward traversal (due to a loop in iget()).
Back traversal (to covered on .. from root directory) is also
to unlimited depth.

0.01: no mount handling

0.10: forward traversal in iget(), back traversal in fs/namei.c:find_entry()
(not by Lions' Book, then - v6 didn't do back traversals at all).
Forward traversal
	* after any component (. and .. included)
No traversal on starting point, no traversal on result of traversal.
OTOH, mount(2) refuses to mount on top of root, so the lack of the last
one is not an issue.

0.12: symlinks added; no mount traversal on starting point of those either.
We start at the process' root for absolute ones, even if it happens to be
overmounted, and we start from parent for relative ones.  The latter matters
only if we were in the beginning of the pathwalk, since anything else would've
traversed mounts back when we'd picked said parent.  Mount traversal takes
precedence over symlink traversal, but that's not an issue since mount follows
links on mountpoint.  It does not, at that point, reject fs image with
symlink for root, but that actually more or less works.

0.97.3: same, with addition of procfs symlinks.  No mount crossing on their
targets (for normal symlinks we don't do mount crossing in the beginning
and any component inside triggers mount crossing as usual; for procfs ones
there's no components inside)

Situation remains essentially unchanged until 2.1.42.  Next few kernels
are in flux, to put it politely - initial merge had been insane and it
took until 2.1.44 or so for the things to get more or less working.

At 2.1.44: forward traversal in fs/namei.c:lookup(), back traversal in
fs/namei.c:reserved_lookup().  Otherwise the same behaviour as pre-dcache
(wrt mount traversals, that is).

2.1.51pre1: forward traversal moved into real_lookup() and __d_lookup().
Forward traversal happens *ONLY* after normal components - not after . or ..

2.1.61: forward traversal moved into follow_mount(), behaviour reverted to
pre-dcache one.

Previous is from reading through the historical trees; my involvement started
circa 2.1.120-something.

2.3.50pre3: call of follow_mount() moved a bit, reverting to 2.1.51pre1
behaviour (nor traversal on . or ..) *again*.  Not sure whose idea had that
been - might've been mine, but unlike the other patch that went into fs/namei.c
in the same release, I hadn't been able to find anything related to that
one.  If your memories (or mail archives) are better...

2.3.99pre4-5: massive surgery in there.  Preparations to allowing mount on top
of mount; forward traversal adjusted accordingly, back traversal still isn't.

2.3.99pre7-1: more surgery, back traversals are also to unlimited depth now
and mount on top of mount has been allowed.

2.3.99pre9-4: mount --bind taught to mount non-directories on top of
non-directories.  At that point it does *NOT* follow trailing symlinks, so
mounting of symlinks and mounting on top of symlinks becomes possible.
Mount traversal still takes precedence over symlink traversal, symlink traversal
of mount traversal result still generally works, even though it's not something
I considered at the time.

v2.4.5.2: mount --bind started to follow symlinks.  So that source of mounting
of and on the symlinks was no more.

2.5.0.5: forward mount traversal is done after .. (in handle_dotdot()).
That brings back the pre-dcache behaviour for those suckers.  Still no
forward traversal after ., though.

At about the same time I'd been getting rid of the early-boot incestous
relationships with fs/namespace.c (initramfs work) and that was probably
the last time we could realistically switch to following mounts at starting
point; I considered trying to do that, but decided not to.  Pity, that...

2.6.5-rc2: normal mount now checks for corrupt fs with symlink for root.
Since it has always been following symlinks for mountpoint, the remaining
source of mounting of and on symlinks was gone; that lasted until
after O_PATH introduction.

2.6.39-rc1: mount traps support - instead of abusing ->follow_link()
for automounting, we have an explicit pair of methods that can be
called at the same places where we traverse mounts.  None too consistent -
we don't do that on .. results.  That was Dave Howells and Ian Kent.

2.6.39-rc1: O_PATH introduced and, later in the same series, allowed for
symlinks.  That has changed things - now procfs symlink targets could
be symlinks themselves.  Originally an attempt to follow those would
blow up with -ELOOP (there's simply no good way to follow such beast;
it's either "stop even if we are asked to follow" or "give an error").

3.6.0-rc1: nd_jump_link() introduction (hch) had unnoticed side effects -
we'd switched from "fail traversal with -ELOOP" to "stop there".  Mostly it
doesn't change behaviour, but it has opened a way to mount symlinks and
mount on top of symlinks.  Which generally worked.

circa 3.8--3.9: side effects had been noticed; my first reaction had been
"let's make nd_jump_link() return an error, then", but I hadn't been
able to find good reasons when challenged to do so.  Did an audit,
found no obvious problems, went "oh, well - whether it works by accident
or by design, it doesn't break anything".

3.12.0-rc1: lookups for umount(2) are different - we don't want
revalidate on the last component.  Which had been handled by
introduction of path_umountat()/umount_lookup_last(), parallel to
path_lookupat().  Which has gotten quite a few things wrong -
it *did* try to follow symlinks obtained by following procfs
ones (and blew up big way) and it didn't follow mounts on
overmounted trailing symlinks.  Nobody noticed for 6 years,
until folks actually tried to play with mount-on-symlink...
Patches were by Jeff Layton, neither he nor I have spotted the
problem back then.  And I should have, since it had been only
a few months since the audit for exactly that kind of problems...

AFAICS, there'd been no serious semantical changes since then.  What we
have right now:
	* no mount traversal on the starting point
	* mount traversal after any component other than "."
	* symlink traversal consists of possibly jumping to given
point plus following a given (possibly empty) series of components.
It can be both - e.g. symlink to "/foo/bar" is 'jump to root,
then traverse "foo", then traverse "bar"'.  Procfs "magic" symlinks
are not really magical - they behave as symlinks to "/" as far as
the pathwalk semantics is concerned.  The only differences is that
jump might be not to process' root.
	* mount traversal takes precedence over symlink traversal.
	* jump (if any) in symlink traversal is treated the same
as the starting point - it's not followed by mount traversal.
It's also not followed by symlink traversal, even if we are jumping
into a symlink.  Of course, in any position other than the end of
pathname that's an instant error.  That's also not different from
the starting point treatment - if ...at(2) is given a symlink for
starting point, it leaves it as-is if AT_EMPTY_PATH is given and
fails with -ENOTDIR otherwise.
	* umount(2) handles the final component differently -
for one thing, it does not do revalidate, for another - its
mount traversal (if any) does not include automount-related
parts.  And there we *do* want mount traversal at the final
point, for obvious reasons.

> > I think the easiest way to handle that is to have O_PATH
> > turn LOOKUP_AUTOMOUNT, same as the normal open() does.  That's
> > trivial to do, but that changes user-visible behaviour.  OTOH,
> > with the current behaviour nobody can rely upon automount not
> > getting triggered by somebody else just as they are entering
> > their open(dir, O_PATH), so I think that's not a problem.
> >
> > Linus, do you have any objections to such O_PATH semantics
> > change?
> 
> See above: I think I'd prefer the O_PATH behavior the other way
> around. That seems to be more of a consistent behavior of what
> "O_PATH" means - it means "don't really open, we'll do it only when
> you use it as a directory".

How would your proposal deal with access("/proc/self/fd/42/foo", MAY_READ)
vs. faccessat(42, "foo", MAY_READ)?  The latter would trigger automount,
the former would not...  Or would you extend that to "traverse mounts
upon following procfs links, if the file in question had been opened with
O_PATH"?  We could do that (give nd_jump_link() an extra argument telling
if we want mount traversal), but I'm not sure if the resulting semantics
is sane...

Note, BTW, that O_PATH users really can't rely upon automounts _not_
being triggered - all it takes is a lookup on bogus path with such prefix
by anybody who can reach that place...  We are not opening anything,
really, but we are not able to ignore automounts triggered by somebody
else.
