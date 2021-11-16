Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43964532F0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 14:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbhKPNj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 08:39:29 -0500
Received: from mail.hallyn.com ([178.63.66.53]:42656 "EHLO mail.hallyn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhKPNj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 08:39:29 -0500
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id 8F708546; Tue, 16 Nov 2021 07:36:28 -0600 (CST)
Date:   Tue, 16 Nov 2021 07:36:28 -0600
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Alistair Delva' <adelva@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        john.johansen@canonical.com, James Morris <jmorris@namei.org>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
Message-ID: <20211116133628.GA6728@mail.hallyn.com>
References: <20211115173850.3598768-1-adelva@google.com>
 <CAFqZXNvVHv8Oje-WV6MWMF96kpR6epTsbc-jv-JF+YJw=55i1w@mail.gmail.com>
 <CANDihLEFZAz8DwkkMGiDJnDMjxiUuSCanYsJtkRwa9RoyruLFA@mail.gmail.com>
 <43aeb7451621474ea0d7bee6b99039c3@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43aeb7451621474ea0d7bee6b99039c3@AcuMS.aculab.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 09:30:12AM +0000, David Laight wrote:
> From: Alistair Delva
> > Sent: 15 November 2021 19:09
> ...
> > > > -                       if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
> > > > +                       if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
> > > >                                 return -EPERM;
> 
> Isn't the real problem that you actually want to test:
> 		if (!capable(CAP_SYS_NICE | CAP_SYS_ADMIN))
> 			return -EPERM;
> so that you only get the fail 'splat' when neither is set.
> 
> This will be true whenever more than one capability enables something.
> 
> Possibly this needs something like:
> int capabale_or(unsigned int, ...);
> #define capabale_or(...) capabable_or(__VA_LIST__, ~0u)
> 
> 	David

Right, that's what i was suggesting yesterday.  We do this in other
places, where we split off a more fine-grained version of a gross
capability.  If we care enough about the audit messages, then we
probably do need a new primitive.

-serge
