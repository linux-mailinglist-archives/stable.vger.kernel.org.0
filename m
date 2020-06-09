Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAD11F47B6
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 22:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbgFIUEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 16:04:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60600 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgFIUED (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 16:04:03 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jikTL-0006t9-U9; Tue, 09 Jun 2020 20:03:48 +0000
Date:   Tue, 9 Jun 2020 22:03:46 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        containers@lists.linux-foundation.org,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        linux-kernel@vger.kernel.org, Matt Denton <mpdenton@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202006091235.930519F5B@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 12:43:48PM -0700, Kees Cook wrote:
> On Fri, Jun 05, 2020 at 07:54:36AM +0000, Sargun Dhillon wrote:
> > On Thu, Jun 04, 2020 at 02:52:26PM +0200, Christian Brauner wrote:
> > > On Wed, Jun 03, 2020 at 07:22:57PM -0700, Kees Cook wrote:
> > > > On Thu, Jun 04, 2020 at 03:24:52AM +0200, Christian Brauner wrote:
> > > > > On Tue, Jun 02, 2020 at 06:10:41PM -0700, Sargun Dhillon wrote:
> > > > > > Previously there were two chunks of code where the logic to receive file
> > > > > > descriptors was duplicated in net. The compat version of copying
> > > > > > file descriptors via SCM_RIGHTS did not have logic to update cgroups.
> > > > > > Logic to change the cgroup data was added in:
> > > > > > commit 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
> > > > > > commit d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
> > > > > > 
> > > > > > This was not copied to the compat path. This commit fixes that, and thus
> > > > > > should be cherry-picked into stable.
> > > > > > 
> > > > > > This introduces a helper (file_receive) which encapsulates the logic for
> > > > > > handling calling security hooks as well as manipulating cgroup information.
> > > > > > This helper can then be used other places in the kernel where file
> > > > > > descriptors are copied between processes
> > > > > > 
> > > > > > I tested cgroup classid setting on both the compat (x32) path, and the
> > > > > > native path to ensure that when moving the file descriptor the classid
> > > > > > is set.
> > > > > > 
> > > > > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > > > > Suggested-by: Kees Cook <keescook@chromium.org>
> > > > > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > > > > Cc: Christian Brauner <christian.brauner@ubuntu.com>
> > > > > > Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > > > > > Cc: David S. Miller <davem@davemloft.net>
> > > > > > Cc: Jann Horn <jannh@google.com>,
> > > > > > Cc: John Fastabend <john.r.fastabend@intel.com>
> > > > > > Cc: Tejun Heo <tj@kernel.org>
> > > > > > Cc: Tycho Andersen <tycho@tycho.ws>
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Cc: cgroups@vger.kernel.org
> > > > > > Cc: linux-fsdevel@vger.kernel.org
> > > > > > Cc: linux-kernel@vger.kernel.org
> > > > > > ---
> > > > > >  fs/file.c            | 35 +++++++++++++++++++++++++++++++++++
> > > > > >  include/linux/file.h |  1 +
> > > > > >  net/compat.c         | 10 +++++-----
> > > > > >  net/core/scm.c       | 14 ++++----------
> > > > > >  4 files changed, 45 insertions(+), 15 deletions(-)
> > > > > > 
> > > > > 
> > > > > This is all just a remote version of fd_install(), yet it deviates from
> > > > > fd_install()'s semantics and naming. That's not great imho. What about
> > > > > naming this something like:
> > > > > 
> > > > > fd_install_received()
> > > > > 
> > > > > and move the get_file() out of there so it has the same semantics as
> > > > > fd_install(). It seems rather dangerous to have a function like
> > > > > fd_install() that consumes a reference once it returned and another
> > > > > version of this that is basically the same thing but doesn't consume a
> > > > > reference because it takes its own. Seems an invitation for confusion.
> > > > > Does that make sense?
> > > > 
> > > > We have some competing opinions on this, I guess. What I really don't
> > > > like is the copy/pasting of the get_unused_fd_flags() and
> > > > put_unused_fd() needed by (nearly) all the callers. If it's a helper, it
> > > > should help. Specifically, I'd like to see this:
> > > > 
> > > > int file_receive(int fd, unsigned long flags, struct file *file,
> > > > 		 int __user *fdptr)
> > > 
> > > I still fail to see what this whole put_user() handling buys us at all
> > > and why this function needs to be anymore complicated then simply:
> > > 
> > > fd_install_received(int fd, struct file *file)
> > > {
> > > 	security_file_receive(file);
> > >  
> > >  	sock = sock_from_file(fd, &err);
> > >  	if (sock) {
> > >  		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> > >  		sock_update_classid(&sock->sk->sk_cgrp_data);
> > >  	}
> > > 
> > > 	fd_install();
> > > 	return;
> > > }
> > > 
> > > exactly like fd_install() but for received files.
> > > 
> > > For scm you can fail somewhere in the middle of putting any number of
> > > file descriptors so you're left in a state with only a subset of
> > > requested file descriptors installed so it's not really useful there.
> > > And if you manage to install an fd but then fail to put_user() it
> > > userspace can simply check it's fds via proc and has to anyway on any
> > > scm message error. If you fail an scm message userspace better check
> > > their fds.
> > > For seccomp maybe but even there I doubt it and I still maintain that
> > > userspace screwing this up is on them which is how we do this most of
> > > the time. And for pidfd_getfd() this whole put_user() thing doesn't
> > > matter at all.
> > > 
> > > It's much easier and clearer if we simply have a fd_install() -
> > > fd_install_received() parallelism where we follow an established
> > > convention. _But_ if that blocks you from making this generic enough
> > > then at least the replace_fd() vs fd_install() logic seems it shouldn't
> > > be in there. 
> > > 
> > > And the function name really needs to drive home the point that it
> > > installs an fd into the tasks fdtable no matter what version you go
> > > with. file_receive() is really not accurate enough for this at all.
> > > 
> > > > {
> > > > 	struct socket *sock;
> > > > 	int err;
> > > > 
> > > > 	err = security_file_receive(file);
> > > > 	if (err)
> > > > 		return err;
> > > > 
> > > > 	if (fd < 0) {
> > > > 		/* Install new fd. */
> > > > 		int new_fd;
> > > > 
> > > > 		err = get_unused_fd_flags(flags);
> > > > 		if (err < 0)
> > > > 			return err;
> > > > 		new_fd = err;
> > > > 
> > > > 		/* Copy fd to any waiting user memory. */
> > > > 		if (fdptr) {
> > > > 			err = put_user(new_fd, fdptr);
> > > > 			if (err < 0) {
> > > > 				put_unused_fd(new_fd);
> > > > 				return err;
> > > > 			}
> > > > 		}
> > > > 		fd_install(new_fd, get_file(file));
> > > > 		fd = new_fd;
> > > > 	} else {
> > > > 		/* Replace existing fd. */
> > > > 		err = replace_fd(fd, file, flags);
> > > > 		if (err)
> > > > 			return err;
> > > > 	}
> > > > 
> > > > 	/* Bump the cgroup usage counts. */
> > > > 	sock = sock_from_file(fd, &err);
> > > > 	if (sock) {
> > > > 		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> > > > 		sock_update_classid(&sock->sk->sk_cgrp_data);
> > > > 	}
> > > > 
> > > > 	return fd;
> > > > }
> > > > 
> > > > If everyone else *really* prefers keeping the get_unused_fd_flags() /
> > > > put_unused_fd() stuff outside the helper, then I guess I'll give up,
> > > > but I think it is MUCH cleaner this way -- all 4 users trim down lots
> > > > of code duplication.
> > > > 
> > > > -- 
> > > > Kees Cook
> > How about this:
> > 
> > 
> > static int do_dup2(struct files_struct *files,
> > 	struct file *file, unsigned fd, unsigned flags)
> > __releases(&files->file_lock)
> > {
> > 	struct file *tofree;
> > 	struct fdtable *fdt;
> > 
> > 	...
> > 
> > 	/*
> > 	 * New bit, allowing the file to be null. Doesn't have the same
> > 	 * "sanity check" bits from __alloc_fd
> > 	 */
> > 	if (likely(file))
> > 		get_file(file);
> > 	rcu_assign_pointer(fdt->fd[fd], file);
> > 
> > 	__set_open_fd(fd, fdt);
> 
> IIUC, this means we can get the fdt into a state of an open fd with a
> NULL file... is that okay? That feels like something Al might rebel at.
> :)
> 
> > 
> > 	...
> > }
> > 
> > /*
> >  * File Receive - Receive a file from another process
> >  *
> >  * Encapsulates the logic to handle receiving a file from another task. It
> >  * does not install the file descriptor. That is delegated to the user. If
> >  * an error occurs that results in the file descriptor not being installed,
> >  * they must put_unused_fd.
> >  *
> >  * fd should be >= 0 if you intend on replacing a file descriptor, or
> >  * alternatively -1 if you want file_receive to allocate an FD for you
> >  *
> >  * Returns the fd number on success.
> >  * Returns negative error code on failure.
> >  *
> >  */
> > int file_receive(int fd, unsigned int flags, struct file *file)
> > {
> > 	int err;
> > 	struct socket *sock;
> > 	struct files_struct *files = current->files;
> > 
> > 	err = security_file_receive(file);
> > 	if (err)
> > 		return err;
> > 
> > 	if (fd >= 0) {
> > 		if (fd >= rlimit(RLIMIT_NOFILE))
> > 			return -EBADF;
> > 
> > 		spin_lock(&files->file_lock);
> > 		err = expand_files(files, fd);
> > 		if (err < 0) {
> > 			goto out_unlock;
> > 		}
> > 
> > 		err = do_dup2(files, NULL, fd, flags);
> > 		if (err)
> > 			return err;
> 
> This seems like we're duplicating some checks and missing others -- I
> really think we need to do this using the existing primitives. But I'd
> really like some review or commentary from Al. We can do this a bunch of
> ways, and I'd like to know which way looks best to him. :(
> 
> > This way there is:
> > 1. No "put_user" logic in file_receive
> > 2. Minimal (single) branching logic, unless there's something in between
> >    the file_receive and installing the FD, such as put_user.
> > 3. Doesn't implement fd_install, so there's no ambiguity about it being
> >    file_install_received vs. just the receive logic.
> 
> I still wonder if we should refactor SCM_RIGHTS to just delay put_user
> failures, which would simplify a bunch. It's a behavior change, but it

I'm looking at __scm_install_fd() and I wonder what specifically you
mean by that? The put_user() seems to be placed such that the install
occurrs only if it succeeded. Sure, it only handles a single fd but
whatever. Userspace knows that already. Just look at systemd when a msg
fails:

void cmsg_close_all(struct msghdr *mh) {
        struct cmsghdr *cmsg;

        assert(mh);

        CMSG_FOREACH(cmsg, mh)
                if (cmsg->cmsg_level == SOL_SOCKET && cmsg->cmsg_type == SCM_RIGHTS)
                        close_many((int*) CMSG_DATA(cmsg), (cmsg->cmsg_len - CMSG_LEN(0)) / sizeof(int));
}

The only reasonable scenario for this whole mess I can think of is sm like (pseudo code):

fd_install_received(int fd, struct file *file)
{
 	sock = sock_from_file(fd, &err);
 	if (sock) {
 		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
 		sock_update_classid(&sock->sk->sk_cgrp_data);
 	}

	fd_install();
}

error = 0;
fdarray = malloc(fdmax);
for (i = 0; i < fdmax; i++) {
	fdarray[i] = get_unused_fd_flags(o_flags);
	if (fdarray[i] < 0) {
		error = -EBADF;
		break;
	}

	error = security_file_receive(file);
	if (error)
		break;

	error = put_user(fd_array[i], ufd);
	if (error)
		break;
}

for (i = 0; i < fdmax; i++) {
	if (error) {
		/* ignore errors */
		put_user(-EBADF, ufd); /* If this put_user() fails and the first one succeeded userspace might now close an fd it didn't intend to. */
		put_unused_fd(fdarray[i]);
	} else {
		fd_install_received(fdarray[i], file);
	}
}

Christian
