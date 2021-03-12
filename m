Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74783389AB
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 11:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhCLKJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 05:09:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232686AbhCLKIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 05:08:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2F4664FC9;
        Fri, 12 Mar 2021 10:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615543313;
        bh=TrQ/nr092C/08eF2A1PSzm4it2w6iaOOQ9OvM2kfVig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZGXpmavMz6QFHJegyBLGvuWF8eO19EliKkqGQO0fwETPDYRoV+xcqvbLRGQOptlGb
         fbCAufDWSlazBCx7eBguxytVMl3aUc3ADWO5IaRcFYIEUODxDnNwG1JpHh2ZV0LmvM
         TWfMWd70gzGdZUNjOEHBWq7+FiNLBY3B1UPbeg1Q=
Date:   Fri, 12 Mar 2021 11:01:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     bgolaszewski@baylibre.com, saravanak@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption"
 failed to apply to 5.11-stable tree
Message-ID: <YEs8C0E6nM4QVBol@kroah.com>
References: <16154845012114@kroah.com>
 <YEsqnDY7nGWuh9h5@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEsqnDY7nGWuh9h5@hovoldconsulting.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 09:47:24AM +0100, Johan Hovold wrote:
> On Thu, Mar 11, 2021 at 06:41:41PM +0100, Greg Kroah-Hartman wrote:
> > 
> > The patch below does not apply to the 5.11-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From cf25ef6b631c6fc6c0435fc91eba8734cca20511 Mon Sep 17 00:00:00 2001
> > From: Johan Hovold <johan@kernel.org>
> > Date: Mon, 1 Mar 2021 10:05:19 +0100
> > Subject: [PATCH] gpio: fix gpio-device list corruption
> > 
> > Make sure to hold the gpio_lock when removing the gpio device from the
> > gpio_devices list (when dropping the last reference) to avoid corrupting
> > the list when there are concurrent accesses.
> > 
> > Fixes: ff2b13592299 ("gpio: make the gpiochip a real device")
> > Cc: stable@vger.kernel.org      # 4.6
> > Reviewed-by: Saravana Kannan <saravanak@google.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > 
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index 6e0572515d02..4253837f870b 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -475,8 +475,12 @@ EXPORT_SYMBOL_GPL(gpiochip_line_is_valid);
> >  static void gpiodevice_release(struct device *dev)
> >  {
> >  	struct gpio_device *gdev = container_of(dev, struct gpio_device, dev);
> > +	unsigned long flags;
> >  
> > +	spin_lock_irqsave(&gpio_lock, flags);
> >  	list_del(&gdev->list);
> > +	spin_unlock_irqrestore(&gpio_lock, flags);
> > +
> >  	ida_free(&gpio_ida, gdev->id);
> >  	kfree_const(gdev->label);
> >  	kfree(gdev->descs);
> > 
> 
> Bah, that's because of a6112998ee45 ("gpio: fix
> NULL-deref-on-deregistration regression") which is strictly only needed
> in 5.12 even if it could be backported (the commit message might be a
> bit confusing though).
> 
> I should have reversed the order of these two.
> 
> Below is a backport to 5.11.

Thanks for the backport, also added to 5.10.y

greg k-h
