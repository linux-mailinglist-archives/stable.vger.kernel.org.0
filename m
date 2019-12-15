Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C1111F99C
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfLORSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:18:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfLORSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 12:18:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A79BE2465E;
        Sun, 15 Dec 2019 17:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576430295;
        bh=lBaXQVDhBlGlffyuK24qEtkZ0lOF2dTznMoC0TZNOCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vu3jfGDc8TFDJvDRnJUxmulRWlc3HCPyKpGky/PEdRM5M0NmlN+Hyb2fXmyhMwgoC
         O4GW4bI1A4k4JGcdRQFnPC+/5+C1Igk8nGkOXdxvOK/pJ6iHhyP6MrJOyH8BdVt6KK
         wBIj3yIuD256oHq+LIrwnLPHDaLXiMV6Xl1/0ocs=
Date:   Sun, 15 Dec 2019 18:18:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix request complete check
Message-ID: <20191215171812.GA853060@kroah.com>
References: <ac5a3593a94fdaa3d92e6352356b5f7a01ccdc7c.1576291140.git.thinhn@synopsys.com>
 <5a7554e4-a12e-d29c-1767-5dd75183922f@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a7554e4-a12e-d29c-1767-5dd75183922f@synopsys.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 14, 2019 at 03:01:40AM +0000, Thinh Nguyen wrote:
> Hi Greg and Felipe,
> 
> Thinh Nguyen wrote:
> > We can only check for IN direction if the request had completed. For OUT
> > direction, it's perfectly fine that the host can send less than the
> > setup length. Let's return true fall all cases of OUT direction.
> >
> > Fixes: e0c42ce590fe ("usb: dwc3: gadget: simplify IOC handling")
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
> > ---
> >   drivers/usb/dwc3/gadget.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index b3f8514d1f27..edc478c20846 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -2470,6 +2470,13 @@ static int dwc3_gadget_ep_reclaim_trb_linear(struct dwc3_ep *dep,
> >   
> >   static bool dwc3_gadget_ep_request_completed(struct dwc3_request *req)
> >   {
> > +	/*
> > +	 * For OUT direction, host may send less than the setup
> > +	 * length. Return true for all OUT requests.
> > +	 */
> > +	if (!req->direction)
> > +		return true;
> > +
> >   	return req->request.actual == req->request.length;
> >   }
> >   
> 
> Not sure if it's too late, but after Tejas's patch* that fixes the SG 
> check in dwc3, it exposes another issue. Without this patch, quite a few 
> function drivers will not work with dwc3.
> 
> If we can pick it up before the next merge, it'd be great.

What exactly breaks without this patch?  And how was the original patch
ever tested?

thanks,

greg k-h
