Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FACF452C95
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 09:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhKPIYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 03:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhKPIYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 03:24:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263636321A;
        Tue, 16 Nov 2021 08:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637050905;
        bh=bYQKZcw7c2FQMHwIW5aHteUVhe1xXATHDDnJ7Fn6nvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1z3iMBeJeljTxggjE+0L4THG0ujjtzEQL65xZOXcDaQ8VjpANvvoVWED04LYF/AvB
         zolX6Blbg9K0nCBEp8ls4ve8p+qV/bno+gOYeqaePLr6geYTIfVXQ8NKk+AV79pi9x
         yP+uvpZlqW/eCULiDCmjGWF4n5whDdDU0TmcqRPs=
Date:   Tue, 16 Nov 2021 09:21:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Alistair Delva <adelva@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Paul Moore <paul@paul-moore.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
Message-ID: <YZNqF7fuwLTd8IIM@kroah.com>
References: <20211115173850.3598768-1-adelva@google.com>
 <CAFqZXNvVHv8Oje-WV6MWMF96kpR6epTsbc-jv-JF+YJw=55i1w@mail.gmail.com>
 <CANDihLEFZAz8DwkkMGiDJnDMjxiUuSCanYsJtkRwa9RoyruLFA@mail.gmail.com>
 <ead81edf-ca8f-9e97-96ca-984202e7d8ac@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ead81edf-ca8f-9e97-96ca-984202e7d8ac@schaufler-ca.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 01:42:54PM -0800, Casey Schaufler wrote:
> On 11/15/2021 11:08 AM, Alistair Delva wrote:
> > On Mon, Nov 15, 2021 at 11:04 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > On Mon, Nov 15, 2021 at 7:14 PM Alistair Delva <adelva@google.com> wrote:
> > > > Booting to Android userspace on 5.14 or newer triggers the following
> > > > SELinux denial:
> > > > 
> > > > avc: denied { sys_nice } for comm="init" capability=23
> > > >       scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
> > > >       permissive=0
> > > > 
> > > > Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
> > > > better compatibility with older SEPolicy, check ADMIN before NICE.
> > > But with this patch you in turn punish the new/better policies that
> > > try to avoid giving domains CAP_SYS_ADMIN unless necessary (using only
> > > the more granular capabilities wherever possible), which may now get a
> > > bogus sys_admin denial. IMHO the order is better as it is, as it
> > > motivates the "good" policy writing behavior - i.e. spelling out the
> > > capability permissions more explicitly and avoiding CAP_SYS_ADMIN.
> > > 
> > > IOW, if you domain does CAP_SYS_NICE things, and you didn't explicitly
> > > grant it that (and instead rely on the CAP_SYS_ADMIN fallback), then
> > > the denial correctly flags it as an issue in your policy and
> > > encourages you to add that sys_nice permission to the domain. Then
> > > when one beautiful hypothetical day the CAP_SYS_ADMIN fallback is
> > > removed, your policy will be ready for that and things will keep
> > > working.
> > > 
> > > Feel free to carry that patch downstream if patching the kernel is
> > > easier for you than fixing the policy, but for the upstream kernel
> > > this is just a step in the wrong direction.
> > I'm personally fine with this position, but I am curious why "never
> > break userspace" doesn't apply to SELinux policies.
> 
> Because SELinux policy is configuration data, not system code.
> One is free to modify SELinux policy to suit one's whims without
> making any change to the Linux kernel or its APIs.

Sure, but the problem here is when the kernel is updated and the
userspace configuration is not changed and then the kernel can not boot
or has other problems.  That is a kernel regression.

> >   At the end of the
> > day, booting 5.13 or older, we don't get a denial, and there's nothing
> > for the sysadmin to do. On 5.14 and newer, we get denials. This is a
> > common pattern we see each year: some new capability or permission is
> > required where it wasn't required before, and there's no compatibility
> > mechanism to grandfather in old policies.
> 
> This is an artifact of separating policy from mechanism. The
> capability mechanism does not suffer from this issue because
> it embodies its policy. SELinux, Smack, AppArmor and "containers"
> are vulnerable to it because they explicitly deny the kernel and
> kernel developers permission to make assumptions about how they
> define "policy".
> 
> >   So, we have to touch
> > userspace. If this is just how things are, I can certainly update our
> > init.te definitions.
> 
> If SELinux was a required kernel mechanism and the policy was
> included in the kernel tree you might be able to argue that
> kernel developers are responsible for changes to SELinux policy.
> But it ain't, and it isn't.   By design.

Again, when you change the logic in the kernel that then requires you to
also somehow change userspace files in order to keep the kernel booting
properly, that is a problem.

Same thing if we changed the tty api to require different options to be
handled differently.  There is nothing "special" about security policies
from any other user/kernel interaction and api.

thanks,

greg k-h
