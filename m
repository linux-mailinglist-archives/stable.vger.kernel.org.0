Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFE41EDA67
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 03:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgFDBY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 21:24:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42656 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFDBY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 21:24:59 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jgecn-0006qD-L0; Thu, 04 Jun 2020 01:24:53 +0000
Date:   Thu, 4 Jun 2020 03:24:52 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Sargun Dhillon <sargun@sargun.me>
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
Message-ID: <20200604012452.vh33nufblowuxfed@wittgenstein>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200603011044.7972-2-sargun@sargun.me>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 06:10:41PM -0700, Sargun Dhillon wrote:
> Previously there were two chunks of code where the logic to receive file
> descriptors was duplicated in net. The compat version of copying
> file descriptors via SCM_RIGHTS did not have logic to update cgroups.
> Logic to change the cgroup data was added in:
> commit 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
> commit d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
> 
> This was not copied to the compat path. This commit fixes that, and thus
> should be cherry-picked into stable.
> 
> This introduces a helper (file_receive) which encapsulates the logic for
> handling calling security hooks as well as manipulating cgroup information.
> This helper can then be used other places in the kernel where file
> descriptors are copied between processes
> 
> I tested cgroup classid setting on both the compat (x32) path, and the
> native path to ensure that when moving the file descriptor the classid
> is set.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jann Horn <jannh@google.com>,
> Cc: John Fastabend <john.r.fastabend@intel.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Tycho Andersen <tycho@tycho.ws>
> Cc: stable@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/file.c            | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/file.h |  1 +
>  net/compat.c         | 10 +++++-----
>  net/core/scm.c       | 14 ++++----------
>  4 files changed, 45 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index abb8b7081d7a..5afd76fca8c2 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -18,6 +18,9 @@
>  #include <linux/bitops.h>
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
> +#include <net/sock.h>
> +#include <net/netprio_cgroup.h>
> +#include <net/cls_cgroup.h>
>  
>  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
>  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> @@ -931,6 +934,38 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
>  	return err;
>  }
>  
> +/*
> + * File Receive - Receive a file from another process
> + *
> + * This function is designed to receive files from other tasks. It encapsulates
> + * logic around security and cgroups. The file descriptor provided must be a
> + * freshly allocated (unused) file descriptor.
> + *
> + * This helper does not consume a reference to the file, so the caller must put
> + * their reference.
> + *
> + * Returns 0 upon success.
> + */
> +int file_receive(int fd, struct file *file)

This is all just a remote version of fd_install(), yet it deviates from
fd_install()'s semantics and naming. That's not great imho. What about
naming this something like:

fd_install_received()

and move the get_file() out of there so it has the same semantics as
fd_install(). It seems rather dangerous to have a function like
fd_install() that consumes a reference once it returned and another
version of this that is basically the same thing but doesn't consume a
reference because it takes its own. Seems an invitation for confusion.
Does that make sense?

> +{
> +	struct socket *sock;
> +	int err;
> +
> +	err = security_file_receive(file);
> +	if (err)
> +		return err;
> +
> +	fd_install(fd, get_file(file));
> +
> +	sock = sock_from_file(file, &err);
> +	if (sock) {
> +		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> +		sock_update_classid(&sock->sk->sk_cgrp_data);
> +	}
> +
> +	return 0;
> +}
> +
>  static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
>  {
>  	int err = -EBADF;
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 142d102f285e..7b56dc23e560 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -94,4 +94,5 @@ extern void fd_install(unsigned int fd, struct file *file);
>  extern void flush_delayed_fput(void);
>  extern void __fput_sync(struct file *);
>  
> +extern int file_receive(int fd, struct file *file);
>  #endif /* __LINUX_FILE_H */
> diff --git a/net/compat.c b/net/compat.c
> index 4bed96e84d9a..8ac0e7e09208 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -293,9 +293,6 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
>  
>  	for (i = 0, cmfptr = (int __user *) CMSG_COMPAT_DATA(cm); i < fdmax; i++, cmfptr++) {
>  		int new_fd;
> -		err = security_file_receive(fp[i]);
> -		if (err)
> -			break;
>  		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & kmsg->msg_flags
>  					  ? O_CLOEXEC : 0);
>  		if (err < 0)
> @@ -306,8 +303,11 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
>  			put_unused_fd(new_fd);
>  			break;
>  		}
> -		/* Bump the usage count and install the file. */
> -		fd_install(new_fd, get_file(fp[i]));
> +		err = file_receive(new_fd, fp[i]);
> +		if (err) {
> +			put_unused_fd(new_fd);
> +			break;
> +		}
>  	}
>  
>  	if (i > 0) {
> diff --git a/net/core/scm.c b/net/core/scm.c
> index dc6fed1f221c..ba93abf2881b 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -303,11 +303,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  	for (i=0, cmfptr=(__force int __user *)CMSG_DATA(cm); i<fdmax;
>  	     i++, cmfptr++)
>  	{
> -		struct socket *sock;
>  		int new_fd;
> -		err = security_file_receive(fp[i]);
> -		if (err)
> -			break;
>  		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & msg->msg_flags
>  					  ? O_CLOEXEC : 0);
>  		if (err < 0)
> @@ -318,13 +314,11 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  			put_unused_fd(new_fd);
>  			break;
>  		}
> -		/* Bump the usage count and install the file. */
> -		sock = sock_from_file(fp[i], &err);
> -		if (sock) {
> -			sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> -			sock_update_classid(&sock->sk->sk_cgrp_data);
> +		err = file_receive(new_fd, fp[i]);
> +		if (err) {
> +			put_unused_fd(new_fd);
> +			break;
>  		}
> -		fd_install(new_fd, get_file(fp[i]));
>  	}
>  
>  	if (i > 0)
> -- 
> 2.25.1
> 
