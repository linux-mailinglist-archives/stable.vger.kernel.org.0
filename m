Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C063603B7
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 09:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhDOHyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 03:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231215AbhDOHyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 03:54:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 182A560FF1;
        Thu, 15 Apr 2021 07:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618473220;
        bh=wBbsq3BHxR0U3Gvztafs7IZfL5R/LWbYaqcp+rGIddc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=malk0Q1T6WsJdGmTQ+Gw5zh+K+/ylDTnbDHWrX69H83FHQ++xUhrVxEw5CPSnRnv7
         v8cpu8aRYgth14o97xu1XXnO8qs1mtxGysWR4JKJONnLDnBZLnVPCTphSMCZUx2ndE
         tlPlYVlT4KTD8Yt+W+Cr8Usl5v8wnzEmieVRpcwY=
Date:   Thu, 15 Apr 2021 09:53:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH] usb: dwc3: core: Do core softreset when switch mode
Message-ID: <YHfxAnbHNrjSwLE+@kroah.com>
References: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
 <87sg3snk1l.fsf@kernel.org>
 <c125a30b-edde-8fe5-3370-d9e62a24f7e9@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c125a30b-edde-8fe5-3370-d9e62a24f7e9@synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 07:10:34AM +0000, Thinh Nguyen wrote:
> Felipe Balbi wrote:
> > 
> > Hi,
> > 
> > Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> >> From: Yu Chen <chenyu56@huawei.com>
> >> From: John Stultz <john.stultz@linaro.org>
> >>
> >> According to the programming guide, to switch mode for DRD controller,
> >> the driver needs to do the following.
> >>
> >> To switch from device to host:
> >> 1. Reset controller with GCTL.CoreSoftReset
> >> 2. Set GCTL.PrtCapDir(host mode)
> >> 3. Reset the host with USBCMD.HCRESET
> >> 4. Then follow up with the initializing host registers sequence
> >>
> >> To switch from host to device:
> >> 1. Reset controller with GCTL.CoreSoftReset
> >> 2. Set GCTL.PrtCapDir(device mode)
> >> 3. Reset the device with DCTL.CSftRst
> >> 4. Then follow up with the initializing registers sequence
> >>
> >> Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
> > 
> > we're not really missing, it was a deliberate choice :-) The only reason
> > why we need the soft reset is because host and gadget registers map to
> > the same physical space within dwc3 core. If we cache and restore the
> > affected registers, we're good ;-)
> 
> It's part of the programming model. I've already discussed with internal
> RTL designers. This is needed, and I've provided the discussion we had
> prior also. We have several different devices in the wild that need
> this. What is the concern?
> 
> > 
> > IMHO, that's a better compromise than doing a full soft reset.
> > 
> >> @@ -40,6 +41,8 @@
> >>  
> >>  #define DWC3_DEFAULT_AUTOSUSPEND_DELAY	5000 /* ms */
> >>  
> >> +static DEFINE_MUTEX(mode_switch_lock);
> > 
> > there are several platforms which more than one DWC3 instance. Sure this
> > won't break on such systems?
> > 
> 
> How? Am I missing something? Please let me know so I can make the change.

All data needs to be per-device, not "global for the codebase" like the
way you declared this lock.

thanks,

greg k-h
