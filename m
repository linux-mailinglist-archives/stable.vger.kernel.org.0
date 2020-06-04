Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545951EDCAF
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 07:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgFDFUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 01:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgFDFUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 01:20:46 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90251C03E96E
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 22:20:44 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id j8so4911298iog.13
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 22:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oKNXmPZh2jB30BHUyHRPpl5a8wx5yENQJM5HVKTmIUg=;
        b=054UqkhvVty3ow+lMQbK9j4Udt3zohY4MtWydjS8v+qaL1KEzL/lBvin5kq+w6wouX
         hZI4wLQja9EIX1nva9plQnfwHl8FzoXwywvdWospv8P8d7E04VgKiRV9X8gRx2J9T1CC
         JEXiaCtFU/kNPlAOilsNcnuQhrVealltviXyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oKNXmPZh2jB30BHUyHRPpl5a8wx5yENQJM5HVKTmIUg=;
        b=fPiHNbEzqdiHp06Mn2JzKYMR+ZSpZdcZyvCgsFVxAps55InZJhJx+MGEJfokTS1F2r
         tbcnVw7bMOzW0mzt/ttTgPozVHe5CzNFxXJUJOLWXUShEWBr9vqyHd1MckZMY8BELMF+
         iuJ8QeQE/Rq7rSuJrNF0GPvJAy3+THJNanEArNICpycPdxRJatVhhcA1QC2+YwRsIo5v
         bzGnuc2lgLLxoMPCZ6EZpUQAcqwkHwNDVbc5UQ4FSUY9Zjr8w4kHieB7VNJ8Vxq4Noul
         5DyttHigbrEEIJX3+I88gNNT4JZ6mAJsFslMTstA+mqi5GzUlnYctvmPWnDt33y7cp1B
         VNlw==
X-Gm-Message-State: AOAM532uA73eJPA2aOCvR2M4HR7gKsu+tRHYLglA0ioRAY916P6kS/u/
        wnFboHZJnJRlK0LyjoUNBq2H2A==
X-Google-Smtp-Source: ABdhPJz1JJFpDvHfIzAqgbnGUeuraT6RkK3cM76pgob/tqzC+lFOJzt//SUhOOU6QHvDtvw+nG2caw==
X-Received: by 2002:a5d:9e51:: with SMTP id i17mr2607501ioi.8.1591248043464;
        Wed, 03 Jun 2020 22:20:43 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id r17sm900698ilc.33.2020.06.03.22.20.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Jun 2020 22:20:42 -0700 (PDT)
Date:   Thu, 4 Jun 2020 05:20:41 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        linux-kernel@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Robert Sesek <rsesek@google.com>,
        containers@lists.linux-foundation.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org,
        cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <20200604052040.GA16501@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006031845.F587F85A@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 07:22:57PM -0700, Kees Cook wrote:
> On Thu, Jun 04, 2020 at 03:24:52AM +0200, Christian Brauner wrote:
> > On Tue, Jun 02, 2020 at 06:10:41PM -0700, Sargun Dhillon wrote:
> > > Previously there were two chunks of code where the logic to receive file
> > > descriptors was duplicated in net. The compat version of copying
> > > file descriptors via SCM_RIGHTS did not have logic to update cgroups.
> > > Logic to change the cgroup data was added in:
> > > commit 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
> > > commit d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
> > > 
> > > This was not copied to the compat path. This commit fixes that, and thus
> > > should be cherry-picked into stable.
> > > 
> > > This introduces a helper (file_receive) which encapsulates the logic for
> > > handling calling security hooks as well as manipulating cgroup information.
> > > This helper can then be used other places in the kernel where file
> > > descriptors are copied between processes
> > > 
> > > I tested cgroup classid setting on both the compat (x32) path, and the
> > > native path to ensure that when moving the file descriptor the classid
> > > is set.
> > > 
> > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > Suggested-by: Kees Cook <keescook@chromium.org>
> > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > Cc: Christian Brauner <christian.brauner@ubuntu.com>
> > > Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > > Cc: David S. Miller <davem@davemloft.net>
> > > Cc: Jann Horn <jannh@google.com>,
> > > Cc: John Fastabend <john.r.fastabend@intel.com>
> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: Tycho Andersen <tycho@tycho.ws>
> > > Cc: stable@vger.kernel.org
> > > Cc: cgroups@vger.kernel.org
> > > Cc: linux-fsdevel@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  fs/file.c            | 35 +++++++++++++++++++++++++++++++++++
> > >  include/linux/file.h |  1 +
> > >  net/compat.c         | 10 +++++-----
> > >  net/core/scm.c       | 14 ++++----------
> > >  4 files changed, 45 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/fs/file.c b/fs/file.c
> > > index abb8b7081d7a..5afd76fca8c2 100644
> > > --- a/fs/file.c
> > > +++ b/fs/file.c
> > > @@ -18,6 +18,9 @@
> > >  #include <linux/bitops.h>
> > >  #include <linux/spinlock.h>
> > >  #include <linux/rcupdate.h>
> > > +#include <net/sock.h>
> > > +#include <net/netprio_cgroup.h>
> > > +#include <net/cls_cgroup.h>
> > >  
> > >  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
> > >  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> > > @@ -931,6 +934,38 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
> > >  	return err;
> > >  }
> > >  
> > > +/*
> > > + * File Receive - Receive a file from another process
> > > + *
> > > + * This function is designed to receive files from other tasks. It encapsulates
> > > + * logic around security and cgroups. The file descriptor provided must be a
> > > + * freshly allocated (unused) file descriptor.
> > > + *
> > > + * This helper does not consume a reference to the file, so the caller must put
> > > + * their reference.
> > > + *
> > > + * Returns 0 upon success.
> > > + */
> > > +int file_receive(int fd, struct file *file)
> > 
> > This is all just a remote version of fd_install(), yet it deviates from
> > fd_install()'s semantics and naming. That's not great imho. What about
> > naming this something like:
> > 
> > fd_install_received()
> > 
> > and move the get_file() out of there so it has the same semantics as
> > fd_install(). It seems rather dangerous to have a function like
> > fd_install() that consumes a reference once it returned and another
> > version of this that is basically the same thing but doesn't consume a
> > reference because it takes its own. Seems an invitation for confusion.
> > Does that make sense?
> 
> We have some competing opinions on this, I guess. What I really don't
> like is the copy/pasting of the get_unused_fd_flags() and
> put_unused_fd() needed by (nearly) all the callers. If it's a helper, it
> should help. Specifically, I'd like to see this:
> 
> int file_receive(int fd, unsigned long flags, struct file *file,
> 		 int __user *fdptr)
> {
> 	struct socket *sock;
> 	int err;
> 
> 	err = security_file_receive(file);
> 	if (err)
> 		return err;
> 
> 	if (fd < 0) {
> 		/* Install new fd. */
> 		int new_fd;
> 
> 		err = get_unused_fd_flags(flags);
> 		if (err < 0)
> 			return err;
> 		new_fd = err;
> 
> 		/* Copy fd to any waiting user memory. */
> 		if (fdptr) {
> 			err = put_user(new_fd, fdptr);
> 			if (err < 0) {
> 				put_unused_fd(new_fd);
> 				return err;
> 			}
> 		}
> 		fd_install(new_fd, get_file(file));
> 		fd = new_fd;
> 	} else {
> 		/* Replace existing fd. */
> 		err = replace_fd(fd, file, flags);
> 		if (err)
> 			return err;
> 	}
> 
> 	/* Bump the cgroup usage counts. */
> 	sock = sock_from_file(fd, &err);
> 	if (sock) {
> 		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> 		sock_update_classid(&sock->sk->sk_cgrp_data);
> 	}
> 
> 	return fd;
> }
> 
> If everyone else *really* prefers keeping the get_unused_fd_flags() /
> put_unused_fd() stuff outside the helper, then I guess I'll give up,
> but I think it is MUCH cleaner this way -- all 4 users trim down lots
> of code duplication.
> 
> -- 
> Kees Cook
This seems weird that the function has two different return mechanisms
depending on the value of fdptr, especially given that behaviour is
only invoked by SCM, whereas the other callers (addfd, and pidfd_getfd)
just want the FD value returned.

Won't this produce a "bad" result, if the user does:

struct msghdr msg = {};
struct cmsghdr *cmsg;
struct iovec io = {
	.iov_base = &c,
	.iov_len = 1,
};

msg.msg_iov = &io;
msg.msg_iovlen = 1;
msg.msg_control = NULL;
msg.msg_controllen = sizeof(buf);

recvmsg(sock, &msg, 0);
----

This will end up installing the FD, but it will efault, when
scm_detach_fds tries to fill out the rest of the info. 

I mean, we can easily solve this with a null pointer check
in scm_detach_fds, but my fear is that user n will forget
to do this, and make a mistake.

Maybe it would be nice to have:

/* Receives file descriptor and installs it in userspace at uptr. */
static inline intfile_receive_user(struct file *file, unsigned long flags,
				   int __user *fdptr)
{
	if (fdptr == NULL)
		return -EFAULT;

	return __file_receive(-1, flags, file, uptr);
}

And then just let pidfd_getfd, and seccomp_addfd call __file_receive
directly, or offer a different helper like:

static inline file_receive(long fd, struct *file, unsigned long flags)
{
	return __file_receive(fd, flags, file, NULL);
}
