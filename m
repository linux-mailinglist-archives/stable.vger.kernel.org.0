Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D013A917A
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 07:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhFPF6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 01:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhFPF6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 01:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 959FC613BF;
        Wed, 16 Jun 2021 05:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623822970;
        bh=dMV6mj8avOtYIM6fDZMCQ/7U10m1DHYngtE/rADgayQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F2huXltdBPNovJk4HlG+2LtNSHW/oGSzMB5+Yin2VSRvdVPwqDhOl5UCfbGUMjcvn
         GyuOQt2sd+J+7oVVQiYx+eQ0fTqLtU65l4K2O3lHFG5iiH9ZpJVIXoPqPVNDTGK8UF
         QqhjtYxqRAe5kPEaANQzdh/E3Pn+YnmlPLYv3W90=
Date:   Wed, 16 Jun 2021 07:56:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        youling 257 <youling257@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>
Subject: Re: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
Message-ID: <YMmSdqnspAXG1CyT@kroah.com>
References: <20210608171221.276899-1-keescook@chromium.org>
 <20210614100234.12077-1-youling257@gmail.com>
 <202106140826.7912F27CD@keescook>
 <202106140941.7CE5AE64@keescook>
 <CAOzgRdZJeN6sQWP=Ou0H3bTrp+7ijKuJikG-f4eer5f1oVjrCQ@mail.gmail.com>
 <202106141503.B3144DFE@keescook>
 <CAOzgRdahaEjtk4jS5N=FQEDbsZVnB+-=xD+-WtV9zD9Tgbm0Hg@mail.gmail.com>
 <CAHk-=winAqy0sjgog9oEsjoBWOGJscFYEc3-=nvtzbyjTw_b+g@mail.gmail.com>
 <202106151449.816D7DA682@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202106151449.816D7DA682@keescook>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 02:50:39PM -0700, Kees Cook wrote:
> On Tue, Jun 15, 2021 at 11:19:04AM -0700, Linus Torvalds wrote:
> > On Mon, Jun 14, 2021 at 6:55 PM youling 257 <youling257@gmail.com> wrote:
> > >
> > > if try to find problem on userspace, i used linux 5.13rc6 on old
> > > android 7 cm14.1, not aosp android 11.
> > > http://git.osdn.net/view?p=android-x86/system-core.git;a=blob;f=init/service.cpp;h=a5334f447fc2fc34453d2f6a37523bedccadc690;hb=refs/heads/cm-14.1-x86#l457
> > >
> > >  457         if (!seclabel_.empty()) {
> > >  458             if (setexeccon(seclabel_.c_str()) < 0) {
> > >  459                 ERROR("cannot setexeccon('%s'): %s\n",
> > >  460                       seclabel_.c_str(), strerror(errno));
> > >  461                 _exit(127);
> > >  462             }
> > >  463         }
> > 
> > I have no idea where the cm14.1 libraries are. Does anybody know where
> > the matching source code for setexeccon() would be?
> > 
> > For me - obviously not on cm14.1 - all "setexeccon()" does is
> > 
> >    n = openat(AT_FDCWD, "/proc/thread-self/attr/exec", O_RDWR|O_CLOEXEC)
> >    write(n, string, len)
> >    close(n)
> > 
> > and if that fails, it would seem to indicate that proc_mem_open()
> > failed. Which would be mm_access() failing. But I don't see how that
> > can be the case, because mm_access() explicitly allows "mm ==
> > current->mm" (which the above clearly should be).
> 
> Yeah, that was what I saw too.
> 
> > youling, can you double-check with the current -git tree? But as far
> > as I can tell, my minimal patch is exactly the same as Kees' patch
> > (just smaller and simpler).
> 
> FWIW, for that patch:
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org

Thanks, I'll go pick it up now.

greg k-h
