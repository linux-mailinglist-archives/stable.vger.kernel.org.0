Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2ED60E1A2
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 15:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiJZNLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 09:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbiJZNLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 09:11:06 -0400
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9167BFA02A;
        Wed, 26 Oct 2022 06:11:02 -0700 (PDT)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 255C85C3ABB;
        Wed, 26 Oct 2022 15:11:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1666789860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QLFgExITwIN4lybw/UjaBeJn22b4fh+Q9W7AXp52SJY=;
        b=NXnk3GNi1ceLZUXZtK/jPKqypVy8x6mNmwOgzfH+iUj3QQb6Z3ENK2E4RlUnXtjfKJVtqm
        Wn5M1kNEE8cyHkU7FE42iFAuIiIAi43yeknhNOjcOrQglCHzKixmbrlc3Vq7Lz40BlGukP
        g+eGl7/bauZiRChnA3yzqFLh/UxjCoo=
MIME-Version: 1.0
Date:   Wed, 26 Oct 2022 15:11:00 +0200
From:   Stefan Agner <stefan@agner.ch>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>, regressions@lists.linux.dev,
        m.szyprowski@samsung.com, krzk@kernel.org
Subject: Re: [PATCH stable-5.15 3/3] usb: dwc3: disable USB core PHY
 management
In-Reply-To: <Y1JCIKT80P9IysKD@hovoldconsulting.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-4-johan@kernel.org>
 <808bdba846bb60456adf10a3016911ee@agner.ch>
 <Y0+8dKESygFunXOu@hovoldconsulting.com>
 <86c0f1ee8ffc94f9a53690dda6a83fbb@agner.ch>
 <Y1JCIKT80P9IysKD@hovoldconsulting.com>
Message-ID: <b2a1e70bda64cb741efe81c5b7e56707@agner.ch>
X-Sender: stefan@agner.ch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-21 08:54, Johan Hovold wrote:
> On Fri, Oct 21, 2022 at 12:06:12AM +0200, Stefan Agner wrote:
>> On 2022-10-19 10:59, Johan Hovold wrote:
>> > On Tue, Oct 18, 2022 at 05:27:24PM +0200, Stefan Agner wrote:
>> >> On 2022-09-06 14:07, Johan Hovold wrote:
>> >> > From: Johan Hovold <johan+linaro@kernel.org>
>> >> >
>> >> > commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.
>> >> >
>> >> > The dwc3 driver manages its PHYs itself so the USB core PHY management
>> >> > needs to be disabled.
>> >> >
>> >> > Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
>> >> > host: xhci-plat: add platform data support") and f768e718911e ("usb:
>> >> > host: xhci-plat: add priv quirk for skip PHY initialization") to
>> >> > propagate the setting for now.
> 
>> >> For some reason, this commit seems to break detection of the USB to
>> >> S-ATA controller on ODROID-HC1 devices (Exynos 5422).
> 
>> > I think this may be related to the calibration calls added to dwc3 and
>> > later removed again by commits:
>> >
>> > 	d8c80bb3b55b ("phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800")
>> > 	a0a465569b45 ("usb: dwc3: remove generic PHY calibrate() calls")
>> >
>> > The removal explicitly mentions that the expectation is that USB core
>> > will do the PHY calibration.
>> >
>> > There could be other changes in the sequencing of events that this
>> > platform has been implicitly relying on, but as a start, could try
>> > adding the missing calibration calls (patch below) and see if that makes a
>> > difference?
>> 
>> The patch below did not apply to 5.15.74 directly, but I think I was
>> able to get the corrected patch applied (see below)
> 
> Looks good to me.
> 
>> That said, I do not have direct access to that hardware, but I created a
>> build and asked the user test it.
> 
> Thanks, let me know how it goes.

The user reports the S-ATA disk is *not* recognized with that patch
applied.

--
Stefan

