Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2C212DC6A
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 01:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgAAAnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 19:43:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40824 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgAAAnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 19:43:42 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1imS6e-00048x-Vr; Wed, 01 Jan 2020 00:43:25 +0000
Date:   Wed, 1 Jan 2020 00:43:24 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200101004324.GA11269@ZenIV.linux.org.uk>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 06:29:59PM +1100, Aleksa Sarai wrote:
> On 2019-12-30, Aleksa Sarai <cyphar@cyphar.com> wrote:
> > On 2019-12-30, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > On Mon, Dec 30, 2019 at 04:20:35PM +1100, Aleksa Sarai wrote:
> > > 
> > > > A reasonably detailed explanation of the issues is provided in the patch
> > > > itself, but the full traces produced by both the oopses and deadlocks is
> > > > included below (it makes little sense to include them in the commit since we
> > > > are disabling this feature, not directly fixing the bugs themselves).
> > > > 
> > > > I've posted this as an RFC on whether this feature should be allowed at
> > > > all (and if anyone knows of legitimate uses for it), or if we should
> > > > work on fixing these other kernel bugs that it exposes.
> > > 
> > > Umm...  Are all of those traces
> > > 	a) reproducible on mainline and
> > 
> > This was on viro/for-next, I'll retry it on v5.5-rc4.
> 
> The NULL deref oops is reproducible on v5.5-rc4. Strangely it seems
> harder to reproduce than on viro/for-next (I kept reproducing it there
> by accident), but I'll double-check if that really is the case.
> 
> The simplest reproducer is (using the attached programs and .config):
> 
>   ln -s . link
>   sudo ./umount_symlink link

FWIW, the problem with that reproducer is that we *CAN'T* resolve that
path.  Look: you have /proc/self/fd/3 resolve to ./link.  OK, you've
asked to follow that.  Got ./link, which is a symlink, so we need to
follow it further.  Relative to what, though?

The meaning of symlink is dependent upon the directory you find it in.
And we don't have any here.

The bug is in mountpoint_last() - we have
        if (unlikely(nd->last_type != LAST_NORM)) {
                error = handle_dots(nd, nd->last_type);
                if (error)
                        return error;
                path.dentry = dget(nd->path.dentry);
        } else {
                path.dentry = d_lookup(dir, &nd->last);
                if (!path.dentry) {
                        /*
                         * No cached dentry. Mounted dentries are pinned in the
                         * cache, so that means that this dentry is probably
                         * a symlink or the path doesn't actually point
                         * to a mounted dentry.
                         */
                        path.dentry = lookup_slow(&nd->last, dir,
                                             nd->flags | LOOKUP_NO_REVAL);
                        if (IS_ERR(path.dentry))
                                return PTR_ERR(path.dentry);
                }
        }
        if (d_flags_negative(smp_load_acquire(&path.dentry->d_flags))) {
                dput(path.dentry);
                return -ENOENT;
        }
        path.mnt = nd->path.mnt;
        return step_into(nd, &path, 0, d_backing_inode(path.dentry), 0);
in there, and that ends up with step_into() called in case of LAST_DOT/LAST_DOTDOT
(where it's harmless) *AND* in case of LAST_BIND.  Where it very much isn't.

I'm not sure if you have caught anything else, but we really, really should *NOT*
consider the LAST_BIND as "maybe we should follow the result" material.  So
at least the following is needed; could you check if anything else remains
with that applied?

diff --git a/fs/namei.c b/fs/namei.c
index d6c91d1e88cb..d4fbbda8a7ff 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2656,10 +2656,7 @@ mountpoint_last(struct nameidata *nd)
 	nd->flags &= ~LOOKUP_PARENT;
 
 	if (unlikely(nd->last_type != LAST_NORM)) {
-		error = handle_dots(nd, nd->last_type);
-		if (error)
-			return error;
-		path.dentry = dget(nd->path.dentry);
+		return handle_dots(nd, nd->last_type);
 	} else {
 		path.dentry = d_lookup(dir, &nd->last);
 		if (!path.dentry) {
