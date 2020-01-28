Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390A314B3AF
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 12:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgA1Lox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 06:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgA1Lox (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 06:44:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0283224684;
        Tue, 28 Jan 2020 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580211892;
        bh=E7sSxi9rEy9lj8TVZnfhNZG9e0AVuStsXP4sldUxT4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ijsPN1f6iteMPvBro/SwB7dEVl3seXEWeB2zfYTOVkE1nDJtOwJjS23a1CkDbQ3ZO
         A7wtuCSmPJO2W0fJ08rbudp+K20sw0w0JIFUMtWNGYg+1Xqzk/zZb45aRAwF0GIxgO
         KHKecvvnQLkBroKWsOysi+JR6xpIBT/6ApGqxrio=
Date:   Tue, 28 Jan 2020 12:44:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Yury Norov <ynorov@caviumnetworks.com>,
        open list <linux-kernel@vger.kernel.org>,
        mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH v4 3/5] bitmap: Add bitmap_alloc(), bitmap_zalloc() and
 bitmap_free()
Message-ID: <20200128114450.GA2672297@kroah.com>
References: <20180630201750.2588-1-andriy.shevchenko@linux.intel.com>
 <20180630201750.2588-4-andriy.shevchenko@linux.intel.com>
 <CA+G9fYs3GPid5fcHEWp2i9NKR1hQGc5h0zKaUK5xr1RGJ83xLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs3GPid5fcHEWp2i9NKR1hQGc5h0zKaUK5xr1RGJ83xLg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 05:08:27PM +0530, Naresh Kamboju wrote:
> On Sun, 1 Jul 2018 at 01:49, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >
> > A lot of code become ugly because of open coding allocations for bitmaps.
> >
> > Introduce three helpers to allow users be more clear of intention
> > and keep their code neat.
> >
> > Note, due to multiple circular dependencies we may not provide
> > the helpers as inliners. For now we keep them exported and, perhaps,
> > at some point in the future we will sort out header inclusion and
> > inheritance.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  include/linux/bitmap.h |  8 ++++++++
> >  lib/bitmap.c           | 19 +++++++++++++++++++
> >  2 files changed, 27 insertions(+)
> >
> > diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> > index 1ee46f492267..acf5e8df3504 100644
> > --- a/include/linux/bitmap.h
> > +++ b/include/linux/bitmap.h
> > @@ -104,6 +104,14 @@
> >   * contain all bit positions from 0 to 'bits' - 1.
> >   */
> >
> > +/*
> > + * Allocation and deallocation of bitmap.
> > + * Provided in lib/bitmap.c to avoid circular dependency.
> > + */
> > +extern unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags);
> > +extern unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags);
> > +extern void bitmap_free(const unsigned long *bitmap);
> > +
> >  /*
> >   * lib/bitmap.c provides these functions:
> >   */
> > diff --git a/lib/bitmap.c b/lib/bitmap.c
> > index 33e95cd359a2..09acf2fd6a35 100644
> > --- a/lib/bitmap.c
> > +++ b/lib/bitmap.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/bitops.h>
> >  #include <linux/bug.h>
> >  #include <linux/kernel.h>
> > +#include <linux/slab.h>
> >  #include <linux/string.h>
> >  #include <linux/uaccess.h>
> >
> > @@ -1125,6 +1126,24 @@ void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int n
> >  EXPORT_SYMBOL(bitmap_copy_le);
> >  #endif
> >
> > +unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
> > +{
> > +       return kmalloc_array(BITS_TO_LONGS(nbits), sizeof(unsigned long), flags);
> > +}
> > +EXPORT_SYMBOL(bitmap_alloc);
> > +
> > +unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
> > +{
> > +       return bitmap_alloc(nbits, flags | __GFP_ZERO);
> > +}
> > +EXPORT_SYMBOL(bitmap_zalloc);
> > +
> > +void bitmap_free(const unsigned long *bitmap)
> > +{
> > +       kfree(bitmap);
> > +}
> > +EXPORT_SYMBOL(bitmap_free);
> > +
> >  #if BITS_PER_LONG == 64
> >  /**
> >   * bitmap_from_arr32 - copy the contents of u32 array of bits to bitmap
> 
> stable-rc 4.14 build failed due to these build error,

Yeah, sorry, I noticed this right before I had to leave for a few hours.
I'll go fix this up now...

greg k-h
