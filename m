Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48E32A3FC3
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 10:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgKCJOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 04:14:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgKCJOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 04:14:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB8020756;
        Tue,  3 Nov 2020 09:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604394885;
        bh=ZHBZOejCjX5l8sZRwuQR75aiAkvpCacnS9a7dm3ZHWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qln8MdI6DivkRV8z0NNzzjlNCxVzjVdA/Fv1NgjVip/n/1gFGnqFFvPb71GuAnUIO
         /2eNbcs3wGdBPupCY+nPbaFzvLuxEUzYibz1rSSFzK875xRQ0sASb7T2390zB6JrJ9
         /8V+j5a9jQGnLDsnL73G32hmgIebDkvEIp3AO60Y=
Date:   Tue, 3 Nov 2020 10:15:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] Fonts: Replace discarded const qualifier
Message-ID: <20201103091538.GA2663113@kroah.com>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <20201102183242.2031659-1-yepeilin.cs@gmail.com>
 <20201103085324.GL4488@dell>
 <CAKMK7uGV10+TEWWMJod1-MRD1jkLqvOGUu4Qk9S84WJAUaB7Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uGV10+TEWWMJod1-MRD1jkLqvOGUu4Qk9S84WJAUaB7Mg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:58:18AM +0100, Daniel Vetter wrote:
> On Tue, Nov 3, 2020 at 9:53 AM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Mon, 02 Nov 2020, Peilin Ye wrote:
> >
> > > From: Lee Jones <lee.jones@linaro.org>
> > >
> > > Commit 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in
> > > fonts") introduced the following error when building rpc_defconfig (only
> > > this build appears to be affected):
> > >
> > >  `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
> > >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> > >  `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
> > >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> > >  make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
> > >  make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
> > >  make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2
> > >
> > > The .data section is discarded at link time.  Reinstating acorndata_8x8 as
> > > const ensures it is still available after linking.  Do the same for the
> > > other 12 built-in fonts as well, for consistency purposes.
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Russell King <linux@armlinux.org.uk>
> > > Fixes: 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts")
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > Co-developed-by: Peilin Ye <yepeilin.cs@gmail.com>
> > > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > > ---
> > > Changes in v2:
> > >   - Fix commit ID to 6735b4632def in commit message (Russell King
> > >     <linux@armlinux.org.uk>)
> > >   - Add `const` back for all 13 built-in fonts (Daniel Vetter
> > >     <daniel.vetter@ffwll.ch>)
> > >   - Add a Fixes: tag
> > >
> > >  lib/fonts/font_10x18.c     | 2 +-
> > >  lib/fonts/font_6x10.c      | 2 +-
> > >  lib/fonts/font_6x11.c      | 2 +-
> > >  lib/fonts/font_6x8.c       | 2 +-
> > >  lib/fonts/font_7x14.c      | 2 +-
> > >  lib/fonts/font_8x16.c      | 2 +-
> > >  lib/fonts/font_8x8.c       | 2 +-
> > >  lib/fonts/font_acorn_8x8.c | 2 +-
> > >  lib/fonts/font_mini_4x6.c  | 2 +-
> > >  lib/fonts/font_pearl_8x8.c | 2 +-
> > >  lib/fonts/font_sun12x22.c  | 2 +-
> > >  lib/fonts/font_sun8x16.c   | 2 +-
> > >  lib/fonts/font_ter16x32.c  | 2 +-
> > >  13 files changed, 13 insertions(+), 13 deletions(-)
> >
> > LGTM.
> >
> > Thanks for keeping my authorship.  Much appreciated.
> 
> Should I stuff this into drm-misc-fixes? Or will someone else pick
> this up? Greg?
> 
> I guess drm-misc-fixes might be easiest since there's a bunch of other
> fbcon/font stuff in the queue in drm-misc from Peilin.

You can take it:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
