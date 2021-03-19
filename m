Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE7B3425ED
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 20:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhCSTNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 15:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhCSTNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 15:13:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39A9C061760
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 12:13:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1lNKYV-0006D0-Md; Fri, 19 Mar 2021 20:13:07 +0100
Message-ID: <693cbfa87ac025d84e1cd8d95c5bd68ec68a943b.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] drm/etnaviv: Use FOLL_FORCE for userptr
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Daniel Vetter <daniel@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        etnaviv@lists.freedesktop.org
Date:   Fri, 19 Mar 2021 20:13:06 +0100
In-Reply-To: <YFT3B9fRldXI470m@phenom.ffwll.local>
References: <20210301095254.1946084-1-daniel.vetter@ffwll.ch>
         <YFT3B9fRldXI470m@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Freitag, dem 19.03.2021 um 20:09 +0100 schrieb Daniel Vetter:
> On Mon, Mar 01, 2021 at 10:52:53AM +0100, Daniel Vetter wrote:
> > Nothing checks userptr.ro except this call to pup_fast, which means
> > there's nothing actually preventing userspace from writing to this.
> > Which means you can just read-only mmap any file you want, userptr it
> > and then write to it with the gpu. Not good.
> > 
> > The right way to handle this is FOLL_WRITE | FOLL_FORCE, which will
> > break any COW mappings and update tracking for MAY_WRITE mappings so
> > there's no exploit and the vm isn't confused about what's going on.
> > For any legit use case there's no difference from what userspace can
> > observe and do.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Lucas Stach <l.stach@pengutronix.de>
> > Cc: Russell King <linux+etnaviv@armlinux.org.uk>
> > Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
> > Cc: etnaviv@lists.freedesktop.org
> 
> Can I please have an ack on this so I can apply it? It's stuck.

Reviewed-by: Lucas Stach <l.stach@pengutronix.de>

> Thanks, Daniel
> 
> > ---
> >  drivers/gpu/drm/etnaviv/etnaviv_gem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> > index 6d38c5c17f23..a9e696d05b33 100644
> > --- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> > +++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> > @@ -689,7 +689,7 @@ static int etnaviv_gem_userptr_get_pages(struct etnaviv_gem_object *etnaviv_obj)
> >  		struct page **pages = pvec + pinned;
> >  
> > 
> > 
> > 
> >  		ret = pin_user_pages_fast(ptr, num_pages,
> > -					  !userptr->ro ? FOLL_WRITE : 0, pages);
> > +					  FOLL_WRITE | FOLL_FORCE, pages);
> >  		if (ret < 0) {
> >  			unpin_user_pages(pvec, pinned);
> >  			kvfree(pvec);
> > -- 
> > 2.30.0
> > 
> 


