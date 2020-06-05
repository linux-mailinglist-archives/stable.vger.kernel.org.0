Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839A11EF280
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 09:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgFEHyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 03:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgFEHyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 03:54:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33ACC08C5C3
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 00:54:39 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id e11so3561765ilr.4
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 00:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n3CbR66nPfpD0gS2lRT/W4hlXwXHn+0jPaByp2D7Ys4=;
        b=t1xgUo7nYwNixWnmxgLBT7oUcykY44kUV/1DJgvAmFZE8wKYdPDHRItAsebPxPwlpG
         9qGmmWtC3P6l8aKd6lz5Ufj75qysHw3dOkMIY69vD1fn+x1acWlT0fCL2Kw5df76B/RX
         lgXHJSzCvbXxPeInThtUHKbu1aZndwqLkRT58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n3CbR66nPfpD0gS2lRT/W4hlXwXHn+0jPaByp2D7Ys4=;
        b=QVfqBCZ8YF5BriD9jBWlXF6eeSzWDaf7WduY0HEmmmGHqH84MexZpyxL7EH1REoHcH
         A6CPbvGQoRFRWeEO7wx02KNH5QUOlABdp/+37cnup3lTXHrxCfHX6+983tX58TGk+tXq
         lpHZSU1f9m/Xib7qDIFAKcw27TD4fL2j5Y9GB2R0usvWGnmxLS51ZJaAxz1JoBWhM1PW
         YRw8ZGZnroQToxlyZNlL6K9Wv3G0pFfpkvQsmeBnDSorhskqUeviqw5deNoUg3N9PfMv
         IC8CiRxdBYke5IBVXb+q4Xm4h7BfTbE/ke1GsczxMtQX4gMwbntbrc/qnhFsU1eZeq1T
         as1w==
X-Gm-Message-State: AOAM531EWTZJ8SO2S1ItQZhbPZNAiWwG6W+g5TJ353k5OZwsfrER2EMB
        N5JlTi6YxDDIJklr4i8kIYPDFw==
X-Google-Smtp-Source: ABdhPJzyjMg39sQ2akfrcESO0H4RodytAdFsFB/8SayPct+ohuphz9c67lrhN/VL/Cw2tpn4nAZ7yQ==
X-Received: by 2002:a92:7f03:: with SMTP id a3mr7379149ild.269.1591343678764;
        Fri, 05 Jun 2020 00:54:38 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id p22sm2732408ill.52.2020.06.05.00.54.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Jun 2020 00:54:38 -0700 (PDT)
Date:   Fri, 5 Jun 2020 07:54:36 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Robert Sesek <rsesek@google.com>,
        containers@lists.linux-foundation.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org,
        cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 04, 2020 at 02:52:26PM +0200, Christian Brauner wrote:
> On Wed, Jun 03, 2020 at 07:22:57PM -0700, Kees Cook wrote:
> > On Thu, Jun 04, 2020 at 03:24:52AM +0200, Christian Brauner wrote:
> > > On Tue, Jun 02, 2020 at 06:10:41PM -0700, Sargun Dhillon wrote:
> > > > Previously there were two chunks of code where the logic to receive file
> > > > descriptors was duplicated in net. The compat version of copying
> > > > file descriptors via SCM_RIGHTS did not have logic to update cgroups.
> > > > Logic to change the cgroup data was added in:
> > > > commit 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
> > > > commit d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
> > > > 
> > > > This was not copied to the compat path. This commit fixes that, and thus
> > > > should be cherry-picked into stable.
> > > > 
> > > > This introduces a helper (file_receive) which encapsulates the logic for
> > > > handling calling security hooks as well as manipulating cgroup information.
> > > > This helper can then be used other places in the kernel where file
> > > > descriptors are copied between processes
> > > > 
> > > > I tested cgroup classid setting on both the compat (x32) path, and the
> > > > native path to ensure that when moving the file descriptor the classid
> > > > is set.
> > > > 
> > > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > > Suggested-by: Kees Cook <keescook@chromium.org>
> > > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > > Cc: Christian Brauner <christian.brauner@ubuntu.com>
> > > > Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > > > Cc: David S. Miller <davem@davemloft.net>
> > > > Cc: Jann Horn <jannh@google.com>,
> > > > Cc: John Fastabend <john.r.fastabend@intel.com>
> > > > Cc: Tejun Heo <tj@kernel.org>
> > > > Cc: Tycho Andersen <tycho@tycho.ws>
> > > > Cc: stable@vger.kernel.org
> > > > Cc: cgroups@vger.kernel.org
> > > > Cc: linux-fsdevel@vger.kernel.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > ---
> > > >  fs/file.c            | 35 +++++++++++++++++++++++++++++++++++
> > > >  include/linux/file.h |  1 +
> > > >  net/compat.c         | 10 +++++-----
> > > >  net/core/scm.c       | 14 ++++----------
> > > >  4 files changed, 45 insertions(+), 15 deletions(-)
> > > > 
> > > 
> > > This is all just a remote version of fd_install(), yet it deviates from
> > > fd_install()'s semantics and naming. That's not great imho. What about
> > > naming this something like:
> > > 
> > > fd_install_received()
> > > 
> > > and move the get_file() out of there so it has the same semantics as
> > > fd_install(). It seems rather dangerous to have a function like
> > > fd_install() that consumes a reference once it returned and another
> > > version of this that is basically the same thing but doesn't consume a
> > > reference because it takes its own. Seems an invitation for confusion.
> > > Does that make sense?
> > 
> > We have some competing opinions on this, I guess. What I really don't
> > like is the copy/pasting of the get_unused_fd_flags() and
> > put_unused_fd() needed by (nearly) all the callers. If it's a helper, it
> > should help. Specifically, I'd like to see this:
> > 
> > int file_receive(int fd, unsigned long flags, struct file *file,
> > 		 int __user *fdptr)
> 
> I still fail to see what this whole put_user() handling buys us at all
> and why this function needs to be anymore complicated then simply:
> 
> fd_install_received(int fd, struct file *file)
> {
> 	security_file_receive(file);
>  
>  	sock = sock_from_file(fd, &err);
>  	if (sock) {
>  		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
>  		sock_update_classid(&sock->sk->sk_cgrp_data);
>  	}
> 
> 	fd_install();
> 	return;
> }
> 
> exactly like fd_install() but for received files.
> 
> For scm you can fail somewhere in the middle of putting any number of
> file descriptors so you're left in a state with only a subset of
> requested file descriptors installed so it's not really useful there.
> And if you manage to install an fd but then fail to put_user() it
> userspace can simply check it's fds via proc and has to anyway on any
> scm message error. If you fail an scm message userspace better check
> their fds.
> For seccomp maybe but even there I doubt it and I still maintain that
> userspace screwing this up is on them which is how we do this most of
> the time. And for pidfd_getfd() this whole put_user() thing doesn't
> matter at all.
> 
> It's much easier and clearer if we simply have a fd_install() -
> fd_install_received() parallelism where we follow an established
> convention. _But_ if that blocks you from making this generic enough
> then at least the replace_fd() vs fd_install() logic seems it shouldn't
> be in there. 
> 
> And the function name really needs to drive home the point that it
> installs an fd into the tasks fdtable no matter what version you go
> with. file_receive() is really not accurate enough for this at all.
> 
> > {
> > 	struct socket *sock;
> > 	int err;
> > 
> > 	err = security_file_receive(file);
> > 	if (err)
> > 		return err;
> > 
> > 	if (fd < 0) {
> > 		/* Install new fd. */
> > 		int new_fd;
> > 
> > 		err = get_unused_fd_flags(flags);
> > 		if (err < 0)
> > 			return err;
> > 		new_fd = err;
> > 
> > 		/* Copy fd to any waiting user memory. */
> > 		if (fdptr) {
> > 			err = put_user(new_fd, fdptr);
> > 			if (err < 0) {
> > 				put_unused_fd(new_fd);
> > 				return err;
> > 			}
> > 		}
> > 		fd_install(new_fd, get_file(file));
> > 		fd = new_fd;
> > 	} else {
> > 		/* Replace existing fd. */
> > 		err = replace_fd(fd, file, flags);
> > 		if (err)
> > 			return err;
> > 	}
> > 
> > 	/* Bump the cgroup usage counts. */
> > 	sock = sock_from_file(fd, &err);
> > 	if (sock) {
> > 		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> > 		sock_update_classid(&sock->sk->sk_cgrp_data);
> > 	}
> > 
> > 	return fd;
> > }
> > 
> > If everyone else *really* prefers keeping the get_unused_fd_flags() /
> > put_unused_fd() stuff outside the helper, then I guess I'll give up,
> > but I think it is MUCH cleaner this way -- all 4 users trim down lots
> > of code duplication.
> > 
> > -- 
> > Kees Cook
How about this:


static int do_dup2(struct files_struct *files,
	struct file *file, unsigned fd, unsigned flags)
__releases(&files->file_lock)
{
	struct file *tofree;
	struct fdtable *fdt;

	...

	/*
	 * New bit, allowing the file to be null. Doesn't have the same
	 * "sanity check" bits from __alloc_fd
	 */
	if (likely(file))
		get_file(file);
	rcu_assign_pointer(fdt->fd[fd], file);

	__set_open_fd(fd, fdt);

	...
}

/*
 * File Receive - Receive a file from another process
 *
 * Encapsulates the logic to handle receiving a file from another task. It
 * does not install the file descriptor. That is delegated to the user. If
 * an error occurs that results in the file descriptor not being installed,
 * they must put_unused_fd.
 *
 * fd should be >= 0 if you intend on replacing a file descriptor, or
 * alternatively -1 if you want file_receive to allocate an FD for you
 *
 * Returns the fd number on success.
 * Returns negative error code on failure.
 *
 */
int file_receive(int fd, unsigned int flags, struct file *file)
{
	int err;
	struct socket *sock;
	struct files_struct *files = current->files;

	err = security_file_receive(file);
	if (err)
		return err;

	if (fd >= 0) {
		if (fd >= rlimit(RLIMIT_NOFILE))
			return -EBADF;

		spin_lock(&files->file_lock);
		err = expand_files(files, fd);
		if (err < 0) {
			goto out_unlock;
		}

		err = do_dup2(files, NULL, fd, flags);
		if (err)
			return err;
	} else {
		fd = get_unused_fd_flags(flags);
		if (fd < 0)
			return fd;
	}

	sock = sock_from_file(file, &err);
	if (sock) {
		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
		sock_update_classid(&sock->sk->sk_cgrp_data);
	}

	return fd;

out_unlock:
	spin_unlock(&files->file_lock);
	return err;
}

---

then the code in scm.c:
err = file_receive(-1, flags, fp[i]);
if (err < 0)
	break;

new_fd = err;
err = put_user(new_fd, cmfptr);
if (err) {
	put_unused_fd(new_fd);
	break;
}

/* Bump the usage count and install the file. */
fd_install(new_fd, get_file(fp[i]));

And addfd:
ret = file_receive(addfd->fd, addfd->flags, addfd->file);
if (ret >= 0)
	fd_install(ret, get_file(addfd->file));
addfd->ret = ret;

----

This way there is:
1. No "put_user" logic in file_receive
2. Minimal (single) branching logic, unless there's something in between
   the file_receive and installing the FD, such as put_user.
3. Doesn't implement fd_install, so there's no ambiguity about it being
   file_install_received vs. just the receive logic.

