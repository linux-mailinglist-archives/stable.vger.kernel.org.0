Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0F112AE5A
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 20:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfLZTqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 14:46:16 -0500
Received: from netrider.rowland.org ([192.131.102.5]:33409 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726748AbfLZTqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Dec 2019 14:46:16 -0500
Received: (qmail 7099 invoked by uid 500); 26 Dec 2019 14:46:15 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 26 Dec 2019 14:46:15 -0500
Date:   Thu, 26 Dec 2019 14:46:15 -0500 (EST)
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
In-Reply-To: <20191226155754.25451-1-linux@roeck-us.net>
Message-ID: <Pine.LNX.4.44L0.1912261428310.6148-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 26 Dec 2019, Guenter Roeck wrote:

> On shutdown, ehci_power_off() is called unconditionally to power off
> each port, even if it was never called to power on the port.
> For chipidea, this results in a call to ehci_ci_portpower() with a request
> to power off ports even if the port was never powered on.
> This results in the following warning from the regulator code.

That's weird -- we should always power-on every port during hub 
initialization.

It looks like there's a bug in hub.c:hub_activate(): The line under
HUB_INIT which calls hub_power_on() should call
usb_hub_set_port_power() instead.  In fact, the comment near the start
of hub_power_on() is wrong.  It says "Enable power on each port", but
in fact it only enables power for ports that had been powered-on
previously (i.e., the port's bit in hub->power_bits was set).  
Apparently this got messed up in commit ad493e5e5805 ("usb: add usb
port auto power off mechanism").

Now, the chipidea driver may still need to be updated, because 
ehci_turn_off_all_ports() will still be called during shutdown and it 
will try to power-down all ports, even those which are already powered 
down (for example, because the port is suspended).

Alan Stern

