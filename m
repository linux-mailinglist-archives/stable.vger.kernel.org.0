Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2091F512D
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 11:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgFJJbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 05:31:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56045 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgFJJbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 05:31:04 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jix4R-0005Hy-9B; Wed, 10 Jun 2020 09:30:55 +0000
Date:   Wed, 10 Jun 2020 11:30:54 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     containers@lists.linux-foundation.org,
        Kees Cook <keescook@chromium.org>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        linux-kernel@vger.kernel.org, Matt Denton <mpdenton@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org,
        stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <20200610093054.z7hydwbcmh7ocanw@wittgenstein>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 11:27:30PM +0200, Christian Brauner wrote:
> On June 9, 2020 10:55:42 PM GMT+02:00, Kees Cook <keescook@chromium.org> wrote:
> >On Tue, Jun 09, 2020 at 10:03:46PM +0200, Christian Brauner wrote:
> >> I'm looking at __scm_install_fd() and I wonder what specifically you
> >> mean by that? The put_user() seems to be placed such that the install
> >> occurrs only if it succeeded. Sure, it only handles a single fd but
> >> whatever. Userspace knows that already. Just look at systemd when a
> >msg
> >> fails:
> >> 
> >> void cmsg_close_all(struct msghdr *mh) {
> >>         struct cmsghdr *cmsg;
> >> 
> >>         assert(mh);
> >> 
> >>         CMSG_FOREACH(cmsg, mh)
> >>                 if (cmsg->cmsg_level == SOL_SOCKET && cmsg->cmsg_type
> >== SCM_RIGHTS)
> >>                         close_many((int*) CMSG_DATA(cmsg),
> >(cmsg->cmsg_len - CMSG_LEN(0)) / sizeof(int));
> >> }
> >> 
> >> The only reasonable scenario for this whole mess I can think of is sm
> >like (pseudo code):
> >> 
> >> fd_install_received(int fd, struct file *file)
> >> {
> >>  	sock = sock_from_file(fd, &err);
> >>  	if (sock) {
> >>  		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> >>  		sock_update_classid(&sock->sk->sk_cgrp_data);
> >>  	}
> >> 
> >> 	fd_install();
> >> }
> >> 
> >> error = 0;
> >> fdarray = malloc(fdmax);
> >> for (i = 0; i < fdmax; i++) {
> >> 	fdarray[i] = get_unused_fd_flags(o_flags);
> >> 	if (fdarray[i] < 0) {
> >> 		error = -EBADF;
> >> 		break;
> >> 	}
> >> 
> >> 	error = security_file_receive(file);
> >> 	if (error)
> >> 		break;
> >> 
> >> 	error = put_user(fd_array[i], ufd);
> >> 	if (error)
> >> 		break;
> >> }
> >> 
> >> for (i = 0; i < fdmax; i++) {
> >> 	if (error) {
> >> 		/* ignore errors */
> >> 		put_user(-EBADF, ufd); /* If this put_user() fails and the first
> >one succeeded userspace might now close an fd it didn't intend to. */
> >> 		put_unused_fd(fdarray[i]);
> >> 	} else {
> >> 		fd_install_received(fdarray[i], file);
> >> 	}
> >> }
> >
> >I see 4 cases of the same code pattern (get_unused_fd_flags(),
> >sock_update_*(), fd_install()), one of them has this difficult
> >put_user()
> >in the middle, and one of them has a potential replace_fd() instead of
> >the get_used/fd_install. So, to me, it makes sense to have a helper
> >that
> >encapsulates the common work that each of those call sites has to do,
> >which I keep cringing at all these suggestions that leave portions of
> >it
> >outside the helper.
> >
> >If it's too ugly to keep the put_user() in the helper, then we can try
> >what was suggested earlier, and just totally rework the failure path
> >for
> >SCM_RIGHTS.
> >
> >LOL. And while we were debating this, hch just went and cleaned stuff
> >up:
> >
> >2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> >
> >So, um, yeah, now my proposal is actually even closer to what we
> >already
> >have there. We just add the replace_fd() logic to __scm_install_fd()
> >and
> >we're done with it.
> 
> Cool, you have a link? :)

For the record, as I didn't see this yesterday since I was already
looking at a kernel with Christoph's changes. His changes just move the
logic that was already there before into a separate helper.

So effectively nothing has changed semantically in the scm code at all.

This is why I was asking yesterday what you meant by reworking the scm
code's put_user() logic as it seems obviously correct as it is done now.

Christian
