Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843FA137DA
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 08:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfEDGpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 02:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbfEDGpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 02:45:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37AA920675;
        Sat,  4 May 2019 06:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556952329;
        bh=LGCs4gvPTmGr/6mh5CkkCOnBvPtC6U3fKyL7tODsf90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uPZNCo/dsELO/HxHPmYaPXapjZsBEx9NDHyE0uCgKGEdT6skj1Gfyo8zMiXMqucyv
         Sq8BkeDRmOfSGn5tLAXB8P2ppTVjQNm4WMKAI+HCXMZ91wmzbrGNHN2btMVuKGCN+H
         mU7/cQgYNETeGJ6kp//UsfYu2feKn6YBDrwALo7M=
Date:   Sat, 4 May 2019 08:45:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aditya Pakki <pakki001@umn.edu>,
        Richard Leitner <richard.leitner@skidata.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: Re: [PATCH 4.19 57/72] usb: usb251xb: fix to avoid potential NULL
 pointer dereference
Message-ID: <20190504064527.GD26311@kroah.com>
References: <20190502143333.437607839@linuxfoundation.org>
 <20190502143337.920245890@linuxfoundation.org>
 <20190503213235.GA9080@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503213235.GA9080@amd>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 11:32:35PM +0200, Pavel Machek wrote:
> On Thu 2019-05-02 17:21:19, Greg Kroah-Hartman wrote:
> > [ Upstream commit 41f00e6e9e55546390031996b773e7f3c1d95928 ]
> > 
> > of_match_device in usb251xb_probe can fail and returns a NULL pointer.
> > The patch avoids a potential NULL pointer dereference in this scenario.
> > 
> > Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> > Reviewed-by: Richard Leitner <richard.leitner@skidata.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
> > ---
> >  drivers/usb/misc/usb251xb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/misc/usb251xb.c b/drivers/usb/misc/usb251xb.c
> > index a6efb9a72939..5f7734c729b1 100644
> > --- a/drivers/usb/misc/usb251xb.c
> > +++ b/drivers/usb/misc/usb251xb.c
> > @@ -601,7 +601,7 @@ static int usb251xb_probe(struct usb251xb *hub)
> >  							   dev);
> >  	int err;
> >  
> > -	if (np) {
> > +	if (np && of_id) {
> >  		err = usb251xb_get_ofdata(hub,
> >  					  (struct usb251xb_data *)of_id->data);
> >  		if (err) {
> 
> Are you sure this si correct?
> 
> If of_id is NULL, this will proceed without setting up hub->conf_data
> etc.
> 
> I'd expect it to just return error from probe...?

I think it will error out later on.

> Was this tested?

Don't know, error paths are hard to test :)

But the code obviously fixes a null dereference, so that's a good thing.

thanks,

greg k-h
