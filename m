Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C473C26DB09
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 14:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgIQMF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 08:05:29 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:59420 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgIQMFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 08:05:08 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 2286B3A5C9A;
        Thu, 17 Sep 2020 10:24:04 +0000 (UTC)
X-Originating-IP: 82.255.60.242
Received: from [192.168.0.28] (lns-bzn-39-82-255-60-242.adsl.proxad.net [82.255.60.242])
        (Authenticated sender: hadess@hadess.net)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 73DD1FF804;
        Thu, 17 Sep 2020 10:23:25 +0000 (UTC)
Message-ID: <2ee0f3922f54888acf3e0cafa47c3829a9b0de8f.camel@hadess.net>
Subject: Re: [PATCH 1/2] usbcore/driver: Fix specific driver selection
From:   Bastien Nocera <hadess@hadess.net>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-usb@vger.kernel.org
Cc:     Andrey Konovalov <andreyknvl@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com
Date:   Thu, 17 Sep 2020 12:23:24 +0200
In-Reply-To: <20200917095959.174378-1-m.v.b@runbox.com>
References: <359d080c-5cbb-250a-0ebd-aaba5f5c530d@runbox.com>
         <20200917095959.174378-1-m.v.b@runbox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.37.90 (3.37.90-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-09-17 at 12:59 +0300, M. Vefa Bicakci wrote:
> This commit resolves two minor bugs in the selection/discovery of
> more
> specific USB device drivers for devices that are currently bound to
> generic USB device drivers.
> 
> The first bug is related to the way a candidate USB device driver is
> compared against the generic USB device driver. The code in
> is_dev_usb_generic_driver() used to unconditionally use
> to_usb_device_driver() on each device driver, without verifying that
> the device driver in question is a USB device driver (as opposed to a
> USB interface driver).

You could also return early if is_usb_device() fails in
__usb_bus_reprobe_drivers(). Each of the interface and the device
itself is a separate "struct device", and "non-interface" devices won't
have interface devices assigned to them.


> The second bug is related to the logic that determines whether a
> device
> currently bound to a generic USB device driver should be re-probed by
> a
> more specific USB device driver or not. The code in
> __usb_bus_reprobe_drivers() used to have the following lines:
> 
>   if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
>       (!new_udriver->match || new_udriver->match(udev) != 0))
>  		return 0;
> 
>   ret = device_reprobe(dev);
> 
> As the reader will notice, the code checks whether the USB device in
> consideration matches the identifier table (id_table) of a specific
> USB device_driver (new_udriver), followed by a similar check, but
> this
> time with the USB device driver's match function. However, the match
> function's return value is not checked correctly. When match()
> returns
> zero, it means that the specific USB device driver is *not*
> applicable
> to the USB device in question, but the code then goes on to reprobe
> the
> device with the new USB device driver under consideration. All this
> to
> say, the logic is inverted.

Could you split that change as the first commit in your patchset?

I'll test your patches locally once you've respun them. Thanks for
working on this.

Cheers

