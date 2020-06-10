Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3CA1F59BC
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 19:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgFJRKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 13:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729340AbgFJRKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 13:10:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C5EC08C5C2
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 10:10:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id m2so1145898pjv.2
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 10:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wu1KxK3oWDaDyFouCR1IJCWRCCZuOnfSKhmf+rK5Zxw=;
        b=oMmr18e2vlsUwaIbxh6CowxNZ5fXzjfgmkFL2R2jM2RUlcV/0jnVTduaVrPaFnDGs9
         QDuR/bYJP+8NCw01k5v6u7s7UrHLS9i8UYMPU93hCzQfrKP3xRzfjAw0OBDtnOAgcdtQ
         7KVFiv3APJf/AYGrTCrcwRMVTg4Dwe/DNZI54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wu1KxK3oWDaDyFouCR1IJCWRCCZuOnfSKhmf+rK5Zxw=;
        b=AaMbL5eKH6YSx8IE7V2FM1iDxErPhSqAxWEDgmuJkrzyqOJB3mjix1i5cax/AoutmO
         YtCiZyYKjtx0i3LQylETZbZe+KoQGgCMAZEu13JrIbxL+IIiFvLsxHjTfXy99acGIQ2a
         FobCNQi9i0SDpt66RLZkicfazGWOOMrsaVPM3nTJeiQ1+OJdx5C6b91c9sYuqUUI2f5v
         uuncudkgRLILDSR6s7Ao7FfzfO9Bk7Vp5ZAenfHA0B8otra77My3VmYzlH0g3hiJ9Ujk
         3w06zzZzbjs6mbY5/c0D8HDwVtYTi9FwFD3moPYbbUs6/QC+X4Kaf/3YKpnplSE7ggsb
         YenA==
X-Gm-Message-State: AOAM533oqQ/MQ2Yo+Xmp4exkbbo2ZSLO7tWiU8aSgcDD9v7DwuoQzgGm
        cpG9h1TvbmNMDQHyqs6IWbdc1w==
X-Google-Smtp-Source: ABdhPJxayOX7rVXqbhvcTIWz5BPNBU4r5agrcCKjs9HEcbi4xBHT9zFhKhsPc7rddjV41A6Y2XRKoQ==
X-Received: by 2002:a17:902:7487:: with SMTP id h7mr3828645pll.155.1591809036089;
        Wed, 10 Jun 2020 10:10:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h3sm484466pfr.2.2020.06.10.10.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 10:10:34 -0700 (PDT)
Date:   Wed, 10 Jun 2020 10:10:33 -0700
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
Message-ID: <202006101005.D1D19EE@keescook>
References: <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> On Tue, Jun 09, 2020 at 10:27:54PM -0700, Kees Cook wrote:
> > On Tue, Jun 09, 2020 at 11:27:30PM +0200, Christian Brauner wrote:
> > > On June 9, 2020 10:55:42 PM GMT+02:00, Kees Cook <keescook@chromium.org> wrote:
> > > >LOL. And while we were debating this, hch just went and cleaned stuff up:
> > > >
> > > >2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> > > >
> > > >So, um, yeah, now my proposal is actually even closer to what we already
> > > >have there. We just add the replace_fd() logic to __scm_install_fd() and
> > > >we're done with it.
> > > 
> > > Cool, you have a link? :)
> > 
> > How about this:
> > 
> Thank you.
> > https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=devel/seccomp/addfd/v3.1&id=bb94586b9e7cc88e915536c2e9fb991a97b62416
> > 
> > -- 
> > Kees Cook
> 
> +		if (ufd) {
> +			error = put_user(new_fd, ufd);
> +			if (error) {
> +				put_unused_fd(new_fd);
> +				return error;
> +			}
> + 		}
> I'm fairly sure this introduces a bug[1] if the user does:

Ah, sorry, I missed this before I posted my "v3.2" tree link.

> 
> struct msghdr msg = {};
> struct cmsghdr *cmsg;
> struct iovec io = {
> 	.iov_base = &c,
> 	.iov_len = 1,
> };
> 
> msg.msg_iov = &io;
> msg.msg_iovlen = 1;
> msg.msg_control = NULL;
> msg.msg_controllen = sizeof(buf);
> 
> recvmsg(sock, &msg, 0);
> 
> They will have the FD installed, no error message, but FD number wont be written 
> to memory AFAICT. If two FDs are passed, you will get an efault. They will both
> be installed, but memory wont be written to. Maybe instead of 0, make it a
> poison pointer, or -1 instead?

Hmmm. I see what you mean -- SCM_RIGHTS effectively _requires_ a valid
__user pointer, so we can't use NULL to indicate "we don't want this".
I'm not sure I can pass this through directly at all, though.

> -----
> As an aside, all of this junk should be dropped:
> +	ret = get_user(size, &uaddfd->size);
> +	if (ret)
> +		return ret;
> +
> +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> +	if (ret)
> +		return ret;
> 
> and the size member of the seccomp_notif_addfd struct. I brought this up 
> off-list with Tycho that ioctls have the size of the struct embedded in them. We 
> should just use that. The ioctl definition is based on this[2]:
> #define _IOC(dir,type,nr,size) \
> 	(((dir)  << _IOC_DIRSHIFT) | \
> 	 ((type) << _IOC_TYPESHIFT) | \
> 	 ((nr)   << _IOC_NRSHIFT) | \
> 	 ((size) << _IOC_SIZESHIFT))
> 
> 
> We should just use copy_from_user for now. In the future, we can either 
> introduce new ioctl names for new structs, or extract the size dynamically from 
> the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.

Okay, sounds good.

> ----
> +#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
> +						struct seccomp_notif_addfd)
> 
> Lastly, what I believe to be a small mistake, it should be SECCOMP_IOW, based on 
> the documentation in ioctl.h -- "_IOW means userland is writing and kernel is 
> reading."

Okay, let me tweak things and get a "v3.3". ;)

-- 
Kees Cook
