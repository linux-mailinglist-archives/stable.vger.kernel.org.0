Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5536645E9DE
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 10:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbhKZJI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 04:08:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346114AbhKZJGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 04:06:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68BEB60E8E;
        Fri, 26 Nov 2021 09:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637917392;
        bh=KIdkGMCUnXGQU6ywk3jGBbBD2VSqSHbmhQx0qPk4tRE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mXjN6MS7Qs3aGXmnW6i+PThqm01KYqufnGVqrZ2tJ4aD7rFlewyejMm9C3huRBCjC
         u6vh+wdSvstvrz+Yb0jvjreWV8mipYr+Ed1U5q/r6LE17jO4vLUqDwK/CpOMVDh54I
         nCqk1OztuIYURgzcuWW3csybJvgDBvgNGnu5uCBE=
Date:   Fri, 26 Nov 2021 10:03:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YaCizHYteAeLT4yk@kroah.com>
References: <20211125142004.686650-1-lee.jones@linaro.org>
 <20211125145004.GN6514@kadam>
 <YZ+muS7vC5iNs/kq@google.com>
 <20211125151822.GJ18178@kadam>
 <20211126071641.GO6514@kadam>
 <YaChOzfm2/3gY4o3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaChOzfm2/3gY4o3@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 26, 2021 at 08:56:27AM +0000, Lee Jones wrote:
> On Fri, 26 Nov 2021, Dan Carpenter wrote:
> 
> > On Thu, Nov 25, 2021 at 06:18:22PM +0300, Dan Carpenter wrote:
> > > I had thought that ->kmap_cnt was a regular int and not an unsigned
> > > int, but I would have to pull a stable tree to see where I misread the
> > > code.
> > 
> > I was looking at (struct ion_buffer)->kmap_cnt but this is
> > (struct ion_handle)->kmap_cnt.  I'm not sure how those are related but
> > it makes me nervous that one can go higher than the other.  Also both
> > probably need overflow protection.
> > 
> > So I guess I would just do something like:
> > 
> > diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > index 806e9b30b9dc8..e8846279b33b5 100644
> > --- a/drivers/staging/android/ion/ion.c
> > +++ b/drivers/staging/android/ion/ion.c
> > @@ -489,6 +489,8 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
> >  	void *vaddr;
> >  
> >  	if (buffer->kmap_cnt) {
> > +		if (buffer->kmap_cnt == INT_MAX)
> > +			return ERR_PTR(-EOVERFLOW);
> >  		buffer->kmap_cnt++;
> >  		return buffer->vaddr;
> >  	}
> > @@ -509,6 +511,8 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
> >  	void *vaddr;
> >  
> >  	if (handle->kmap_cnt) {
> > +		if (handle->kmap_cnt == INT_MAX)
> > +			return ERR_PTR(-EOVERFLOW);
> >  		handle->kmap_cnt++;
> >  		return buffer->vaddr;
> >  	}
> 
> Which is all well and good until somebody changes the type.

That's hard to do on code that is removed from the kernel tree :)
