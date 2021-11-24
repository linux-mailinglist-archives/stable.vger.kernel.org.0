Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F410A45C8B1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 16:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239939AbhKXPef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 10:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233565AbhKXPee (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 10:34:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F07260F5B;
        Wed, 24 Nov 2021 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637767884;
        bh=LJdfsnrN6zkgkJ5bpl+Sj/7Ntb7JRh85UkiCV9vqFHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kwQ5XFpqxPP/p/y6DVWh1h2Qc2B4iiu3FJrEvrk3UlmoSAqB9aiM0ezUzXkJYWavO
         0wfEvXzLEuQ9zKGmNfwAWlCrzqIXk/K6HXrjCwPfc9Fo7oCSIjaiDsAjKVDIjFnRQi
         NKL2Reyn4i/+bOLthQVW0mGbi5edYwKerqSWi5d8=
Date:   Wed, 24 Nov 2021 16:31:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@users.sourceforge.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alistair Delva <adelva@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 5.10 130/154] block: Check ADMIN before NICE for
 IOPRIO_CLASS_RT
Message-ID: <YZ5ayhuOMZwkd9j6@kroah.com>
References: <20211124115702.361983534@linuxfoundation.org>
 <20211124115706.507376250@linuxfoundation.org>
 <619E4ABA.DC78AA58@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <619E4ABA.DC78AA58@users.sourceforge.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 04:22:50PM +0200, Jari Ruusu wrote:
> Greg Kroah-Hartman wrote:
> > From: Alistair Delva <adelva@google.com>
> > 
> > commit 94c4b4fd25e6c3763941bdec3ad54f2204afa992 upstream.
>  [SNIP]
> > --- a/block/ioprio.c
> > +++ b/block/ioprio.c
> > @@ -69,7 +69,14 @@ int ioprio_check_cap(int ioprio)
> > 
> >         switch (class) {
> >                 case IOPRIO_CLASS_RT:
> > -                       if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
> > +                       /*
> > +                        * Originally this only checked for CAP_SYS_ADMIN,
> > +                        * which was implicitly allowed for pid 0 by security
> > +                        * modules such as SELinux. Make sure we check
> > +                        * CAP_SYS_ADMIN first to avoid a denial/avc for
> > +                        * possibly missing CAP_SYS_NICE permission.
> > +                        */
> > +                       if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
> >                                 return -EPERM;
> >                         fallthrough;
> >                         /* rt has prio field too */
> 
> What exactly is above patch trying to fix?
> It does not change control flow at all, and added comment is misleading.

See the thread on the mailing list for what it does and why it is
needed.

It does change the result when selinux is enabled.

thanks,

greg k-h
