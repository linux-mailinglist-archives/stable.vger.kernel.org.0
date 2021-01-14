Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFCB2F5CE3
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 10:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbhANJGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 04:06:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbhANJGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 04:06:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B39D8221E2;
        Thu, 14 Jan 2021 09:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610615140;
        bh=qDLAwr206zXZGSraoMYhwbCT8GXAxyVUGRS5xaVvuCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D8nfgL2RYDjxvaiOr+aBNxixlWHMIzKz88eFYWFcrnGOofzWISWWWy34X/OLkS4Ko
         GbGIju3ZfNsq7Q4ymiYpPiM7TSD7R2s63diJ0qgEB6bWniRowRgADpoD/IKFhCAHTB
         aDfe3E1nxWIYwk6sUpOlzOIyX9DF8DyJzui5wbZs=
Date:   Thu, 14 Jan 2021 10:06:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Peter Chen <peter.chen@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: udc: core: Use lock when write to soft_connect
Message-ID: <YAAJpb1myYDviJO7@kroah.com>
References: <311bc6d30b23427420133602c2833308310b7fcb.1610595364.git.Thinh.Nguyen@synopsys.com>
 <X//nfLN9bW1K/yVm@lx-t490>
 <CAHp75Vf3eZjg20QEr6YqdY7R1Eu=D2za+sKb0vVBaAmETg1z4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vf3eZjg20QEr6YqdY7R1Eu=D2za+sKb0vVBaAmETg1z4Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 09:03:53AM +0200, Andy Shevchenko wrote:
> On Thursday, January 14, 2021, Ahmed S. Darwish <a.darwish@linutronix.de>
> wrote:
> 
> > On Wed, Jan 13, 2021 at 07:38:28PM -0800, Thinh Nguyen wrote:
> > ...
> > > @@ -1543,10 +1546,12 @@ static ssize_t soft_connect_store(struct device
> > *dev,
> > >               usb_gadget_udc_stop(udc);
> > >       } else {
> > >               dev_err(dev, "unsupported command '%s'\n", buf);
> > > -             return -EINVAL;
> > > +             ret = -EINVAL;
> > >       }
> > >
> > > -     return n;
> 
> 
> 
> Should be ret = n; here.

Why?  That happened higher up in the patch.

thanks,

greg k-h
