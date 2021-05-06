Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1DE37523F
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 12:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhEFKZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 06:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231863AbhEFKZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 06:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D5BF6100A;
        Thu,  6 May 2021 10:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620296657;
        bh=UB7ckpxhjHZ7Pla4ATl0gbfE9Nu4AqhOhAvpTvKdiRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nGqRkC8AnxEyHv419G04DpyRMsHxiSlRZ++axtyjq05PMQn1a3IxWcIn624G9+/mM
         VmwnkLMHCI0A7id5khnk7YYrP0NoTrgomjoF2u9dX3vCBz02J5QwMtHUzoPY4tAz9U
         AXNizdzSQcBFNRZRyefB2JPHyf9P1fmhQkE7HuHA=
Date:   Thu, 6 May 2021 12:24:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Rosin <peda@axentia.se>
Cc:     linux-kernel@vger.kernel.org,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 27/69] cdrom: gdrom: deallocate struct gdrom_unit fields
 in remove_gdrom
Message-ID: <YJPDzqAAnP0jDRDF@kroah.com>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-28-gregkh@linuxfoundation.org>
 <223d5bda-bf02-a4a8-ab1d-de25e32b8d47@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <223d5bda-bf02-a4a8-ab1d-de25e32b8d47@axentia.se>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 04:13:18PM +0200, Peter Rosin wrote:
> Hi!
> 
> On 2021-05-03 13:56, Greg Kroah-Hartman wrote:
> > From: Atul Gopinathan <atulgopinathan@gmail.com>
> > 
> > The fields, "toc" and "cd_info", of "struct gdrom_unit gd" are allocated
> > in "probe_gdrom()". Prevent a memory leak by making sure "gd.cd_info" is
> > deallocated in the "remove_gdrom()" function.
> > 
> > Also prevent double free of the field "gd.toc" by moving it from the
> > module's exit function to "remove_gdrom()". This is because, in
> > "probe_gdrom()", the function makes sure to deallocate "gd.toc" in case
> > of any errors, so the exit function invoked later would again free
> > "gd.toc".
> > 
> > The patch also maintains consistency by deallocating the above mentioned
> > fields in "remove_gdrom()" along with another memory allocated field
> > "gd.disk".
> > 
> > Suggested-by: Jens Axboe <axboe@kernel.dk>
> > Cc: Peter Rosin <peda@axentia.se>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/cdrom/gdrom.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> > index 7f681320c7d3..6c4f6139f853 100644
> > --- a/drivers/cdrom/gdrom.c
> > +++ b/drivers/cdrom/gdrom.c
> > @@ -830,6 +830,8 @@ static int remove_gdrom(struct platform_device *devptr)
> >  	if (gdrom_major)
> >  		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
> >  	unregister_cdrom(gd.cd_info);
> > +	kfree(gd.cd_info);
> > +	kfree(gd.toc);
> >  
> >  	return 0;
> >  }
> > @@ -861,7 +863,6 @@ static void __exit exit_gdrom(void)
> >  {
> >  	platform_device_unregister(pd);
> >  	platform_driver_unregister(&gdrom_driver);
> > -	kfree(gd.toc);
> >  }
> >  
> >  module_init(init_gdrom);
> > 
> 
> I worry about the gd.toc = NULL; statement in init_gdrom(). It sets off
> all kinds of warnings with me. It looks completely bogus, but the fact
> that it's there at all makes me go hmmmm.

Yeah, that's bogus.

> probe_gdrom_setupcd() will arrange for gdrom_ops to be used, including
> .get_last_session pointing to gdrom_get_last_session() 
> 
> gdrom_get_last_session() will use gd.toc, if it is non-NULL.
> 
> The above will all be registered externally to the driver with the call
> to register_cdrom() in probe_gdrom(), before a possible stale gd.toc is
> overwritten with a new one at the end of probe_gdrom().

But can that really happen given that it hasn't ever happened before in
a real system?  :)

> Side note, .get_last_session is an interesting name in this context, but
> I have no idea if it might be called in the "bad" window (but relying on
> that to not be the case would be ... subtle).
> 
> So, by simply freeing gd.toc in remove_gdrom() without also setting
> it to NULL, it looks like a potential use after free of gd.toc is
> introduced, replacing a potential leak. Not good.

So should we set it to NULL after freeing it?  Is that really going to
help here given that the probe failed?  Nothing can use it after
remove_gdrom() is called because unregiser_* is called already.

I don't see the race here, sorry.

> The same is not true for gd.cd_info as far as I can tell, but it's a bit
> subtle. gdrom_probe() calls gdrom_execute_diagnostics() before the stale
> gd.cd_info is overwritten, and gdrom_execute_diagnostic() passes the
> stale pointer to gdrom_hardreset(), which luckily doesn't use it. But
> this is - as hinted - a bit too subtle for me. I would prefer to have
> remove_gdrom() also clear out the gd.cd_info pointer.

Ok, but again, how can that be used after remove_gdrom() is called?

> In addition to adding these clears of gd.toc and gd.cd_info to
> remove_gdrom(), they also need to be cleared in case probe fails.
> 
> Or instead, maybe add a big fat
> 	memset(&gd, 0, sizeof(gd));
> at the top of probe?

Really, that's what is happening today as there is only 1 device here,
and the whole structure was zeroed out already.  So that would be a
no-op.

> Or maybe the struct gdrom_unit should simply be kzalloc:ed? But that
> triggers some . to -> churn...

Yes, ideally that would be the correct change, but given that you can
only have 1 device in the system at a time of this type, it's not going
to make much difference at all here.

> Anyway, the patch as proposed gets a NACK from me.

Why?  It fixes the obvious memory leak, right?  Worst case you are
saying we should also set to NULL these pointers, but I can not see how
they are accessed as we have already torn everything down.

thanks,

greg k-h
