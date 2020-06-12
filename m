Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34781F7A7E
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgFLPNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 11:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgFLPNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 11:13:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D95C08C5C3
        for <stable@vger.kernel.org>; Fri, 12 Jun 2020 08:13:29 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a127so4423035pfa.12
        for <stable@vger.kernel.org>; Fri, 12 Jun 2020 08:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pno+5kYSHMw8xwXOucwExt5jksL9Xbw8epr6Z7fMvHE=;
        b=JSjDP2ux5xIsExDkMu+jKwnIWyDo4yP7FcO/2uWZWDhSupr7sF/6Bfpw0z0x2wQ2jD
         j1ozQAHLCGlCTem8qZTE8r5BEHrMzvoaVFkJpu0QI/WYFW09ANKlCOnUPTxBzpCa6lzT
         u+IsrxgbSZPWpttOWWycjfaNnRDFQE2NPKRQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pno+5kYSHMw8xwXOucwExt5jksL9Xbw8epr6Z7fMvHE=;
        b=ZVUFsarFQKK7PbiOkF37AoEyHglSDpivvvNs1zScRiXCBmXYRW/MvQJF02FYv3xM/+
         ItD+qQ8vYWfFhSRT2fIBLRQFKJvf6mXfU0DdORxbXDGvhKUa7imyKfunMZrRzVuIXaFG
         eMutebEA2Zt5NYWJHGEihuL8nQceNvy80RhOTe0mr9IkMHeK0yu6k8eFm+PHGyr9dOLB
         jHB+liYU4j4cxBMMSA0moeZNr3jqJQZ7l3xQm6ILry6fnezFoeTQUwfzxCZYwGNQ/Cyy
         QhwI+YDrdn4jXwXCzkumPvU/gV6ZO4d2XE98R+o/Xdj0Viw+NYyDs8hKjVoUl28W4+BH
         O7qQ==
X-Gm-Message-State: AOAM530MRcKnvoCn8/yA07p2H9ehfaHlfH3T/7JvvI86Xywve+EM0D+D
        QfwsLD18mJhUFNYZEqZSHL/u/Q==
X-Google-Smtp-Source: ABdhPJyXqtcPGd0aOR35qpAPznOfkgdDl72Ymk+kTDk2BJaQ8wwoEcZmw5DNB85G8nblxzhkxmohAQ==
X-Received: by 2002:a62:8c15:: with SMTP id m21mr11771587pfd.182.1591974808293;
        Fri, 12 Jun 2020 08:13:28 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y4sm6573117pfr.182.2020.06.12.08.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 08:13:27 -0700 (PDT)
Date:   Fri, 12 Jun 2020 08:13:25 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Denton <mpdenton@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <202006120806.E770867EF@keescook>
References: <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
 <202006111634.8237E6A5C6@keescook>
 <94407449bedd4ba58d85446401ff0a42@AcuMS.aculab.com>
 <20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 10:46:30AM +0000, Sargun Dhillon wrote:
> My suggest, written out (no idea if this code actually works), is as follows:
> 
> ioctl.h:
> /* This needs to be added */
> #define IOCDIR_MASK	(_IOC_DIRMASK << _IOC_DIRSHIFT)

This exists already:

#define _IOC_DIRMASK    ((1 << _IOC_DIRBITS)-1)

> 
> 
> seccomp.h:
> 
> struct struct seccomp_notif_addfd {
> 	__u64 fd;
> 	...
> }
> 
> /* or IOW? */
> #define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOWR(3, struct seccomp_notif_addfd)
> 
> seccomp.c:
> static long seccomp_notify_addfd(struct seccomp_filter *filter,
> 				 struct seccomp_notif_addfd __user *uaddfd int size)
> {
> 	struct seccomp_notif_addfd addfd;
> 	int ret;
> 
> 	if (size < 32)
> 		return -EINVAL;
> 	if (size > PAGE_SIZE)
> 		return -E2BIG;

(Tanget: what was the reason for copy_struct_from_user() not including
the min/max check? I have a memory of Al objecting to having an
"internal" limit?)

> 
> 	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> 	if (ret)
> 		return ret;
> 
> 	...
> }
> 
> /* Mask out size */
> #define SIZE_MASK(cmd)	(~IOCSIZE_MASK & cmd)
> 
> /* Mask out direction */
> #define DIR_MASK(cmd)	(~IOCDIR_MASK & cmd)
> 
> static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
> 				 unsigned long arg)
> {
> 	struct seccomp_filter *filter = file->private_data;
> 	void __user *buf = (void __user *)arg;
> 
> 	/* Fixed size ioctls. Can be converted later on? */
> 	switch (cmd) {
> 	case SECCOMP_IOCTL_NOTIF_RECV:
> 		return seccomp_notify_recv(filter, buf);
> 	case SECCOMP_IOCTL_NOTIF_SEND:
> 		return seccomp_notify_send(filter, buf);
> 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
> 		return seccomp_notify_id_valid(filter, buf);
> 	}
> 
> 	/* Probably should make some nicer macros here */
> 	switch (SIZE_MASK(DIR_MASK(cmd))) {
> 	case SIZE_MASK(DIR_MASK(SECCOMP_IOCTL_NOTIF_ADDFD)):

Ah yeah, I like this because of what you mention below: it's forward
compat too. (I'd just use the ioctl masks directly...)

	switch (cmd & ~(_IOC_SIZEMASK | _IOC_DIRMASK))

> 		return seccomp_notify_addfd(filter, buf, _IOC_SIZE(cmd));

I really like that this ends up having the same construction as a
standard EA syscall: the size is part of the syscall arguments.

> 	default:
> 		return -EINVAL;
> 	}
> }
> 
> --------
> 
> What boxes does this tick?
> * Forwards (and backwards) compatibility
> * Applies to existing commands
> * Command can be extended without requiring new ioctl to be defined

(Technically, a new one is always redefined, but it's automatic in that
the kernel needs to do nothing.)

> * It well accomodates the future where we want to have a kernel
>   helper copy the structures from userspace

Yeah, this is a good solution.

> The fact that the size of the argument struct, and the ioctl are defined in the 
> same header gives us the ability to "cheat", and for the argument size to be 
> included / embedded for free in the command passed to ioctl. In turn, this
> gives us two benefits. First, it means we don't have to copy from user twice,
> and can just do it all in one shot since the size is passed with the syscall
> arguments. Second, it means that the user does not have to do the following:
> 
> seccomp_notif_addfd addfd = {};
> addfd.size = sizeof(struct seccomp_notif_addfd)
> 
> Because sizeof(struct seccomp_notif_addfd) is embedded in 
> SECCOMP_IOCTL_NOTIF_ADDFD based on the same headers they plucked the struct out of.

Cool. I will do more patch reworking! ;)

-- 
Kees Cook
