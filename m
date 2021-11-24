Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9870545CBED
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 19:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350266AbhKXSTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 13:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350398AbhKXSSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 13:18:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFEAA60F55;
        Wed, 24 Nov 2021 18:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637777737;
        bh=Qf1psx4hFnkfyS/I8jNT4xJkTgotUILZVrpZCQUH9Sg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gAKEZdL/RPkxGfvpjNwGhSu/lM9HAUWUT0qF3o2BKqanhjeDlciqPauYFZfNAFjFq
         cnbi74J0jwHGO8eR3NH2tLDGOnYtnxv8jxCa0/sFCYDaZjkL6zgv1g30qKTNHI4SID
         1JnevlYQEj7Nj3miqWw0D7+Vf9AotQGijdYAh8SU=
Date:   Wed, 24 Nov 2021 19:15:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Serge E. Hallyn" <serge@hallyn.com>
Cc:     Jari Ruusu <jariruusu@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alistair Delva <adelva@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Paul Moore <paul@paul-moore.com>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 5.10 130/154] block: Check ADMIN before NICE for
 IOPRIO_CLASS_RT
Message-ID: <YZ6BR09OXP8x7lRs@kroah.com>
References: <20211124115702.361983534@linuxfoundation.org>
 <20211124115706.507376250@linuxfoundation.org>
 <619E4ABA.DC78AA58@users.sourceforge.net>
 <YZ5ayhuOMZwkd9j6@kroah.com>
 <20211124173310.GA12039@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124173310.GA12039@mail.hallyn.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 11:33:11AM -0600, Serge E. Hallyn wrote:
> On Wed, Nov 24, 2021 at 04:31:22PM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Nov 24, 2021 at 04:22:50PM +0200, Jari Ruusu wrote:
> > > Greg Kroah-Hartman wrote:
> > > > From: Alistair Delva <adelva@google.com>
> > > > 
> > > > commit 94c4b4fd25e6c3763941bdec3ad54f2204afa992 upstream.
> > >  [SNIP]
> > > > --- a/block/ioprio.c
> > > > +++ b/block/ioprio.c
> > > > @@ -69,7 +69,14 @@ int ioprio_check_cap(int ioprio)
> > > > 
> > > >         switch (class) {
> > > >                 case IOPRIO_CLASS_RT:
> > > > -                       if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
> > > > +                       /*
> > > > +                        * Originally this only checked for CAP_SYS_ADMIN,
> > > > +                        * which was implicitly allowed for pid 0 by security
> > > > +                        * modules such as SELinux. Make sure we check
> > > > +                        * CAP_SYS_ADMIN first to avoid a denial/avc for
> > > > +                        * possibly missing CAP_SYS_NICE permission.
> > > > +                        */
> > > > +                       if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
> > > >                                 return -EPERM;
> > > >                         fallthrough;
> > > >                         /* rt has prio field too */
> > > 
> > > What exactly is above patch trying to fix?
> > > It does not change control flow at all, and added comment is misleading.
> > 
> > See the thread on the mailing list for what it does and why it is
> > needed.
> > 
> > It does change the result when selinux is enabled.
> > 
> > thanks,
> > 
> > greg k-h
> 
> The case where we create a newer more fine grained capability which is a
> sub-cap of a broader capability like CAP_SYS_ADMIN is analogous.  See
> check_syslog_permissions() for instance.
> 
> So I think a helper like
> 
> int capable_either_or(int cap1, int cap2) {
> 	if (has_capability_noaudit(current, cap1))
> 		return 0;
> 	return capable(cap2);
> }
> 
> might be worthwhile.

Sure, feel free to work on that and submit it, but for now, this change
is needed.

thanks,

greg k-h
