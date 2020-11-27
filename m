Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09452C6738
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 14:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbgK0Nul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 08:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730316AbgK0Nul (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 08:50:41 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA27F2224A;
        Fri, 27 Nov 2020 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606485040;
        bh=uxMc+v5y4/CAVDXdUUY5D5KHB8dWir/j+6ArLkukR9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oaq4mlruYrAHadOKy20SeMZh5bUP3ROfkvMrH9XFd86Tt9gOEDzVya9pXHn/umn/v
         EuUOr/+e85Ffg0ARyJOHFd5sr7XQBqE4VoBTMZVOELk3rAiZQS32Ten1s08XyV211H
         K/3Xjz9Wj41BAwR3H5iQ7HSg4YKJOmVr3BU/pIIg=
Date:   Fri, 27 Nov 2020 14:50:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Chen <peter.chen@nxp.com>
Cc:     "balbi@kernel.org" <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "taehyun.cho" <taehyun.cho@samsung.com>,
        stable <stable@vger.kernel.org>,
        Will McVicker <willmcvicker@google.com>
Subject: Re: [PATCH 3/4] USB: gadget: f_fs: add SuperSpeed Plus support
Message-ID: <X8EELU42XwBV9UV5@kroah.com>
References: <20201126180937.255892-1-gregkh@linuxfoundation.org>
 <20201126180937.255892-3-gregkh@linuxfoundation.org>
 <20201127025517.GA22238@b29397-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127025517.GA22238@b29397-desktop>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 02:55:47AM +0000, Peter Chen wrote:
> On 20-11-26 19:09:36, Greg Kroah-Hartman wrote:
> > From: "taehyun.cho" <taehyun.cho@samsung.com>
> > 
> > Setup the descriptors for SuperSpeed Plus for f_fs. This allows the
> > gadget to work properly without crashing at SuperSpeed rates.
> > 
> > Cc: Felipe Balbi <balbi@kernel.org>
> > Cc: Peter Chen <peter.chen@nxp.com>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: taehyun.cho <taehyun.cho@samsung.com>
> > Signed-off-by: Will McVicker <willmcvicker@google.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/usb/gadget/function/f_fs.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> > index 046f770a76da..a34a7c96a1ab 100644
> > --- a/drivers/usb/gadget/function/f_fs.c
> > +++ b/drivers/usb/gadget/function/f_fs.c
> > @@ -1327,6 +1327,7 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
> >  		struct usb_endpoint_descriptor *desc;
> >  
> >  		switch (epfile->ffs->gadget->speed) {
> > +		case USB_SPEED_SUPER_PLUS:
> >  		case USB_SPEED_SUPER:
> >  			desc_idx = 2;
> >  			break;
> > @@ -3222,6 +3223,10 @@ static int _ffs_func_bind(struct usb_configuration *c,
> >  	func->function.os_desc_n =
> >  		c->cdev->use_os_string ? ffs->interfaces_count : 0;
> >  
> > +	if (likely(super)) {
> 
> Why likely is used? Currently, there are still lots of HS devices on market
> or on the development.

It looks to be a cut/paste of the other tests above, all of which say
"likely" which we all know is not true at all.  I'll leave this now, and
add a patch that removes them all as this is NOT a function where it
should be used at all.

thanks for the review.

greg k-h
