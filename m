Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E0B12C382
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 17:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfL2Qkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 11:40:53 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49165 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726455AbfL2Qkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 11:40:53 -0500
Received: (qmail 20510 invoked by uid 500); 29 Dec 2019 11:40:52 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 29 Dec 2019 11:40:52 -0500
Date:   Sun, 29 Dec 2019 11:40:52 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     Guenter Roeck <linux@roeck-us.net>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: chipidea: host: Disable port power only if previously
 enabled
In-Reply-To: <20191229162811.GA21566@roeck-us.net>
Message-ID: <Pine.LNX.4.44L0.1912291137150.19645-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 29 Dec 2019, Guenter Roeck wrote:

> On Sat, Dec 28, 2019 at 02:33:01PM -0500, Alan Stern wrote:
> > 
> > Let's try a slightly different approach.  What happens with this patch?
> > 
> > Alan Stern
> > 
> > 
> > Index: usb-devel/drivers/usb/core/hub.c
> > ===================================================================
> > --- usb-devel.orig/drivers/usb/core/hub.c
> > +++ usb-devel/drivers/usb/core/hub.c
> > @@ -1065,6 +1065,7 @@ static void hub_activate(struct usb_hub
> >  		if (type == HUB_INIT) {
> >  			delay = hub_power_on_good_delay(hub);
> >  
> > +			hub->power_bits[0] = ~0UL;	/* All ports on */
> >  			hub_power_on(hub, false);
> >  			INIT_DELAYED_WORK(&hub->init_work, hub_init_func2);
> >  			queue_delayed_work(system_power_efficient_wq,
> > 
> 
> That doesn't make a difference - the traceback is still seen with this patch
> applied.

Can you trace what's going on?  Does this code pathway now end up
calling ehci_port_power() for each root-hub port, and from there down
into the chipidea driver?  If not, can you find where it gets
sidetracked?

Alan Stern

