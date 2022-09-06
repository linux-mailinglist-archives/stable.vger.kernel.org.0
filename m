Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783B65AE821
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiIFMac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239058AbiIFMaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:30:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09187F132;
        Tue,  6 Sep 2022 05:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1ACA6147A;
        Tue,  6 Sep 2022 12:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAAEC433C1;
        Tue,  6 Sep 2022 12:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662467217;
        bh=Q9COnJ6Jp4KdTCX0e8YUnK8/L3323njkYDJxjZWnOKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XKvaXJkoQ00l8a3ccNjeBFEMhagSkWsnGGPH6hAl3ZMwZBdMRhFNhGxgKVWM5mhVp
         zW+Ez7oPs0FDp3Zr6siZDDCAf4p6m5wMuEVST1DnF0dlEsq11PyG06atxipIVImhvU
         tx4ZJStQ6wT+lMkdC8XV5V7SUu9tik16FqjrXe2o78BVahB6As8WxH90jaJrgTKdb2
         oJuLIAjtuza17D5wg2WMWqiPVFZZhGfL8piw2SMD52vEqv1ll5aacx6GxFnpXyUz9W
         yuNNP0DRaLQogt/Kn7Pzu4EIXJHyVUvQTLcgbgQor00+qPyeLoOETPZOeN90olsLvZ
         A6w39j+McAAPQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVXfR-0008Bx-91; Tue, 06 Sep 2022 14:27:01 +0200
Date:   Tue, 6 Sep 2022 14:27:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>
Subject: Re: usb: dwc3: disable USB core PHY management
Message-ID: <Yxc8lQ+ckvMJ8R9D@hovoldconsulting.com>
References: <20220906120702.19219-4-johan@kernel.org>
 <Yxc6gCoDZ3w8MHOy@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxc6gCoDZ3w8MHOy@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 02:18:08PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 06, 2022 at 02:07:02PM +0200, Johan Hovold wrote:
> > From: Johan Hovold <johan+linaro@kernel.org>
> > 
> > commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.
> > 
> > The dwc3 driver manages its PHYs itself so the USB core PHY management
> > needs to be disabled.
> > 
> > Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
> > host: xhci-plat: add platform data support") and f768e718911e ("usb:
> > host: xhci-plat: add priv quirk for skip PHY initialization") to
> > propagate the setting for now.
> > 
> > Fixes: 4e88d4c08301 ("usb: add a flag to skip PHY initialization to struct usb_hcd")
> > Fixes: 178a0bce05cb ("usb: core: hcd: integrate the PHY wrapper into the HCD core")
> > Tested-by: Matthias Kaehlcke <mka@chromium.org>
> > Cc: stable <stable@kernel.org>
> > Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > Link: https://lore.kernel.org/r/20220825131836.19769-1-johan+linaro@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > [ johan: adjust context to 5.15 ]
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/usb/dwc3/host.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> 
> Breaks the build on 4.19.y :(

It's OK to not to backport this one.

Johan
