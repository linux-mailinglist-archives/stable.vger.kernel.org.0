Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0121F65CF
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 12:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgFKKj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 06:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgFKKj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 06:39:27 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D056C08C5C1
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 03:39:27 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id h3so4928268ilh.13
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 03:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=09AhYfVptAXhl8RbRmV+vzYPYyK8rezI6f1741Byi5g=;
        b=hXWw9qrKRCz4lCsZBfjd9GvLPINzD5z7fubizgxMT+JbNOAdKmYagKXytL8D+qGPRs
         lmq7mz6l8u1AbkV3NVEYISeBNmcu3aUHaVlPzhm+AkMtv3s4lXT3XROD5xmQKChyhc2U
         y0+7scW5saZn8EzuurZAZeWC3/gnoQi+Wfu4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=09AhYfVptAXhl8RbRmV+vzYPYyK8rezI6f1741Byi5g=;
        b=YI8t5YOjDNo8EPXB6bbQtwpFFd4j7N7b/GaRtD0PvlnkAx4OP4s3YUeRLrxKIYwXFr
         kce4MLX3xpssXKSojYplxQUOZ3HBZlXCxwhuo1HMPl+Bg2rBIPDCY+rXbFYntYq71ozA
         VFX/VVprsoMgQZ+GKbP9ST43yJR0lbU9XpaFzbpv90ziA5j1BjTrNNc2rpzx8OiFgJZm
         Er1kGOw/b5xwQ2vcKAwatkbqBcKNdVAdvD12xRAqBTeXG1UuwRxrg8gCTrHqQGl2jpvx
         876ywDKYXQuDJc4qQ3VGYCEsX7+5np9QikvkOHSusdvwGTyXAk+8KszQa9EzitM+SzGI
         Hz7g==
X-Gm-Message-State: AOAM530wT4D7oJMRFR4QfXIlRm7a73AHwF7fm4KG948lyU/L8R9hYPNH
        viYTJh9UvyYKZ4M2svncZqDaBA==
X-Google-Smtp-Source: ABdhPJxolVZUsL9RqG7Jc9UwE72uQAKUEuhgQv/dBYmuIHqJ/Sf9yGKuChTRxgA86GGNuZ/S+QQO+g==
X-Received: by 2002:a92:dccd:: with SMTP id b13mr7169618ilr.98.1591871965927;
        Thu, 11 Jun 2020 03:39:25 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id v2sm1276642iol.36.2020.06.11.03.39.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jun 2020 03:39:25 -0700 (PDT)
Date:   Thu, 11 Jun 2020 10:39:23 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Kees Cook <keescook@chromium.org>,
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
Message-ID: <20200611103922.GA30103@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611091942.jni2glnpmxisnant@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611091942.jni2glnpmxisnant@wittgenstein>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 11:19:42AM +0200, Christian Brauner wrote:
> On Wed, Jun 10, 2020 at 07:59:55PM -0700, Kees Cook wrote:
> > On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> > > As an aside, all of this junk should be dropped:
> > > +	ret = get_user(size, &uaddfd->size);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > > +	if (ret)
> > > +		return ret;
> > > 
> > > and the size member of the seccomp_notif_addfd struct. I brought this up 
> > > off-list with Tycho that ioctls have the size of the struct embedded in them. We 
> > > should just use that. The ioctl definition is based on this[2]:
> > > #define _IOC(dir,type,nr,size) \
> > > 	(((dir)  << _IOC_DIRSHIFT) | \
> > > 	 ((type) << _IOC_TYPESHIFT) | \
> > > 	 ((nr)   << _IOC_NRSHIFT) | \
> > > 	 ((size) << _IOC_SIZESHIFT))
> > > 
> > > 
> > > We should just use copy_from_user for now. In the future, we can either 
> > > introduce new ioctl names for new structs, or extract the size dynamically from 
> > > the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.
> > 
> > Yeah, that seems reasonable. Here's the diff for that part:
> > 
> > diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> > index 7b6028b399d8..98bf19b4e086 100644
> > --- a/include/uapi/linux/seccomp.h
> > +++ b/include/uapi/linux/seccomp.h
> > @@ -118,7 +118,6 @@ struct seccomp_notif_resp {
> >  
> >  /**
> >   * struct seccomp_notif_addfd
> > - * @size: The size of the seccomp_notif_addfd datastructure
> >   * @id: The ID of the seccomp notification
> >   * @flags: SECCOMP_ADDFD_FLAG_*
> >   * @srcfd: The local fd number
> > @@ -126,7 +125,6 @@ struct seccomp_notif_resp {
> >   * @newfd_flags: The O_* flags the remote FD should have applied
> >   */
> >  struct seccomp_notif_addfd {
> > -	__u64 size;
> >  	__u64 id;
> >  	__u32 flags;
> >  	__u32 srcfd;
> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > index 3c913f3b8451..00cbdad6c480 100644
> > --- a/kernel/seccomp.c
> > +++ b/kernel/seccomp.c
> > @@ -1297,14 +1297,9 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
> >  	struct seccomp_notif_addfd addfd;
> >  	struct seccomp_knotif *knotif;
> >  	struct seccomp_kaddfd kaddfd;
> > -	u64 size;
> >  	int ret;
> >  
> > -	ret = get_user(size, &uaddfd->size);
> > -	if (ret)
> > -		return ret;
> > -
> > -	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > +	ret = copy_from_user(&addfd, uaddfd, sizeof(addfd));
> >  	if (ret)
> >  		return ret;
> >  
> > 
> > > 
> > > ----
> > > +#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
> > > +						struct seccomp_notif_addfd)
> > > 
> > > Lastly, what I believe to be a small mistake, it should be SECCOMP_IOW, based on 
> > > the documentation in ioctl.h -- "_IOW means userland is writing and kernel is 
> > > reading."
> > 
> > Oooooh. Yeah; good catch. Uhm, that means SECCOMP_IOCTL_NOTIF_ID_VALID
> > is wrong too, yes? Tycho, Christian, how disruptive would this be to
> > fix? (Perhaps support both and deprecate the IOR version at some point
> > in the future?)
> 
> We have custom defines in our source code, i.e.
> #define SECCOMP_IOCTL_NOTIF_ID_VALID  SECCOMP_IOR(2, __u64)
> so ideally we'd have a SECCOMP_IOCTL_NOTIF_ID_VALID_V2
> 
> Does that sound ok?
> 
> Christian
Why not change the public API in seccomp.h to:
#define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOW(2, __u64)

And then in seccomp.c:
#define SECCOMP_IOCTL_NOTIF_ID_VALID_OLD	SECCOMP_IOR(2, __u64)
static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
				 unsigned long arg)
{
	struct seccomp_filter *filter = file->private_data;
	void __user *buf = (void __user *)arg;

	switch (cmd) {
	case SECCOMP_IOCTL_NOTIF_RECV:
		return seccomp_notify_recv(filter, buf);
	case SECCOMP_IOCTL_NOTIF_SEND:
		return seccomp_notify_send(filter, buf);
	case SECCOMP_IOCTL_NOTIF_ID_VALID_OLD:
		pr_warn_once("Detected usage of legacy (incorrect) version of seccomp notifier notif_id_valid ioctl\n");
	case SECCOMP_IOCTL_NOTIF_ID_VALID:
		return seccomp_notify_id_valid(filter, buf);
	default:
		return -EINVAL;
	}
}
---- 

So, both will work fine, and whenevery anyone recompiles, or picks up new 
headers, they will start calling the "right" one without a code change, and
we wont break any userspace.
