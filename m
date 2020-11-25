Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601742C3B0A
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 09:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgKYIYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 03:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgKYIYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 03:24:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D5320872;
        Wed, 25 Nov 2020 08:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606292674;
        bh=GzRz70XUcTol8ydvpgXrLvcv/1Y/Ui8JqlMmBRtqjz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PjbizLW5hleYKuVZXINYxT+TVdx2+0+I6z+L0D3JhXxOfg1Io2pS0aQNFhaUKAdQ4
         AJRVgRwX8Mhzw01aNOeOdCDo9D5r+Llc8kvbPvkJqv/W6OJcckcrvItCEMMgUwsuf6
         NU1oVV/Fb3XODVqOGgd47ABgOu0W5NAlg3e4+d/A=
Date:   Wed, 25 Nov 2020 09:25:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-efi <linux-efi@vger.kernel.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <mjg59@google.com>,
        David Laight <David.Laight@aculab.com>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] efivarfs: revert "fix memory leak in efivarfs_create()"
Message-ID: <X74VBej49SCPVisA@kroah.com>
References: <20201125075303.3963-1-ardb@kernel.org>
 <97016e69314d90aef859ae6d98e4bb9c@natalenko.name>
 <CAMj1kXG0D7H=A=2DjjNxqHRC26dhWR2c-i3b2Enc4sLoYgFbJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG0D7H=A=2DjjNxqHRC26dhWR2c-i3b2Enc4sLoYgFbJQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 09:05:42AM +0100, Ard Biesheuvel wrote:
> On Wed, 25 Nov 2020 at 09:05, Oleksandr Natalenko
> <oleksandr@natalenko.name> wrote:
> >
> > Hello.
> >
> > On 25.11.2020 08:53, Ard Biesheuvel wrote:
> > > The memory leak addressed by commit fe5186cf12e3 is a false positive:
> > > all allocations are recorded in a linked list, and freed when the
> > > filesystem is unmounted. This leads to double frees, and as reported
> > > by David, leads to crashes if SLUB is configured to self destruct when
> > > double frees occur.
> > >
> > > So drop the redundant kfree() again, and instead, mark the offending
> > > pointer variable so the allocation is ignored by kmemleak.
> > >
> > > Cc: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
> >
> > Should also have:
> >
> > Cc: <stable@vger.kernel.org> # v5.9
> >
> 
> No it should not. The fixes tag should be sufficient.

No, "Fixes:" does not ever mean "I want this patch to go to a stable
tree".  It might happen, it might not, if you REALLY know this should go
to a stable tree, please follow the directions for what we have been
doing for 15+ years now, as documented in:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Hint, use "cc: stable@vger.kernel.org" if you know you want it applied,
otherwise it's just a best-guess-effort on our part.

thanks,

greg k-h
