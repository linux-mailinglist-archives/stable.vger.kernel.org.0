Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB8645DABD
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346672AbhKYNL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:11:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351606AbhKYNK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 08:10:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECC1360C49;
        Thu, 25 Nov 2021 13:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637845638;
        bh=IApYsxIkJhViWpxrZR4DzRPaKCUKSgSwRKOl/hlTXYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fN2iqFY+9FmO/UcxnVPLQqhvlxO+WkPz0H8EOn7tiG3A4jtzo0DJNiyWDq37wbsOp
         OWb0jYFdIpqFLeOLnO+SWPaVXRmLfXFK7NMFS6Jf5utgz67JP3lBgg1L5TGNDK5bTs
         p7CzEMSPQqhGuUJ4Rmcx9hutvvK0mMtaNb3e9EeA=
Date:   Thu, 25 Nov 2021 14:06:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YZ+Kc/M1qSaWfXPW@kroah.com>
References: <20211125120234.67987-1-lee.jones@linaro.org>
 <YZ9+YPc7w9Z4xotR@kroah.com>
 <YZ+Fn0S1j4JzotGO@google.com>
 <YZ+HiBRUqLhSPwY0@kroah.com>
 <YZ+JsjZicl8jsRHM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ+JsjZicl8jsRHM@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 01:03:46PM +0000, Lee Jones wrote:
> On Thu, 25 Nov 2021, Greg KH wrote:
> 
> > On Thu, Nov 25, 2021 at 12:46:23PM +0000, Lee Jones wrote:
> > > On Thu, 25 Nov 2021, Greg KH wrote:
> > > 
> > > > On Thu, Nov 25, 2021 at 12:02:34PM +0000, Lee Jones wrote:
> > > > > Supply additional checks in order to prevent unexpected results.
> > > > > 
> > > > > Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > ---
> > > > >  drivers/staging/android/ion/ion.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > > > > index 806e9b30b9dc8..30f359faba575 100644
> > > > > --- a/drivers/staging/android/ion/ion.c
> > > > > +++ b/drivers/staging/android/ion/ion.c
> > > > > @@ -509,6 +509,9 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> > > > >  	void *vaddr;
> > > > >  
> > > > >  	if (handle->kmap_cnt) {
> > > > > +		if (handle->kmap_cnt + 1 < handle->kmap_cnt)
> > > > 
> > > > What about using the nice helpers in overflow.h for this?
> > > 
> > > I haven't heard of these before.
> > > 
> > > Looks like they're not widely used.
> > > 
> > > I'll try them out and see how they go.
> > > 
> > > > > +			return ERR_PTR(-EOVERFLOW);
> > > > > +
> > > > >  		handle->kmap_cnt++;
> > > > >  		return buffer->vaddr;
> > > > >  	}
> > > > 
> > > > What stable kernel branch(es) is this for?
> > > 
> > > I assumed your magic scripts could determine this from the Fixes:
> > > tag.  I'll be more explicit in v2.
> > 
> > The fixes tag says how far back for it to go, but not where to start
> > that process from :)
> 
> What's your preferred method for identifying a start-point?
> 
> In the [PATCH] tag or appended on to Cc: stable ... # <here>?
> 
> I know both work, but what makes your life easier?

Easiest is below the --- line say:
---
 This is for kernel versions X.X and older.

nothing complex.

thanks,

greg k-h
