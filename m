Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F92137A12
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 00:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbgAJXUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 18:20:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37730 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbgAJXUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 18:20:05 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iq3ZB-005lcr-Fx; Fri, 10 Jan 2020 23:19:45 +0000
Date:   Fri, 10 Jan 2020 23:19:45 +0000
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
Message-ID: <20200110231945.GL8904@ZenIV.linux.org.uk>
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
> On Thu, Jan 02, 2020 at 02:59:20PM +1100, Aleksa Sarai wrote:
> > On 2020-01-01, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > On Thu, Jan 02, 2020 at 01:44:07AM +1100, Aleksa Sarai wrote:
> > > 
> > > > Thanks, this fixes the issue for me (and also fixes another reproducer I
> > > > found -- mounting a symlink on top of itself then trying to umount it).
> > > > 
> > > > Reported-by: Aleksa Sarai <cyphar@cyphar.com>
> > > > Tested-by: Aleksa Sarai <cyphar@cyphar.com>
> > > 
> > > Pushed into #fixes.
> > 
> > Thanks. One other thing I noticed is that umount applies to the
> > underlying symlink rather than the mountpoint on top. So, for example
> > (using the same scripts I posted in the thread):
> > 
> >   # ln -s /tmp/foo link
> >   # ./mount_to_symlink /etc/passwd link
> >   # umount -l link # will attempt to unmount "/tmp/foo"
> > 
> > Is that intentional?
> 
> It's a mess, again in mountpoint_last().  FWIW, at some point I proposed
> to have nd_jump_link() to fail with -ELOOP if the target was a symlink;
> Linus asked for reasons deeper than my dislike of the semantics, I looked
> around and hadn't spotted anything.  And there hadn't been at the time,
> but when four months later umount_lookup_last() went in I failed to look
> for that source of potential problems in it ;-/

FWIW, since Ian appears to agree that we want ->d_manage() on the mount
crossing at the end of umount(2) lookup, here's a much simpler solution -
kill mountpoint_last() and switch to using lookup_last().  As a side
benefit, LOOKUP_NO_REVAL also goes away.  It's possible to trim the
things even more (path_mountpoint() is very similar to path_lookupat()
at that point, and it's not hard to make the differences conditional on
something like LOOKUP_UMOUNT); I would rather do that part in the
cleanups series - the one below is easier to backport.

Aleksa, Ian - could you see if the patch below works for you?

commit e56b43b971a7c08762fceab330a52b7245041dbc
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri Jan 10 17:17:19 2020 -0500

    reimplement path_mountpoint() with less magic
    
    ... and get rid of a bunch of bugs in it.  Background:
    the reason for path_mountpoint() is that umount() really doesn't
    want attempts to revalidate the root of what it's trying to umount.
    The thing we want to avoid actually happen from complete_walk();
    solution was to do something parallel to normal path_lookupat()
    and it both went overboard and got the boilerplate subtly
    (and not so subtly) wrong.
    
    A better solution is to do pretty much what the normal path_lookupat()
    does, but instead of complete_walk() do unlazy_walk().  All it takes
    to avoid that ->d_weak_revalidate() call...  mountpoint_last() goes
    away, along with everything it got wrong, and so does the magic around
    LOOKUP_NO_REVAL.
    
    Another source of bugs is that when we traverse mounts at the final
    location (and we need to do that - umount . expects to get whatever's
    overmounting ., if any, out of the lookup) we really ought to take
    care of ->d_manage() - as it is, manual umount of autofs automount
    in progress can lead to unpleasant surprises for the daemon.  Easily
    solved by using handle_lookup_down() instead of follow_mount().
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/namei.c b/fs/namei.c
index d6c91d1e88cb..1793661c3342 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1649,17 +1649,15 @@ static struct dentry *__lookup_slow(const struct qstr *name,
 	if (IS_ERR(dentry))
 		return dentry;
 	if (unlikely(!d_in_lookup(dentry))) {
-		if (!(flags & LOOKUP_NO_REVAL)) {
-			int error = d_revalidate(dentry, flags);
-			if (unlikely(error <= 0)) {
-				if (!error) {
-					d_invalidate(dentry);
-					dput(dentry);
-					goto again;
-				}
+		int error = d_revalidate(dentry, flags);
+		if (unlikely(error <= 0)) {
+			if (!error) {
+				d_invalidate(dentry);
 				dput(dentry);
-				dentry = ERR_PTR(error);
+				goto again;
 			}
+			dput(dentry);
+			dentry = ERR_PTR(error);
 		}
 	} else {
 		old = inode->i_op->lookup(inode, dentry, flags);
@@ -2618,72 +2616,6 @@ int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
 EXPORT_SYMBOL(user_path_at_empty);
 
 /**
- * mountpoint_last - look up last component for umount
- * @nd:   pathwalk nameidata - currently pointing at parent directory of "last"
- *
- * This is a special lookup_last function just for umount. In this case, we
- * need to resolve the path without doing any revalidation.
- *
- * The nameidata should be the result of doing a LOOKUP_PARENT pathwalk. Since
- * mountpoints are always pinned in the dcache, their ancestors are too. Thus,
- * in almost all cases, this lookup will be served out of the dcache. The only
- * cases where it won't are if nd->last refers to a symlink or the path is
- * bogus and it doesn't exist.
- *
- * Returns:
- * -error: if there was an error during lookup. This includes -ENOENT if the
- *         lookup found a negative dentry.
- *
- * 0:      if we successfully resolved nd->last and found it to not to be a
- *         symlink that needs to be followed.
- *
- * 1:      if we successfully resolved nd->last and found it to be a symlink
- *         that needs to be followed.
- */
-static int
-mountpoint_last(struct nameidata *nd)
-{
-	int error = 0;
-	struct dentry *dir = nd->path.dentry;
-	struct path path;
-
-	/* If we're in rcuwalk, drop out of it to handle last component */
-	if (nd->flags & LOOKUP_RCU) {
-		if (unlazy_walk(nd))
-			return -ECHILD;
-	}
-
-	nd->flags &= ~LOOKUP_PARENT;
-
-	if (unlikely(nd->last_type != LAST_NORM)) {
-		error = handle_dots(nd, nd->last_type);
-		if (error)
-			return error;
-		path.dentry = dget(nd->path.dentry);
-	} else {
-		path.dentry = d_lookup(dir, &nd->last);
-		if (!path.dentry) {
-			/*
-			 * No cached dentry. Mounted dentries are pinned in the
-			 * cache, so that means that this dentry is probably
-			 * a symlink or the path doesn't actually point
-			 * to a mounted dentry.
-			 */
-			path.dentry = lookup_slow(&nd->last, dir,
-					     nd->flags | LOOKUP_NO_REVAL);
-			if (IS_ERR(path.dentry))
-				return PTR_ERR(path.dentry);
-		}
-	}
-	if (d_flags_negative(smp_load_acquire(&path.dentry->d_flags))) {
-		dput(path.dentry);
-		return -ENOENT;
-	}
-	path.mnt = nd->path.mnt;
-	return step_into(nd, &path, 0, d_backing_inode(path.dentry), 0);
-}
-
-/**
  * path_mountpoint - look up a path to be umounted
  * @nd:		lookup context
  * @flags:	lookup flags
@@ -2699,14 +2631,17 @@ path_mountpoint(struct nameidata *nd, unsigned flags, struct path *path)
 	int err;
 
 	while (!(err = link_path_walk(s, nd)) &&
-		(err = mountpoint_last(nd)) > 0) {
+		(err = lookup_last(nd)) > 0) {
 		s = trailing_symlink(nd);
 	}
+	if (!err)
+		err = unlazy_walk(nd);
+	if (!err)
+		err = handle_lookup_down(nd);
 	if (!err) {
 		*path = nd->path;
 		nd->path.mnt = NULL;
 		nd->path.dentry = NULL;
-		follow_mount(path);
 	}
 	terminate_walk(nd);
 	return err;
diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index f64a33d2a1d1..2a82dcce5fc1 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -206,7 +206,6 @@ TRACE_DEFINE_ENUM(LOOKUP_AUTOMOUNT);
 TRACE_DEFINE_ENUM(LOOKUP_PARENT);
 TRACE_DEFINE_ENUM(LOOKUP_REVAL);
 TRACE_DEFINE_ENUM(LOOKUP_RCU);
-TRACE_DEFINE_ENUM(LOOKUP_NO_REVAL);
 TRACE_DEFINE_ENUM(LOOKUP_OPEN);
 TRACE_DEFINE_ENUM(LOOKUP_CREATE);
 TRACE_DEFINE_ENUM(LOOKUP_EXCL);
@@ -224,7 +223,6 @@ TRACE_DEFINE_ENUM(LOOKUP_DOWN);
 			{ LOOKUP_PARENT, "PARENT" }, \
 			{ LOOKUP_REVAL, "REVAL" }, \
 			{ LOOKUP_RCU, "RCU" }, \
-			{ LOOKUP_NO_REVAL, "NO_REVAL" }, \
 			{ LOOKUP_OPEN, "OPEN" }, \
 			{ LOOKUP_CREATE, "CREATE" }, \
 			{ LOOKUP_EXCL, "EXCL" }, \
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 7fe7b87a3ded..07bfb0874033 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -34,7 +34,6 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 
 /* internal use only */
 #define LOOKUP_PARENT		0x0010
-#define LOOKUP_NO_REVAL		0x0080
 #define LOOKUP_JUMPED		0x1000
 #define LOOKUP_ROOT		0x2000
 #define LOOKUP_ROOT_GRABBED	0x0008
