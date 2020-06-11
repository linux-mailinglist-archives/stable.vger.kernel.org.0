Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845C51F6494
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 11:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgFKJTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 05:19:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43309 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgFKJTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 05:19:52 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jjJN9-0007JQ-NC; Thu, 11 Jun 2020 09:19:43 +0000
Date:   Thu, 11 Jun 2020 11:19:42 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        containers@lists.linux-foundation.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
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
Message-ID: <20200611091942.jni2glnpmxisnant@wittgenstein>
References: <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202006101953.899EFB53@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 07:59:55PM -0700, Kees Cook wrote:
> On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> > As an aside, all of this junk should be dropped:
> > +	ret = get_user(size, &uaddfd->size);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > +	if (ret)
> > +		return ret;
> > 
> > and the size member of the seccomp_notif_addfd struct. I brought this up 
> > off-list with Tycho that ioctls have the size of the struct embedded in them. We 
> > should just use that. The ioctl definition is based on this[2]:
> > #define _IOC(dir,type,nr,size) \
> > 	(((dir)  << _IOC_DIRSHIFT) | \
> > 	 ((type) << _IOC_TYPESHIFT) | \
> > 	 ((nr)   << _IOC_NRSHIFT) | \
> > 	 ((size) << _IOC_SIZESHIFT))
> > 
> > 
> > We should just use copy_from_user for now. In the future, we can either 
> > introduce new ioctl names for new structs, or extract the size dynamically from 
> > the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.
> 
> Yeah, that seems reasonable. Here's the diff for that part:
> 
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index 7b6028b399d8..98bf19b4e086 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -118,7 +118,6 @@ struct seccomp_notif_resp {
>  
>  /**
>   * struct seccomp_notif_addfd
> - * @size: The size of the seccomp_notif_addfd datastructure
>   * @id: The ID of the seccomp notification
>   * @flags: SECCOMP_ADDFD_FLAG_*
>   * @srcfd: The local fd number
> @@ -126,7 +125,6 @@ struct seccomp_notif_resp {
>   * @newfd_flags: The O_* flags the remote FD should have applied
>   */
>  struct seccomp_notif_addfd {
> -	__u64 size;
>  	__u64 id;
>  	__u32 flags;
>  	__u32 srcfd;
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 3c913f3b8451..00cbdad6c480 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1297,14 +1297,9 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
>  	struct seccomp_notif_addfd addfd;
>  	struct seccomp_knotif *knotif;
>  	struct seccomp_kaddfd kaddfd;
> -	u64 size;
>  	int ret;
>  
> -	ret = get_user(size, &uaddfd->size);
> -	if (ret)
> -		return ret;
> -
> -	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> +	ret = copy_from_user(&addfd, uaddfd, sizeof(addfd));
>  	if (ret)
>  		return ret;
>  
> 
> > 
> > ----
> > +#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
> > +						struct seccomp_notif_addfd)
> > 
> > Lastly, what I believe to be a small mistake, it should be SECCOMP_IOW, based on 
> > the documentation in ioctl.h -- "_IOW means userland is writing and kernel is 
> > reading."
> 
> Oooooh. Yeah; good catch. Uhm, that means SECCOMP_IOCTL_NOTIF_ID_VALID
> is wrong too, yes? Tycho, Christian, how disruptive would this be to
> fix? (Perhaps support both and deprecate the IOR version at some point
> in the future?)

We have custom defines in our source code, i.e.
#define SECCOMP_IOCTL_NOTIF_ID_VALID  SECCOMP_IOR(2, __u64)
so ideally we'd have a SECCOMP_IOCTL_NOTIF_ID_VALID_V2

Does that sound ok?

Christian
