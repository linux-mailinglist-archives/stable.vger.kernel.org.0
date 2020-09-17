Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E6826D98D
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 12:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIQKuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 06:50:25 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:39485 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgIQKuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 06:50:19 -0400
X-Greylist: delayed 1597 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 06:50:17 EDT
X-Originating-IP: 82.255.60.242
Received: from [192.168.0.28] (lns-bzn-39-82-255-60-242.adsl.proxad.net [82.255.60.242])
        (Authenticated sender: hadess@hadess.net)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 1F28940003;
        Thu, 17 Sep 2020 10:49:46 +0000 (UTC)
Message-ID: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
Subject: Re: [PATCH 1/2] usbcore/driver: Fix specific driver selection
From:   Bastien Nocera <hadess@hadess.net>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-usb@vger.kernel.org
Cc:     Andrey Konovalov <andreyknvl@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com
Date:   Thu, 17 Sep 2020 12:49:46 +0200
In-Reply-To: <0ce9fcb5-8684-cf5c-e8ad-02217848cbe7@runbox.com>
References: <359d080c-5cbb-250a-0ebd-aaba5f5c530d@runbox.com>
         <20200917095959.174378-1-m.v.b@runbox.com>
         <2ee0f3922f54888acf3e0cafa47c3829a9b0de8f.camel@hadess.net>
         <0ce9fcb5-8684-cf5c-e8ad-02217848cbe7@runbox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.37.90 (3.37.90-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-09-17 at 13:39 +0300, M. Vefa Bicakci wrote:
> On 17/09/2020 13.23, Bastien Nocera wrote:
> > On Thu, 2020-09-17 at 12:59 +0300, M. Vefa Bicakci wrote:
> > > This commit resolves two minor bugs in the selection/discovery of
> > > more
> > > specific USB device drivers for devices that are currently bound
> > > to
> > > generic USB device drivers.
> > > 
> > > The first bug is related to the way a candidate USB device driver
> > > is
> > > compared against the generic USB device driver. The code in
> > > is_dev_usb_generic_driver() used to unconditionally use
> > > to_usb_device_driver() on each device driver, without verifying
> > > that
> > > the device driver in question is a USB device driver (as opposed
> > > to a
> > > USB interface driver).
> > 
> > You could also return early if is_usb_device() fails in
> > __usb_bus_reprobe_drivers(). Each of the interface and the device
> > itself is a separate "struct device", and "non-interface" devices
> > won't
> > have interface devices assigned to them.
> 
> Will do! If I understand you correctly, you mean something like the
> following:
> 
> static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
> {
>          struct usb_device_driver *new_udriver = data;
>          struct usb_device *udev;
>          int ret;
> 
> 	/* Proposed addition begins */
> 
> 	if (!is_usb_device(dev))
> 		return 0;
> 
> 	/* Proposed addition ends */
> 
>          if (!is_dev_usb_generic_driver(dev))
>                  return 0;

Or:
	if (!is_usb_device(dev) ||
            !is_dev_usb_generic_driver(dev))
 		return 0;


