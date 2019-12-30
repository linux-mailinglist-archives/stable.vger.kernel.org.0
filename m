Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F2C12CB80
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 01:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfL3A5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 19:57:45 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44420 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfL3A5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 19:57:45 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so17241374pgl.11;
        Sun, 29 Dec 2019 16:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UVnprGvLewdhuWA7pzt73rmpOg554J2l+Ch1m7KvQNQ=;
        b=M8nb6HdXs4EZh2oyQEe/0LpTjEerc6Qzg8fLvT8k+c4V7MauftFfWMIYuayRMs0NUY
         6B4tLSAHGqBo2RAJgxA3waMxqHkEiHi2cdQZbBCwfADp+f/HHgvfzuzxYSrcL5k94/qx
         7hKtxJHXBtP9vjC9Uk6lo4qKbRdQUpfrjRlvKoGsyWlHh/LlsQyEugNIlNzZNxJPZVao
         aMyWljFroZzMNQfz56Zg+jafw7Z2bF6q27iC/lHlZZj0FjiHy7HJD3iCYvKAb55M/x95
         yDQ+qlvNYCC3DnM84IahITsa0/mz4Csd2sIzVoQqOXsM/y3JNc4p+wG4xAWWLPz7rkht
         f88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=UVnprGvLewdhuWA7pzt73rmpOg554J2l+Ch1m7KvQNQ=;
        b=fN2QeZ8ruzBIikiNZjL91iDO5lj52uZRni2loIa8f9YjopNz47rfhb0MJ27N5BYsM6
         pbo6pz9NTj7NZ8b85sRR7bxBpL7MPX6QQYSZa651pTJeTlEK6ZaKbE35SC0z3domF0II
         QLCxNk6FTzN//wQXHB/cw4pRgnLakNzHwaE3mjh8EQkbQd6ApNk8shST9x32zPy4XK2f
         td5oS9DhZ80+Xv/nxrQQUEOnWMjAW3ZBb+vMaQshrjwN2rFDVfoTl6BufdR+cpR9nIOs
         sT+CYBWpJZE4OIdYktgUJfF5GsSjXAVPPgT/uSczqoUkUcQd3Oqj8Q576KTUmzwWZSRj
         WzUw==
X-Gm-Message-State: APjAAAVvozQ1J27BX7+edk+14s6YUPLtYgnHYtHv1DN8Vp16pEk4mjDU
        w1YJECaDIny41jtpzmd3BV/cBjZ/
X-Google-Smtp-Source: APXvYqxwQcbGRxWsq5dg8Tr+u+V6Yx8Fqv406yJ4eqHhgpfiPLjgdTHOhSmj5+wXMxtGKxi12ud5cg==
X-Received: by 2002:a63:d041:: with SMTP id s1mr69679419pgi.363.1577667464428;
        Sun, 29 Dec 2019 16:57:44 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z13sm22222445pjz.15.2019.12.29.16.57.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 29 Dec 2019 16:57:43 -0800 (PST)
Date:   Sun, 29 Dec 2019 16:57:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: chipidea: host: Disable port power only if
 previously enabled
Message-ID: <20191230005742.GA25100@roeck-us.net>
References: <20191229162811.GA21566@roeck-us.net>
 <Pine.LNX.4.44L0.1912291137150.19645-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1912291137150.19645-100000@netrider.rowland.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 11:40:52AM -0500, Alan Stern wrote:
> On Sun, 29 Dec 2019, Guenter Roeck wrote:
> 
> > On Sat, Dec 28, 2019 at 02:33:01PM -0500, Alan Stern wrote:
> > > 
> > > Let's try a slightly different approach.  What happens with this patch?
> > > 
> > > Alan Stern
> > > 
> > > 
> > > Index: usb-devel/drivers/usb/core/hub.c
> > > ===================================================================
> > > --- usb-devel.orig/drivers/usb/core/hub.c
> > > +++ usb-devel/drivers/usb/core/hub.c
> > > @@ -1065,6 +1065,7 @@ static void hub_activate(struct usb_hub
> > >  		if (type == HUB_INIT) {
> > >  			delay = hub_power_on_good_delay(hub);
> > >  
> > > +			hub->power_bits[0] = ~0UL;	/* All ports on */
> > >  			hub_power_on(hub, false);
> > >  			INIT_DELAYED_WORK(&hub->init_work, hub_init_func2);
> > >  			queue_delayed_work(system_power_efficient_wq,
> > > 
> > 
> > That doesn't make a difference - the traceback is still seen with this patch
> > applied.
> 
> Can you trace what's going on?  Does this code pathway now end up
> calling ehci_port_power() for each root-hub port, and from there down
> into the chipidea driver?  If not, can you find where it gets
> sidetracked?
> 
Sure, I'll do that. It will have to wait for the new year, though -
internet connectivity is terrible where I am right now,

Guenter
