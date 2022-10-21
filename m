Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0173860708B
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 08:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJUGyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 02:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJUGyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 02:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F9C3471D;
        Thu, 20 Oct 2022 23:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2009161DDD;
        Fri, 21 Oct 2022 06:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7008EC433C1;
        Fri, 21 Oct 2022 06:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666335278;
        bh=lPK+4yk6wIaWs16XPlFFiwD0H7JQ/7cPrriZHPFIifM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Os+v4aeJRFpSrCJyKcU1UCOQNd0DZMuv+g4yEoXcbOnvBfmb6TZWArioYEWVXxLLg
         qRvleqXjwB+ghd9l2BgPQY1zQ/DIeTcg4tWk4N+WMvvMJ/z6tp+lkCDnShQZbGRQVh
         O7UG4sGPmuU73cpntnq8pO2bQFwpWYR42LapCMjZuTwEiGA+Fav2MYTlCg/K54maS2
         op7BSMCaRH8X+wgsDQhsuO745Ynhe4x5DDSxbhpwegHDm0EGLypq7sHm+UZeEng9HU
         KmmZv1+7+z/Nr3xkaOg6uC0qQ3UQ+fsoLuRbAFK8feu9OfEdDX+1Wj/lQ9qofsFp8o
         mxQUIVNgGAnXg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ollvE-0001m5-PI; Fri, 21 Oct 2022 08:54:24 +0200
Date:   Fri, 21 Oct 2022 08:54:24 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Stefan Agner <stefan@agner.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>, regressions@lists.linux.dev,
        m.szyprowski@samsung.com, krzk@kernel.org
Subject: Re: [PATCH stable-5.15 3/3] usb: dwc3: disable USB core PHY
 management
Message-ID: <Y1JCIKT80P9IysKD@hovoldconsulting.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-4-johan@kernel.org>
 <808bdba846bb60456adf10a3016911ee@agner.ch>
 <Y0+8dKESygFunXOu@hovoldconsulting.com>
 <86c0f1ee8ffc94f9a53690dda6a83fbb@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86c0f1ee8ffc94f9a53690dda6a83fbb@agner.ch>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 12:06:12AM +0200, Stefan Agner wrote:
> On 2022-10-19 10:59, Johan Hovold wrote:
> > On Tue, Oct 18, 2022 at 05:27:24PM +0200, Stefan Agner wrote:
> >> On 2022-09-06 14:07, Johan Hovold wrote:
> >> > From: Johan Hovold <johan+linaro@kernel.org>
> >> >
> >> > commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.
> >> >
> >> > The dwc3 driver manages its PHYs itself so the USB core PHY management
> >> > needs to be disabled.
> >> >
> >> > Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
> >> > host: xhci-plat: add platform data support") and f768e718911e ("usb:
> >> > host: xhci-plat: add priv quirk for skip PHY initialization") to
> >> > propagate the setting for now.

> >> For some reason, this commit seems to break detection of the USB to
> >> S-ATA controller on ODROID-HC1 devices (Exynos 5422).

> > I think this may be related to the calibration calls added to dwc3 and
> > later removed again by commits:
> > 
> > 	d8c80bb3b55b ("phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800")
> > 	a0a465569b45 ("usb: dwc3: remove generic PHY calibrate() calls")
> > 
> > The removal explicitly mentions that the expectation is that USB core
> > will do the PHY calibration.
> > 
> > There could be other changes in the sequencing of events that this
> > platform has been implicitly relying on, but as a start, could try
> > adding the missing calibration calls (patch below) and see if that makes a
> > difference?
> 
> The patch below did not apply to 5.15.74 directly, but I think I was
> able to get the corrected patch applied (see below)

Looks good to me.

> That said, I do not have direct access to that hardware, but I created a
> build and asked the user test it.

Thanks, let me know how it goes.

Johan
