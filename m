Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D741F70D5
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 01:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgFKXXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 19:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgFKXXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 19:23:12 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F4BC08C5C1
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 16:23:12 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d8so2926902plo.12
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 16:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dF5S2dn2pVgES3YrOEuT/txRTXS0NkdBy5TQaEH6DIU=;
        b=Im7VtVIhpDqHDj91TB7IHzCdVnA7cfAKvscZOGBTPVCyTJytRbl+ab1O58LQFqAHOi
         U4CzwwHUZnlrb8MvXGRZ430PTCx5cAFj98PV4U2LQtuIFjbr8XzRxz5SIGSuj3FBGQDo
         ASsFRokK8d6OyeBDvWzybCftl71yZ/TTfnUO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dF5S2dn2pVgES3YrOEuT/txRTXS0NkdBy5TQaEH6DIU=;
        b=O9M0+/vssYd5KXBKOYbPjWBH4pRJbGp+Dz5luqkG91pcxV2SsgefiI3EI53L1oxhEj
         zyTptsWwt3ee5lzvHoW2XeV3kZ3DUZgvZYQd9eQ1yz9qHtMjW2QVcaOA7muH9ycL5Rm1
         LONSkpw/vsQmnPt/dVmEzgDuv32QwgN08oyyNcerdJ5arX2+i1qEq+4OWhYOwgyAxH3W
         19nsPDWH7m4u9XK3NGjJ5PrqVDUt+Skll4oJVFrVpvrCX7j2SULw2Q5al6WPxlWC36Zo
         lMVCo2Ps12dzDJZt5uUk2Hw2/1uv1XHGeQTtltrK4e0g90cNpSm/fCs0Clm77BNQO9cR
         wjnA==
X-Gm-Message-State: AOAM532NH1cqpahVg8N2QGjQpkEcxXQx3u5GL1EPYXEbYhVHvv09Zaid
        7vXxwk0Qajrqkwnp7DzYZzk50A==
X-Google-Smtp-Source: ABdhPJwTmpa2kzC8wDU5aCXCVkPVDsBffhaUPbr0t/XzzYQF4UVcbOpP5W8PS0r8XWx0KOQrRuCd8A==
X-Received: by 2002:a17:902:c214:: with SMTP id 20mr9177825pll.193.1591917792301;
        Thu, 11 Jun 2020 16:23:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d189sm4120162pfc.51.2020.06.11.16.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 16:23:11 -0700 (PDT)
Date:   Thu, 11 Jun 2020 16:23:10 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
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
Message-ID: <202006111622.01F596D@keescook>
References: <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611091942.jni2glnpmxisnant@wittgenstein>
 <20200611103922.GA30103@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611103922.GA30103@ircssh-2.c.rugged-nimbus-611.internal>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 10:39:23AM +0000, Sargun Dhillon wrote:
> On Thu, Jun 11, 2020 at 11:19:42AM +0200, Christian Brauner wrote:
> > On Wed, Jun 10, 2020 at 07:59:55PM -0700, Kees Cook wrote:
> > > On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> > > > As an aside, all of this junk should be dropped:
> > > > +	ret = get_user(size, &uaddfd->size);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > > > +	if (ret)
> > > > +		return ret;
> > > > 
> > > > and the size member of the seccomp_notif_addfd struct. I brought this up 
> > > > off-list with Tycho that ioctls have the size of the struct embedded in them. We 
> > > > should just use that. The ioctl definition is based on this[2]:
> > > > #define _IOC(dir,type,nr,size) \
> > > > 	(((dir)  << _IOC_DIRSHIFT) | \
> > > > 	 ((type) << _IOC_TYPESHIFT) | \
> > > > 	 ((nr)   << _IOC_NRSHIFT) | \
> > > > 	 ((size) << _IOC_SIZESHIFT))
> > > > 
> > > > 
> > > > We should just use copy_from_user for now. In the future, we can either 
> > > > introduce new ioctl names for new structs, or extract the size dynamically from 
> > > > the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.
> > > 
> > > Yeah, that seems reasonable. Here's the diff for that part:
> > > 
> > > diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> > > index 7b6028b399d8..98bf19b4e086 100644
> > > --- a/include/uapi/linux/seccomp.h
> > > +++ b/include/uapi/linux/seccomp.h
> > > @@ -118,7 +118,6 @@ struct seccomp_notif_resp {
> > >  
> > >  /**
> > >   * struct seccomp_notif_addfd
> > > - * @size: The size of the seccomp_notif_addfd datastructure
> > >   * @id: The ID of the seccomp notification
> > >   * @flags: SECCOMP_ADDFD_FLAG_*
> > >   * @srcfd: The local fd number
> > > @@ -126,7 +125,6 @@ struct seccomp_notif_resp {
> > >   * @newfd_flags: The O_* flags the remote FD should have applied
> > >   */
> > >  struct seccomp_notif_addfd {
> > > -	__u64 size;
> > >  	__u64 id;
> > >  	__u32 flags;
> > >  	__u32 srcfd;
> > > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > > index 3c913f3b8451..00cbdad6c480 100644
> > > --- a/kernel/seccomp.c
> > > +++ b/kernel/seccomp.c
> > > @@ -1297,14 +1297,9 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
> > >  	struct seccomp_notif_addfd addfd;
> > >  	struct seccomp_knotif *knotif;
> > >  	struct seccomp_kaddfd kaddfd;
> > > -	u64 size;
> > >  	int ret;
> > >  
> > > -	ret = get_user(size, &uaddfd->size);
> > > -	if (ret)
> > > -		return ret;
> > > -
> > > -	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > > +	ret = copy_from_user(&addfd, uaddfd, sizeof(addfd));
> > >  	if (ret)
> > >  		return ret;
> > >  
> > > 
> > > > 
> > > > ----
> > > > +#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
> > > > +						struct seccomp_notif_addfd)
> > > > 
> > > > Lastly, what I believe to be a small mistake, it should be SECCOMP_IOW, based on 
> > > > the documentation in ioctl.h -- "_IOW means userland is writing and kernel is 
> > > > reading."
> > > 
> > > Oooooh. Yeah; good catch. Uhm, that means SECCOMP_IOCTL_NOTIF_ID_VALID
> > > is wrong too, yes? Tycho, Christian, how disruptive would this be to
> > > fix? (Perhaps support both and deprecate the IOR version at some point
> > > in the future?)
> > 
> > We have custom defines in our source code, i.e.
> > #define SECCOMP_IOCTL_NOTIF_ID_VALID  SECCOMP_IOR(2, __u64)
> > so ideally we'd have a SECCOMP_IOCTL_NOTIF_ID_VALID_V2
> > 
> > Does that sound ok?
> > 
> > Christian
> Why not change the public API in seccomp.h to:
> #define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOW(2, __u64)
> 
> And then in seccomp.c:
> #define SECCOMP_IOCTL_NOTIF_ID_VALID_OLD	SECCOMP_IOR(2, __u64)
> static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
> 				 unsigned long arg)
> {
> 	struct seccomp_filter *filter = file->private_data;
> 	void __user *buf = (void __user *)arg;
> 
> 	switch (cmd) {
> 	case SECCOMP_IOCTL_NOTIF_RECV:
> 		return seccomp_notify_recv(filter, buf);
> 	case SECCOMP_IOCTL_NOTIF_SEND:
> 		return seccomp_notify_send(filter, buf);
> 	case SECCOMP_IOCTL_NOTIF_ID_VALID_OLD:
> 		pr_warn_once("Detected usage of legacy (incorrect) version of seccomp notifier notif_id_valid ioctl\n");
> 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
> 		return seccomp_notify_id_valid(filter, buf);
> 	default:
> 		return -EINVAL;
> 	}
> }
> ---- 
> 
> So, both will work fine, and whenevery anyone recompiles, or picks up new 
> headers, they will start calling the "right" one without a code change, and
> we wont break any userspace.

Yeah, that's what I'd prefer here.

-- 
Kees Cook
