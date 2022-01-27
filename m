Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E6A49E654
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbiA0Pl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiA0Pl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:41:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B287BC061714;
        Thu, 27 Jan 2022 07:41:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CCEBB80185;
        Thu, 27 Jan 2022 15:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A325C340E8;
        Thu, 27 Jan 2022 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643298116;
        bh=lgh5duDb2OaMpb8AC9iwUYMi+3DL9JsLL4D3JVIHU/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s/MeKAArX7Yo0sq/xvZjIZLmYADos2UrxYkG9o/IcvQ0rbbTFN3uCspY3NT93l8Hx
         ttz5yXfCBzdQZKB8OXwVY/mBNuSJn4zqf+ObhFSRHM3UXntseV/B7q22LDtP67TyYL
         8/glk3xtjenSpmOWv1wMNTgG6fL/LRhgB82RMfSc=
Date:   Thu, 27 Jan 2022 16:41:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..." 
        <bcm-kernel-feedback-list@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Phil Elwell <phil@raspberrypi.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PIN CONTROL SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "moderated list:BROADCOM BCM2711/BCM2835 ARM ARCHITECTURE" 
        <linux-rpi-kernel@lists.infradead.org>,
        "moderated list:BROADCOM BCM2711/BCM2835 ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH stable 5.4 0/7] pinctrl-bcm2835 gpio-ranges bugfix
Message-ID: <YfK9QfDm/p7XmgFq@kroah.com>
References: <20220125194222.12783-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125194222.12783-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 11:42:15AM -0800, Florian Fainelli wrote:
> Hi all,
> 
> This patch series is intended to backport the fix from Phil "pinctrl:
> bcm2835: Change init order for gpio hogs" into the 5.4 tree since the
> blamed commit:
> 
> 73345a18d464b ("pinctrl: bcm2835: Pass irqchip when adding gpiochip")
> 
> is in 5.4. To get there, I did backport a number of changes in order for
> the commit "pinctrl: bcm2835: Change init order for gpio hogs" to apply
> cleanly with no hunks.
> 
> Those should have no functional impact since we do not have support for
> 7211 or 2711 in the upstream stable 5.4.
> 
> Both the pinctrl *and* the DTS changes must be taken in lockstep
> otherwise the GPIO pins are simply not usable unfortunately.
> 
> Thanks!
> 
> Florian Fainelli (2):
>   pinctrl: bcm2835: Match BCM7211 compatible string
>   pinctrl: bcm2835: Add support for wake-up interrupts
> 
> Phil Elwell (2):
>   pinctrl: bcm2835: Change init order for gpio hogs
>   ARM: dts: gpio-ranges property is now required
> 
> Stefan Wahren (3):
>   pinctrl: bcm2835: Drop unused define
>   pinctrl: bcm2835: Refactor platform data
>   pinctrl: bcm2835: Add support for all GPIOs on BCM2711
> 
>  arch/arm/boot/dts/bcm283x.dtsi        |   1 +
>  drivers/pinctrl/bcm/pinctrl-bcm2835.c | 209 +++++++++++++++++++++-----
>  2 files changed, 175 insertions(+), 35 deletions(-)
> 
> -- 
> 2.25.1
> 

All now queued up, thanks.

greg k-h
