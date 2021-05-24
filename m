Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF9138E53F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 13:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhEXLVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 07:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232516AbhEXLVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 07:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F37961132;
        Mon, 24 May 2021 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621855208;
        bh=6MhbRVnhXj52pCV9G691X4wozHkIHV+CMIGQkpSFPT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3VTQGSt1yLHAP8xpF62AEeS2bEqr0Cy16h1foxZ/s5PZy1ZZ7Wzhe+3j+aHnl640
         lFbcXzPRVsW+0Ul6sRmUpaka+guVzymUc+ca3bqN+f6j9pdP+kqgCX2Am9DiBsEFa+
         1q6uwQ04kRKNsnt3UD1qGkL+Nkl6H9CGPrtSE5f1OZ7ooMPvV2nh4yhZ5KDnVktYHB
         fl9CD4+DmB/8vzhViiL2jiKipSqNqF7RRHBgAZCcJCnqtsSIyjmMjR5Sn4OABeEjTu
         Sp3snRPesBtcST4CyRSYSTdsNRMTUVXO8hpnr9v5ccL66X9Uvo091o5w2GlixPRSfV
         AanRtOu1sZ1mg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ll8cv-0006Tm-6H; Mon, 24 May 2021 13:20:05 +0200
Date:   Mon, 24 May 2021 13:20:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: trancevibrator: fix control-request direction
Message-ID: <YKuL5TcWGiEqofF2@hovoldconsulting.com>
References: <20210521133109.17396-1-johan@kernel.org>
 <YKf28CaRalCTsXfO@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKf28CaRalCTsXfO@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 21, 2021 at 08:07:44PM +0200, Greg Kroah-Hartman wrote:
> On Fri, May 21, 2021 at 03:31:09PM +0200, Johan Hovold wrote:
> > The direction of the pipe argument must match the request-type direction
> > bit or control requests may fail depending on the host-controller-driver
> > implementation.
> > 
> > Fix the set-speed request which erroneously used USB_DIR_IN and update
> > the default timeout argument to match (same value).
> > 
> > Fixes: 5638e4d92e77 ("USB: add PlayStation 2 Trance Vibrator driver")
> > Cc: stable@vger.kernel.org      # 2.6.19
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/misc/trancevibrator.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/usb/misc/trancevibrator.c b/drivers/usb/misc/trancevibrator.c
> > index a3dfc77578ea..26baba3ab7d7 100644
> > --- a/drivers/usb/misc/trancevibrator.c
> > +++ b/drivers/usb/misc/trancevibrator.c
> > @@ -61,9 +61,9 @@ static ssize_t speed_store(struct device *dev, struct device_attribute *attr,
> >  	/* Set speed */
> >  	retval = usb_control_msg(tv->udev, usb_sndctrlpipe(tv->udev, 0),
> >  				 0x01, /* vendor request: set speed */
> > -				 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_OTHER,
> > +				 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
> >  				 tv->speed, /* speed value */
> > -				 0, NULL, 0, USB_CTRL_GET_TIMEOUT);
> > +				 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
> >  	if (retval) {
> >  		tv->speed = old;
> >  		dev_dbg(&tv->udev->dev, "retval = %d\n", retval);
> > -- 
> > 2.26.3
> > 
> 
> Thanks for searching the whole tree for these mistakes, nice work!

Thanks, but I only did a first quick scan of the more obvious mismatches
when the USB_DIR macros was being used.

I found a few more when grepping for harcoded request types but that
still won't catch drivers that use defines for the type and other even
harder to detect variants.

Syzbot already found a couple more but it usually doesn't check anything
beyond the probe function.

Johan
