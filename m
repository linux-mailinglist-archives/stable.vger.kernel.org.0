Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E241F7CDD
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 20:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgFLS22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 14:28:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45497 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLS22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 14:28:28 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jjoPZ-0006KF-MP; Fri, 12 Jun 2020 18:28:17 +0000
Date:   Fri, 12 Jun 2020 20:28:16 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Denton <mpdenton@google.com>, Tejun Heo <tj@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <20200612182816.okwylihs6u6wkgxd@wittgenstein>
References: <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
 <202006111634.8237E6A5C6@keescook>
 <94407449bedd4ba58d85446401ff0a42@AcuMS.aculab.com>
 <20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal>
 <202006120806.E770867EF@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202006120806.E770867EF@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 08:13:25AM -0700, Kees Cook wrote:
> On Fri, Jun 12, 2020 at 10:46:30AM +0000, Sargun Dhillon wrote:
> > My suggest, written out (no idea if this code actually works), is as follows:
> > 
> > ioctl.h:
> > /* This needs to be added */
> > #define IOCDIR_MASK	(_IOC_DIRMASK << _IOC_DIRSHIFT)
> 
> This exists already:
> 
> #define _IOC_DIRMASK    ((1 << _IOC_DIRBITS)-1)
> 
> > 
> > 
> > seccomp.h:
> > 
> > struct struct seccomp_notif_addfd {
> > 	__u64 fd;
> > 	...
> > }
> > 
> > /* or IOW? */
> > #define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOWR(3, struct seccomp_notif_addfd)
> > 
> > seccomp.c:
> > static long seccomp_notify_addfd(struct seccomp_filter *filter,
> > 				 struct seccomp_notif_addfd __user *uaddfd int size)
> > {
> > 	struct seccomp_notif_addfd addfd;
> > 	int ret;
> > 
> > 	if (size < 32)
> > 		return -EINVAL;
> > 	if (size > PAGE_SIZE)
> > 		return -E2BIG;
> 
> (Tanget: what was the reason for copy_struct_from_user() not including
> the min/max check? I have a memory of Al objecting to having an
> "internal" limit?)

Al didn't want the PAGE_SIZE limit in there because there's nothing
inherently wrong with copying insane amounts of memory.

(Another tangent. I've asked this on Twitter not too long ago: do we
have stats how long copy_from_user()/copy_struct_from_user() takes with
growing struct/memory size? I'd be really interested in this. I have a
feeling that clone3()'s and - having had a chat with David Howells -
openat2()'s structs will continue to grow for a while... and I'd really
like to have some numbers on when copy_struct_from_user() becomes
costly or how costly it becomes.)

> 
> > 
> > 	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > 	if (ret)
> > 		return ret;
> > 
> > 	...
> > }
> > 
> > /* Mask out size */
> > #define SIZE_MASK(cmd)	(~IOCSIZE_MASK & cmd)
> > 
> > /* Mask out direction */
> > #define DIR_MASK(cmd)	(~IOCDIR_MASK & cmd)
> > 
> > static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
> > 				 unsigned long arg)
> > {
> > 	struct seccomp_filter *filter = file->private_data;
> > 	void __user *buf = (void __user *)arg;
> > 
> > 	/* Fixed size ioctls. Can be converted later on? */
> > 	switch (cmd) {
> > 	case SECCOMP_IOCTL_NOTIF_RECV:
> > 		return seccomp_notify_recv(filter, buf);
> > 	case SECCOMP_IOCTL_NOTIF_SEND:
> > 		return seccomp_notify_send(filter, buf);
> > 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
> > 		return seccomp_notify_id_valid(filter, buf);
> > 	}
> > 
> > 	/* Probably should make some nicer macros here */
> > 	switch (SIZE_MASK(DIR_MASK(cmd))) {
> > 	case SIZE_MASK(DIR_MASK(SECCOMP_IOCTL_NOTIF_ADDFD)):
> 
> Ah yeah, I like this because of what you mention below: it's forward
> compat too. (I'd just use the ioctl masks directly...)
> 
> 	switch (cmd & ~(_IOC_SIZEMASK | _IOC_DIRMASK))
> 
> > 		return seccomp_notify_addfd(filter, buf, _IOC_SIZE(cmd));
> 
> I really like that this ends up having the same construction as a
> standard EA syscall: the size is part of the syscall arguments.

This is basically what I had proposed in my previous mail, right?

Christian
