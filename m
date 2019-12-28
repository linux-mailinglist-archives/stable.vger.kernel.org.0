Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC5612BEB3
	for <lists+stable@lfdr.de>; Sat, 28 Dec 2019 20:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfL1TdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Dec 2019 14:33:03 -0500
Received: from netrider.rowland.org ([192.131.102.5]:57667 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726362AbfL1TdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Dec 2019 14:33:03 -0500
Received: (qmail 18436 invoked by uid 500); 28 Dec 2019 14:33:01 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 28 Dec 2019 14:33:01 -0500
Date:   Sat, 28 Dec 2019 14:33:01 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     Guenter Roeck <linux@roeck-us.net>
cc:     Peter Chen <peter.chen@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: chipidea: host: Disable port power only if previously
 enabled
In-Reply-To: <20191227165543.GA15950@roeck-us.net>
Message-ID: <Pine.LNX.4.44L0.1912281431190.18379-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 27 Dec 2019, Guenter Roeck wrote:

> On Thu, Dec 26, 2019 at 02:46:15PM -0500, Alan Stern wrote:
> > On Thu, 26 Dec 2019, Guenter Roeck wrote:
> > 
> > > On shutdown, ehci_power_off() is called unconditionally to power off
> > > each port, even if it was never called to power on the port.
> > > For chipidea, this results in a call to ehci_ci_portpower() with a request
> > > to power off ports even if the port was never powered on.
> > > This results in the following warning from the regulator code.
> > 
> > That's weird -- we should always power-on every port during hub 
> > initialization.
> > 
> That is what I would have assumed, but test code shows that it doesn't
> happen.
> 
> > It looks like there's a bug in hub.c:hub_activate(): The line under
> > HUB_INIT which calls hub_power_on() should call
> > usb_hub_set_port_power() instead.  In fact, the comment near the start
> 
> usb_hub_set_port_power() operates on a port of the hub. hub_activate()
> operates on the hub itself, or at least I think it does. I don't know
> how to convert the calls. Also, there are more calls to hub_power_on()
> in the same function.  Can you provide more details on what to do,
> or even better a patch for me to test ?

Let's try a slightly different approach.  What happens with this patch?

Alan Stern


Index: usb-devel/drivers/usb/core/hub.c
===================================================================
--- usb-devel.orig/drivers/usb/core/hub.c
+++ usb-devel/drivers/usb/core/hub.c
@@ -1065,6 +1065,7 @@ static void hub_activate(struct usb_hub
 		if (type == HUB_INIT) {
 			delay = hub_power_on_good_delay(hub);
 
+			hub->power_bits[0] = ~0UL;	/* All ports on */
 			hub_power_on(hub, false);
 			INIT_DELAYED_WORK(&hub->init_work, hub_init_func2);
 			queue_delayed_work(system_power_efficient_wq,

