Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167351EDB27
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 04:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgFDCXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 22:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgFDCXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 22:23:01 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D7AC08C5C2
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 19:22:59 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k2so410866pjs.2
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 19:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yipjb/nJ+PoPYGY3bQlr0vEC5GDtsZwp9TVgxD0rnGk=;
        b=Qn2BQw97F7bIZrtjDlecVedaFxpvLQXfHqx5ZIkhrdMftq1Uzxuvb3gxbs04al8f6z
         dUNJTwOCuq0f5AzUIWaq/boxSUbsE7CQq5poZsErcM9jbnlKvwg3ugwzZmw6UY051thR
         aeypVbCcCPa33vgHBqM+4kc/3K8/7P1pLFmH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yipjb/nJ+PoPYGY3bQlr0vEC5GDtsZwp9TVgxD0rnGk=;
        b=EmfJojTQN9AeiZDizs0XItbvzVlfJBiOtbOWR+2r4f16M3Ud/rnit7/D3GXxTg/PW2
         scbCLURfg3pVWCFUWWNTulE34LNiSN+zsQWUjmFr4cYdxkJ8kUtsfV8m2e+ZgbiolZ5y
         CBGssw2zzE3r+4jJ6uemkWk1GjP/6mGg3MDzkvX9oFHba4STrUtGUuVu+RmtYNR65Hud
         28VQLgbNGxrnncoG7Pwo0oiNXSOv5DQVvEbPkuviloFuqfacEDCpx8n+zcsnKssZHWn2
         HlqZwFVv3LThsurcdCDf7Bc7F/lAOixFzAFQ0TyeP+RpV2MEjkCAJOsV4v22oa41xYri
         2ogw==
X-Gm-Message-State: AOAM531jM93mZu4icIBCGjhc0OkJkbyCzNhubL5m3dqUilQqSQtAB+VI
        fZcQwXON2K9/cnLNBNAJWHitBw==
X-Google-Smtp-Source: ABdhPJyecMU8uoaQFlZIapME+iRHy6MQjiZHyGdWTsN1FsR15QCal3RaNi3fnZYfnzICd0tiI8+uGQ==
X-Received: by 2002:a17:90a:4d4e:: with SMTP id l14mr3326764pjh.10.1591237379271;
        Wed, 03 Jun 2020 19:22:59 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y6sm3106283pfp.144.2020.06.03.19.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 19:22:58 -0700 (PDT)
Date:   Wed, 3 Jun 2020 19:22:57 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org,
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
Message-ID: <202006031845.F587F85A@keescook>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604012452.vh33nufblowuxfed@wittgenstein>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 04, 2020 at 03:24:52AM +0200, Christian Brauner wrote:
> On Tue, Jun 02, 2020 at 06:10:41PM -0700, Sargun Dhillon wrote:
> > Previously there were two chunks of code where the logic to receive file
> > descriptors was duplicated in net. The compat version of copying
> > file descriptors via SCM_RIGHTS did not have logic to update cgroups.
> > Logic to change the cgroup data was added in:
> > commit 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
> > commit d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
> > 
> > This was not copied to the compat path. This commit fixes that, and thus
> > should be cherry-picked into stable.
> > 
> > This introduces a helper (file_receive) which encapsulates the logic for
> > handling calling security hooks as well as manipulating cgroup information.
> > This helper can then be used other places in the kernel where file
> > descriptors are copied between processes
> > 
> > I tested cgroup classid setting on both the compat (x32) path, and the
> > native path to ensure that when moving the file descriptor the classid
> > is set.
> > 
> > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > Suggested-by: Kees Cook <keescook@chromium.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Christian Brauner <christian.brauner@ubuntu.com>
> > Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Jann Horn <jannh@google.com>,
> > Cc: John Fastabend <john.r.fastabend@intel.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Tycho Andersen <tycho@tycho.ws>
> > Cc: stable@vger.kernel.org
> > Cc: cgroups@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  fs/file.c            | 35 +++++++++++++++++++++++++++++++++++
> >  include/linux/file.h |  1 +
> >  net/compat.c         | 10 +++++-----
> >  net/core/scm.c       | 14 ++++----------
> >  4 files changed, 45 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/file.c b/fs/file.c
> > index abb8b7081d7a..5afd76fca8c2 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -18,6 +18,9 @@
> >  #include <linux/bitops.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/rcupdate.h>
> > +#include <net/sock.h>
> > +#include <net/netprio_cgroup.h>
> > +#include <net/cls_cgroup.h>
> >  
> >  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
> >  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> > @@ -931,6 +934,38 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
> >  	return err;
> >  }
> >  
> > +/*
> > + * File Receive - Receive a file from another process
> > + *
> > + * This function is designed to receive files from other tasks. It encapsulates
> > + * logic around security and cgroups. The file descriptor provided must be a
> > + * freshly allocated (unused) file descriptor.
> > + *
> > + * This helper does not consume a reference to the file, so the caller must put
> > + * their reference.
> > + *
> > + * Returns 0 upon success.
> > + */
> > +int file_receive(int fd, struct file *file)
> 
> This is all just a remote version of fd_install(), yet it deviates from
> fd_install()'s semantics and naming. That's not great imho. What about
> naming this something like:
> 
> fd_install_received()
> 
> and move the get_file() out of there so it has the same semantics as
> fd_install(). It seems rather dangerous to have a function like
> fd_install() that consumes a reference once it returned and another
> version of this that is basically the same thing but doesn't consume a
> reference because it takes its own. Seems an invitation for confusion.
> Does that make sense?

We have some competing opinions on this, I guess. What I really don't
like is the copy/pasting of the get_unused_fd_flags() and
put_unused_fd() needed by (nearly) all the callers. If it's a helper, it
should help. Specifically, I'd like to see this:

int file_receive(int fd, unsigned long flags, struct file *file,
		 int __user *fdptr)
{
	struct socket *sock;
	int err;

	err = security_file_receive(file);
	if (err)
		return err;

	if (fd < 0) {
		/* Install new fd. */
		int new_fd;

		err = get_unused_fd_flags(flags);
		if (err < 0)
			return err;
		new_fd = err;

		/* Copy fd to any waiting user memory. */
		if (fdptr) {
			err = put_user(new_fd, fdptr);
			if (err < 0) {
				put_unused_fd(new_fd);
				return err;
			}
		}
		fd_install(new_fd, get_file(file));
		fd = new_fd;
	} else {
		/* Replace existing fd. */
		err = replace_fd(fd, file, flags);
		if (err)
			return err;
	}

	/* Bump the cgroup usage counts. */
	sock = sock_from_file(fd, &err);
	if (sock) {
		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
		sock_update_classid(&sock->sk->sk_cgrp_data);
	}

	return fd;
}

If everyone else *really* prefers keeping the get_unused_fd_flags() /
put_unused_fd() stuff outside the helper, then I guess I'll give up,
but I think it is MUCH cleaner this way -- all 4 users trim down lots
of code duplication.

-- 
Kees Cook
