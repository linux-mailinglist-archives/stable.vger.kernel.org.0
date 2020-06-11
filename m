Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E471E1F7106
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 01:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFKXtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 19:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgFKXtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 19:49:40 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045ECC08C5C2
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 16:49:39 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b7so3561840pju.0
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 16:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bIgDlQTcxFw2KokzUZZm6ZkdF0vG1JUVRJ5FqN6wv7w=;
        b=EsU01laKYlXeUwOzqhDZANOi8lScnIXVlCztg5QhuFJsyVQo713bCIGsIewq5t48hK
         TXYXa29VAKYNO2/fMiuiFoiAuuyam8P394K3s2j/jS1UkQhxzRjnSyM61NwpSFXT6C2r
         dURzq4gRo8VVxydHIaMV2rFLmPerA444DM6uw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bIgDlQTcxFw2KokzUZZm6ZkdF0vG1JUVRJ5FqN6wv7w=;
        b=KPkTt5TKGeWYlOQ9j/0Cz5uNwvrOtGarLo48LvX6k24O//EB5wpjCxbnBYD00wUxNa
         jmNDmvogxgWWK8usW2iKQuW4HzsVVWbQdCPc81/pzaRxI6x/lC/KlRyo94boQUaRPKCH
         davu6RULm5qC/meh21owQ9dkZ1e+TOBTG1BmTD8KM2lfoekzH9kmPvude6b4ukDvajty
         pGKlNHZRDTtM4JcYyycs5v3v/MFIGUx50PG3NYQSm+4UMmA65IcM53DSnpVpCqO4f80B
         lLlgZ6YurznxmxFXLEPHkniG+NB/ywNYqN1JD8Yu3PGTT2KhNckv9ITsD410dNU+m3ya
         e1Ig==
X-Gm-Message-State: AOAM530x/ZF0JueGgstkzZW8FZQmw7dzPkvYFtNttXR3xlR7YZnPIJVd
        lmW9N3ganoocYw4/Vopvr6wdyw==
X-Google-Smtp-Source: ABdhPJzKAntT+tqihIhi6knyDIQA+kIZiwM6SoOqVvMIgkg6dNBDxl2KwSVM7Qy1cAVFqCn/cRDWuA==
X-Received: by 2002:a17:90b:e05:: with SMTP id ge5mr10405229pjb.49.1591919379416;
        Thu, 11 Jun 2020 16:49:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k126sm4448492pfd.129.2020.06.11.16.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 16:49:38 -0700 (PDT)
Date:   Thu, 11 Jun 2020 16:49:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Sargun Dhillon' <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Denton <mpdenton@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <202006111634.8237E6A5C6@keescook>
References: <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 02:56:22PM +0000, David Laight wrote:
> From: Sargun Dhillon
> > Sent: 11 June 2020 12:07
> > Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to move fds across processes
> > 
> > On Thu, Jun 11, 2020 at 12:01:14PM +0200, Christian Brauner wrote:
> > > On Wed, Jun 10, 2020 at 07:59:55PM -0700, Kees Cook wrote:
> > > > On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> > > > > As an aside, all of this junk should be dropped:
> > > > > +	ret = get_user(size, &uaddfd->size);
> > > > > +	if (ret)
> > > > > +		return ret;
> > > > > +
> > > > > +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > > > > +	if (ret)
> > > > > +		return ret;
> > > > >
> > > > > and the size member of the seccomp_notif_addfd struct. I brought this up
> > > > > off-list with Tycho that ioctls have the size of the struct embedded in them. We
> > > > > should just use that. The ioctl definition is based on this[2]:
> > > > > #define _IOC(dir,type,nr,size) \
> > > > > 	(((dir)  << _IOC_DIRSHIFT) | \
> > > > > 	 ((type) << _IOC_TYPESHIFT) | \
> > > > > 	 ((nr)   << _IOC_NRSHIFT) | \
> > > > > 	 ((size) << _IOC_SIZESHIFT))
> > > > >
> > > > >
> > > > > We should just use copy_from_user for now. In the future, we can either
> > > > > introduce new ioctl names for new structs, or extract the size dynamically from
> > > > > the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.
> > > >
> > > > Yeah, that seems reasonable. Here's the diff for that part:
> > >
> > > Why does it matter that the ioctl() has the size of the struct embedded
> > > within? Afaik, the kernel itself doesn't do anything with that size. It
> > > merely checks that the size is not pathological and it does so at
> > > compile time.
> > >
> > > #ifdef __CHECKER__
> > > #define _IOC_TYPECHECK(t) (sizeof(t))
> > > #else
> > > /* provoke compile error for invalid uses of size argument */
> > > extern unsigned int __invalid_size_argument_for_IOC;
> > > #define _IOC_TYPECHECK(t) \
> > > 	((sizeof(t) == sizeof(t[1]) && \
> > > 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
> > > 	  sizeof(t) : __invalid_size_argument_for_IOC)
> > > #endif
> > >
> > > The size itself is not verified at runtime. copy_struct_from_user()
> > > still makes sense at least if we're going to allow expanding the struct
> > > in the future.
> > Right, but if we simply change our headers and extend the struct, it will break
> > all existing programs compiled against those headers. In order to avoid that, if
> > we intend on extending this struct by appending to it, we need to have a
> > backwards compatibility mechanism. Just having copy_struct_from_user isn't
> > enough. The data structure either must be fixed size, or we need a way to handle
> > multiple ioctl numbers derived from headers with different sized struct arguments
> > 
> > The two approaches I see are:
> > 1. use more indirection. This has previous art in drm[1]. That's look
> > something like this:
> > 
> > struct seccomp_notif_addfd_ptr {
> > 	__u64 size;
> > 	__u64 addr;
> > }
> > 
> > ... And then it'd be up to us to dereference the addr and copy struct from user.
> 
> Do not go down that route. It isn't worth the pain.
> 
> You should also assume that userspace might have a compile-time check
> on the buffer length (I've written one - not hard) and that the kernel
> might (in the future - or on a BSD kernel) be doing the user copies
> for you.
> 
> Also, if you change the structure you almost certainly need to
> change the name of the ioctl cmd as well as its value.
> Otherwise a recompiled program will pass the new cmd value (and
> hopefully the right sized buffer) but it won't have initialised
> the buffer properly.
> This is likely to lead to unexpected behaviour.

Hmmm.

So, while initially I thought Sargun's observation about ioctl's fixed
struct size was right, I think I've been swayed to Christian's view
(which is supported by the long tail of struct size pain we've seen in
other APIs).

Doing a separate ioctl for each structure version seems like the "old
solution" now that we've got EA syscalls. So, I'd like to keep the size
and copy_struct_from_user().

Which leaves us with the question of how to deal with the ioctl
numbering. As we've seen, there is no actual enforcement of direction
nor size, so to that end, while we could provide the hints about both, I
guess we just don't need to. To that end, perhaps _IO() is best:

#define SECCOMP_IOCTL_NOTIF_ADDFD       SECCOMP_IO(3)

Alternatively, we could use a size of either 0, 8(u64), or -1, and then
use IORW() so we _also_ won't paint ourselves into a corner if we ever
want to write something back to userspace in the structure:

#define SECCOMP_IOCTL_EA(nr) _IOC(_IOC_READ|_IOC_WRITE,SECCOMP_IOC_MAGIC,(nr),0)
#define SECCOMP_IOCTL_NOTIF_ADDFD       SECCOMP_IOCTL_EA(3)

or

#define SECCOMP_IOCTL_EA(nr) _IOC(_IOC_READ|_IOC_WRITE,SECCOMP_IOC_MAGIC,(nr),8)
#define SECCOMP_IOCTL_NOTIF_ADDFD       SECCOMP_IOCTL_EA(3)

or

#define SECCOMP_IOCTL_EA(nr) _IOC(_IOC_READ|_IOC_WRITE,SECCOMP_IOC_MAGIC,(nr),_IOC_SIZEMASK)
#define SECCOMP_IOCTL_NOTIF_ADDFD       SECCOMP_IOCTL_EA(3)

I think I prefer the last one.

-- 
Kees Cook
