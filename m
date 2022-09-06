Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9735AE7FA
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239960AbiIFMWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239962AbiIFMVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:21:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769747C524;
        Tue,  6 Sep 2022 05:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FF1F614F0;
        Tue,  6 Sep 2022 12:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D80BC433C1;
        Tue,  6 Sep 2022 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662466690;
        bh=1gMZkYY0yDzHXlPGzNHurF/vidUlbmKz4+0OJev6OOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CSggKgk1lcxhSWGD2WRJrmHwlZ4kyuhdYX6Fe1itri3TPI7D037aKm48NfnUi50SF
         oVjZdeMMH4MSUHy1RRTZnPggpm4AN/75JAFBbdD0N8c6lWz0CP26zTUEHKDKfwsmQg
         nBL2SkFxIp4ipUTlBi7/sccBYU8zYY7FUmct7vRo=
Date:   Tue, 6 Sep 2022 14:18:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>
Subject: Re: usb: dwc3: disable USB core PHY management
Message-ID: <Yxc6gCoDZ3w8MHOy@kroah.com>
References: <20220906120702.19219-4-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906120702.19219-4-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 02:07:02PM +0200, Johan Hovold wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.
> 
> The dwc3 driver manages its PHYs itself so the USB core PHY management
> needs to be disabled.
> 
> Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
> host: xhci-plat: add platform data support") and f768e718911e ("usb:
> host: xhci-plat: add priv quirk for skip PHY initialization") to
> propagate the setting for now.
> 
> Fixes: 4e88d4c08301 ("usb: add a flag to skip PHY initialization to struct usb_hcd")
> Fixes: 178a0bce05cb ("usb: core: hcd: integrate the PHY wrapper into the HCD core")
> Tested-by: Matthias Kaehlcke <mka@chromium.org>
> Cc: stable <stable@kernel.org>
> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220825131836.19769-1-johan+linaro@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [ johan: adjust context to 5.15 ]
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/dwc3/host.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)

Breaks the build on 4.19.y :(
