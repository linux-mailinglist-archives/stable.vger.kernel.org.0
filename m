Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA976278B3E
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgIYOvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728977AbgIYOvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 10:51:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C44A2074B;
        Fri, 25 Sep 2020 14:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601045464;
        bh=EQH46Xw8u1uSxIM/OiphAtLbpXSRFw1JZcQ5GWM6dXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XL+qYfXaFXWn7Nw+gl2XPdN28LGPdFsCqnyruwbJxhIbpZeeUw0RHEaUK51DMDLm9
         4y0i69nBeVYHkRngwf5XNnp7FZCcuIAHS3KxGDY9vTOx1I9K3elCYByQuoj3pwofAy
         QA5ROSG3/448Ia+WeVXh+zl2doTt+QtByBMjH8yo=
Date:   Fri, 25 Sep 2020 16:51:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        Shuah Khan <shuah@kernel.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        syzkaller@googlegroups.com
Subject: Re: [PATCH v3 3/4] usbcore/driver: Fix incorrect downcast
Message-ID: <20200925145118.GA3114228@kroah.com>
References: <20200922110703.720960-1-m.v.b@runbox.com>
 <20200922110703.720960-4-m.v.b@runbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922110703.720960-4-m.v.b@runbox.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 02:07:02PM +0300, M. Vefa Bicakci wrote:
> This commit resolves a minor bug in the selection/discovery of more
> specific USB device drivers for devices that are currently bound to
> generic USB device drivers.
> 
> The bug is related to the way a candidate USB device driver is
> compared against the generic USB device driver. The code in
> is_dev_usb_generic_driver() assumes that the device driver in question
> is a USB device driver by calling to_usb_device_driver(dev->driver)
> to downcast; however I have observed that this assumption is not always
> true, through code instrumentation.
> 
> This commit avoids the incorrect downcast altogether by comparing
> the USB device's driver (i.e., dev->driver) to the generic USB
> device driver directly. This method was suggested by Alan Stern.
> 
> This bug was found while investigating Andrey Konovalov's report
> indicating usbip device driver misbehaviour with the recently merged
> generic USB device driver selection feature. The report is linked
> below.
> 
> Fixes: d5643d2249 ("USB: Fix device driver race")

Nit, this should have been:
	Fixes: d5643d2249b2 ("USB: Fix device driver race")

I'll go fix it up as my scripts are rejecting it as-is...

thanks,

greg k-h
