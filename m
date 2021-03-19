Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E2D341D01
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhCSMgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhCSMgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:36:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEE7064EE7;
        Fri, 19 Mar 2021 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616157401;
        bh=sw+dwUnM/VBNehzDex5eKJ4K/A8buWQIaP9UKnVyadM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pkv4barNiyj+frvVOquZmD6jDWhTR5UgzMEVu1FQYmTHpNywnXoHnGBW7DXIK+DOT
         uXO1vt/7sOnujXCdzIyyIqHkpv+W2XDitsBZw/rxDrfVqnWOoXO1zd19QtYMNI1VBP
         /GcS1pVldj3QBR7aJHjoVKM6x0k106McoFUu5uwg=
Date:   Fri, 19 Mar 2021 13:36:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Roman Guskov <rguskov@dh-electronics.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.11 12/31] gpiolib: Read "gpio-line-names" from a
 firmware node
Message-ID: <YFSa1mczWev8KrQK@kroah.com>
References: <20210319121747.203523570@linuxfoundation.org>
 <20210319121747.594813307@linuxfoundation.org>
 <5c3f2fb9-c1bf-5939-2e83-8cd0fa6d0c20@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c3f2fb9-c1bf-5939-2e83-8cd0fa6d0c20@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 01:27:23PM +0100, Marek Vasut wrote:
> On 3/19/21 1:19 PM, Greg Kroah-Hartman wrote:
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > 
> > [ Upstream commit b41ba2ec54a70908067034f139aa23d0dd2985ce ]
> > 
> > On STM32MP1, the GPIO banks are subnodes of pin-controller@50002000,
> > see arch/arm/boot/dts/stm32mp151.dtsi. The driver for
> > pin-controller@50002000 is in drivers/pinctrl/stm32/pinctrl-stm32.c
> > and iterates over all of its DT subnodes when registering each GPIO
> > bank gpiochip. Each gpiochip has:
> > 
> >    - gpio_chip.parent = dev,
> >      where dev is the device node of the pin controller
> >    - gpio_chip.of_node = np,
> >      which is the OF node of the GPIO bank
> > 
> > Therefore, dev_fwnode(chip->parent) != of_fwnode_handle(chip.of_node),
> > i.e. pin-controller@50002000 != pin-controller@50002000/gpio@5000*000.
> > 
> > The original code behaved correctly, as it extracted the "gpio-line-names"
> > from of_fwnode_handle(chip.of_node) = pin-controller@50002000/gpio@5000*000.
> > 
> > To achieve the same behaviour, read property from the firmware node.
> 
> I think we agreed to drop this one for now before, see
> [PATCH 5.10 081/290] gpiolib: Read "gpio-line-names" from a firmware node
> Message-ID: <YFIo3A14Fb4Hty4O@kroah.com>

Sorry, now dropped.  Again.

greg k-h
