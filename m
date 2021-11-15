Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8A6451D61
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348533AbhKPA3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:29:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346558AbhKOTed (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:34:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F299260184;
        Mon, 15 Nov 2021 19:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637004678;
        bh=/5EFFGdANEQuECDTL8tXYsI+5VlfFp0wPsn+etL4mt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GTfUJFO+Km6M3nMLM0Q6pu4UUwMDf90PsdZfHB7eEX8//eSp38IcshkynffZOQ/dY
         yrnm1q62f6FbGqnE/i3hQvsoiFkU/pEmw1Ae1Q+VB2LwMiNEL3CZxgyxxhcabkKbt5
         rJO+G8EVxMkBrxdq99EYk6XmVNu9zxYM8gm1OsQs=
Date:   Mon, 15 Nov 2021 20:31:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Alistair Delva <adelva@google.com>,
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
Message-ID: <YZK1gy9ARwoSxVrO@kroah.com>
References: <20211115173850.3598768-1-adelva@google.com>
 <CAFqZXNvVHv8Oje-WV6MWMF96kpR6epTsbc-jv-JF+YJw=55i1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqZXNvVHv8Oje-WV6MWMF96kpR6epTsbc-jv-JF+YJw=55i1w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 08:04:05PM +0100, Ondrej Mosnacek wrote:
> On Mon, Nov 15, 2021 at 7:14 PM Alistair Delva <adelva@google.com> wrote:
> > Booting to Android userspace on 5.14 or newer triggers the following
> > SELinux denial:
> >
> > avc: denied { sys_nice } for comm="init" capability=23
> >      scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
> >      permissive=0
> >
> > Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
> > better compatibility with older SEPolicy, check ADMIN before NICE.
> 
> But with this patch you in turn punish the new/better policies that
> try to avoid giving domains CAP_SYS_ADMIN unless necessary (using only
> the more granular capabilities wherever possible), which may now get a
> bogus sys_admin denial. IMHO the order is better as it is, as it
> motivates the "good" policy writing behavior - i.e. spelling out the
> capability permissions more explicitly and avoiding CAP_SYS_ADMIN.
> 
> IOW, if you domain does CAP_SYS_NICE things, and you didn't explicitly
> grant it that (and instead rely on the CAP_SYS_ADMIN fallback), then
> the denial correctly flags it as an issue in your policy and
> encourages you to add that sys_nice permission to the domain. Then
> when one beautiful hypothetical day the CAP_SYS_ADMIN fallback is
> removed, your policy will be ready for that and things will keep
> working.
> 
> Feel free to carry that patch downstream if patching the kernel is
> easier for you than fixing the policy, but for the upstream kernel
> this is just a step in the wrong direction.

So you want to "punish" existing systems by throwing up a warning where
there used to not be one?  That is not nice, you need to handle
upgrading kernels without breaking or causing problems like this.

Yes, SELinux has done this in the past, with many different things, but
that does not mean that it _should_ do this.  Please realize that you do
not want to punish people from upgrading their kernel to a newer
version.  If you do so, they will never upgrade.

thanks,

greg k-h
