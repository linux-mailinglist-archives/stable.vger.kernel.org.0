Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593C614790D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 08:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgAXHre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 02:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgAXHre (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 02:47:34 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EFB92071A;
        Fri, 24 Jan 2020 07:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579852052;
        bh=TzKIcShPbXV86j/ne+0jGsahikBovP7GGd4G3GuTOIw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jcf90v8W35fcShvCDVE9NfL2UBWbi2jhBr8SY16yFJ4IKoNnfHxmzPgiP2g/m9rXh
         H7iGu8kt9BXrC5t8Grow4NPJU+wMzRmcLhvplSgU6Ilfvdk0KAj9LBQVo0L5H7ACDf
         O1+DPMkFjS0Wa7SZfzJZSX/TM4dkgtAQk1E5tkDA=
Date:   Fri, 24 Jan 2020 08:38:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>, Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge@hallyn.com>, Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 4.14 20/65] ptrace: reintroduce usage of subjective
 credentials in ptrace_has_cap()
Message-ID: <20200124073822.GA2910462@kroah.com>
References: <20200122092750.976732974@linuxfoundation.org>
 <20200122092754.007578340@linuxfoundation.org>
 <20200123230129.GA3737@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123230129.GA3737@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 23, 2020 at 03:01:29PM -0800, Guenter Roeck wrote:
> On Wed, Jan 22, 2020 at 10:29:05AM +0100, Greg Kroah-Hartman wrote:
> > From: Christian Brauner <christian.brauner@ubuntu.com>
> > 
> > commit 6b3ad6649a4c75504edeba242d3fd36b3096a57f upstream.
> > 
> > Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> > introduced the ability to opt out of audit messages for accesses to various
> > proc files since they are not violations of policy.  While doing so it
> > somehow switched the check from ns_capable() to
> > has_ns_capability{_noaudit}(). That means it switched from checking the
> > subjective credentials of the task to using the objective credentials. This
> > is wrong since. ptrace_has_cap() is currently only used in
> > ptrace_may_access() And is used to check whether the calling task (subject)
> > has the CAP_SYS_PTRACE capability in the provided user namespace to operate
> > on the target task (object). According to the cred.h comments this would
> > mean the subjective credentials of the calling task need to be used.
> > This switches ptrace_has_cap() to use security_capable(). Because we only
> > call ptrace_has_cap() in ptrace_may_access() and in there we already have a
> > stable reference to the calling task's creds under rcu_read_lock() there's
> > no need to go through another series of dereferences and rcu locking done
> > in ns_capable{_noaudit}().
> > 
> > As one example where this might be particularly problematic, Jann pointed
> > out that in combination with the upcoming IORING_OP_OPENAT feature, this
> > bug might allow unprivileged users to bypass the capability checks while
> > asynchronously opening files like /proc/*/mem, because the capability
> > checks for this would be performed against kernel credentials.
> > 
> > To illustrate on the former point about this being exploitable: When
> > io_uring creates a new context it records the subjective credentials of the
> > caller. Later on, when it starts to do work it creates a kernel thread and
> > registers a callback. The callback runs with kernel creds for
> > ktask->real_cred and ktask->cred. To prevent this from becoming a
> > full-blown 0-day io_uring will call override_cred() and override
> > ktask->cred with the subjective credentials of the creator of the io_uring
> > instance. With ptrace_has_cap() currently looking at ktask->real_cred this
> > override will be ineffective and the caller will be able to open arbitray
> > proc files as mentioned above.
> > Luckily, this is currently not exploitable but will turn into a 0-day once
> > IORING_OP_OPENAT{2} land in v5.6. Fix it now!
> > 
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Eric Paris <eparis@redhat.com>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Reviewed-by: Serge Hallyn <serge@hallyn.com>
> > Reviewed-by: Jann Horn <jannh@google.com>
> > Fixes: 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  kernel/ptrace.c |   15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> > 
> > --- a/kernel/ptrace.c
> > +++ b/kernel/ptrace.c
> > @@ -258,12 +258,17 @@ static int ptrace_check_attach(struct ta
> >  	return ret;
> >  }
> >  
> > -static int ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
> > +static bool ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
> > +			   unsigned int mode)
> >  {
> > +	int ret;
> > +
> >  	if (mode & PTRACE_MODE_NOAUDIT)
> > -		return has_ns_capability_noaudit(current, ns, CAP_SYS_PTRACE);
> > +		ret = security_capable(cred, ns, CAP_SYS_PTRACE);
> >  	else
> > -		return has_ns_capability(current, ns, CAP_SYS_PTRACE);
> > +		ret = security_capable(cred, ns, CAP_SYS_PTRACE);
> > +
> > +	return ret == 0;
> 
> This results in
> 	if (condition)
> 		do_something;
> 	else
> 		do_the_same;
> 
> Is that really correct ? The upstream patch calls security_capable()
> with additional CAP_OPT_NOAUDIT vs. CAP_OPT_NONE parameter, which does
> make sense. But I don't really see the benefit of the change above.

Yeah, this is odd, and differs from the original version I applied to
the staging queue.

Sasha, you made this change to the patch, I'm guessing to make it build
properly in 4.14?  Should I just have dropped it from there instead?

thanks,

greg k-h
