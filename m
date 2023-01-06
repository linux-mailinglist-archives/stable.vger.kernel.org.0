Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EBE660356
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 16:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbjAFPdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 10:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235725AbjAFPc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 10:32:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7843C193DC;
        Fri,  6 Jan 2023 07:32:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03B22618A2;
        Fri,  6 Jan 2023 15:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0ABC433D2;
        Fri,  6 Jan 2023 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673019175;
        bh=MoJReKfnakkKkR+HCW1RUf/lLV/d/JIzG9RpdEBEcEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F5qh+PV05KsdefxSqbA8fNXGIuCG7pUCkxsCuYnuj7Bu0c8Jt16/4eXDNjLxxmt4B
         vy/N9v454re2s/6tYP6PIq1J9hFrcw33IHV2/bCXItGgcoXjQjQD3xF5/a4aTrrest
         qaSrCbaTb8qtyn2IRRGeNnY4HJhdyMCgsPJbaaRs=
Date:   Fri, 6 Jan 2023 16:32:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Icenowy Zheng <uwu@icenowy.me>,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: Re: [PATCH 1/2] usb: misc: onboard_hub: Invert driver registration
 order
Message-ID: <Y7g/JA0KZukK+41g@kroah.com>
References: <20230105230119.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105230119.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 11:03:28PM +0000, Matthias Kaehlcke wrote:
> The onboard_hub 'driver' consists of two drivers, a platform
> driver and a USB driver. Currently when the onboard hub driver
> is initialized it first registers the platform driver, then the
> USB driver. This results in a race condition when the 'attach'
> work is executed, which is scheduled when the platform device
> is probed. The purpose of fhe 'attach' work is to bind elegible
> USB hub devices to the onboard_hub USB driver. This fails if
> the work runs before the USB driver has been registered.
> 
> Register the USB driver first, then the platform driver. This
> increases the chances that the onboard_hub USB devices are probed
> before their corresponding platform device, which the USB driver
> tries to locate in _probe(). The driver already handles this
> situation and defers probing if the onboard hub platform device
> doesn't exist yet.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> Link: https://lore.kernel.org/lkml/Y6W00vQm3jfLflUJ@hovoldconsulting.com/T/#m0d64295f017942fd988f7c53425db302d61952b4
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> 
>  drivers/usb/misc/onboard_usb_hub.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Does this superseed this thread:
	Link: https://lore.kernel.org/r/20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid

or is that also needed?

confused,

greg k-h
