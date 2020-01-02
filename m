Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB2D12E1B4
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 03:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgABCaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 21:30:35 -0500
Received: from netrider.rowland.org ([192.131.102.5]:33455 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727511AbgABCaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 21:30:35 -0500
Received: (qmail 30587 invoked by uid 500); 1 Jan 2020 21:30:34 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 1 Jan 2020 21:30:34 -0500
Date:   Wed, 1 Jan 2020 21:30:34 -0500 (EST)
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
In-Reply-To: <1fd709ce-04a3-4183-da39-c1921ec69ce7@roeck-us.net>
Message-ID: <Pine.LNX.4.44L0.2001012117220.30059-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Jan 2020, Guenter Roeck wrote:

> On 12/29/19 8:40 AM, Alan Stern wrote:
> > On Sun, 29 Dec 2019, Guenter Roeck wrote:
> > 
> >> On Sat, Dec 28, 2019 at 02:33:01PM -0500, Alan Stern wrote:
> >>>
> >>> Let's try a slightly different approach.  What happens with this patch?
> >>>
> >>> Alan Stern
> >>>
> >>>
> >>> Index: usb-devel/drivers/usb/core/hub.c
> >>> ===================================================================
> >>> --- usb-devel.orig/drivers/usb/core/hub.c
> >>> +++ usb-devel/drivers/usb/core/hub.c
> >>> @@ -1065,6 +1065,7 @@ static void hub_activate(struct usb_hub
> >>>   		if (type == HUB_INIT) {
> >>>   			delay = hub_power_on_good_delay(hub);
> >>>   
> >>> +			hub->power_bits[0] = ~0UL;	/* All ports on */
> >>>   			hub_power_on(hub, false);
> >>>   			INIT_DELAYED_WORK(&hub->init_work, hub_init_func2);
> >>>   			queue_delayed_work(system_power_efficient_wq,
> >>>
> >>
> >> That doesn't make a difference - the traceback is still seen with this patch
> >> applied.
> > 
> > Can you trace what's going on?  Does this code pathway now end up
> > calling ehci_port_power() for each root-hub port, and from there down
> > into the chipidea driver?  If not, can you find where it gets
> > sidetracked?
> > 
> 
> A complete traceback is attached below, so, yes, I think it is safe to say that
> ehci_port_power() is called unconditionally for each root-hub port on shutdown.

I was really asking about hub activation and powering-up, but you found 
the answer to that too, so okay.

> The only mystery to me was why ehci_port_power() isn't called to enable port power
> when the port comes up. As it turns out, HCS_PPC(ehci->hcs_params) is false on my
> simulated hardware, and thus ehci_port_power(..., true) is not called from
> ehci_hub_control().
> 
> Given that, it may well be that the problem is not seen on "real" hardware,
> at least not with real mcimx7d-sabre hardware, if the hub on that hardware does
> support power control. To test this idea, I modified qemu to claim hub power
> control support by setting the "power control support" capability bit. With
> that, the traceback is gone.
> 
> Any suggestion how to proceed ?

Given that HCS_PPC(ehci_hcs_params) is false, I would say that
ehci_turn_off_all_ports() shouldn't call ehci_port_power().  You should
add that test there.  (Although to tell the truth, I'm not really sure 
we need to test HCS_PPC anywhere...)

Did you check what happens without the patch I sent you?  I would like
to know if that patch really does make a difference.  If we don't send
the Set-Port-Feature(power) request during hub activation without the
patch then it does need to be merged.

Alan Stern

