Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E095D12B5FE
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 17:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfL0Qzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 11:55:47 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39083 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfL0Qzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Dec 2019 11:55:46 -0500
Received: by mail-pf1-f195.google.com with SMTP id q10so14969297pfs.6;
        Fri, 27 Dec 2019 08:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4nsIk431IJE2Vk4G5K7I24soUyvvlcDR7eoVO3tZXDI=;
        b=WhCmF3lfXiFeaDgdh8Zc4no994MMyy7RRNjNO3kp4sQAtoEC8jvl4bViEffarZPS8Q
         OyGs55rjGjxyd98MBtFtV3PT+fNXmJS1V6Decc/gOiUrMGsGss+QjIRRV239f0cilRg5
         tj/DC2EocfQvI9tfDYIzou/z6PgqvIBnysYOA1FQmgiB+eT6uWITC0O9qtgXynTQKyhy
         tSinIq4wBl4o0ntM7G2w7AFfH98LNAd67r5jUx29l8zoFUSrgrK+32dhYpVg9YXAHGW0
         /4a0TrPFLvwK4TE7mAJmdwglD3EpKpZ/qaV836dbxYAX1JlbvMQtwo4gTCFC2rJL1+Rc
         PS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4nsIk431IJE2Vk4G5K7I24soUyvvlcDR7eoVO3tZXDI=;
        b=ZMVN+j6RZcdlIOQ9N9iK5nrvQj9Ig5UHOFJmqUxyjXILLW3rAKfMfEigftq6jnQf9K
         pFG5xqAfUm5zGS0/2jW2YjAYNr09kjekF7xHwxaX0xVm0mLVMdUvlvCpfXX29YR7DGk2
         5wJSQzgw4SfP+fxfu/dTFLQmJ4Dm3f4ZYtO7Dj1GBU1h2VSV0PWu5wOWUW3io3ZxMAs+
         pD7OEPfHkVbHVPWupOhxUwSWlDyg4VfjwuhlGP4OzOI85Ey1AQSadJb7gTLTQqgO+laR
         iKLsaXTKITYjGPdqOjvRoxYO7J3LTyhaDGOlCct931dprbcWa/+dZQChQEZETdF5f/Fj
         iH+g==
X-Gm-Message-State: APjAAAXF17Iw8rBisfugdELBoa6rU/hahu4cbAVhXB6BL53TEONDiJ2W
        bRAgPi5vFqZUZier3i6t9D0=
X-Google-Smtp-Source: APXvYqyOPBCF3FRS8/uziPFI11Vq570WtF+ynBSOXyBPpYleRxUNXfDxAsungHAaqmCnvy0UyewLqA==
X-Received: by 2002:aa7:86d4:: with SMTP id h20mr51240296pfo.232.1577465745925;
        Fri, 27 Dec 2019 08:55:45 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i23sm20166129pfo.11.2019.12.27.08.55.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Dec 2019 08:55:45 -0800 (PST)
Date:   Fri, 27 Dec 2019 08:55:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Peter Chen <peter.chen@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: chipidea: host: Disable port power only if
 previously enabled
Message-ID: <20191227165543.GA15950@roeck-us.net>
References: <20191226155754.25451-1-linux@roeck-us.net>
 <Pine.LNX.4.44L0.1912261428310.6148-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1912261428310.6148-100000@netrider.rowland.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 26, 2019 at 02:46:15PM -0500, Alan Stern wrote:
> On Thu, 26 Dec 2019, Guenter Roeck wrote:
> 
> > On shutdown, ehci_power_off() is called unconditionally to power off
> > each port, even if it was never called to power on the port.
> > For chipidea, this results in a call to ehci_ci_portpower() with a request
> > to power off ports even if the port was never powered on.
> > This results in the following warning from the regulator code.
> 
> That's weird -- we should always power-on every port during hub 
> initialization.
> 
That is what I would have assumed, but test code shows that it doesn't
happen.

> It looks like there's a bug in hub.c:hub_activate(): The line under
> HUB_INIT which calls hub_power_on() should call
> usb_hub_set_port_power() instead.  In fact, the comment near the start

usb_hub_set_port_power() operates on a port of the hub. hub_activate()
operates on the hub itself, or at least I think it does. I don't know
how to convert the calls. Also, there are more calls to hub_power_on()
in the same function.  Can you provide more details on what to do,
or even better a patch for me to test ?

Thanks,
Guenter

> of hub_power_on() is wrong.  It says "Enable power on each port", but
> in fact it only enables power for ports that had been powered-on
> previously (i.e., the port's bit in hub->power_bits was set).  
> Apparently this got messed up in commit ad493e5e5805 ("usb: add usb
> port auto power off mechanism").
> 
> Now, the chipidea driver may still need to be updated, because 
> ehci_turn_off_all_ports() will still be called during shutdown and it 
> will try to power-down all ports, even those which are already powered 
> down (for example, because the port is suspended).
> 
> Alan Stern
> 
