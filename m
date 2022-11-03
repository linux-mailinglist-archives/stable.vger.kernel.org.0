Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5156182E3
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiKCPa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiKCPad (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:30:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE89C110B;
        Thu,  3 Nov 2022 08:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 660CB61F2D;
        Thu,  3 Nov 2022 15:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB804C433D6;
        Thu,  3 Nov 2022 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667489401;
        bh=6e8ruPJPD4sSHdabvzka5nsqzYWSReJCia4VC8DZ9CM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nOVFgG2pxHS9Fg7mzPDyqbmvyepYWB3Y3X2N8+EBwUlijrMPVpLJoiJVMBdgRwIXX
         4HlUO6GU3oDEA8CwPGikMMybTagUvLONlIkaMjNb4pfwti5A7CgmB83C0VgDGLGQ04
         sLfDc/20/O1uyAoz6AA6rYUmebq7/dyFlO0VSbNMa9/LUzSpMzOPBJShHu7PIUHJR9
         oc64zKZqnKMHvD5Hd8VNlefEKteotP4zD1oYVGGlA+UpsmMMxYd/WDi/t5SbEvXppc
         W72EuztIQUVG3z/pImAUg3kHwDydmv+jo3keWGktKNrlYeV68tvsEnKyr/HdlULtQ5
         ie6sLLiYT9Ztg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oqcA4-0004AX-C3; Thu, 03 Nov 2022 16:29:44 +0100
Date:   Thu, 3 Nov 2022 16:29:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Stefan Agner <stefan@agner.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>, regressions@lists.linux.dev,
        krzk@kernel.org
Subject: Re: [PATCH stable-5.15 3/3] usb: dwc3: disable USB core PHY
 management
Message-ID: <Y2PeaP/dcaklXW+x@hovoldconsulting.com>
References: <20220906120702.19219-4-johan@kernel.org>
 <808bdba846bb60456adf10a3016911ee@agner.ch>
 <Y0+8dKESygFunXOu@hovoldconsulting.com>
 <86c0f1ee8ffc94f9a53690dda6a83fbb@agner.ch>
 <Y1JCIKT80P9IysKD@hovoldconsulting.com>
 <b2a1e70bda64cb741efe81c5b7e56707@agner.ch>
 <Y1p9Wy9w5umMBC4V@hovoldconsulting.com>
 <CGME20221103145022eucas1p2218e78d51500c85b3cda59cc533a3631@eucas1p2.samsung.com>
 <Y2PVF/IJoKvSu3SM@hovoldconsulting.com>
 <53e543e8-f895-d4f1-da94-d0baca528e79@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53e543e8-f895-d4f1-da94-d0baca528e79@samsung.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 03, 2022 at 04:18:12PM +0100, Marek Szyprowski wrote:
> Hi Johan,
> 
> On 03.11.2022 15:49, Johan Hovold wrote:
> > On Thu, Oct 27, 2022 at 02:45:15PM +0200, Johan Hovold wrote:
> >> On Wed, Oct 26, 2022 at 03:11:00PM +0200, Stefan Agner wrote:
> >>> The user reports the S-ATA disk is *not* recognized with that patch
> >>> applied.
> >> I just noticed a mistake in the instrumentation patch I sent you. Could
> >> you try moving the calibrations calls after dwc3_host_init() (e.g. as in
> >> the second chunk in the diff below)?
> >>
> >> As mentioned in the commit message for a0a465569b45 ("usb: dwc3: remove
> >> generic PHY calibrate() calls"), this may not work if the xhci-plat
> >> driver is built as a module and there are some corner cases that it does
> >> not cover.
> >>
> >> It seems we should revert the offending commit and then try to find some
> >> time to untangle this mess, but please check if the below addresses the
> >> issue first so we know what the problem is.
> >>
> >> I'll prepare a revert in the meantime.
> > I've now posted the revert, but please do check if the below patch was
> > enough to resolve the immediate issue.
> 
> The below patch was a half-fix. It worked only if both dwc3 and 
> xhci_plat_hcd were compiled into the kernel. Afair Debian-based distros 
> used xhci compiled as a module, so this didn't work for that case due to 
> timing issues.

Yeah, I mentioned that above too. The intention here was just to confirm
the hypothesis that the regression was due to the missing calibration
calls.

Johan
