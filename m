Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E033A2D5F35
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391737AbgLJPMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389313AbgLJPMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 10:12:14 -0500
Date:   Thu, 10 Dec 2020 16:12:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607613093;
        bh=8LnWVA9tBVBdECrQ3EZYa9gCyEM1NCSqT1EEqJu33xI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=tzznl9VwtMU11kfBVsYPiq/XCWLCkOt7wdNqvWMDAV2GjBIB6aLQSxFw5lteXzToP
         B4axthHsWP2XHwen8+en5RX6qzTalFAV61H72WIQyJdAQdfMF0L16SUSqixNJY2IeH
         RvZ0aEq+D0rEoZLQE1MexoTHS6VBQFughLDFFkuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Chen <peter.chen@nxp.com>
Cc:     Jack Pham <jackp@codeaurora.org>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "willmcvicker@google.com" <willmcvicker@google.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "taehyun.cho" <taehyun.cho@samsung.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] USB: gadget: f_fs: add SuperSpeed Plus support
Message-ID: <X9I672Sq/zj8cpzY@kroah.com>
References: <20201127140559.381351-1-gregkh@linuxfoundation.org>
 <20201127140559.381351-5-gregkh@linuxfoundation.org>
 <20201130091259.GB31406@jackp-linux.qualcomm.com>
 <20201201023149.GA11393@b29397-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201023149.GA11393@b29397-desktop>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 02:32:18AM +0000, Peter Chen wrote:
> On 20-11-30 01:13:00, Jack Pham wrote:
> > On Fri, Nov 27, 2020 at 03:05:58PM +0100, Greg Kroah-Hartman wrote:
> > > From: "taehyun.cho" <taehyun.cho@samsung.com>
> > > 
> > > Setup the descriptors for SuperSpeed Plus for f_fs. This allows the
> > > gadget to work properly without crashing at SuperSpeed rates.
> > > 
> > > Cc: Felipe Balbi <balbi@kernel.org>
> > > Cc: stable <stable@vger.kernel.org>
> > > Signed-off-by: taehyun.cho <taehyun.cho@samsung.com>
> > > Signed-off-by: Will McVicker <willmcvicker@google.com>
> > > Reviewed-by: Peter Chen <peter.chen@nxp.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  drivers/usb/gadget/function/f_fs.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> > > index 046f770a76da..a34a7c96a1ab 100644
> > > --- a/drivers/usb/gadget/function/f_fs.c
> > > +++ b/drivers/usb/gadget/function/f_fs.c
> > > @@ -1327,6 +1327,7 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
> > >  		struct usb_endpoint_descriptor *desc;
> > >  
> > >  		switch (epfile->ffs->gadget->speed) {
> > > +		case USB_SPEED_SUPER_PLUS:
> > >  		case USB_SPEED_SUPER:
> > >  			desc_idx = 2;
> > >  			break;
> > > @@ -3222,6 +3223,10 @@ static int _ffs_func_bind(struct usb_configuration *c,
> > >  	func->function.os_desc_n =
> > >  		c->cdev->use_os_string ? ffs->interfaces_count : 0;
> > >  
> > > +	if (likely(super)) {
> > > +		func->function.ssp_descriptors =
> > > +			usb_copy_descriptors(func->function.ss_descriptors);
> > > +	}
> > >  	/* And we're done */
> > >  	ffs_event_add(ffs, FUNCTIONFS_BIND);
> > >  	return 0;
> > > -- 
> > 
> > Hi Greg,
> > 
> > FWIW I had sent a very similar patch[1] a while back (twice in fact)
> > but got no response about it. Looks like Taehyun's patch already went
> > through Google for this, I assume it must be working on their Android
> > kernels so I've no problem with you or Felipe taking this instead.
> > 
> > Only one difference with my patch though is mine additionally clears the
> > func->function.ssp_descriptors member to NULL upon ffs_func_unbind() as
> > otherwise it could lead to a dangling reference in case the function is
> > re-bound and userspace does not issue SS descriptors the next time.
> > Realistically I don't think that's possible, except maybe when fuzzing?
> > 
> 
> Yours is better, since there is no judgement for
> func->function.ssp_descriptors at __ffs_func_bind_do_descs, without
> clearing its value can't cause problem.

Ok, I've taken the older patch instead, thanks!

greg k-h
