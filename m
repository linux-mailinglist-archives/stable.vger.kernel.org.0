Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6004033F503
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhCQQG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232214AbhCQQFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 12:05:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AC1A64DD1;
        Wed, 17 Mar 2021 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615997150;
        bh=2mX2x5ADc//zk3Jiby2HBW7pn+4QY403j4U50sTDsg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DldvU6MCTKzmqGKoETycSUe8uWg2ruILPLAvrLeJ+T7hSaPskFSGPmrr2+qKbVEqe
         /Na1EGOmqSkIPINagX84YXhZRs5fos6zDSws1nyLrA6YVHcsRPBIeGTbQuRRqYIyAt
         FHgHoZzsPFUltrajondL8eEQjb1+fGgWdwajx2nI=
Date:   Wed, 17 Mar 2021 17:05:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Marek Vasut <marex@denx.de>, LKML <linux-kernel@vger.kernel.org>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>,
        Roman Guskov <rguskov@dh-electronics.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 5.10 081/290] gpiolib: Read "gpio-line-names" from a
 firmware node
Message-ID: <YFIo3A14Fb4Hty4O@kroah.com>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135544.659848571@linuxfoundation.org>
 <6abd9dd3-e14b-f690-f967-15fb58dffae8@denx.de>
 <CAMpxmJV1kbam7mhb7mM111Or8fnpTEo14EczCJ5Efw+45xBUcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMpxmJV1kbam7mhb7mM111Or8fnpTEo14EczCJ5Efw+45xBUcQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 05:32:09PM +0100, Bartosz Golaszewski wrote:
> On Mon, Mar 15, 2021 at 4:01 PM Marek Vasut <marex@denx.de> wrote:
> >
> > On 3/15/21 2:52 PM, gregkh@linuxfoundation.org wrote:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > >
> > > commit b41ba2ec54a70908067034f139aa23d0dd2985ce upstream.
> > >
> > > On STM32MP1, the GPIO banks are subnodes of pin-controller@50002000,
> > > see arch/arm/boot/dts/stm32mp151.dtsi. The driver for
> > > pin-controller@50002000 is in drivers/pinctrl/stm32/pinctrl-stm32.c
> > > and iterates over all of its DT subnodes when registering each GPIO
> > > bank gpiochip. Each gpiochip has:
> > >
> > >    - gpio_chip.parent = dev,
> > >      where dev is the device node of the pin controller
> > >    - gpio_chip.of_node = np,
> > >      which is the OF node of the GPIO bank
> > >
> > > Therefore, dev_fwnode(chip->parent) != of_fwnode_handle(chip.of_node),
> > > i.e. pin-controller@50002000 != pin-controller@50002000/gpio@5000*000.
> > >
> > > The original code behaved correctly, as it extracted the "gpio-line-names"
> > > from of_fwnode_handle(chip.of_node) = pin-controller@50002000/gpio@5000*000.
> > >
> > > To achieve the same behaviour, read property from the firmware node.
> >
> > There seem to be some discussion going on around this patch, so please
> > postpone backporting until that is settled. Same for v5.11 backport. I
> > hope Andy/Bartosz agrees ?
> 
> Yes, this patch broke at least the testing module and we're working to
> determine if it breaks DT drivers too.

Now dropped, thanks.

greg k-h
